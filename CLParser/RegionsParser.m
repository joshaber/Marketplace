//
//  RegionsParser.m
//  CLParser
//
//  Created by Josh Abernathy on 10/25/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "RegionsParser.h"


@interface RegionsParser (Private) 
- (void)parseCountry:(NSString *)country;
@end


@implementation RegionsParser

+ (RegionsParser *)parserForCountries:(NSDictionary *)countries {
	RegionsParser *parser = [[RegionsParser alloc] init];
	parser->countries = countries;
	
	return [parser autorelease];
}

- (id)init {
	self = [super init];
	
	regions = [NSMutableDictionary dictionary];
	
	return self;
}

- (void)parse {
	for(NSString *country in [countries allKeys]) {
		[self parseCountry:country];
	}
}

- (void)parseCountry:(NSString *)country {	
	NSURL *url = [NSURL URLWithString:[countries objectForKey:country]];
	
	NSMutableDictionary *countryValue = [NSMutableDictionary dictionary];
	[countryValue setObject:url forKey:@"url"];
	[countryValue setObject:@"Countries" forKey:@"category"];
	[regions setObject:countryValue forKey:country];

	NSXMLDocument *document = [[NSXMLDocument alloc] initWithContentsOfURL:url
																   options:NSXMLDocumentTidyHTML 
																	 error:NULL];
	
	NSArray *array = [document nodesForXPath:@"//div[@id=\"list\"]/a" error:NULL];
	for(NSXMLNode *item in array) {
		NSArray *locationNode = [item nodesForXPath:@"text()" error:NULL];
		
		// some location names are bolded
		if([locationNode count] == 0) {
			locationNode = [item nodesForXPath:@"b/text()" error:NULL];
		}
		
		NSString *location = [[locationNode objectAtIndex:0] stringValue];
		NSString *url = [[[item nodesForXPath:@"@href" error:NULL] objectAtIndex:0] stringValue];
		url = [url substringToIndex:[url length] - 1];
		
		NSMutableDictionary *regionValue = [NSMutableDictionary dictionary];
		[regionValue setObject:url forKey:@"url"];
		[regionValue setObject:@"Regions" forKey:@"category"];
		[regionValue setObject:country forKey:@"country"];
		[regions setObject:regionValue forKey:[location capitalizedString]];
	}
}

@synthesize regions;

@end
