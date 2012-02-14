//
//  RegionSelectionView.m
//  Layers
//
//  Created by Josh Abernathy on 12/16/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "RegionSelectionView.h"
#import <QuartzCore/QuartzCore.h>

#import "RegionView.h"
#import "AllRegionsView.h"


@interface RegionSelectionView ()
- (void)layoutSubviews;
- (CGFloat)cumulativeHeight;
- (RegionView *)nextSubview;
- (RegionView *)previousSubview;
@end


@implementation RegionSelectionView

- (void)awakeFromNib {
	[self setWantsLayer:YES];
	
	CATransition *transition = [CATransition animation];
    [transition setType:kCATransitionPush];
    [transition setSubtype:kCATransitionFromRight];
    
    [self setAnimations:[NSDictionary dictionaryWithObject:transition forKey:@"subviews"]];
	
	originalSize = [self frame].size;
}

- (void)layoutSubviews {
	CGFloat topHeight = [self cumulativeHeight];
	// > 8200
	[self setFrameSize:NSMakeSize(self.frame.size.width, MAX(originalSize.height, topHeight))];
		
	NSArray *subviews = [self.subviews copy];
	
	CGFloat currentY = self.frame.size.height;
	RegionView *previousView = nil;
	for(RegionView *view in subviews) {
		currentY -= view.frame.size.height;
		[view setFrameSize:NSMakeSize(self.frame.size.width, view.frame.size.height)];
		[view setFrameOrigin:NSMakePoint(0, currentY)];
		
		if(previousView == nil || ![previousView.category isEqualToString:view.category]) {
			view.shouldDrawCategory = YES;
			[view setNeedsDisplay:YES];
		}
				
		previousView = view;
	}
}

- (CGFloat)cumulativeHeight {
	NSArray *subviews = [[self subviews] copy];
	CGFloat height = 0.0f;
	for(NSView *view in subviews) {
		height += [view frame].size.height;
	}
	
	return height;
}

- (void)reloadData {
	// disable screen updates so we don't get ugly un-layed out views
	NSDisableScreenUpdates();
	
	NSArray *subviews = [[self subviews] copy];
	for(NSView *view in subviews) {
		[view removeFromSuperviewWithoutNeedingDisplay];
	}
	
	for(NSUInteger i = 0; i < [dataSource numberOfRows]; i++) {
		NSView *view = [dataSource viewForRegionSelectionRow:i];
		[self addSubview:view];
	}
	
	[self layoutSubviews];
	NSEnableScreenUpdates();
	
	[self setNeedsDisplay:YES];
}

- (void)animateReloadData {
	[NSAnimationContext beginGrouping];
	
	NSArray *subviews = [[self subviews] copy];
	for(NSView *view in subviews) {
		[[view animator] removeFromSuperviewWithoutNeedingDisplay];
	}
	
	for(NSUInteger i = 0; i < [dataSource numberOfRows]; i++) {
		NSView *view = [dataSource viewForRegionSelectionRow:i];
		[[self animator] addSubview:view];
	}
	
	[self layoutSubviews];
	[NSAnimationContext endGrouping];
	
	[self setNeedsDisplay:YES];
}

- (void)viewClicked:(RegionView *)view {
    if([view isKindOfClass:[AllRegionsView class]]) {
        for(RegionView *regionView in [self.subviews copy]) {
            if(regionView == view) continue;
            
            [delegate regionViewAdded:regionView];
        }
    } else {
        if(view.doesExpand) {
            [delegate regionViewClicked:view];
        } else {
            [delegate regionViewAdded:view];
        }
    }
}

- (BOOL)acceptsFirstResponder {
	return YES;
}

- (void)keyDown:(NSEvent *)event {
	unichar key = [[event charactersIgnoringModifiers] characterAtIndex:0];
	
	if(key == NSDownArrowFunctionKey) {
		[self selectNextView];
	} else if(key == NSUpArrowFunctionKey) {
		[self selectPreviousView];
	} else if(key == NSRightArrowFunctionKey) {
		[self viewClicked:selectedView];
	} else if(key == NSLeftArrowFunctionKey) {
		self.selectedView = nil;
		[[[self window] parentWindow] makeKeyAndOrderFront:nil];
	} else if([event keyCode] == 36) {
		[self viewClicked:selectedView];
	} else if([event keyCode] == 48 && [event modifierFlags] & NSShiftKeyMask) {
		self.selectedView = nil;
		[[[self window] parentWindow] makeKeyAndOrderFront:nil];
	}
}

- (void)setSelectedView:(RegionView *)view {
	RegionView *oldView = selectedView;
	
	selectedView = view;
	
	[selectedView setNeedsDisplay:YES];
	[oldView setNeedsDisplay:YES];
}

- (void)selectNextView {
	self.selectedView = [self nextSubview];
	[self scrollRectToVisible:[selectedView frame]];
}

- (void)selectPreviousView {
	self.selectedView = [self previousSubview];
	[self scrollRectToVisible:[selectedView frame]];
}

- (RegionView *)nextSubview {
	NSArray *subviews = [self.subviews copy];
	
	RegionView *previousView = nil;
	for(RegionView *view in subviews) {
		if(previousView == selectedView) {
			return view;
		}
		
		previousView = view;
	}
	
	return [subviews objectAtIndex:0];
}

- (RegionView *)previousSubview {
	NSArray *subviews = [self.subviews copy];
	
	RegionView *previousView = nil;
	for(RegionView *view in subviews) {
		if(view == selectedView) {
			return previousView;
		}
		
		previousView = view;
	}
	
	return [subviews lastObject];
}

@synthesize dataSource;
@synthesize delegate;
@synthesize selectedView;

@end
