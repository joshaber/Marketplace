//
//  FavoritesViewController.m
//  Marketplace
//
//  Created by Josh Abernathy on 7/27/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "FavoritesViewController.h"
#import "JAViewCell.h"
#import "JACellView.h"
#import "JAGradientView.h"
#import "JATableView.h"
#import "SearchResult.h"
#import "AppDelegate.h"

#import "NSWorkspace+JAAdditions.h"
#import "NSObject+JAAdditions.h"
#import "NSArray+JAAdditions.h"
#import "NSString+Additions.h"


@interface FavoritesViewController ()
- (void)cleanCellViews;
- (void)resultsChanged;
- (void)emailSelectedPage;
@end


@implementation FavoritesViewController

- (void)viewDidLoad {
	// colors shamelessly stolen from Safari search bar
	topBarView.gradient = [[NSGradient alloc] initWithStartingColor:[NSColor colorWithCalibratedRed:(209.0f/255.0f) 
																							  green:(209.0f/255.0f) 
																							   blue:(209.0f/255.0f) 
																							  alpha:1.0f] 
														endingColor:[NSColor colorWithCalibratedRed:(233.0f/255.0f) 
																							  green:(233.0f/255.0f) 
																							   blue:(233.0f/255.0f) 
																							  alpha:1.0f]];
	
	bottomBarView.gradient = topBarView.gradient;
	
	[favoritesTable setDoubleAction:@selector(goToSelectedPage)];
    [favoritesTable setIntercellSpacing:NSMakeSize(0, 0)];
	[[[favoritesTable tableColumns] firstObject] setDataCell:[[JAViewCell alloc] init]];
	
	[favorites addObserver:self 
				forKeyPath:@"arrangedObjects" 
				   options:NSKeyValueObservingOptionNew 
				   context:@selector(resultsChanged)];
	
	[favorites setSortDescriptors:[NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO]]];
	
	[webView setPolicyDelegate:self];
    [webView setMaintainsBackForwardList:NO];
    
    // override Craigslist's fugly css
    NSString *styleFilePath = [[NSApp delegate] pathForDataFile:@"style.css"];
    if(![[NSFileManager defaultManager] fileExistsAtPath:styleFilePath]) {
        NSError *error = nil;
        BOOL success = [[NSFileManager defaultManager] copyItemAtPath:[[NSBundle mainBundle] pathForResource:@"style" ofType:@"css"] toPath:styleFilePath error:&error];
        if(!success) {
            NSLog(@"Failed copying style css: %@", error);
        }
    }
    
    [webView setPreferencesIdentifier:[[NSBundle mainBundle] bundleIdentifier]];
    WebPreferences *prefs = [webView preferences];
    [prefs setAutosaves:YES];
    [prefs setUserStyleSheetEnabled:YES];
    [prefs setUserStyleSheetLocation:[NSURL fileURLWithPath:styleFilePath]];
    [prefs setCacheModel:WebCacheModelPrimaryWebBrowser];
    [prefs setUsesPageCache:NO];
	
	[splitView setVertical:[[NSUserDefaults standardUserDefaults] boolForKey:JAResultsViewVertical]];
}

- (void)filterPredicateChanged {
	// clean out the old cell views
	// probably not crazy efficient but it works ok
	[self cleanCellViews];
}

- (void)resultsChanged {
	[self postValueChangedForKey:@"searchableResults"];
	[self postValueChangedForKey:@"displayableResults"];
	[self cleanCellViews];
}

- (void)goToSelectedPage {
	NSArray *selected = [favorites selectedObjects];
	NSMutableArray *urls = [NSMutableArray array];
	for(SearchResult *item in selected) {
		[urls addObject:[NSURL URLWithString:item.url]];
	}
	
	if([[NSUserDefaults standardUserDefaults] boolForKey:JAOpenLinksInBackground]) {
		[[NSWorkspace sharedWorkspace] openURLsInBackground:urls];
	} else {
		[[NSWorkspace sharedWorkspace] openURLs:urls];
	}
}

