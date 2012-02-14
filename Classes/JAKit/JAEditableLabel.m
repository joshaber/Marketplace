//
//  JAEditableLabel.m
//  Marketplace
//
//  Created by Josh Abernathy on 8/11/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "JAEditableLabel.h"
#import "JAShadowedViewContainer.h"

@interface JAEditableLabel () <NSTextFieldDelegate>
- (void)popOut;
- (void)restore;
@end


@implementation JAEditableLabel

- (void)awakeFromNib {
    NSTrackingArea *trackingArea = [[NSTrackingArea alloc] initWithRect:self.bounds options:NSTrackingMouseEnteredAndExited | NSTrackingActiveInKeyWindow owner:self userInfo:nil];
    [self addTrackingArea:trackingArea];
    [self.cell setBackgroundStyle:NSBackgroundStyleLowered];
    [self.cell setBackgroundColor:[NSColor whiteColor]];
    [self setBackgroundColor:[NSColor whiteColor]];
    self.delegate = self;
    defaultValue = [[super stringValue] copy];
}

- (void)controlTextDidEndEditing:(NSNotification *)aNotification {
    [self setEditable:NO];
    if([super stringValue].length < 1) {
        [self setStringValue:defaultValue];
    }
    [self restore];
    [self setNeedsDisplay:YES];
    isFirstResponder = NO;
}

- (BOOL)becomeFirstResponder {
    [self popOut];
    [self setNeedsDisplay:YES];
    isFirstResponder = YES;
    return YES;
}

- (void)mouseEntered:(NSEvent *)event {
    [[NSCursor IBeamCursor] push];
}

- (void)mouseExited:(NSEvent *)event {
    [NSCursor pop];
}

- (void)mouseDown:(NSEvent *)event {
    [self setEditable:YES];
    if([self stringValue] == nil) {
        [self setStringValue:@""];
    }
    [super mouseDown:event];
}

- (NSString *)stringValue {
    NSString *value = [super stringValue];
    if([value isEqualToString:defaultValue]) {
        return nil;
    }
    
    return value;
}

- (void)setStringValue:(NSString *)aString {
    if((aString == nil || aString.length < 1) && !self.isEditable) {
        [super setStringValue:defaultValue];
    } else {
        [super setStringValue:aString];
    }
}

- (void)popOut {
    if(shadowedView == nil) {
        shadowedView = [[JAShadowedViewContainer alloc] initWithFrame:NSInsetRect(self.frame, -10, -13)];
        shadowedView.shadowedView = self;
        shadowedView.shadowOffset = NSMakeSize(0, -3);
        
        originalFrame = self.frame;
    }
    
    [self.superview addSubview:shadowedView];
    [self setFrameOrigin:NSMakePoint(10, 13)];
    [shadowedView addSubview:self];
    
    [self setDrawsBackground:YES];
}

- (void)restore {
    [self setFrame:originalFrame];
    [shadowedView.superview addSubview:self];
    [shadowedView removeFromSuperview];
    
    [self setDrawsBackground:NO];
}

@end
