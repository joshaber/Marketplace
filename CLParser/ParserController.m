//
//  ParserController.m
//  CLParser
//
//  Created by Josh Abernathy on 10/25/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "ParserController.h"
#import "CountriesParser.h"
#import "RegionsParser.h"
#import "SubregionsParser.h"

//http://www.craigslist.org/about/sites

@interface ParserController ()
- (void)parseCountries;
- (void)parseSubregions;
@end


@implementation ParserController

- (IBAction)parse:(id)sender {
	//[self parseCountries];
    [self parseSubregions];
}

- (void)parseSubregions {
    SubregionsParser *parser = [SubregionsParser parser];
    [parser parse];
}

- (void)parseCountries {
	/*CountriesParser *countriesParser = [CountriesParser parser];
	[countriesParser parse];
	NSLog(@"Parsed countries");*/
	
	NSDictionary *countries = [NSDictionary dictionaryWithContentsOfFile:@"countries.plist"];
	
	RegionsParser *regionsParser = [RegionsParser parserForCountries:countries];
	[regionsParser parse];
	NSLog(@"Parsed regions");
	
	/*[countriesParser.countries writeToFile:@"countries.plist" atomically:YES];
	NSLog(@"Wrote countries");*/
	
	[[regionsParser.regions description] writeToFile:@"regions.plist" atomically:YES];
	NSLog(@"Wrote regions: %@", regionsParser.regions);
}

@end
