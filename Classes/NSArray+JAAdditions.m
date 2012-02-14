//
//  NSArray+Additions.m
//  Marketplace
//
//  Created by Josh Abernathy on 1/28/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "NSArray+JAAdditions.h"


@implementation NSArray (JAAdditions)

- (NSArray *)alphabeticallySortedArray {
	return [self sortedArrayUsingDescriptors:[NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:@"self" ascending:YES]]];
}

- (id)firstObject {
    if(self.count < 1) return nil;
    
	return [self objectAtIndex:0];
}

@end
