//
//  JAViewController.h
//  Marketplace
//
//  Created by Josh Abernathy on 7/30/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface JAViewController : NSViewController {
	NSWindowController *windowController;
}

+ (id)defaultController;

- (void)viewWillLoad;
- (void)viewDidLoad;

@property (assign, nonatomic) IBOutlet NSWindowController *windowController;

@end
