//
//  GradientView.m
//  Marketplace
//
//  Created by Josh Abernathy on 3/27/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "JAGradientView.h"


@implementation JAGradientView

- (void)drawRect:(NSRect)rect {
	[gradient drawInRect:[self bounds] angle:90];
}

@synthesize gradient;

@end
