//
//  JAMouseOverCellView.m
//  Marketplace
//
//  Created by Josh Abernathy on 7/17/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "JAMouseOverCellView.h"


@implementation JAMouseOverCellView

- (void)viewDidMoveToSuperview {
	if([self superview] != nil) {
		trackingArea = [self makeNewTrackingArea];
		[self addTrackingArea:trackingArea];
	}
}

- (NSTrackingArea *)makeNewTrackingArea {
	return [[NSTrackingArea alloc] initWithRect:[self frame]
										options:NSTrackingMouseEnteredAndExited | NSTrackingActiveInActiveApp 
										  owner:self 
									   userInfo:nil];
}

- (void)mouseEntered:(NSEvent *)event {
	self.isMouseOver = YES;
	[self setNeedsDisplay:YES];
}

- (void)mouseExited:(NSEvent *)event {
	self.isMouseOver = NO;
	[self setNeedsDisplay:YES];
}

- (void)mouseDown:(NSEvent *)event {
	[super mouseDown:event];
	[self setNeedsDisplay:YES];
}

- (void)mouseUp:(NSEvent *)event {
	[super mouseUp:event];
	[self setNeedsDisplay:YES];
}

@synthesize isMouseOver;

@end
