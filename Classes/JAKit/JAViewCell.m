//
//  ViewCell.m
//  Marketplace
//
//  Created by Josh Abernathy on 6/29/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "JAViewCell.h"

@interface NSObject (JAViewCellDelegate)
- (NSValue *)adjustFrame:(NSValue *)defaultRect;
@end


@implementation JAViewCell

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {
	NSView *view = [[self objectValue] view];
	
	NSRect viewRect = cellFrame;
	// check if the view wants to change its frame
	if([view respondsToSelector:@selector(adjustFrame:)]) {
		NSValue *newRect = [view performSelector:@selector(adjustFrame:) 
									  withObject:[NSValue valueWithRect:cellFrame]];
		viewRect = [newRect rectValue];
	}
		
	if([view superview] != controlView) {
		[controlView addSubview:view];
		[view setFrame:viewRect];
    }
	
	// don't change the frame unless we have to
	if(!NSEqualRects([view frame], viewRect)) {
		[view setFrame:viewRect];
	}
}

// Override this to intercept mouse click selection *and* keyboard selection
- (void)setHighlighted:(BOOL)h {
	[super setHighlighted:h];
	[[[self objectValue] view] setValue:[NSNumber numberWithBool:h] forKey:@"isHighlighted"];
}

@end
