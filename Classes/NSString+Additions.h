//
//  NSString+Additions.h
//  Marketplace
//
//  Created by Josh Abernathy on 2/21/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface NSString (Additions)
- (NSString *)stringByDeletingLastCharacter;
- (NSString *)stringByEscapingForURLArgument;
- (NSString *)stringByUnescapingFromURLArgument;
@end
