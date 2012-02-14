//
//  NSXMLNode+JAAdditions.m
//  Marketplace
//
//  Created by Josh Abernathy on 3/21/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "NSXMLNode+JAAdditions.h"
#import "NSArray+JAAdditions.h"


@implementation NSXMLNode (JAAdditions)

- (NSString *)stringValueForFirstNodeForXPath:(NSString *)xpath {
	NSError *error = nil;
	NSArray *results = [self nodesForXPath:xpath error:&error];
	if(error != nil) {
		[NSException raise:@"NodeParseException" format:@"There was an error parsing for XPath: %@", xpath];
	}
	
	if(results.count < 1) return nil;
	
	return [[results firstObject] stringValue];
}

@end
