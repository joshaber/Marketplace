//
//  ShadowedViewContainer.h
//
//  Created by Josh Abernathy on 2/24/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface JAShadowedViewContainer : NSView {
	NSView *shadowedView;
	
	NSShadow *shadow;
	
	NSSize shadowOffset;
	CGFloat blurRadius;
	NSColor *shadowColor;
	
	NSBezierPath *shadowPath;
	
	BOOL showShadow;
}

@property (assign) IBOutlet NSView *shadowedView;
@property (assign) NSSize shadowOffset;
@property (assign) CGFloat blurRadius;
@property (assign) NSColor *shadowColor;
@property (assign) BOOL showShadow;
@property (assign) NSBezierPath *shadowPath;

@end
