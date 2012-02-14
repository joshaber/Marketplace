//
//  JAOutlineView.m
//  Marketplace
//
//  Created by Josh Abernathy on 4/5/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "JAOutlineView.h"
#import "NSObject+JAAdditions.h"

@interface NSObject (JAOutlineViewDelegate)
- (void)outlineView:(JAOutlineView *)outlineView keyDown:(NSEvent *)event;
- (void)outlineView:(JAOutlineView *)outlineView mouseDown:(NSEvent *)event;
- (void)outlineView:(JAOutlineView *)outlineView mouseUp:(NSEvent *)event;
- (void)outlineView:(JAOutlineView *)outlineView rightMouseDown:(NSEvent *)event;
- (void)outlineView:(JAOutlineView *)outlineView rightMouseUp:(NSEvent *)event;
- (BOOL)outlineView:(JAOutlineView *)outlineView shouldDrawDisclosureArrowForRow:(NSInteger)row;
@end


@implementation JAOutlineView

- (void)keyDown:(NSEvent *)event {
	if([[self delegate] respondsToSelector:@selector(outlineView:keyDown:)]) {
		[[self delegate] performSelector:@selector(outlineView:keyDown:) 
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
    // reinterpret mouseDown + control as a right click
	if([event modifierFlags] & NSControlKeyMask) {
		[self rightMouseDown:event];
        return;
	}
    
    if([[self delegate] respondsToSelector:@selector(outlineView:mouseDown:)]) {
        [[self delegate] performSelector:@selector(outlineView:mouseDown:) 
                              withObject:self 
                              withObject:event];
    } else {
        [super mouseDown:event];
    }
}

- (void)forwardMouseDown:(NSEvent *)event {
	[super mouseDown:event];
}

- (void)mouseUp:(NSEvent *)event {
	if([[self delegate] respondsToSelector:@selector(outlineView:mouseUp:)]) {
		[[self delegate] performSelector:@selector(outlineView:mouseUp:) 
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
	if([[self delegate] respondsToSelector:@selector(outlineView:rightMouseDown:)]) {
		[[self delegate] performSelector:@selector(outlineView:rightMouseDown:) 
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
	if([[self delegate] respondsToSelector:@selector(outlineView:rightMouseUp:)]) {
		[[self delegate] performSelector:@selector(outlineView:rightMouseUp:) 
							  withObject:self 
							  withObject:event];
	} else {
		[super rightMouseUp:event];
	}
}

- (void)forwardRightMouseUp:(NSEvent *)event {
	[super rightMouseUp:event];
}

- (NSRect)frameOfOutlineCellAtRow:(NSInteger)row {
    SEL selector = @selector(outlineView:shouldDrawDisclosureArrowForRow:);
    if([[self delegate] respondsToSelector:selector]) {
        BOOL shouldDraw = YES;
        [(id)[self delegate] performSelector:selector withArgument:self withArgument:&row returnValue:&shouldDraw];
        if(!shouldDraw) {
            return NSZeroRect;
        }
    }
    
    return [super frameOfOutlineCellAtRow:row];
}

- (BOOL)acceptsFirstResponder {
	return YES;
}

- (BOOL)becomeFirstResponder {
	return YES;
}

@end
