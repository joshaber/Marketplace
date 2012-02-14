//
//  HousingOptionsViewController.h
//  Marketplace
//
//  Created by Josh Abernathy on 1/14/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "OptionsViewController.h"


@interface HousingOptionsViewController : OptionsViewController {
	NSTextField *minPriceField;
	NSTextField *maxPriceField;
	NSMatrix *allowsMatrix;
	NSTextField *numberOfRoomsField;
}

@property (assign, nonatomic) IBOutlet NSTextField *minPriceField;
@property (assign, nonatomic) IBOutlet NSTextField *maxPriceField;
@property (assign, nonatomic) IBOutlet NSMatrix *allowsMatrix;
@property (assign, nonatomic) IBOutlet NSTextField *numberOfRoomsField;

@end
