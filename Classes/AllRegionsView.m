//
//  AllRegionsView.m
//  Marketplace
//
//  Created by Josh Abernathy on 9/23/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AllRegionsView.h"


@implementation AllRegionsView

+ (AllRegionsView *)allRegionsView {
    AllRegionsView *view = [[AllRegionsView alloc] init];
    view.label = @"All";
    view.category = @"";
    return [view autorelease];
}

- (void)drawLabel {
	NSDictionary *textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
									self.isSelected ? [NSColor whiteColor] : [NSColor blackColor], NSForegroundColorAttributeName, 
									[NSFont fontWithName:@"Helvetica Bold" size:12], NSFontAttributeName, nil];
	[label drawAtPoint:NSMakePoint(70, 5) withAttributes:textAttributes];
}

@end
