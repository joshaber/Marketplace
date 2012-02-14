//
//  FavoritesView.m
//  Marketplace
//
//  Created by Josh Abernathy on 7/26/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "FavoritesRowView.h"
#import "FavoritesController.h"
#import "MainWindowController.h"

@interface FavoritesRowView ()
- (void)windowDidChangeKey:(NSNotification *)notification;
@end


@implementation FavoritesRowView

- (void)drawRect:(NSRect)rect {
	if([NSApp isActive]) {
		if(isHighlighted) {
			NSGradient *gradient = [[NSGradient alloc] initWithStartingColor:
									[NSColor colorWithDeviceRed:(22.0f/255.0f) 
														  green:(84.0f/255.0f) 
														   blue:(170.0f/255.0f) 
														  alpha:1.0f] 
																 endingColor:
									[NSColor colorWithDeviceRed:(69.0f/255.0f) 
														  green:(128.0f/255.0f) 
														   blue:(200.0f/255.0f) 
														  alpha:1.0f]];
			[gradient drawInRect:self.bounds angle:90.0f];
		} else {
            [[NSColor colorWithDeviceRed:(220.0f/255.0f) 
								   green:(227.0f/255.0f) 
									blue:(234.0f/255.0f) 
								   alpha:1.0f] set];
			NSRectFill(self.bounds);
        }
	} else {
		if(isHighlighted) {
			NSGradient *gradient = [[NSGradient alloc] initWithStartingColor:
									[NSColor colorWithDeviceRed:(137.0f/255.0f) 
														  green:(137.0f/255.0f) 
														   blue:(137.0f/255.0f) 
														  alpha:1.0f] 
																 endingColor:
									[NSColor colorWithDeviceRed:(180.0f/255.0f) 
														  green:(180.0f/255.0f) 
														   blue:(180.0f/255.0f) 
														  alpha:1.0f]];
			[gradient drawInRect:self.bounds angle:90.0f];
		} else {
			[[NSColor colorWithDeviceRed:(236.0f/255.0f) 
								   green:(236.0f/255.0f) 
									blue:(236.0f/255.0f) 
								   alpha:1.0f] set];
			NSRectFill(self.bounds);
		}
	}
}

- (void)updateChildCells {
	NSArray *subviews = [[self subviews] copy];
	for(NSView *view in subviews) {
		if([view isKindOfClass:[NSTextField class]]) {
			NSTextField *textField = (NSTextField *)view;
			[[textField cell] setHighlighted:isHighlighted];
		}
	}
}

- (void)setIsHighlighted:(BOOL)h {
	// don't do any extra redraws/updates
	if(h == isHighlighted) return;
	
	isHighlighted = h;
    
    if(isHighlighted) {
        [imageView setImage:[NSImage imageNamed:@"star_white"]];
    } else {
        [imageView setImage:[NSImage imageNamed:@"star-dark"]];
    }
	
	[self updateChildCells];
	[self setNeedsDisplay:YES];
}

- (void)viewWillMoveToWindow:(NSWindow *)newWindow {
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(windowDidChangeKey:)
												 name:NSWindowDidResignKeyNotification 
											   object:self.window];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(windowDidChangeKey:)
												 name:NSWindowDidBecomeKeyNotification 
											   object:self.window];
}

- (void)windowDidChangeKey:(NSNotification *)notification {
	[self setNeedsDisplay:YES];
}

- (void)mouseDown:(NSEvent *)event {
	[mainWindowController highlightFavorites];
}

@synthesize isHighlighted;
@synthesize mainWindowController;
@synthesize imageView;

@end
