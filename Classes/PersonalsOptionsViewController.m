//
//  PersonalsOptionsViewController.m
//  Marketplace
//
//  Created by Josh Abernathy on 1/14/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PersonalsOptionsViewController.h"
#import "NSDictionary+JAAdditions.h"


@implementation PersonalsOptionsViewController

- (NSString *)URLAttributes {
	NSMutableString *attrs = [NSMutableString string];
	
	if([minAgeField stringValue].length > 0) {
		[attrs appendFormat:@"&minAsk=%ld", (long) [minAgeField integerValue]];
	}
	
	if([maxAgeField stringValue].length > 0) {
		[attrs appendFormat:@"&maxAsk=%ld", (long) [maxAgeField integerValue]];
	}
	
	return attrs;
}

- (void)parseURLAttributes:(NSString *)url {
    NSDictionary *values = [NSDictionary dictionaryFromURLQuery:url];
    [minAgeField setStringValue:JAEmptyStringIfNil([values objectForKey:@"minAsk"])];
    [maxAgeField setStringValue:JAEmptyStringIfNil([values objectForKey:@"maxAsk"])];
}

- (void)clearValues {
    [minAgeField setStringValue:@""];
    [maxAgeField setStringValue:@""];
}

@synthesize minAgeField;
@synthesize maxAgeField;

@end
