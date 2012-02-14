//
//  NSWorkspace+JAAdditions.h
//  Marketplace
//
//  Created by Josh Abernathy on 3/21/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface NSWorkspace (JAAdditions)
- (void)openURLInBackground:(NSURL *)url;
- (void)openURLsInBackground:(NSArray *)urls;
- (void)openURLs:(NSArray *)urls;

- (NSString *)applicationSupportDirectory;
- (NSString *)preferencesDirectory;
@end
