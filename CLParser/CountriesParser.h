//
//  CountriesParser.h
//  CLParser
//
//  Created by Josh Abernathy on 10/25/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface CountriesParser : NSObject {
	NSMutableDictionary *countries;
}

+ (CountriesParser *)parser;

- (void)parse;

@property (copy) NSMutableDictionary *countries;

@end
