//
//  DividerResult.m
//  Marketplace
//
//  Created by Josh Abernathy on 7/4/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "DividerResult.h"
#import "NSObject+DDExtensions.h"


@implementation DividerResult

+ (DividerResult *)resultWithRegion:(NSString *)r {
	DividerResult *result = [[DividerResult alloc] init];
	result->region = r;
	
	return [result autorelease];
}

- (id)copyWithZone:(NSZone *)zone {
	return self;
}

- (BOOL)isSearchable {
	return NO;
}

- (BOOL)isFavorite {
	return NO;
}

- (NSString *)url {
    return region;
}

- (NSView *)view {
	if(view == nil) {
		[[NSBundle dd_invokeOnMainThreadAndWaitUntilDone:YES] loadNibNamed:@"DividerResultView" owner:self];
	}
	
	return view;
}

- (NSDate *)date {
    return [NSDate dateWithTimeIntervalSinceNow:60*60*24*365];
}

- (NSDate *)dateFound {
    return [self date];
}

- (BOOL)isEqual:(id)object {	
	return [(NSString *)[object url] isEqualToString:[self url]];
}

@synthesize view;
@synthesize region;
@synthesize search;

@end
