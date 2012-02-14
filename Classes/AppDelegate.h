//
//  AppDelegate.h
//  Marketplace
//
//  Created by Josh Abernathy on 12/22/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Growl/Growl.h>
#import "MYNetwork.h"

#define WEBSITE_URL @"http://www.marketplacemac.com/"
#define STORE_URL @"http://www.marketplacemac.com/buy/"
#define HELP_URL @"http://www.marketplacemac.com/support/"

#define JARefreshInterval @"JARefreshInterval"
#define JAOpenLinksInBackground @"JAOpenLinksInBackground"
#define JARefreshSearchesAtStartup @"JARefreshSearchesAtStartup"
#define JAFirstLaunch @"SUHasLaunchedBefore"
#define JAShowNewResultsNotifications @"JAShowNewResultsNotifications"
#define JAShowNotificationsOnlyWhenInactive @"JAShowNotificationsOnlyWhenInactive"
#define JAResultsViewVertical @"JAResultsViewVertical"
#define JACloseRegionsWindowAfterAdding @"JACloseRegionsWindowAfterAdding"
#define JABuildHash @"JABuildHash"
#define JARefreshSearchesAtWake @"JARefreshSearchesAtWake"
#define JARefreshSearchesAtScreenSaverEnd @"JARefreshSearchesAtScreenSaverEnd"

@class MainWindowController;
@class PreferencesWindowController;
@class EnterLicenseWindowController;
@class Search;


@interface AppDelegate : NSObject <GrowlApplicationBridgeDelegate, BLIPConnectionDelegate, TCPListenerDelegate> {
	MainWindowController *windowController;
    PreferencesWindowController *preferencesWindowController;
    EnterLicenseWindowController *enterLicenseWindowController;
    NSWindowController *aboutWindowController;
	NSTimer *refreshTimer;
	
	NSDictionary *persistentData;
	NSData *licenseData;
	
	NSDate *startDate;
	
	NSString *nameFromLicense;
	NSString *emailFromLicense;
	
	NSMenuItem *enterLicenseItem;
	NSMenuItem *purchaseLicenseItem;
    
    NSOperationQueue *searchQueue;
    
    BLIPListener *syncListener;
    TCPConnection *currentConnection;
}

- (IBAction)goToWebsite:(id)sender;
- (IBAction)goToStore:(id)sender;
- (IBAction)showAbout:(id)sender;
- (IBAction)showPreferences:(id)sender;
- (IBAction)showEnterLicense:(id)sender;
- (IBAction)showHelp:(id)sender;

- (BOOL)isValidLicenseData:(NSData *)data;
- (void)validateAndStoreLicense:(NSData *)data;
- (BOOL)isLicensed;
- (BOOL)isLicensedOrInTrial;
- (NSInteger)daysUntilExpiration;
- (NSData *)licenseDataForName:(NSString *)name email:(NSString *)email key:(NSString *)key;

- (NSString *)pathForDataFile:(NSString *)name;

- (NSString *)version;

- (void)enqueueSearch:(Search *)search;

@property (assign) NSDictionary *persistentData;
@property (assign, nonatomic) IBOutlet NSMenuItem *enterLicenseItem;
@property (assign, nonatomic) IBOutlet NSMenuItem *purchaseLicenseItem;
@property (assign) NSString *nameFromLicense;
@property (assign) NSString *emailFromLicense;

@end
