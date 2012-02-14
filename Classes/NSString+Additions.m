//
//  NSString+Additions.m
//  Marketplace
//
//  Created by Josh Abernathy on 2/21/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "NSString+Additions.h"


@implementation NSString (Additions)

- (NSString *)stringByDeletingLastCharacter {
	return [self substringToIndex:[self length]-1];
}

- (NSString *)stringByEscapingForURLArgument {
    // Encode all the reserved characters, per RFC 3986
    // (<http://www.ietf.org/rfc/rfc3986.txt>)
    CFStringRef escaped = 
    CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                            (CFStringRef)self,
                                            NULL,
                                            (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                            kCFStringEncodingUTF8);
    CFMakeCollectable(escaped);
    return (NSString *) escaped;
}

- (NSString *)stringByUnescapingFromURLArgument {
    NSMutableString *resultString = [NSMutableString stringWithString:self];
    [resultString replaceOccurrencesOfString:@"+"
                                  withString:@" "
                                     options:NSLiteralSearch
                                       range:NSMakeRange(0, [resultString length])];
    return [resultString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

@end
