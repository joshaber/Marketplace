//
//  JATextFieldCell.m
//  Marketplace
//
//  Created by Josh Abernathy on 7/26/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "JATextFieldCell.h"


@implementation JATextFieldCell

static NSColor *defaultColor;
static NSColor *alternateColor;

+ (void)initialize {
    if([self class] == [JATextFieldCell class]) {
        defaultColor = [NSColor textColor];
        alternateColor = [NSColor alternateSelectedControlTextColor];
    }
}

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {
	NSColor *fontColor = [self isHighlighted] ? alternateColor : defaultColor;
	NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
								fontColor, NSForegroundColorAttributeName, 
								[self font], NSFontAttributeName, nil];
	
	[[self stringValue] drawInRect:cellFrame withAttributes:attributes];
}

@end
