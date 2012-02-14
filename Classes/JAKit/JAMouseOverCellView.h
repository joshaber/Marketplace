//
//  JAMouseOverCellView.h
//  Marketplace
//
//  Created by Josh Abernathy on 7/17/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "JACellView.h"


@interface JAMouseOverCellView : JACellView {
	NSTrackingArea *trackingArea;
	BOOL isMouseOver;
}

- (NSTrackingArea *)makeNewTrackingArea;

@property (assign) BOOL isMouseOver;

@end
