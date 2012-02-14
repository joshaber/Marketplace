//
//  OptionsViewController.h
//  Marketplace
//
//  Created by Josh Abernathy on 1/13/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "JAViewController.h"


@interface OptionsViewController : JAViewController {
	NSMutableDictionary *attributes;
}

- (NSString *)URLAttributes;
- (void)parseURLAttributes:(NSString *)url;
- (void)clearValues;

@property (assign, nonatomic) NSMutableDictionary *attributes;

@end
