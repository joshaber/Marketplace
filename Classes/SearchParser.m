//
//  SearchParser.m
//  Marketplace
//
//  Created by Josh Abernathy on 2/23/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "SearchParser.h"
#import "SearchResult.h"
#import "Search.h"
#import "Region.h"
#import "DividerResult.h"
#import "SearchParseWorker.h"

#import "NSString+Additions.h"
#import "NSObject+DDExtensions.h"

NSString * const JASearchParserSearchDoneNotification = @"JASearchParserSearchDoneNotification";

@interface SearchParser ()
- (void)createWorkers;
- (void)startNextWorker;
- (void)searchDone;
- (BOOL)shouldAddResult:(id<Result>)result;
@end


@implementation SearchParser

static const NSUInteger MAX_WORKERS = 4;


+ (SearchParser *)parserForSearch:(Search *)s {
	SearchParser *parser = [[SearchParser alloc] init];
	parser->search = s;
	parser->originalResults = [[NSArray alloc] initWithArray:s.results copyItems:YES];
	
	return [parser autorelease];
}

- (id)init {
	self = [super init];
	
	completedWorkers = [NSMutableArray array];
	workers = [NSMutableArray array];
	foundResults = [NSMutableArray array];
	
	return self;
}

- (void)performSearch {
	[self createWorkers];
}

- (void)createWorkers {
	NSArray *regions = search.regions;
	for(Region *region in regions) {
		[workers addObject:[SearchParseWorker workerForSearch:search inRegion:region reportTo:self]];
	}
	
	numberOfWorkers = workers.count;
		
	for(NSUInteger i = 0; i < MIN(workers.count, MAX_WORKERS); i++) {
		[self startNextWorker];
	}
}

- (void)startNextWorker {
	SearchParseWorker *newWorker = [workers lastObject];
	[workers removeObject:newWorker];
	[newWorker start];
}

- (void)workerDone:(SearchParseWorker *)worker {
	@synchronized(self) {
        [completedWorkers addObject:worker];
        
        if(workers.count > 0 && !shouldStop) {
            [self startNextWorker];
        } else if(completedWorkers.count == numberOfWorkers) {
            [[self dd_invokeOnMainThread] searchDone];
        }
	}
}

- (void)searchDone {
	for(id result in originalResults) {
		if(![result isKindOfClass:[SearchResult class]]) continue;
		
		if(![foundResults containsObject:result]) {
			[search removeResult:result];
		}
	}
	
	[[NSNotificationCenter defaultCenter] postNotificationName:JASearchParserSearchDoneNotification object:search userInfo:nil];
}

- (void)foundResults:(NSArray *)results {
    [foundResults addObjectsFromArray:results];
    
    NSMutableArray *resultsToAdd = [NSMutableArray arrayWithArray:results];
    for(id<Result> result in results) {
        if(![self shouldAddResult:result]) {
            [resultsToAdd removeObject:result];
        } else {
            search.hasFoundNewItems = YES;
        }
    }
    
    [search addResults:resultsToAdd];
}

- (void)foundResult:(id<Result>)result {
	[self foundResults:[NSArray arrayWithObject:result]];
}

- (BOOL)shouldAddResult:(id<Result>)result {
	return ![originalResults containsObject:result];
}

@synthesize search;
@synthesize shouldStop;

@end
