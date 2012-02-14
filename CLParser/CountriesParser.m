//
//  CountriesParser.m
//  CLParser
//
//  Created by Josh Abernathy on 10/25/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "CountriesParser.h"


@implementation CountriesParser

+ (CountriesParser *)parser {
	return [[[CountriesParser alloc] init] autorelease];
}

- (id)init {
	self = [super init];
	
	countries = [NSMutableDictionary dictionary];
	
	return self;
}

- (void)parse {
	NSURL *parseURL = [NSURL URLWithString:@"http://craigslist.org/"];
		
	NSXMLDocument *document = [[NSXMLDocument alloc] initWithContentsOfURL:parseURL 
																   options:NSXMLDocumentTidyHTML 
																	 error:NULL];
	
	NSArray *countriesArray = [document nodesForXPath:@"//td[last()]/ul/li/a" error:NULL];
	if([countriesArray count] > 0) {
		for(NSXMLNode *item in countriesArray) {
			NSArray *urls = [item nodesForXPath:@"@href" error:NULL];
			if([urls count] != 1) continue;
			
			NSArray *names = [item nodesForXPath:@"text()" error:NULL];
			if([names count] != 1) continue;
			
			NSString *countryURL = [[urls objectAtIndex:0] stringValue];
			NSString *name = [[names objectAtIndex:0] stringValue];
			
			[countries setObject:countryURL forKey:[name capitalizedString]];
		}
	}
}

@synthesize countries;

@end
