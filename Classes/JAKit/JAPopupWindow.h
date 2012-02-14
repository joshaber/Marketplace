//
//  CustomWindow.h
//  Marketplace
//
//  Created by Josh Abernathy on 2/8/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>


@class JAAnimatingContainer;

@interface JAPopupWindow : NSWindow {
	NSWindow *parent;
	JAAnimatingContainer *animatingContainer;
}

- (IBAction)animateClose:(id)sender;
- (IBAction)animateOpen:(id)sender;

- (void)closeWindow;

@property (assign) IBOutlet NSWindow *parent;

@end
