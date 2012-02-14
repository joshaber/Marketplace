//
//  SearchParseWorker.h
//  Marketplace
//
//  Created by Josh Abernathy on 1/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class Search;
@class Region;
@class SearchParser;


@interface SearchParseWorker : NSOperation {
	__weak Search *search;
	__weak Region *region;
	__weak SearchParser *manager;
    
    BOOL hasReportedRegion;
	
	NSDictionary *categories;
}

+ (SearchParseWorker *)workerForSearch:(Search *)s inRegion:(Region *)r reportTo:(SearchParser *)m;

@end
