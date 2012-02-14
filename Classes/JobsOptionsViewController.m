//
//  JobsOptionsViewController.m
//  Marketplace
//
//  Created by Josh Abernathy on 1/14/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "JobsOptionsViewController.h"
#import "NSDictionary+JAAdditions.h"


@implementation JobsOptionsViewController

- (NSString *)URLAttributes {
	NSMutableString *attrs = [NSMutableString string];
	
	NSArray *cells = [typesMatrix cells];
	for(NSCell *cell in cells) {
		if([cell state] == NSOnState) {
			if(cell.tag == 0) {
				[attrs appendString:@"&addOne=telecommuting"];
			} else if(cell.tag == 1) {
				[attrs appendString:@"&addTwo=contract"];
			} else if(cell.tag == 2) {
				[attrs appendString:@"&addThree=internship"];
			} else if(cell.tag == 3) {
				[attrs appendString:@"&addFour=part-time"];
			} else if(cell.tag == 4) {
				[attrs appendString:@"&addFive=non-profit"];
			}
		}
	}
	
	return attrs;
}

- (void)parseURLAttributes:(NSString *)url {
	NSDictionary *values = [NSDictionary dictionaryFromURLQuery:url];
	for(NSString *key in values) {
		if([key isEqualToString:@"addOne"]) {
			[typesMatrix selectCellAtRow:0 column:0];
		} else if([key isEqualToString:@"addTwo"]) {
			[typesMatrix selectCellAtRow:1 column:0];
		} else if([key isEqualToString:@"addThree"]) {
			[typesMatrix selectCellAtRow:2 column:0];
		} else if([key isEqualToString:@"addFour"]) {
			[typesMatrix selectCellAtRow:3 column:0];
		} else if([key isEqualToString:@"addFive"]) {
			[typesMatrix selectCellAtRow:4 column:0];
		}
	}
}

@synthesize typesMatrix;

@end
