//
//  GigsOptionsViewController.h
//  Marketplace
//
//  Created by Josh Abernathy on 1/13/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "OptionsViewController.h"


@interface GigsOptionsViewController : OptionsViewController {
	NSMatrix *typesMatrix;
}

@property (assign, nonatomic) IBOutlet NSMatrix *typesMatrix;

@end