- (void)emailSelectedPage {
	NSArray *selected = [favorites selectedObjects];
	if(selected.count < 1) return;
	
	SearchResult *result = [selected firstObject];
	NSMutableString *subject = [NSMutableString string];
	NSMutableString *body = [NSMutableString string];
	
	[subject appendFormat:@"Craig's List: %@", result.title];
	[body appendFormat:@"Hi!\n\nYou are receiving this email because %@ wanted to let you know about a posting on Craig's List:\n\n", NSFullUserName()];
	[body appendFormat:@"%@ (%@): %@\n\nEnjoy!\n\n--------\n\n", result.title, result.region, result.url];
	[body appendFormat:@"Email created by Marketplace (http://www.marketplacemac.com/). Craig's List, without the Ugly.\n\n"];
	
	subject = [[subject stringByEscapingForURLArgument] mutableCopy];
	body = [[body stringByEscapingForURLArgument] mutableCopy];
	
	// abuse of openURL? maybe
	NSString *urlString = [NSString stringWithFormat:@"mailto:?subject=%@&body=%@", subject, body];
	[[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:urlString]];
}

- (void)cleanCellViews {
	NSArray *subviews = [[favoritesTable subviews] copy];
	for(NSView *view in subviews) {
		if([view isKindOfClass:[JACellView class]]) {
			[view removeFromSuperviewWithoutNeedingDisplay];
		}
	}
}

- (NSArray *)displayableResults {
	return [favorites arrangedObjects];
}

- (NSArray *)searchableResults {
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isSearchable == YES"];
	return [[favorites arrangedObjects] filteredArrayUsingPredicate:predicate];
}

- (void)observeValueForKeyPath:(NSString *)keyPath 
					  ofObject:(id)object 
						change:(NSDictionary *)change 
					   context:(void *)context {
	SEL selector = (SEL)context;
	if([self respondsToSelector:selector]) {
		[self performSelector:selector];
	}
}


#pragma mark Table methods

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
    return 55.0f;
}

- (void)tableView:(JATableView *)tableView keyDown:(NSEvent *)event {
	unichar key = [[event charactersIgnoringModifiers] characterAtIndex:0];
	
	if(key == NSRightArrowFunctionKey) {
		[self goToSelectedPage];
	} else if(key == ' ') {
        if([event modifierFlags] & NSShiftKeyMask) {
            [webView scrollPageUp:nil];
        } else {
            [webView scrollPageDown:nil];
        }
	} else {
		[tableView forwardKeyDown:event];
	}
}

- (BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)rowIndex {
	if([[[favorites arrangedObjects] objectAtIndex:rowIndex] isKindOfClass:[SearchResult class]]) {
		return YES;
	}
	
	return NO;
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification {
	NSArray *selectedObjects = [favorites selectedObjects];
	
	if([selectedObjects count] > 0) {
		SearchResult *selected = [selectedObjects firstObject];
        [webView setMainFrameURL:selected.url];
	} else {
		[[webView mainFrame] loadHTMLString:@"" baseURL:nil];
	}
}


#pragma mark Web policy delegate

- (void)webView:(WebView *)sender 
decidePolicyForNavigationAction:(NSDictionary *)actionInformation 
		request:(NSURLRequest *)request 
		  frame:(WebFrame *)frame 
decisionListener:(id <WebPolicyDecisionListener>)listener {	
	if ([[actionInformation objectForKey:WebActionNavigationTypeKey] integerValue] != WebNavigationTypeOther) {
		[listener ignore];
		[[NSWorkspace sharedWorkspace] openURL:[request URL]];
	} else {
		[listener use];
	}
}

@synthesize favoritesTable;
@synthesize favorites;
@synthesize webView;
@synthesize topBarView;
@synthesize bottomBarView;
@synthesize splitView;

@end
