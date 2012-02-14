//
//  Region.m
//  Marketplace
//
//  Created by Josh Abernathy on 3/22/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "Region.h"


@implementation Region

+ (Region *)region {
	return [[[Region alloc] init] autorelease];
}

+ (Region *)regionWithURL:(NSString *)u name:(NSString *)n {
	Region *r = [[Region alloc] init];
	r->url = u;
	r->name = n;
	
	return [r autorelease];
}

- (void) encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:MPAppVersion forKey:@"version"];
	[coder encodeObject:url forKey:@"url"];
	[coder encodeObject:name forKey:@"name"];
}

- (id)initWithCoder:(NSCoder *)coder {
	self = [self init];
	
	self.url = [coder decodeObjectForKey:@"url"];
	self.name = [coder decodeObjectForKey:@"name"];
	
	return self;
}

- (id)copyWithZone:(NSZone *)zone {
	Region *region = [[[self class] allocWithZone:zone] init];
	region->url = url;
	region->name = name;
	
    return region;
}

- (BOOL)isEqual:(Region *)region {
	return [url isEqualToString:region.url];
}

- (NSString *)strippedUrl {
    NSString *strippedUrl = [self.url copy];
    if(strippedUrl == nil) return nil;
    
    if([strippedUrl rangeOfString:@"[SEARCH]"].location != NSNotFound) {
        strippedUrl = [strippedUrl stringByReplacingOccurrencesOfString:@"[SEARCH]/" withString:@""];
        strippedUrl = [strippedUrl stringByReplacingOccurrencesOfString:@"[CATEGORY]/" withString:@""];
        strippedUrl = [strippedUrl stringByReplacingOccurrencesOfString:@"?[QUERY]" withString:@""];
        strippedUrl = [NSString stringWithFormat:@"http://%@/", [[NSURL URLWithString:strippedUrl] host]];
    }
    
    return strippedUrl;
}

@synthesize url;
@synthesize name;

@end
