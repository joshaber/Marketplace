//
//  NSObject+JAAdditions.m
//  Marketplace
//
//  Created by Josh Abernathy on 7/23/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "NSObject+JAAdditions.h"


@implementation NSObject (JAAdditions)

- (void)postValueChangedForKey:(NSString *)key {
	[self willChangeValueForKey:key];
	[self didChangeValueForKey:key];
}

- (void)performSelector:(SEL)selector withArguments:(NSPointerArray *)arguments returnValue:(void *)returnValue {
    NSMethodSignature *signature = [[self class] instanceMethodSignatureForSelector:selector];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setSelector:selector];
    [invocation setTarget:self];
    
    for(NSUInteger i = 0; i < arguments.count; i++) {
        [invocation setArgument:[arguments pointerAtIndex:i] atIndex:i + 2];
    }
    
    [invocation invoke];
    [invocation getReturnValue:returnValue];
}

- (void)performSelector:(SEL)selector withArgument:(void *)arg1 withArgument:(void *)arg2 returnValue:(void *)returnValue {
    NSPointerArray *arguments = [NSPointerArray pointerArrayWithWeakObjects];
    // NULL's get passed on, NSNull's don't
    if(arg1 != [NSNull null]) [arguments addPointer:arg1];
    if(arg2 != [NSNull null]) [arguments addPointer:arg2];
    [self performSelector:selector withArguments:arguments returnValue:returnValue];
}

- (void)performSelector:(SEL)selector withArgument:(void *)arg1 returnValue:(void *)returnValue {
    [self performSelector:selector withArgument:arg1 withArgument:[NSNull null] returnValue:returnValue];
}

- (void)performSelector:(SEL)selector returnValue:(void *)returnValue {
    [self performSelector:selector withArgument:[NSNull null] withArgument:[NSNull null] returnValue:returnValue];
}

@end
