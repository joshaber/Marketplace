//
//  ForSaleOptionsViewController.m
//  Marketplace
//
//  Created by Josh Abernathy on 1/14/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ForSaleOptionsViewController.h"
#import "NSDictionary+JAAdditions.h"


@implementation ForSaleOptionsViewController

- (NSString *)URLAttributes {
	NSMutableString *attrs = [NSMutableString string];
	
	if([minPriceField stringValue].length > 0) {
		[attrs appendFormat:@"&minAsk=%ld", (long) [minPriceField integerValue]];
	}
	
	if([maxPriceField stringValue].length > 0) {
		[attrs appendFormat:@"&maxAsk=%ld", (long) [maxPriceField integerValue]];
	}
	
	return attrs;
}

- (void)parseURLAttributes:(NSString *)url {
    NSDictionary *values = [NSDictionary dictionaryFromURLQuery:url];
    [minPriceField setStringValue:JAEmptyStringIfNil([values objectForKey:@"minAsk"])];
    [maxPriceField setStringValue:JAEmptyStringIfNil([values objectForKey:@"maxAsk"])];
}

- (void)clearValues {
    [minPriceField setStringValue:@""];
    [maxPriceField setStringValue:@""];
}

@synthesize minPriceField;
@synthesize maxPriceField;

@end
