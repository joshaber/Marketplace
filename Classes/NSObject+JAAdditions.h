//
//  NSObject+JAAdditions.h
//  Marketplace
//
//  Created by Josh Abernathy on 7/23/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface NSObject (JAAdditions)
- (void)postValueChangedForKey:(NSString *)key;
- (void)performSelector:(SEL)selector withArguments:(NSPointerArray *)arguments returnValue:(void *)returnValue;
- (void)performSelector:(SEL)selector withArgument:(void *)arg1 withArgument:(void *)arg2 returnValue:(void *)returnValue;
- (void)performSelector:(SEL)selector withArgument:(void *)arg1 returnValue:(void *)returnValue;
- (void)performSelector:(SEL)selector returnValue:(void *)returnValue;
@end
