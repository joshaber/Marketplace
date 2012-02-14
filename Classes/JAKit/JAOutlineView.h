//
//  JAOutlineView.h
//  Marketplace
//
//  Created by Josh Abernathy on 4/5/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface JAOutlineView : NSOutlineView

- (void)forwardKeyDown:(NSEvent *)event;
- (void)forwardMouseDown:(NSEvent *)event;
- (void)forwardMouseUp:(NSEvent *)event;
- (void)forwardRightMouseDown:(NSEvent *)event;
- (void)forwardRightMouseUp:(NSEvent *)event;

@end
