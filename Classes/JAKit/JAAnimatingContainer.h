//
//  JAAnimatingContainer.h
//  ManyViewTest
//
//  Created by Josh Abernathy on 2/27/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>


@interface JAAnimatingContainer : NSObject {
	NSWindow *hostWindow;
	NSView *view;
	id delegate;
	
	NSWindow *originalParentWindow;
}

+ (JAAnimatingContainer *)containerFromWindow:(NSWindow *)window;
+ (JAAnimatingContainer *)containerFromView:(NSView *)view;
+ (JAAnimatingContainer *)containerWithImage:(CGImageRef)image at:(NSPoint)loc onScreen:(NSScreen *)screen;

- (void)swapViewWithContainer;
- (void)swapContainerWithView;

- (void)startAnimation:(CAAnimation *)animation forKey:(NSString *)key;

- (void)flyTo:(NSPoint)loc;
- (void)scaleTo:(NSSize)scale;

- (CALayer *)animationLayer;

@property (readonly) NSWindow *hostWindow;
@property (assign) id delegate;

@end
