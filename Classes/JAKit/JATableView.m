//
//  JATableView.m
//  Marketplace
//
//  Created by Josh Abernathy on 3/12/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "JATableView.h"

@interface NSObject (JATableViewDelegate)
- (void)tableView:(JATableView *)tableView keyDown:(NSEvent *)event;
- (void)tableView:(JATableView *)tableView mouseDown:(NSEvent *)event;
- (void)tableView:(JATableView *)tableView mouseUp:(NSEvent *)event;
- (void)tableView:(JATableView *)tableView rightMouseDown:(NSEvent *)event;
- (void)tableView:(JATableView *)tableView rightMouseUp:(NSEvent *)event;
@end


@implementation JATableView

- (void)keyDown:(NSEvent *)event {
	if([[self delegate] respondsToSelector:@selector(tableView:keyDown:)]) {
		[[self delegate] performSelector:@selector(tableView:keyDown:) 
							  withObject:self 
							  withObject:event];
	} else {
		[super keyDown:event];
	}
}

- (void)forwardKeyDown:(NSEvent *)event {
	[super keyDown:event];
}

- (void)mouseDown:(NSEvent *)event {
	if([event modifierFlags] & NSControlKeyMask) {
		[self rightMouseDown:event];
	} else {
		if([[self delegate] respondsToSelector:@selector(tableView:mouseDown:)]) {
			[[self delegate] performSelector:@selector(tableView:mouseDown:) 
								  withObject:self 
								  withObject:event];
		} else {
			[super mouseDown:event];
		}
	}
}

- (void)forwardMouseDown:(NSEvent *)event {
	[super mouseDown:event];
}

- (void)mouseUp:(NSEvent *)event {
	if([[self delegate] respondsToSelector:@selector(tableView:mouseUp:)]) {
		[[self delegate] performSelector:@selector(tableView:mouseUp:) 
							  withObject:self 
							  withObject:event];
	} else {
		[super mouseUp:event];
	}
}

- (void)forwardMouseUp:(NSEvent *)event {
	[super mouseUp:event];
}

- (void)rightMouseDown:(NSEvent *)event {
	if([[self delegate] respondsToSelector:@selector(tableView:rightMouseDown:)]) {
		[[self delegate] performSelector:@selector(tableView:rightMouseDown:) 
							  withObject:self 
							  withObject:event];
	} else {
		[super rightMouseDown:event];
	}
}

- (void)forwardRightMouseDown:(NSEvent *)event {
	[super rightMouseDown:event];
}

- (void)rightMouseUp:(NSEvent *)event {	
	if([[self delegate] respondsToSelector:@selector(tableView:rightMouseUp:)]) {
		[[self delegate] performSelector:@selector(tableView:rightMouseUp:) 
							  withObject:self 
							  withObject:event];
	} else {
		[super rightMouseUp:event];
	}
}

- (void)forwardRightMouseUp:(NSEvent *)event {
	[super rightMouseUp:event];
}

- (BOOL)acceptsFirstResponder {
	return YES;
}

- (BOOL)becomeFirstResponder {
	return YES;
}

@end
