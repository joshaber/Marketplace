//
//  RegionView.m
//  Layers
//
//  Created by Josh Abernathy on 12/16/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "RegionView.h"

#import "RegionSelectionView.h"


@interface RegionView ()
- (NSTrackingArea *)makeNewTrackingArea;
- (NSBezierPath *)arrowPath;
- (void)drawLabel;
- (void)drawCategory;
- (void)drawMouseOverGradient;
- (void)drawDecoration;
- (RegionSelectionView *)superview;
@end


@implementation RegionView

+ (RegionView *)regionViewWithLabel:(NSString *)l inCategory:(NSString *)c {
	RegionView *view = [[RegionView alloc] init];
	view.label = l;
	view.category = c;
	
	return [view autorelease];
}

- (id)init {
    self = [super init];
    
    shouldDrawCategory = NO;
    doesExpand = NO;
    
    return self;
}

- (void)drawRect:(NSRect)rect {
    // fill with a color so that text draws w/ subpixel antialiasing
    [[[NSColor whiteColor] colorWithAlphaComponent:0.7f] set];
    [NSBezierPath fillRect:rect];
        
	if([self isSelected]) {
		[self drawMouseOverGradient];
	}
	
	[self drawLabel];
	
	if(shouldDrawCategory) {
		[self drawCategory];
	}
	
	[self drawDecoration];
}

- (void)drawDecoration {
	[[NSColor colorWithDeviceWhite:(self.isSelected ? 0.95f : 0.3f) alpha:1.0f] set];
	
	if(doesExpand) {
		[[self arrowPath] fill];
	} /*else {
		NSRect frame = [self bounds];
		[NSBezierPath fillRect:NSMakeRect(frame.size.width - 20, 8, 4, 11)];
		[NSBezierPath fillRect:NSMakeRect(frame.size.width - 23, 12, 10, 4)];
	}*/
}

- (void)drawMouseOverGradient {
	NSColor *start = [NSColor colorWithDeviceRed:14.0f/255.0f green:55.0f/255.0f blue:231.0f/255.0f alpha:1.0f];
	NSColor *end = [NSColor colorWithDeviceRed:72.0f/255.0f green:103.0f/255.0f blue:234.0f/255.0f alpha:1.0f];
	NSGradient *gradient = [[NSGradient alloc] initWithStartingColor:start endingColor:end];
	
	NSBezierPath *rounded = [NSBezierPath bezierPathWithRoundedRect:[self bounds] 
															xRadius:4 
															yRadius:4];
	[gradient drawInBezierPath:rounded angle:90];
}

- (void)drawLabel {
	NSDictionary *textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
									self.isSelected ? [NSColor whiteColor] : [NSColor blackColor], NSForegroundColorAttributeName, 
									[NSFont fontWithName:@"Helvetica" size:11], NSFontAttributeName, nil];
	[label drawAtPoint:NSMakePoint(70, 5) withAttributes:textAttributes];
}

- (void)drawCategory {
	NSColor *textColor = [NSColor colorWithDeviceWhite:(self.isSelected ? 0.75f : 0.25f) alpha:0.5f];
	NSDictionary *textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
									textColor, NSForegroundColorAttributeName, 
									[NSFont fontWithName:@"Helvetica Bold" size:11], NSFontAttributeName, nil];
	[category drawAtPoint:NSMakePoint(10, 5) withAttributes:textAttributes];
}

- (void)viewDidMoveToSuperview {
	if(self.superview != nil) {
		[self setFrameSize:NSMakeSize(self.superview.frame.size.width - 7, 25)];
		
		trackingArea = [self makeNewTrackingArea];
		[self addTrackingArea:trackingArea];
	}
}

- (NSTrackingArea *)makeNewTrackingArea {	
	return [[NSTrackingArea alloc] initWithRect:[self frame]
										options:NSTrackingMouseEnteredAndExited | NSTrackingActiveInActiveApp 
										  owner:self 
									   userInfo:nil];
}

- (NSBezierPath *)arrowPath {
	NSRect frame = [self bounds];
	NSBezierPath *path = [NSBezierPath bezierPath];
	[path moveToPoint:NSMakePoint(frame.size.width - 20, 17)];
	[path lineToPoint:NSMakePoint(frame.size.width - 10, 12)];
	[path lineToPoint:NSMakePoint(frame.size.width - 20, 7)];
	[path lineToPoint:NSMakePoint(frame.size.width - 20, 17)];
	
	return path;
}

- (void)mouseEntered:(NSEvent *)event {
	[self.superview setSelectedView:self];
	[self setNeedsDisplay:YES];
}

- (void)mouseExited:(NSEvent *)event {
	[self.superview setSelectedView:nil];
	[self setNeedsDisplay:YES];
}

- (void)mouseDown:(NSEvent *)event {
	[self.superview viewClicked:self];
	[super mouseDown:event];
}

- (BOOL)isSelected {
	return [self.superview selectedView] == self;
}

- (BOOL)acceptsFirstMouse:(NSEvent *)event {
	return YES;
}

- (RegionSelectionView *)superview {
    return (RegionSelectionView *) super.superview;
}

@synthesize label;
@synthesize category;
@synthesize shouldDrawCategory;
@synthesize doesExpand;

@end
