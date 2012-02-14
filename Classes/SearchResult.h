//
//  Entry.h
//  Marketplace
//
//  Created by Josh Abernathy on 12/22/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Result.h"


@interface SearchResult : NSObject <Result, NSCoding> {
	NSView *view;
	
	NSDate *date;
	NSString *url;
	NSString *title;
	NSString *region;
	NSString *category;
	NSString *location;
    
    NSDate *dateFound;
	
	BOOL isFavorite;
	BOOL hasPicture;
    BOOL hasBeenRead;
	
    NSUInteger resultOrder;
    
	__weak Search *search;
}

+ (SearchResult *)result;

- (BOOL)isSearchable;

@property (retain) NSDate *date;
@property (retain) IBOutlet NSView *view;
@property (copy) NSString *url;
@property (copy) NSString *title;
@property (copy) NSString *region;
@property (copy) NSString *location;
@property (copy) NSString *category;
@property (assign) __weak Search *search;
@property (assign) BOOL isFavorite;
@property (assign) BOOL hasPicture;
@property (assign) NSDate *dateFound;
@property (assign) BOOL hasBeenRead;
@property (assign) NSUInteger resultOrder;

@end
