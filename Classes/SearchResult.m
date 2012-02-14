//
//  Entry.m
//  Marketplace
//
//  Created by Josh Abernathy on 12/22/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "SearchResult.h"
#import "NSObject+DDExtensions.h"
#import "Search.h"


@implementation SearchResult

+ (SearchResult *)result {
	return [[[SearchResult alloc] init] autorelease];
}

+ (void)initialize {
    if([self class] == [SearchResult class]) {
        [self setKeys:[NSArray arrayWithObject:@"hasBeenRead"] triggerChangeNotificationsForDependentKey:@"fontColor"];
    }
}

- (id)init {
	self = [super init];
	
	isFavorite = NO;
	hasPicture = NO;
    hasBeenRead = NO;
	
	return self;
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (BOOL)isSearchable {
	return YES;
}

- (NSColor *)fontColor {
	if(self.hasBeenRead) {
		return [[NSColor blackColor] colorWithAlphaComponent:0.3f];
	} else {
		return [NSColor blackColor];
	}
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:MPAppVersion forKey:@"version"];
	[coder encodeObject:date forKey:@"date"];
	[coder encodeObject:url forKey:@"url"];
	[coder encodeObject:title forKey:@"title"];
	[coder encodeObject:region forKey:@"region"];
	[coder encodeObject:category forKey:@"category"];
	[coder encodeObject:location forKey:@"location"];
	[coder encodeBool:isFavorite forKey:@"isFavorite"];
	[coder encodeBool:hasPicture forKey:@"hasPicture"];
    [coder encodeObject:dateFound forKey:@"dateFound"];
    [coder encodeBool:hasBeenRead forKey:@"hasBeenRead"];
}

- (id)initWithCoder:(NSCoder *)coder {
	self = [self init];
	
	self.date = [coder decodeObjectForKey:@"date"];
	self.url = [coder decodeObjectForKey:@"url"];
	self.title = [coder decodeObjectForKey:@"title"];
	self.region = [coder decodeObjectForKey:@"region"];
	self.category = [coder decodeObjectForKey:@"category"];
	self.location = [coder decodeObjectForKey:@"location"];
	self.isFavorite = [coder decodeBoolForKey:@"isFavorite"];
	self.hasPicture = [coder decodeBoolForKey:@"hasPicture"];
    self.dateFound = [coder decodeObjectForKey:@"dateFound"];
    self.hasBeenRead = [coder decodeBoolForKey:@"hasBeenRead"];
	
	return self;
}

- (BOOL)isEqual:(id)object {
    if(![object isKindOfClass:[SearchResult class]]) return NO;
    
    SearchResult *otherResult = object;
	return [otherResult.url isEqualToString:self.url] || ([otherResult.title isEqualToString:self.title] && [otherResult.region isEqualToString:self.region] && [otherResult.category isEqualToString:self.category]);
}

- (NSView *)view {
	if(view == nil) {
		[[NSBundle dd_invokeOnMainThreadAndWaitUntilDone:YES] loadNibNamed:@"ResultView" owner:self];
	}
	
	return view;
}

@synthesize view;
@synthesize date;
@synthesize url;
@synthesize title;
@synthesize region;
@synthesize category;
@synthesize location;
@synthesize search;
@synthesize isFavorite;
@synthesize hasPicture;
@synthesize dateFound;
@synthesize hasBeenRead;
@synthesize resultOrder;

@end
