//
//  ForSaleOptionsViewController.h
//  Marketplace
//
//  Created by Josh Abernathy on 1/14/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "OptionsViewController.h"


@interface ForSaleOptionsViewController : OptionsViewController {
	NSTextField *minPriceField;
	NSTextField *maxPriceField;
}

@property (assign, nonatomic) IBOutlet NSTextField *minPriceField;
@property (assign, nonatomic) IBOutlet NSTextField *maxPriceField;

@end
