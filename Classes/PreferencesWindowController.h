//
//  PreferencesWindowController.h
//  Marketplace
//
//  Created by Josh Abernathy on 11/4/09.
//  Copyright 2009 Dandy Code. All rights reserved.
//

#import <Cocoa/Cocoa.h>

extern NSString * const JARefreshIntervalChangedNotification;


@interface PreferencesWindowController : NSWindowController {

}

+ (PreferencesWindowController *)defaultController;

- (IBAction)refreshIntervalChanged:(id)sender;

@end
