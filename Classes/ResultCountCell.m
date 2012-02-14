//
//  ResultCountCell.m
//  Marketplace
//
//  Created by Josh Abernathy on 4/12/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "ResultCountCell.h"
#import "Search.h"


@implementation ResultCountCell

static NSColor *defaultColor;
static NSColor *alternateColor;

+ (void)initialize {
    if([self class] == [ResultCountCell class]) {
        defaultColor = [NSColor colorWithCalibratedRed:149.0f/255.0f
                                                 green:155.0f/255.0f
                                                  blue:204.0f/255.0f
                                                 alpha:1.0f];
        alternateColor = [NSColor whiteColor];
    }
}

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {
	NSRect rect = cellFrame;
	rect.origin.y += 3;
	rect.size.height = 16;
	
	NSInteger count = [self integerValue];
	if(count <= 0) return;
		
	NSColor *fillColor = [self isHighlighted] ? alternateColor : defaultColor;
	[fillColor setFill];
	
	NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
	[style setAlignment:NSCenterTextAlignment];
	
	NSColor *fontColor = [self isHighlighted] ? defaultColor : alternateColor;
	NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
				  fontColor, NSForegroundColorAttributeName, 
				  [NSFont boldSystemFontOfSize:11], NSFontAttributeName, 
				  style, NSParagraphStyleAttributeName, nil];
    
    NSString *countString = [NSString stringWithFormat:@"%ld", (long) count];
    NSSize stringSize = [countString sizeWithAttributes:attributes];
    stringSize.width = MAX(stringSize.width + 10, 30);
    
    NSRect pillRect = NSMakeRect(NSMidX(rect) - stringSize.width/2, rect.origin.y, stringSize.width, rect.size.height);
    [[NSBezierPath bezierPathWithRoundedRect:pillRect xRadius:10.0f yRadius:10.0f] fill];
	[countString drawInRect:rect withAttributes:attributes];
}

@end
