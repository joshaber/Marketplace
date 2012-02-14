//
//  HousingOptionsViewController.m
//  Marketplace
//
//  Created by Josh Abernathy on 1/14/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "HousingOptionsViewController.h"
#import "NSDictionary+JAAdditions.h"


@implementation HousingOptionsViewController

- (NSString *)URLAttributes {
	NSMutableString *attrs = [NSMutableString string];
	
	NSArray *cells = [allowsMatrix cells];
	for(NSCell *cell in cells) {
		if([cell state] == NSOnState) {
			if(cell.tag == 0) {
				[attrs appendString:@"&addThree=wooof"];
			} else if(cell.tag == 1) {
				[attrs appendString:@"&addTwo=purrr"];
			}
		}
	}
	
	if([minPriceField stringValue].length > 0) {
		[attrs appendFormat:@"&minAsk=%ld", (long) [minPriceField integerValue]];
	}
	
	if([maxPriceField stringValue].length > 0) {
		[attrs appendFormat:@"&maxAsk=%ld", (long) [maxPriceField integerValue]];
	}
	
	if([numberOfRoomsField stringValue].length > 0) {
		[attrs appendFormat:@"&bedrooms=%ld", (long) [numberOfRoomsField integerValue]];
	}
	
	return attrs;
}

- (void)parseURLAttributes:(NSString *)url {
    NSDictionary *values = [NSDictionary dictionaryFromURLQuery:url];
	for(NSString *key in values) {
		if([key isEqualToString:@"addThree"]) {
			[allowsMatrix selectCellAtRow:0 column:0];
		} else if([key isEqualToString:@"addTwo"]) {
			[allowsMatrix selectCellAtRow:1 column:0];
		} 
    }

    [minPriceField setStringValue:JAEmptyStringIfNil([values objectForKey:@"minAsk"])];
    [maxPriceField setStringValue:JAEmptyStringIfNil([values objectForKey:@"maxAsk"])];
    [numberOfRoomsField setStringValue:JAEmptyStringIfNil([values objectForKey:@"bedrooms"])];
}

- (void)clearValues {
    [minPriceField setStringValue:@""];
    [maxPriceField setStringValue:@""];
    [numberOfRoomsField setStringValue:@""];
}

@synthesize minPriceField;
@synthesize maxPriceField;
@synthesize allowsMatrix;
@synthesize numberOfRoomsField;

@end
