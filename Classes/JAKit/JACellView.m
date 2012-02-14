//
//  CellView.m
//  Marketplace
//
//  Created by Josh Abernathy on 7/3/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "JACellView.h"


@implementation JACellView

- (void)mouseDown:(NSEvent *)event {
	[super mouseDown:event];
	
	self.isBeingClicked = YES;
	
	[self setNeedsDisplay:YES];
}

- (void)mouseUp:(NSEvent *)event {
	[super mouseUp:event];
	
	self.isBeingClicked = NO;
	
	[self setNeedsDisplay:YES];
}

@synthesize isHighlighted;
@synthesize isBeingClicked;

@end
