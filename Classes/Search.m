//
//  SearchEntry.m
//  Marketplace
//
//  Created by Josh Abernathy on 3/13/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "Search.h"

#import "AppDelegate.h"
#import "SearchResult.h"
#import "SearchParser.h"
#import "NSObject+JAAdditions.h"

NSString * const JAUnreadCountChangedNotification = @"JAUnreadCountChangedNotification";

@interface Search ()
- (void)searchEnded:(id)object;
@end


@implementation Search

+ (void)initialize {
    if([self class] == [Search class]) {
        [self setKeys:[NSArray arrayWithObject:@"text"] triggerChangeNotificationsForDependentKey:@"title"];
    }
}

+ (Search *)search {
	return [[[Search alloc] init] autorelease];
}

- (id)init {
	self = [super init];
	
	self.isSearching = NO;
	self.resultCount = 0;
	self.image = [[NSImage imageNamed:@"find"] TIFFRepresentation];
	self.subCategories = [NSMutableArray array];
	self.visitedURLs = [NSMutableDictionary dictionary];
	self.isFiltered = NO;
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchEnded:) name:JASearchParserSearchDoneNotification object:self];
	
	return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:MPAppVersion forKey:@"version"];
	[coder encodeObject:regions forKey:@"regions"];
	[coder encodeObject:text forKey:@"text"];
	[coder encodeObject:category forKey:@"category"];
	[coder encodeObject:subcategory forKey:@"subcategory"];
	[coder encodeObject:filter forKey:@"filter"];
	[coder encodeObject:URLAttributes forKey:@"URLAttributes"];
	[coder encodeObject:visitedURLs forKey:@"visitedURLs"];
	[coder encodeBool:isFiltered forKey:@"isFiltered"];
    [coder encodeObject:title forKey:@"title"];
}

- (id)initWithCoder:(NSCoder *)coder {
	self = [self init];
	
    self.title = [coder decodeObjectForKey:@"title"];
	self.regions = [coder decodeObjectForKey:@"regions"];
	self.text = [coder decodeObjectForKey:@"text"];
	self.category = [coder decodeObjectForKey:@"category"];
	self.subcategory = [coder decodeObjectForKey:@"subcategory"];
	self.filter = [coder decodeObjectForKey:@"filter"];
	self.URLAttributes = [coder decodeObjectForKey:@"URLAttributes"];
	self.visitedURLs = [coder decodeObjectForKey:@"visitedURLs"];
	self.isFiltered = [coder decodeBoolForKey:@"isFiltered"];
	if(self.visitedURLs == nil) {
		self.visitedURLs = [NSMutableDictionary dictionary];
	}
			
	return self;
}

- (id)copyWithZone:(NSZone *)zone {
	Search *entry = [[[self class] allocWithZone:zone] init];
	entry.regions = regions;
	entry.text = text;
	entry.category = category;
	entry.subcategory = subcategory;
	entry.filter = filter;
	entry.URLAttributes = URLAttributes;
	entry.isFiltered = isFiltered;
	entry.title = title;
    
    return entry;
}

- (NSString *)displayName {
    if(title == nil || title.length < 1) return text;
    return title;
}

- (NSMutableArray *)results {
	if(results == nil) {
		[self search];
	}
	
	return results;
}

- (void)search {
	if(isSearching) return;
	
	if(results == nil) {
		results = [NSMutableArray array];
	}
	
	self.isSearching = YES;
	hasFoundNewItems = NO;
	
	searchParser = [SearchParser parserForSearch:self];
	[searchParser performSearch];
}

- (void)stopSearch {
    searchParser.shouldStop = YES;
}

- (void)searchEnded:(id)object {
    for(id<Result> result in self.results) {
        if(![result isKindOfClass:[SearchResult class]]) continue;
        
        SearchResult *realResult = (SearchResult *) result;
        if(realResult.hasBeenRead) {
            [visitedURLs setObject:[NSNumber numberWithBool:YES] forKey:realResult.url];
        } else {
            if([visitedURLs objectForKey:realResult.url] != nil) {
                realResult.hasBeenRead = YES;
            }
        }
    }
    
	NSLog(@"%@ done searching", self);
	
	if(hasFoundNewItems) {
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		if([defaults boolForKey:JAShowNewResultsNotifications]) {
			if(([defaults boolForKey:JAShowNotificationsOnlyWhenInactive] && ![NSApp isActive]) || 
			   ![defaults boolForKey:JAShowNotificationsOnlyWhenInactive]) {
				NSString *description = [NSString stringWithFormat:@"There are new search results for \"%@\" (%@)", self.displayName, self.category];
				[GrowlApplicationBridge notifyWithTitle:@"New search results" 
											description:description
									   notificationName:@"New results found"
											   iconData:nil
											   priority:0
											   isSticky:NO
										   clickContext:@""];
			}
		}
	}
	
	searchParser = nil;
	
	self.isSearching = NO;
}

- (void)addResult:(id<Result>)result {
	[self addResults:[NSArray arrayWithObject:result]];
}

- (void)addResults:(NSArray *)newResults {
    for(id<Result> result in newResults) {
        // this code makes me feel dirty
        if([result isKindOfClass:[SearchResult class]]) {
            self.resultCount++;
            SearchResult *realResult = (SearchResult *) result;
            if([visitedURLs objectForKey:realResult.url] != nil) {
                realResult.hasBeenRead = YES;
            }
            
            if(![subCategories containsObject:realResult.category]) {
                [subCategories addObject:realResult.category];
            }
        }
        
        result.search = self;
    }
    
	// notify of KVC change
	[self willChangeValueForKey:@"results"];
    [results addObjectsFromArray:newResults];
	[self didChangeValueForKey:@"results"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:JAUnreadCountChangedNotification 
														object:nil 
													  userInfo:[NSDictionary dictionaryWithObject:self forKey:@"search"]];
}

- (void)removeResult:(id<Result>)result {
	if([result isKindOfClass:[SearchResult class]]) {
		self.resultCount--;
        SearchResult *realResult = (SearchResult *) result;
		[visitedURLs removeObjectForKey:realResult.url];
	}
	
	result.search = nil;
		
	// notify of KVC change
	[self willChangeValueForKey:@"results"];
	[results removeObject:result];
	[self didChangeValueForKey:@"results"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:JAUnreadCountChangedNotification 
														object:nil 
													  userInfo:[NSDictionary dictionaryWithObject:self forKey:@"search"]];
}

- (void)reset {
	if(isSearching) return;
		
	[self search];
}

- (void)markResultAsRead:(SearchResult *)result {
	[visitedURLs setObject:[NSNumber numberWithBool:YES] forKey:result.url];
    result.hasBeenRead = YES;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:JAUnreadCountChangedNotification 
														object:nil 
													  userInfo:[NSDictionary dictionaryWithObject:self forKey:@"search"]];
}

- (NSString *)description {
	return [NSString stringWithFormat:@"%@: %ld", [self title], (long) resultCount];
}

- (NSUInteger)unreadCount {    
    return [[results filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"isSearchable == YES && hasBeenRead = NO"]] count];
}

@synthesize regions;
@synthesize text;
@synthesize category;
@synthesize subcategory;
@synthesize filter;
@synthesize results;
@synthesize isSearching;
@synthesize resultCount;
@synthesize image;
@synthesize subCategories;
@synthesize URLAttributes;
@synthesize visitedURLs;
@synthesize isFiltered;
@synthesize hasFoundNewItems;
@synthesize title;

@end
