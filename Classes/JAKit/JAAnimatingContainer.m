//
//  JAAnimatingContainer.m
//  ManyViewTest
//
//  Created by Josh Abernathy on 2/27/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "JAAnimatingContainer.h"


@interface JAAnimatingContainer ()
- (CAAnimation *)flyAnimationTo:(NSPoint)loc;
- (CAAnimation *)scaleAnimationTo:(NSSize)scale;
@end


@implementation JAAnimatingContainer

+ (JAAnimatingContainer *)containerFromWindow:(NSWindow *)window {
    return [self containerFromView:[[window contentView] superview]];
}

+ (JAAnimatingContainer *)containerFromView:(NSView *)view {
	NSRect bounds = view.bounds;
	NSBitmapImageRep *bitmap = [view bitmapImageRepForCachingDisplayInRect:bounds];
	[view cacheDisplayInRect:bounds toBitmapImageRep:bitmap];
	
	NSPoint location = [view.window convertBaseToScreen:view.frame.origin];
	JAAnimatingContainer *container = [JAAnimatingContainer containerWithImage:bitmap.CGImage at:location onScreen:view.window.screen];
	container->view = view;
	container->originalParentWindow = view.window;
	return container;
}

+ (JAAnimatingContainer *)containerWithImage:(CGImageRef)image at:(NSPoint)loc onScreen:(NSScreen *)screen {
	NSWindow *window = [[NSWindow alloc] initWithContentRect:screen.frame
												   styleMask:NSBorderlessWindowMask
													 backing:NSBackingStoreBuffered 
													   defer:NO];
	
	[window setOpaque:NO];
	[window useOptimizedDrawing:YES];
	[window setMovableByWindowBackground:NO];
	
	window.hasShadow = NO;
	window.backgroundColor = [NSColor clearColor];
		
	CALayer *mainLayer = [CALayer layer];
	mainLayer.anchorPoint = CGPointMake(0.5f, 0.5f);
	
	CGRect rect;
	rect.size = CGSizeMake(CGImageGetWidth(image), CGImageGetHeight(image));
	rect.origin = NSPointToCGPoint(loc);
	mainLayer.frame = rect;
	mainLayer.contents = (id) image;
	mainLayer.shadowColor = CGColorCreateGenericGray(0.2f, 1.0f);
	mainLayer.shadowOffset = CGSizeMake(0, -4);
	mainLayer.shadowRadius = 4.0;
	mainLayer.shadowOpacity = 0.5f;
	
	NSView *rootView = window.contentView;
	[rootView setLayer:[CALayer layer]];
	[rootView setWantsLayer:YES];
	[[rootView layer] addSublayer:mainLayer];
	
	JAAnimatingContainer *container = [[JAAnimatingContainer alloc] init];
	container->hostWindow = window;
	return [container autorelease];
}

- (void)flyTo:(NSPoint)loc {	
	[self startAnimation:[self flyAnimationTo:loc] forKey:@"fly"];
}

- (void)scaleTo:(NSSize)scale {	
	[self startAnimation:[self scaleAnimationTo:scale] forKey:@"scale"];
}

- (void)startAnimation:(CAAnimation *)animation forKey:(NSString *)key {
	[[self animationLayer] addAnimation:animation forKey:key];
}

- (void)swapViewWithContainer {
	if(view == nil) return;
	
	NSDisableScreenUpdates();
	[view removeFromSuperview];
	[hostWindow orderFront:nil];
	[view.window display];
	NSEnableScreenUpdates();
}

- (void)swapContainerWithView {
	if(view == nil) return;
	
	NSDisableScreenUpdates();
	[originalParentWindow.contentView addSubview:view];
	[hostWindow orderOut:nil];
	[originalParentWindow display];
	NSEnableScreenUpdates();
}

- (CALayer *)animationLayer {
	return [[[hostWindow.contentView layer] sublayers] objectAtIndex:0];
}

- (CAAnimation *)flyAnimationTo:(NSPoint)loc {
	static const CGFloat DEFAULT_DURATION = 0.5f;
	
	CGFloat duration = ([hostWindow currentEvent].modifierFlags & NSShiftKeyMask) ? 10.0f : DEFAULT_DURATION;
	
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    animation.toValue = [NSValue valueWithPoint:loc];
    animation.duration = duration;
	animation.fillMode = kCAFillModeForwards;
	animation.removedOnCompletion = NO;
	animation.delegate = delegate;
	
	return animation;
}

- (CAAnimation *)scaleAnimationTo:(NSSize)scale {
	static const CGFloat DEFAULT_DURATION = 0.5f;
	
	CGFloat duration = ([hostWindow currentEvent].modifierFlags & NSShiftKeyMask) ? 10.0f : DEFAULT_DURATION;
	
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.toValue = [NSValue valueWithSize:scale];
    animation.duration = duration;
	animation.fillMode = kCAFillModeForwards;
	animation.removedOnCompletion = NO;
	animation.delegate = delegate;
	
	return animation;
}

@synthesize hostWindow;
@synthesize delegate;

@end
