//
//  NSDictionary+JAAdditions.m
//  Marketplace
//
//  Created by Josh Abernathy on 9/22/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "NSDictionary+JAAdditions.h"


@implementation NSDictionary (JAAdditions)

+ (id)dictionaryFromURLQuery:(NSString *)query {
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    NSArray *pieces = [query componentsSeparatedByString:@"&"];
	for(NSString *piece in pieces) {
		NSArray *keys = [piece componentsSeparatedByString:@"="];
		if(keys.count < 2) continue;
        
		NSString *key = [keys objectAtIndex:0];
		NSString *value = [keys objectAtIndex:1];
        [result setObject:value forKey:key];
    }
    
    return [result copy];
}

@end
