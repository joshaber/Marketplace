//
//  FavoritesController.m
//  Marketplace
//
//  Created by Josh Abernathy on 7/26/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "FavoritesController.h"
#import "FavoritesViewController.h"
#import "SearchResult.h"
#import "NSArray+JAAdditions.h"


@implementation FavoritesController

+ (FavoritesController *)sharedInstance {
	return [[FavoritesController alloc] init];
}

- (id)init {
	static FavoritesController *instance = nil;
	
	if(instance == nil) {
		self = [super init];
		
		favorites = [NSMutableArray array];
		instance = self;
	}
	
	return instance;
}

- (void)addFavoriteFromArray:(NSArray *)selectedObjects {
	if([selectedObjects count] < 1) return;

	[self addFavorite:[selectedObjects firstObject]];
}

// Add the result to the favorites array. Throws out duplicates.
- (void)addFavorite:(SearchResult *)result {
	if([favorites containsObject:result]) return;
	
	result.isFavorite = YES;
	
	[self willChangeValueForKey:@"favorites"];
	[favorites addObject:result];
	[self didChangeValueForKey:@"favorites"];
}

- (void)addFavorites:(NSArray *)favs {
	for(SearchResult *fav in favs) {
		[self addFavorite:fav];
	}
}

- (void)removeFavoriteFromArray:(NSArray *)selectedObjects {
	if([selectedObjects count] < 1) return;
	
	[self removeFavorite:[selectedObjects firstObject]];
}

- (void)removeFavorite:(SearchResult *)result {
	result.isFavorite = NO;
	
	[self willChangeValueForKey:@"favorites"];
	[favorites removeObject:result];
	[self didChangeValueForKey:@"favorites"];
}

@synthesize favorites;

@end
