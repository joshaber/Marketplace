//
//  JABorderlessWindow.m
//  Marketplace
//
//  Created by Josh Abernathy on 9/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "JABorderlessWindow.h"


@implementation JABorderlessWindow

- (id)initWithContentRect:(NSRect)contentRect 
				styleMask:(NSUInteger)windowStyle 
				  backing:(NSBackingStoreType)bufferingType 
					defer:(BOOL)deferCreation {
	self = [super initWithContentRect:contentRect 
							styleMask:NSBorderlessWindowMask 
							  backing:NSBackingStoreBuffered 
								defer:NO];
	
	[self setMovableByWindowBackground:NO];

	return self;
}

- (BOOL)canBecomeMainWindow { return NO; }
- (BOOL)canBecomeKeyWindow { return YES; }
- (BOOL)isExcludedFromWindowsMenu { return YES; }

@end
