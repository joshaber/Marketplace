//
//  SearchController.m
//  Marketplace
//
//  Created by Josh Abernathy on 7/30/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "SearchController.h"

#import "Search.h"


@implementation SearchController

+ (SearchController *)sharedInstance {
	return [[SearchController alloc] init];
}

- (id)init {
	static SearchController *instance = nil;
	
	if(instance == nil) {
		self = [super init];
		
		searches = [NSMutableArray array];
		instance = self;
	}
	
	return instance;
}

- (void)addSearch:(Search *)search {
	[self willChangeValueForKey:@"searches"];
	[searches addObject:search];
	[self didChangeValueForKey:@"searches"];
}

- (void)addSearches:(NSArray *)array {
	[self willChangeValueForKey:@"searches"];
	[searches addObjectsFromArray:array];
	[self didChangeValueForKey:@"searches"];
}

- (void)removeSearch:(Search *)search {
	[self willChangeValueForKey:@"searches"];
	[searches removeObject:search];
	[self didChangeValueForKey:@"searches"];
}

@synthesize searches;

@end
