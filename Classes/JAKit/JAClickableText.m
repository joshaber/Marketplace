//
//  JAClickableText.m
//
//  Created by Ben Haller on Tue Jul 15 2003.
//
//  This code is hereby released into the public domain.  Do with it as you wish.
//

#import "JAClickableText.h"


@implementation NSColor (ClickableTextColors)

+ (NSColor *)basicClickableTextColor {
	static NSColor *cachedColor = nil;
	
	if(!cachedColor) {
		cachedColor = [NSColor colorWithCalibratedRed:0.0f 
												green:0.0f 
												 blue:0.0f 
												alpha:1.0f];
	}
	
	return cachedColor;
}

+ (NSColor *)trackingClickableTextColor {
	static NSColor *cachedColor = nil;
	
	if(!cachedColor) {
		cachedColor = [NSColor colorWithCalibratedRed:1.0f 
												green:0.0f 
												 blue:0.0f 
												alpha:1.0f];
	}
	
	return cachedColor;
}

+ (NSColor *)visitedClickableTextColor {
	static NSColor *cachedColor = nil;
	
	if(!cachedColor) {
		cachedColor = [NSColor colorWithCalibratedRed:0.4f 
												green:0.2f 
												 blue:0.7f 
												alpha:1.0f];
	}
	
	return cachedColor;
}

@end


@implementation JAClickableText

- (void)finishInitialization {
	[self setBordered:NO];
	[self setBezeled:NO];
	[self setDrawsBackground:NO];
	[self setEditable:NO];
	[self setSelectable:NO];
	[self setEnabled:YES];
	[self setTextColor:[NSColor basicClickableTextColor]];
}

- (id)initWithCoder:(NSCoder *)decoder {
	if((self = [super initWithCoder:decoder])) {
		[self finishInitialization];
	}
	
	return self;
}

- (id)initWithFrame:(NSRect)frame {
	if((self = [super initWithFrame:frame])) {
		[self finishInitialization];
	}
	
	return self;
}

- (void)mouseDown:(NSEvent *)event {
	BOOL mouseInside = YES;
	
	beingClicked = YES;
	[self setTextColor:[NSColor trackingClickableTextColor]];
	
	while(beingClicked && (event = [[self window] 
									 nextEventMatchingMask:(NSLeftMouseUpMask | NSLeftMouseDraggedMask)])) {
		NSEventType type = [event type];
		NSPoint location = [event locationInWindow];
		
		location = [self convertPoint:location fromView:nil];
		mouseInside = NSPointInRect(location, [self bounds]);
		
		if(mouseInside) {
			[self setTextColor:[NSColor trackingClickableTextColor]];
		} else if(beenClicked) {
			//[self setTextColor:[NSColor visitedClickableTextColor]];
		} else {
			//[self setTextColor:[NSColor basicClickableTextColor]];
		}
			
		if (type == NSLeftMouseUp) {
			beingClicked = NO;
		}
	}
	
	if(mouseInside) {
		beenClicked = YES;
		[self setTextColor:[NSColor visitedClickableTextColor]];
		[self sendAction:[self action] to:[self target]];
	}
}

@end
