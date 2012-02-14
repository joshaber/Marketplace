//
//  SearchEntry.h
//  Marketplace
//
//  Created by Josh Abernathy on 3/13/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Result.h"

extern NSString * const JAUnreadCountChangedNotification;

@class SearchResult;
@class SearchParser;

@interface Search : NSObject <NSCopying, NSCoding> {
	NSString *text;
	NSString *category;
	NSString *subcategory;
	NSString *URLAttributes;
	NSArray *regions;
	NSMutableArray *results;
	NSData *image;
	NSPredicate *filter;
    NSString *title;
	
	NSMutableDictionary *visitedURLs;
	
	NSMutableArray *subCategories;
	
	BOOL isSearching;
	BOOL isFiltered;
	NSInteger resultCount;
	
	BOOL hasFoundNewItems;
	
	SearchParser *searchParser;
}

+ (Search *)search;

- (void)search;
- (void)stopSearch;

- (void)reset;

- (NSString *)displayName;

- (void)addResult:(id<Result>)result;
- (void)addResults:(NSArray *)newResults;
- (void)removeResult:(id<Result>)result;

- (void)markResultAsRead:(SearchResult *)result;

@property (copy) NSString *text;
@property (copy) NSString *category;
@property (copy) NSString *title;
@property (copy) NSString *subcategory;
@property (retain) NSArray *regions;
@property (retain) NSData *image;
@property (assign) NSPredicate *filter;

@property (retain) NSMutableArray *results;
@property (assign) BOOL isSearching;
@property (assign) NSInteger resultCount;
@property (assign) NSMutableArray *subCategories;
@property (assign) NSString *URLAttributes;
@property (assign) NSMutableDictionary *visitedURLs;
@property (readonly) NSUInteger unreadCount;
@property (assign) BOOL isFiltered;
@property (assign) BOOL hasFoundNewItems;

@end
