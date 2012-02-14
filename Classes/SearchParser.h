//
//  SearchParser.h
//  Marketplace
//
//  Created by Josh Abernathy on 2/23/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Result.h"

extern NSString * const JASearchParserSearchDoneNotification;

@class Search;
@class SearchParseWorker;
@class SearchResult;


@interface SearchParser : NSObject {
	__weak Search *search;
	
	NSMutableArray *workers;
	NSMutableArray *completedWorkers;
	NSMutableArray *foundResults;
	NSArray *originalResults;
	NSUInteger numberOfWorkers;
    
    BOOL shouldStop;
}

+ (SearchParser *)parserForSearch:(Search *)s;

- (void)performSearch;

- (void)workerDone:(SearchParseWorker *)worker;
- (void)foundResults:(NSArray *)results;
- (void)foundResult:(id<Result>)result;

@property (assign) __weak Search *search;
@property (assign) BOOL shouldStop;

@end
