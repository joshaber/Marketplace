//
//  JAFloatingView.m
//  Marketplace
//
//  Created by Josh Abernathy on 1/20/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "JAFloatingView.h"


@implementation JAFloatingView

- (id)initWithFrame:(NSRect)frame {
	self = [super initWithFrame:frame];
	
	hostWindow = [[NSWindow alloc] initWithContentRect:frame 
											 styleMask:NSBorderlessWindowMask 
											   backing:NSBackingStoreBuffered 
												 defer:NO];
	[hostWindow setContentView:self];
	[hostWindow setMovableByWindowBackground:NO];
	[hostWindow setOpaque:NO];
	[hostWindow setHasShadow:YES];
	[hostWindow useOptimizedDrawing:YES];
	[hostWindow setBackgroundColor:[NSColor clearColor]];
	
	return self;
}

- (void)showAtPoint:(NSPoint)point inWindow:(NSWindow *)parent {
	parentWindow = parent;
		
	[parentWindow addChildWindow:hostWindow ordered:NSWindowAbove];
	
	[hostWindow orderFront:nil];
	[hostWindow setFrameOrigin:[parentWindow convertBaseToScreen:point]];
}

- (IBAction)close:(id)sender {
	[parentWindow removeChildWindow:hostWindow];
	[hostWindow orderOut:nil];
}

@synthesize parentWindow;

@end
