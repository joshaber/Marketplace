//
//  PersonalsOptionsViewController.h
//  Marketplace
//
//  Created by Josh Abernathy on 1/14/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "OptionsViewController.h"


@interface PersonalsOptionsViewController : OptionsViewController {
	NSTextField *minAgeField;
	NSTextField *maxAgeField;
}

@property (assign, nonatomic) IBOutlet NSTextField *minAgeField;
@property (assign, nonatomic) IBOutlet NSTextField *maxAgeField;

@end
