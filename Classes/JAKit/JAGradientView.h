//
//  GradientView.h
//  Marketplace
//
//  Created by Josh Abernathy on 3/27/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface JAGradientView : NSView {
	NSGradient *gradient;
}

@property (retain) NSGradient *gradient;

@end
