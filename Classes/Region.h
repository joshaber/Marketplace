//
//  Region.h
//  Marketplace
//
//  Created by Josh Abernathy on 3/22/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface Region : NSObject <NSCopying, NSCoding> {
	NSString *url;
	NSString *name;
}

+ (Region *)region;
+ (Region *)regionWithURL:(NSString *)u name:(NSString *)n;

- (NSString *)strippedUrl;

@property (assign) NSString *url;
@property (assign) NSString *name;

@end
