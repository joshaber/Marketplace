//
//  JAFloatingView.h
//  Marketplace
//
//  Created by Josh Abernathy on 1/20/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface JAFloatingView : NSView {
	NSWindow *hostWindow;
	NSWindow *parentWindow;
}

- (void)showAtPoint:(NSPoint)point inWindow:(NSWindow *)parent;
- (IBAction)close:(id)sender;

@property (assign, nonatomic) IBOutlet NSWindow *parentWindow;

@end
