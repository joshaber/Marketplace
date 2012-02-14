//
//  AppDelegate.m
//  Marketplace
//
//  Created by Josh Abernathy on 12/22/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Sparkle/Sparkle.h>
#import "AquaticPrime.h"

#import "AppDelegate.h"

#import "MainWindowController.h"
#import "PreferencesWindowController.h"
#import "EnterLicenseWindowController.h"
#import "SearchController.h"
#import "FavoritesController.h"

#import "NSWorkspace+JAAdditions.h"
#import "NSData+Base64Additions.h"
#import "NSSocketPort+JAExtensions.h"

NSString * const MPSynchServiceType = @"_marketplace._tcp.";
static NSString * const MPSyncServiceResponseTypeKey = @"type";
static NSString * const MPSyncServiceResponseTypeHandshake = @"handshake";
static NSString * const MPSyncServiceResponseTypeBeginXfer = @"begin";

@interface AppDelegate ()
- (void)loadDataFromDisk;
- (void)saveDataToDisk;
- (NSString *)pathForDataFile:(NSString *)name;
- (void)refreshIntervalChanged;
- (BOOL)isGrowlInstalled;
- (void)cleanMenu;
- (void)didWakeFromSleep:(NSNotification *)notification;
@end


@implementation AppDelegate

static inline void setupAquaticPrime() {

}

+ (void)initialize {
    if([self class] == [AppDelegate class]) {
        NSDictionary *defaults = [NSDictionary dictionaryWithObjectsAndKeys:
                                  [NSNumber numberWithBool:NO], JAOpenLinksInBackground,
                                  @"Manually", JARefreshInterval,
                                  [NSNumber numberWithBool:NO], JARefreshSearchesAtStartup,
                                  [NSNumber numberWithBool:YES], JAShowNewResultsNotifications,
                                  [NSNumber numberWithBool:YES], JAShowNotificationsOnlyWhenInactive,
                                  [NSNumber numberWithBool:YES], JAResultsViewVertical,
                                  [NSNumber numberWithBool:YES], JACloseRegionsWindowAfterAdding,
                                  nil];
        [[NSUserDefaults standardUserDefaults] registerDefaults:defaults];
    }
}

- (void)awakeFromNib {	
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(refreshIntervalChanged) 
												 name:JARefreshIntervalChangedNotification 
											   object:nil];
	
	if(![self isGrowlInstalled]) {
		[[NSUserDefaults standardUserDefaults] setBool:NO forKey:JAShowNewResultsNotifications];
	}
    
    NSLog(@"done awake from nib");
}

- (void)applicationWillFinishLaunching:(NSNotification *)notification {

}

- (void)applicationDidFinishLaunching:(NSNotification *)notification {
	[self loadDataFromDisk];
	
	windowController = [MainWindowController defaultController];
	
	// this call apparently takes an oddly long time...
	[GrowlApplicationBridge performSelectorInBackground:@selector(setGrowlDelegate:) withObject:self];
	
	[[windowController window] makeMainWindow];
	[[windowController window] makeKeyAndOrderFront:nil];
	[[windowController window] setContentBorderThickness:30 forEdge:NSMinYEdge];
	
	[[SUUpdater sharedUpdater] checkForUpdatesInBackground];
	
	[self refreshIntervalChanged];
	if([[NSUserDefaults standardUserDefaults] boolForKey:JARefreshSearchesAtStartup]) {
		[windowController refreshAllSearches:nil];
	}
	
	if([self isLicensed]) {
		[self cleanMenu];
	}
    
    [[[NSWorkspace sharedWorkspace] notificationCenter] addObserver:self 
                                                           selector:@selector(didWakeFromSleep:) 
                                                               name:NSWorkspaceDidWakeNotification 
                                                             object:nil];
    
    [[NSDistributedNotificationCenter defaultCenter] addObserver:self
                                                        selector:@selector(didWakeFromSleep:)
                                                            name:NSScreenSaverDidStopNotification 
                                                          object:nil];
    
    preferencesWindowController = [PreferencesWindowController defaultController];
    enterLicenseWindowController = [EnterLicenseWindowController defaultController];
    aboutWindowController = [[NSWindowController alloc] initWithWindowNibName:@"AboutWindow"];
    
    searchQueue = [[NSOperationQueue alloc] init];

    static NSString * const MPSyncServiceName = @"Marketplace Sync";
    syncListener = [[BLIPListener alloc] initWithPort:8448];
    syncListener.pickAvailablePort = YES;
    syncListener.delegate = self;
    syncListener.bonjourServiceType = MPSynchServiceType;
    syncListener.bonjourServiceName = MPSyncServiceName;
    [syncListener open];
}

- (void)applicationWillTerminate:(NSNotification *)notification {
    [currentConnection close];
    [syncListener close];
    
	[self saveDataToDisk];
}

