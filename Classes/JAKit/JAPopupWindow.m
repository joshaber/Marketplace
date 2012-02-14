//
//  CustomWindow.m
//  Marketplace
//
//  Created by Josh Abernathy on 2/8/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "JAPopupWindow.h"
#import "JAAnimatingContainer.h"


@interface JAPopupWindow ()
- (CAAnimation *)popUpAnimation;
@end


@implementation JAPopupWindow

NSRect centerRectInRect(NSRect rect, NSRect parent) {
	NSRect result = rect;
	
	result.origin.x = parent.origin.x + parent.size.width/2 - result.size.width/2;
	result.origin.y = parent.origin.y + parent.size.height/2 - result.size.height/2;
	
	return result;
}


static const NSInteger SIZE_DELTA = 95;
static const CGFloat ANIMATION_DURATION = 0.17f;

- (id)initWithContentRect:(NSRect)contentRect 
				styleMask:(NSUInteger)windowStyle 
				  backing:(NSBackingStoreType)bufferingType 
					defer:(BOOL)deferCreation {
	self = [super initWithContentRect:contentRect 
							styleMask:NSBorderlessWindowMask 
							  backing:NSBackingStoreBuffered 
								defer:NO];
	
	[self setMovableByWindowBackground:NO];
	[self setAlphaValue:1.0f];
	[self setOpaque:NO];
	[self setHasShadow:YES];
	[self useOptimizedDrawing:YES];
	
	return self;
}

- (BOOL)canBecomeMainWindow { return NO; }
- (BOOL)canBecomeKeyWindow { return YES; }
- (BOOL)isExcludedFromWindowsMenu { return YES; }
- (BOOL)isKeyWindow { return YES; }

- (BOOL)validateMenuItem:(NSMenuItem *)item {
	return [parent validateMenuItem:item];
}

- (IBAction)performClose:(id)sender {
	[parent performClose:sender];
}

- (IBAction)animateClose:(id)sender {
	[parent makeKeyAndOrderFront:nil];
	
	[NSAnimationContext beginGrouping];
		[[NSAnimationContext currentContext] setDuration:ANIMATION_DURATION];
		[[self animator] setAlphaValue:0.0f];
	[NSAnimationContext endGrouping];
		
	[self performSelector:@selector(closeWindow) withObject:nil afterDelay:ANIMATION_DURATION + 0.01];
}

- (void)closeWindow {
	[parent removeChildWindow:self];
	[self orderOut:nil];
}

- (IBAction)animateOpen:(id)sender {
	[self setFrame:centerRectInRect([self frame], [parent frame]) display:NO];
    [self setAlphaValue:0.0];
    [self makeKeyAndOrderFront:nil];
	
	animatingContainer = [JAAnimatingContainer containerFromWindow:self];
	// make the layer transparent from the start, otherwise we see it right before the animation starts
	[[animatingContainer animationLayer] setValue:[NSNumber numberWithDouble:0.0] forKeyPath:@"opacity"];
	[animatingContainer.hostWindow makeKeyAndOrderFront:nil];
	[animatingContainer startAnimation:[self popUpAnimation] forKey:@"animateWindow"];
}

- (void)animationDidStop:(CAAnimation *)animation finished:(BOOL)finished {
    if(!finished) return;
    
    [parent addChildWindow:self ordered:NSWindowAbove];
    [self makeKeyAndOrderFront:nil];
    
	NSDisableScreenUpdates();
    [self setAlphaValue:1.0f];
    [animatingContainer.hostWindow setAlphaValue:0.0];
	NSEnableScreenUpdates();

    [animatingContainer.hostWindow orderOut:nil];
}

- (CAAnimation *)popUpAnimation {
	CGFloat duration = ([self currentEvent].modifierFlags & NSShiftKeyMask) ? 10.0f : 0.25f;

	NSMutableArray *frames = [NSMutableArray array];
	[frames addObject:[NSNumber numberWithDouble:0.0]];
	[frames addObject:[NSNumber numberWithDouble:1.25]];
	[frames addObject:[NSNumber numberWithDouble:1.0]];
    
	CAKeyframeAnimation *scaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
	scaleAnimation.values = frames;
    scaleAnimation.duration = duration;
	scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
	
	CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.toValue = [NSNumber numberWithDouble:0.97];
    opacityAnimation.duration = duration / 4;
	opacityAnimation.fillMode = kCAFillModeForwards;
	opacityAnimation.removedOnCompletion = NO;
	
	CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = [NSArray arrayWithObjects:scaleAnimation, opacityAnimation, nil];
    animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animationGroup.duration = duration;
	animationGroup.delegate = self;
	
	return animationGroup;
}

@synthesize parent;

@end
