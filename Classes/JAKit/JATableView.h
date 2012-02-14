//
//  JATableView.h
//  Marketplace
//
//  Created by Josh Abernathy on 3/12/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface JATableView : NSTableView {
}

- (void)forwardKeyDown:(NSEvent *)event;
- (void)forwardMouseDown:(NSEvent *)event;
- (void)forwardMouseUp:(NSEvent *)event;
- (void)forwardRightMouseDown:(NSEvent *)event;
- (void)forwardRightMouseUp:(NSEvent *)event;

@end
