//
//  SearchController.h
//  Marketplace
//
//  Created by Josh Abernathy on 7/30/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class Search;


@interface SearchController : NSObject {
	NSMutableArray *searches;
}

+ (SearchController *)sharedInstance;

- (void)addSearch:(Search *)search;
- (void)addSearches:(NSArray *)array;
- (void)removeSearch:(Search *)search;

@property (readonly) NSMutableArray *searches;

@end
