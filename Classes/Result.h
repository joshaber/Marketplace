//
//  GenericResult.h
//  Marketplace
//
//  Created by Josh Abernathy on 7/4/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class Search;


@protocol Result <NSObject, NSCopying>
- (NSView *)view;
- (BOOL)isSearchable;
- (BOOL)isFavorite;

@property (assign) __weak Search *search;

@end