- (void)didWakeFromSleep:(NSNotification *)notification {
    if([[NSUserDefaults standardUserDefaults] boolForKey:JARefreshSearchesAtWake] || [[NSUserDefaults standardUserDefaults] boolForKey:JARefreshSearchesAtScreenSaverEnd]) {
        [windowController refreshAllSearches:nil];
    }
}

- (IBAction)goToWebsite:(id)sender {
	[[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:WEBSITE_URL]];
}

- (IBAction)goToStore:(id)sender {
	[[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:STORE_URL]];
}

- (IBAction)showHelp:(id)sender {
	[[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:HELP_URL]];
}

- (IBAction)showAbout:(id)sender {
    [aboutWindowController.window makeKeyAndOrderFront:nil];
}

- (IBAction)showPreferences:(id)sender {
	[NSApp beginSheet:preferencesWindowController.window 
	   modalForWindow:windowController.window 
		modalDelegate:nil 
	   didEndSelector:nil 
		  contextInfo:NULL];
	[NSApp endSheet:preferencesWindowController.window];
}

- (IBAction)showEnterLicense:(id)sender {
	[NSApp beginSheet:enterLicenseWindowController.window 
	   modalForWindow:windowController.window 
		modalDelegate:nil 
	   didEndSelector:nil 
		  contextInfo:NULL];
}

- (NSString *)pathForDataFile:(NSString *)name {
	NSString *folder = [[[NSWorkspace sharedWorkspace] applicationSupportDirectory] stringByAppendingPathComponent:@"Marketplace"];
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if(![fileManager fileExistsAtPath:folder]) {
		[fileManager createDirectoryAtPath:folder attributes:nil];
	}
	
	return [folder stringByAppendingPathComponent:name];
}

- (void)saveDataToDisk {
	NSString *path = [self pathForDataFile:@"Searches"];
	NSMutableDictionary *rootObject = [NSMutableDictionary dictionary];
    
	[rootObject setValue:[SearchController sharedInstance].searches forKey:@"searches"];
	[rootObject setValue:[FavoritesController sharedInstance].favorites forKey:@"favorites"];
	
	if(windowController.lastSearch != nil) {
		[rootObject setValue:windowController.lastSearch forKey:@"lastSearch"];
	} else {
		[rootObject setValue:[persistentData valueForKey:@"lastSearch"] forKey:@"lastSearch"];
	}
	
	[NSKeyedArchiver archiveRootObject:rootObject toFile:path];
}

- (void)loadDataFromDisk {	
	persistentData = [NSKeyedUnarchiver unarchiveObjectWithFile:[self pathForDataFile:@"Searches"]];
    
	[[SearchController sharedInstance] addSearches:[persistentData valueForKey:@"searches"]];
	[[FavoritesController sharedInstance] addFavorites:[persistentData valueForKey:@"favorites"]];
	
	licenseData = [NSData dataWithContentsOfFile:[self pathForDataFile:@"License.marketplaceLicense"]];
	
	NSString *datePath = [[[NSWorkspace sharedWorkspace] applicationSupportDirectory] stringByAppendingPathComponent:@".m4rk8"];
	startDate = [NSKeyedUnarchiver unarchiveObjectWithFile:datePath];
	if(startDate == nil) {
		startDate = [NSDate date];
		[NSKeyedArchiver archiveRootObject:startDate toFile:datePath];
	}
}

- (NSString *)version {
	return [NSString stringWithFormat:@"%@ (%@)", MPAppVersion, [[NSBundle mainBundle] objectForInfoDictionaryKey:JABuildHash]];
}


#pragma mark License

- (void)cleanMenu {
	NSMenu *appMenu = [[[NSApp mainMenu] itemAtIndex:0] submenu];
	[appMenu removeItem:enterLicenseItem];
	[appMenu removeItem:purchaseLicenseItem];
}

- (BOOL)application:(NSApplication *)application openFile:(NSString *)filename {
	[self validateAndStoreLicense:[NSData dataWithContentsOfFile:filename]];
	
	return YES;
}

- (void)validateAndStoreLicense:(NSData *)data {
	if([self isValidLicenseData:data]) {
		NSRunInformationalAlertPanel(@"Thanks!", @"Thank you for purchasing Marketplace! Please save your license information for your own records.", nil, nil, nil);
		[windowController removeBuyNowButton];
		[self cleanMenu];
	} else {
		NSRunInformationalAlertPanel(@"Invalid License", @"That license does not appear to be valid.", nil, nil, nil);
	}
	
	licenseData = data;
	[licenseData writeToFile:[self pathForDataFile:@"License.marketplaceLicense"] atomically:YES];
}

- (BOOL)isValidLicenseData:(NSData *)data {
    setupAquaticPrime();
	NSDictionary *license = NSMakeCollectable(APCreateDictionaryForLicenseData((CFDataRef) data));
	if(license == nil) {
		return NO;
	} else {
		self.nameFromLicense = [license objectForKey:@"Name"];
		self.emailFromLicense = [license objectForKey:@"Email"];
		return YES;
	}
}

