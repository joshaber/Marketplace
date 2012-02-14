//
//  OptionsViewController.m
//  Marketplace
//
//  Created by Josh Abernathy on 1/13/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "OptionsViewController.h"


@implementation OptionsViewController

- (id)init {
	self = [super init];
	
	attributes = [NSMutableDictionary dictionary];
	
	return self;
}

- (NSString *)URLAttributes {
	return @"";
}

- (void)parseURLAttributes:(NSString *)url {}

- (void)clearValues {}

@synthesize attributes;

@end
