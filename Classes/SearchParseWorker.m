//
//  SearchParseWorker.m
//  Marketplace
//
//  Created by Josh Abernathy on 1/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SearchParseWorker.h"
#import "DividerResult.h"
#import "SearchResult.h"
#import "Region.h"
#import "Search.h"
#import "SearchParser.h"
#import "NSObject+DDExtensions.h"
#import "NSString+Additions.h"
#import "NSArray+JAAdditions.h"
#import "NSXMLNode+JAAdditions.h"

@interface SearchParseWorker ()
- (void)searchRegion;
- (void)parseSearchForTextAtURL:(NSString *)findURL;
- (SearchResult *)entryFromNode:(NSXMLNode *)node withURL:(NSString *)url;
- (NSString *)categoryForSearch;
- (NSInteger)numberOfPagesForDocument:(NSXMLDocument *)document;
- (void)reportResultsToManager:(NSArray *)results;
@end


@implementation SearchParseWorker

+ (SearchParseWorker *)workerForSearch:(Search *)s inRegion:(Region *)r reportTo:(SearchParser *)m {
	SearchParseWorker *worker = [[SearchParseWorker alloc] init];
	
	worker->search = s;
	worker->region = r;
	worker->manager = m;
	
	return [worker autorelease];
}

- (id)init {
    self = [super init];
    
    hasReportedRegion = NO;
    
    return self;
}

- (void)start {
    @try {
        [self performSelectorInBackground:@selector(searchRegion) withObject:nil];
    } @catch(NSException *exception) {
        NSLog(@"exception hit: %@: %@", exception, [exception userInfo]);
    }
}

- (void)searchRegion {
    @try {
        NSString *category = [self categoryForSearch];
        NSString *attributes = (search.URLAttributes != nil) ? search.URLAttributes : @"";
        NSString *findURL = nil;
        
        if(region.url == nil) {
            NSLog(@"region url is nil: %@", region.name);
            [manager workerDone:self];
            return;
        }
        
        // if we're using the new style, do the replacements. otherwise fallback
        if([region.url rangeOfString:@"[SEARCH]"].location != NSNotFound) {
            findURL = [region.url stringByReplacingOccurrencesOfString:@"[SEARCH]" withString:@"search"];
            findURL = [findURL stringByReplacingOccurrencesOfString:@"[CATEGORY]" withString:category];
            findURL = [findURL stringByReplacingOccurrencesOfString:@"[QUERY]" withString:[NSString stringWithFormat:@"query=%@%@", search.text, attributes]];
        } else {
            findURL = [NSString stringWithFormat:@"%@/search/%@?query=%@%@", region.url, category, search.text, attributes];
        }
    	
        [self parseSearchForTextAtURL:findURL];
        [manager workerDone:self];
    } @catch (id exception) {
        NSLog(@"exception in searchregion: %@", exception);
    }
}