- (BOOL)isLicensedOrInTrial {
	return [self isLicensed] || [self daysUntilExpiration] > 0;
}

- (BOOL)isLicensed {
	return YES;
}

- (NSInteger)daysUntilExpiration {
	NSDate *future = [startDate addTimeInterval:25*24*60*60];
	
	return (NSInteger) [future timeIntervalSinceDate:[NSDate date]] / 60 / 60 / 24 + 1;
}

- (NSData *)licenseDataForName:(NSString *)name email:(NSString *)email key:(NSString *)key {
	key = [key stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	key = [key stringByReplacingOccurrencesOfString:@"\n" withString:@""];
	key = [key stringByReplacingOccurrencesOfString:@"\t" withString:@""];
	
	name = [name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	email = [email stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	NSDictionary *license = [NSDictionary dictionaryWithObjectsAndKeys:name, @"Name", email, @"Email", [NSData dataWithBase64EncodedString:key], @"Signature", nil];
	
	NSPropertyListFormat format = NSPropertyListXMLFormat_v1_0;
	return [NSPropertyListSerialization dataFromPropertyList:license 
													  format:format 
											errorDescription:NULL];
}


#pragma mark Growl delegate

- (void)growlNotificationWasClicked:(id)clickContext {
	[NSApp activateIgnoringOtherApps:YES];
	//[windowController.searches setSelectedObjects:[NSArray arrayWithObject:clickContext]];
}

- (BOOL)isGrowlInstalled {
	return [GrowlApplicationBridge isGrowlInstalled];
}


#pragma mark Preferences

- (void)refreshIntervalChanged {	
	[refreshTimer invalidate];
	
	NSString *refreshInterval = [[NSUserDefaults standardUserDefaults] stringForKey:JARefreshInterval];
    NSTimeInterval interval = 10000000;
	if([refreshInterval isEqualToString:@"Every minute"]) {
        interval = 60;
	} else if([refreshInterval isEqualToString:@"Every 5 minutes"]) {
        interval = 5*60;
	} else if([refreshInterval isEqualToString:@"Every 15 minutes"]) {
        interval = 15*60;
	} else if([refreshInterval isEqualToString:@"Every 30 minutes"]) {
        interval = 30*60;
	} else if([refreshInterval isEqualToString:@"Every hour"]) {
        interval = 60*60;
	} else if([refreshInterval isEqualToString:@"Every day"]) {
        interval = 60*60*24;
    }
    
    refreshTimer = [NSTimer scheduledTimerWithTimeInterval:interval 
                                                    target:windowController 
                                                  selector:@selector(refreshAllSearches:) 
                                                  userInfo:nil 
                                                   repeats:YES];
}


#pragma mark Searches

- (void)enqueueSearch:(Search *)search {
    [searchQueue addOperation:nil];
}


#pragma mark TCPListenerDelegate

- (void)listener:(TCPListener *)listener failedToOpen:(NSError *)error {
    NSLog(@"error: %@: %@", error, [error userInfo]);
}

- (void)listener:(TCPListener *)listener didAcceptConnection:(TCPConnection *)connection {
    currentConnection.delegate = nil;
    
    currentConnection = connection;
    currentConnection.delegate = self;
}


#pragma mark BLIPConnectionDelegate

- (void)connection:(TCPConnection *)connection failedToOpen:(NSError *)error {
    if(connection != currentConnection) return;
    
    NSLog(@"failed opening: %@: %@", error, [error userInfo]);
}

- (BOOL)connection:(BLIPConnection *)connection receivedRequest:(BLIPRequest *)request {
    if(connection != currentConnection) return NO;
    
    NSString *type = [request valueOfProperty:MPSyncServiceResponseTypeKey];
    if([type isEqualToString:MPSyncServiceResponseTypeHandshake]) {
        if([request.bodyString isEqualToString:@"hi"]) {
            BLIPResponse *response = request.response;
            [response setValue:type ofProperty:MPSyncServiceResponseTypeKey];
            response.bodyString = @"ok";
            [response send];
        } else {
            NSLog(@"invalid handshake: %@", request.bodyString);
        }
    } else if([type isEqualToString:MPSyncServiceResponseTypeBeginXfer]) {
        NSArray *searches = [SearchController sharedInstance].searches;
        NSArray *favorites = [FavoritesController sharedInstance].favorites;
        NSDictionary *wrappedInfo = [NSDictionary dictionaryWithObjectsAndKeys:searches, @"searches", favorites, @"favorites", nil];
        BLIPResponse *response = request.response;
        [response setValue:type ofProperty:MPSyncServiceResponseTypeKey];
        response.body = [NSKeyedArchiver archivedDataWithRootObject:wrappedInfo];
        [response send];
    } else {
        NSAssert1(NO, @"Invalid request type: %@", type);
    }
    
    return YES;
}

@synthesize persistentData;
@synthesize nameFromLicense;
@synthesize emailFromLicense;
@synthesize enterLicenseItem;
@synthesize purchaseLicenseItem;

@end
