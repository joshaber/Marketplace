//
//  RegionsParser.h
//  CLParser
//
//  Created by Josh Abernathy on 10/25/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface RegionsParser : NSObject {
	NSDictionary *countries;
	NSMutableDictionary *regions;
}

+ (RegionsParser *)parserForCountries:(NSDictionary *)countries;

- (void)parse;

@property (copy) NSMutableDictionary *regions;

@end
