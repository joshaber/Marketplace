//
//  PreferencesWindowController.m
//  Marketplace
//
//  Created by Josh Abernathy on 11/4/09.
//  Copyright 2009 Dandy Code. All rights reserved.
//

#import "PreferencesWindowController.h"

NSString * const JARefreshIntervalChangedNotification = @"JARefreshIntervalChanged";


@implementation PreferencesWindowController

+ (PreferencesWindowController *)defaultController {
	return [[[PreferencesWindowController alloc] initWithWindowNibName:@"PreferencesWindow"] autorelease];
}

- (IBAction)refreshIntervalChanged:(id)sender {
	[[NSNotificationCenter defaultCenter] postNotificationName:JARefreshIntervalChangedNotification object:nil];
}

@end
