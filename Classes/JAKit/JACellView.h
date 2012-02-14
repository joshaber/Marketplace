//
//  CellView.h
//  Marketplace
//
//  Created by Josh Abernathy on 7/3/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface JACellView : NSView {
	BOOL isHighlighted;
	BOOL isBeingClicked;
}

@property (assign) BOOL isHighlighted;
@property (assign) BOOL isBeingClicked;

@end
