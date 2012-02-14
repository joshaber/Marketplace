//
//  SearchCell.m
//  Marketplace
//
//  Created by Josh Abernathy on 3/24/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "SearchCell.h"
#import "Search.h"
#import "Region.h"


@interface SearchCell ()
- (void)drawTitleInFrame:(NSRect)cellFrame;
- (void)drawRegionsInFrame:(NSRect)cellFrame;
@end


@implementation SearchCell

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {
	[self setTextColor:[NSColor blackColor]];
		
	[self drawTitleInFrame:cellFrame];
	[self drawRegionsInFrame:cellFrame];
}

- (void)drawRegionsInFrame:(NSRect)cellFrame {
	Search *entry = [self objectValue];
	
	NSColor *secondaryColor = [self isHighlighted] ? [NSColor alternateSelectedControlTextColor] : [NSColor disabledControlTextColor];
	NSMutableString *secondaryText = [NSMutableString string];
	NSArray *regions = entry.regions;
	/*for(Region *region in regions) {
		if([secondaryText length] > 0) {
			[secondaryText appendString:@"\n"];
		}
		
		[secondaryText appendString:region.name];
	}*/
	[secondaryText appendFormat:@"%@", entry.category];
	if(entry.subcategory != nil) [secondaryText appendFormat:@": %@", entry.subcategory];
	[secondaryText appendFormat:@"\n", entry.category];
	
	[secondaryText appendFormat:@"%lu", (unsigned long) regions.count];
    if(regions.count == 1) [secondaryText appendString:@" region"];
    else [secondaryText appendString:@" regions"];
	
	NSDictionary* secondaryTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
											 secondaryColor, NSForegroundColorAttributeName, 
											 [NSFont systemFontOfSize:10], NSFontAttributeName, nil];
	
	[secondaryText drawAtPoint:NSMakePoint(cellFrame.origin.x, cellFrame.origin.y+18) 
				withAttributes:secondaryTextAttributes];
}

- (void)drawTitleInFrame:(NSRect)cellFrame {
	Search *entry = [self objectValue];
	
	NSColor *primaryColor = [self isHighlighted] ? [NSColor alternateSelectedControlTextColor] : [NSColor textColor];
	NSString *primaryText = entry.displayName;
	if([primaryText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length < 1) {
		primaryText = @"(no text)";
	}
	
	NSDictionary *primaryTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys: 
										   primaryColor, NSForegroundColorAttributeName, 
										   [NSFont systemFontOfSize:12], NSFontAttributeName, nil];
	
	[primaryText drawAtPoint:NSMakePoint(cellFrame.origin.x, NSMinY(cellFrame)) 
			  withAttributes:primaryTextAttributes];
}

@end
