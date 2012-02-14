//
//  JADottedSeparator.m
//  Marketplace
//
//  Created by Josh Abernathy on 3/18/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "JADottedSeparator.h"


@implementation JADottedSeparator

- (void)drawRect:(NSRect)rect {
	NSBezierPath *path = [NSBezierPath bezierPath];
	[path moveToPoint:NSMakePoint(NSMinX(self.bounds), NSMaxY(self.bounds))];
	[path lineToPoint:NSMakePoint(NSMinX(self.bounds), NSMinY(self.bounds))];
	
	CGFloat pattern[2] = { 1.6f, 1.6f };
	[path setLineDash:pattern count:2 phase:0.0f];
	
	[[NSColor grayColor] set];
	[path stroke];
}

@end
