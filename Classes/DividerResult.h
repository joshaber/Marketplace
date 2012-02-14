//
//  DividerResult.h
//  Marketplace
//
//  Created by Josh Abernathy on 7/4/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Result.h"


@interface DividerResult : NSObject <Result> {
	NSView *view;
	
	NSString *region;
	
	__weak Search *search;
}

+ (DividerResult *)resultWithRegion:(NSString *)r;

- (BOOL)isSearchable;
- (NSDate *)dateFound;

@property (retain) IBOutlet NSView *view;
@property (retain) NSString *region;
@property (assign) __weak Search *search;

@end
