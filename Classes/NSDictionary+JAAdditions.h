//
//  NSDictionary+JAAdditions.h
//  Marketplace
//
//  Created by Josh Abernathy on 9/22/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface NSDictionary (JAAdditions)
+ (id)dictionaryFromURLQuery:(NSString *)query;
@end
