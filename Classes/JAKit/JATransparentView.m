//
//  JATransparentView.m
//  Marketplace
//
//  Created by Josh Abernathy on 1/12/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "JATransparentView.h"


@implementation JATransparentView

- (void)drawRect:(NSRect)rect {
    [[NSColor clearColor] set];
	[NSBezierPath fillRect:rect];
}

@end
