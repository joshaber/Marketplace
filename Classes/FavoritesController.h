//
//  FavoritesController.h
//  Marketplace
//
//  Created by Josh Abernathy on 7/26/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class SearchResult;


@interface FavoritesController : NSObject {	
	NSMutableArray *favorites;
}

+ (FavoritesController *)sharedInstance;

- (void)addFavoriteFromArray:(NSArray *)selectedObjects;
- (void)addFavorite:(SearchResult *)result;
- (void)addFavorites:(NSArray *)favs;

- (void)removeFavoriteFromArray:(NSArray *)selectedObjects;
- (void)removeFavorite:(SearchResult *)result;

@property (readonly) NSMutableArray *favorites;

@end