- (void)parseSearchForTextAtURL:(NSString *)findURL {
	NSInteger numberOfResults = -1;
	NSInteger offset = 0;
	BOOL areMorePages = YES;
	while(areMorePages) {
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        NSMutableArray *results = [NSMutableArray array];
		NSString *offsetUrl = [findURL stringByAppendingFormat:@"&s=%ld", (long) offset];
		NSURL *url = [NSURL URLWithString:[offsetUrl stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
		
		NSLog(@"%@: %@", region.name, url);
		
        NSError *error = nil;
		NSXMLDocument *document = [[[NSXMLDocument alloc] initWithContentsOfURL:url 
                                                                        options:NSXMLDocumentTidyHTML 
                                                                          error:&error] autorelease];
		
		// try to parse the number of results out
		if(numberOfResults == -1) {
			numberOfResults = [self numberOfPagesForDocument:document];
		}
		
		NSArray *items = [document nodesForXPath:@"//p" error:NULL];
		for(NSXMLNode *item in items) {
			SearchResult *entry = nil;
			@try {
				entry = [self entryFromNode:item withURL:region.strippedUrl];
			} @catch(NSException *exception) {
				NSLog(@"Exception in entry parsing: %@: %@", [exception name], [exception reason]);
                continue;
			}
			
			entry.region = region.name;

            [results addObject:entry];
		}
        
        [[self dd_invokeOnMainThread] reportResultsToManager:results];
                
		offset += 100;
		areMorePages = (items.count > 0 && offset < numberOfResults && !manager.shouldStop);
        [pool drain];
	}
}

- (void)reportResultsToManager:(NSArray *)results {
    if(results.count < 1) return;
    
    if(!hasReportedRegion) {
        [manager foundResult:[DividerResult resultWithRegion:region.name]];
        hasReportedRegion = YES;
    }
    
    [manager foundResults:results];
}

- (SearchResult *)entryFromNode:(NSXMLNode *)node withURL:(NSString *)url {
	SearchResult *result = [SearchResult result];
	result.dateFound = [NSDate date];
    
	NSString *title = [node stringValueForFirstNodeForXPath:@"a/text()"];
	if(title != nil) {
		result.title = title;
	} else {
		// TODO: should we just ignore entries with no title?
		result.title = @"";
	}
	
	NSString *urlString = [node stringValueForFirstNodeForXPath:@"a/@href"];
	// urls will sometimes be absolute, in which case we don't prepend the region url
	if([urlString hasPrefix:@"http://"]) {
		result.url = urlString;
	} else {
        if([url characterAtIndex:url.length - 1] == '/') {
            result.url = [NSString stringWithFormat:@"%@%@", [url substringToIndex:url.length - 1], urlString];
        } else {
            result.url = [NSString stringWithFormat:@"%@%@", url, urlString];
        }
	}

	NSString *dateString = [[[node stringValue] componentsSeparatedByString:@" - "] firstObject];
	@try {
		// default time is 12:00:00 so zero it out
		result.date = [[NSDate dateWithNaturalLanguageString:dateString] addTimeInterval:-12*60*60];
		
		// there can be no date after now, must be the previous year
		if([result.date laterDate:[NSDate date]] == result.date) {
			NSDateComponents *components = [[NSDateComponents alloc] init];
			[components setYear:-1];
			result.date = [[NSCalendar currentCalendar] dateByAddingComponents:components 
																		toDate:result.date 
																	   options:0];
		}
	} @catch(NSException *exception) {
		NSLog(@"Exception in parsing date: '%@'", dateString);
		result.date = [NSDate date];
	}
	
	NSString *location = [node stringValueForFirstNodeForXPath:@"font/text()"];
	if(location != nil) {
		result.location = [[location stringByTrimmingCharactersInSet:
							[NSCharacterSet characterSetWithCharactersInString:@"()"]] capitalizedString];
	} else {
		result.location = @"No location";
	}
	
	NSString *picture = [[node stringValueForFirstNodeForXPath:@"span[@class='p']/text()"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	if([picture isEqualToString:@"pic"] || [picture isEqualToString:@"img"]) {
		result.hasPicture = YES;
	}
	
	NSString *category = [node stringValueForFirstNodeForXPath:@"small[@class='gc']"];
	if(category != nil) {
		result.category = [category capitalizedString];
	} else {
		result.category = search.subcategory;
	}
	
	return result;
}

- (NSInteger)numberOfPagesForDocument:(NSXMLDocument *)document {
	NSInteger numberOfResults = 0;
	NSArray *results = [document nodesForXPath:@"//h4/b[1]" error:NULL];
	if(results.count > 1) {
		NSString *resultCountString = [[results objectAtIndex:1] stringValue];
		NSArray *pieces = [resultCountString componentsSeparatedByString:@":"];
		if(pieces.count <= 1) {
			resultCountString = [[results objectAtIndex:1] stringValue];
			pieces = [resultCountString componentsSeparatedByString:@":"];
		}
		if(pieces.count > 1) {
			NSArray *pieces2 = [[pieces objectAtIndex:1] componentsSeparatedByString:@" "];
			if(pieces2.count > 1) {
				numberOfResults = [[pieces2 objectAtIndex:1] integerValue];
			}
		}
	}
	
	return numberOfResults;
}

- (NSString *)categoryForSearch {
	if(categories == nil) {
		categories = [NSDictionary dictionaryWithContentsOfFile:
					  [[NSBundle mainBundle] pathForResource:@"categories" ofType:@"plist"]];
	}
	
	NSDictionary *categoryInfo = [categories objectForKey:search.category];
	if(search.subcategory != nil) {
		NSDictionary *subcategories = [categoryInfo objectForKey:@"subcategories"];
		return [subcategories objectForKey:search.subcategory];
	}

    return [categoryInfo objectForKey:@"urlAttribute"];
}

@end
