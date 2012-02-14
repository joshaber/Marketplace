//
//  ShadowedViewContainer.m
//
//  Created by Josh Abernathy on 2/24/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "JAShadowedViewContainer.h"

@interface JAShadowedViewContainer ()
@end


@implementation JAShadowedViewContainer

- (id)initWithFrame:(NSRect)frame {
	self = [super initWithFrame:frame];
	
	self.shadowOffset = NSMakeSize(0, 0);
	self.blurRadius = 12.0f;
	self.shadowColor = [NSColor shadowColor];
	self.showShadow = YES;
	self.shadowPath = nil;
	
	return self;
}

- (void)drawRect:(NSRect)rect {
    if(self.shadowPath == nil) {
        self.shadowPath = [NSBezierPath bezierPathWithRect:shadowedView.frame];
    }
    
	if(showShadow) {
		[NSGraphicsContext saveGraphicsState];
		
		[self.shadow set];
		[[NSColor redColor] set];
		[shadowPath fill];
		
		[NSGraphicsContext restoreGraphicsState];
	}
	
	[super drawRect:rect];
}

- (NSShadow *)shadow {
	if(shadow == nil) {
		shadow = [[NSShadow alloc] init];
		[shadow setShadowOffset:shadowOffset];
		[shadow setShadowBlurRadius:blurRadius];
		[shadow setShadowColor:shadowColor];
	}
	
	return shadow;
}

- (void)setShadowOffset:(NSSize)offset {
	shadowOffset = offset;
	shadow = nil;
}

- (void)setBlurRadius:(CGFloat)radius {
	blurRadius = radius;
	shadow = nil;
}

- (void)setShadowColor:(NSColor *)color {
	shadowColor = color;
	shadow = nil;
}

- (void)setShadowPath:(NSBezierPath *)path {
	shadowPath = path;
	shadow = nil;
}

- (void)setShowShadow:(BOOL)show {
	showShadow = show;
	shadow = nil;
}

@synthesize shadowedView;
@synthesize shadowOffset;
@synthesize blurRadius;
@synthesize shadowColor;
@synthesize showShadow;
@synthesize shadowPath;

@end
