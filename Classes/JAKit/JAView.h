//
//  JAView.h
//  Layers
//
//  Created by Josh Abernathy on 12/16/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface JAView : NSView {
	NSViewController *viewController;
}

@property (assign, nonatomic) IBOutlet NSViewController *viewController;

@end
