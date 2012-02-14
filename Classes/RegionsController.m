//
//  RegionsController.m
//  Marketplace
//
//  Created by Josh Abernathy on 10/24/09.
//  Copyright 2009 Dandy Code. All rights reserved.
//

#import "RegionsController.h"

@interface RegionsController ()
- (void)loadRegions;
@end


@implementation RegionsController

+ (RegionsController *)sharedInstance {
    return [[RegionsController alloc] init];
}

- (id)init {
	static RegionsController *instance = nil;
	
	if(instance == nil) {
		self = [super init];
		
        [self loadRegions];
		instance = self;
	}
	
	return instance;
}

- (void)loadRegions {
	allRegions = [NSMutableDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"regions" ofType:@"plist"]];
	expandableRegions = [NSMutableDictionary dictionary];
	
	for(NSString *regionName in [allRegions allKeys]) {
		NSDictionary *region = [allRegions objectForKey:regionName];
		if([region objectForKey:@"parent"] == nil) continue;
		
		NSString *parentRegion = [region objectForKey:@"parent"];
		NSMutableArray *subregions = [expandableRegions objectForKey:parentRegion];
		if(subregions == nil) subregions = [NSMutableArray array];
		
		[subregions addObject:regionName];
		[expandableRegions setObject:subregions forKey:parentRegion];
		
		[[allRegions objectForKey:parentRegion] setObject:@"yes" forKey:@"expandable"];
	}
}

@synthesize allRegions;
@synthesize expandableRegions;

@end
