//
//  DividerCellView.m
//  Marketplace
//
//  Created by Josh Abernathy on 7/4/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "DividerCellView.h"


@implementation DividerCellView

- (void)awakeFromNib {	
	gradientView.gradient = [[NSGradient alloc] initWithStartingColor:[NSColor colorWithDeviceRed:(150.0f/255.0f) 
																							green:(165.0f/255.0f) 
																							 blue:(178.0f/255.0f) 
																							alpha:1.0f] 
														  endingColor:[NSColor colorWithDeviceRed:(180.0f/255.0f) 
																							green:(195.0f/255.0f) 
																							 blue:(208.0f/255.0f) 
																							alpha:1.0f]];
}

- (NSValue *)adjustFrame:(NSValue *)defaultRect {
	NSRect rect = [defaultRect rectValue];
	rect.origin.x--;
	rect.origin.y--;
	rect.size.width += 4;
	rect.size.height += 3;
	
	return [NSValue valueWithRect:rect];
}

@synthesize gradientView;

@end
