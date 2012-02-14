//
//  GigsOptionsViewController.m
//  Marketplace
//
//  Created by Josh Abernathy on 1/13/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "GigsOptionsViewController.h"
#import "NSDictionary+JAAdditions.h"


@implementation GigsOptionsViewController

- (NSString *)URLAttributes {
	NSInteger row = [typesMatrix selectedRow];
	if(row == 0) {
		return @"&addThree=";
	} else if(row == 1) {
		return @"&addThree=forpay";
	} else if(row == 2) {
		return @"&addThree=nopay";
	}
	
	return @"";
}

- (void)parseURLAttributes:(NSString *)url {
    NSDictionary *values = [NSDictionary dictionaryFromURLQuery:url];
    NSString *value = JAEmptyStringIfNil([values objectForKey:@"addThree"]);
    
    if([value isEqualToString:@"forpay"]) {
        [typesMatrix selectCellAtRow:1 column:0];
    } else if([value isEqualToString:@"nopay"]) {
        [typesMatrix selectCellAtRow:2 column:0];
    } else {
        [typesMatrix selectCellAtRow:0 column:0];
    }
}

@synthesize typesMatrix;

@end
