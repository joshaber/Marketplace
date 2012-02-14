//
//  NSString+Capitalization.m
//  CLParser
//
//  Created by Josh Abernathy on 10/20/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "NSString+Capitalization.h"


@implementation NSString (Capitalization)

- (NSString *)stringByCapitalizingEveryWord {
    NSMutableString *capitalizedString = [[self capitalizedString] mutableCopy];
    
    CFRange stringRange = CFRangeMake(0, capitalizedString.length);
    CFLocaleRef localeRef = CFLocaleCopyCurrent();
    
    CFStringTokenizerRef tokenizer = CFStringTokenizerCreate(kCFAllocatorDefault, (CFStringRef) capitalizedString, stringRange, kCFStringTokenizerUnitWord, localeRef);
    while(CFStringTokenizerAdvanceToNextToken(tokenizer) != kCFStringTokenizerTokenNone) {
        CFRange wordRange = CFStringTokenizerGetCurrentTokenRange(tokenizer);
        NSRange tempRange = NSMakeRange(wordRange.location, wordRange.length);
        NSString *tempWord = [[capitalizedString substringWithRange:tempRange] capitalizedString];
        [capitalizedString replaceCharactersInRange:tempRange withString:tempWord];
    }
    
    CFRelease(tokenizer);
    CFRelease(localeRef);
    
    return [capitalizedString autorelease];
}

@end
