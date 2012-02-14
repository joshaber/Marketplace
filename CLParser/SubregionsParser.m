//
//  SubregionsParser.m
//  CLParser
//
//  Created by Josh Abernathy on 10/19/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SubregionsParser.h"
#import "NSString+Capitalization.h"


@implementation SubregionsParser

+ (SubregionsParser *)parser {
    return [[[SubregionsParser alloc] init] autorelease];
}

- (void)parse {
    NSDictionary *previousRegions = [NSDictionary dictionaryWithContentsOfFile:@"/Users/joshaber/Documents/Source/Marketplace/CLParser/regions.plist"];
    NSAssert(previousRegions != nil, @"previousRegions is nil");
    
    NSMutableDictionary *allRegions = [NSMutableDictionary dictionary];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    for(NSString *regionName in previousRegions) {
        dispatch_group_async(group, queue, ^{
            NSDictionary *region = [previousRegions objectForKey:regionName];
            NSString *url = [region objectForKey:@"url"];
            if(url == nil) {
                [allRegions setObject:region forKey:regionName];
                return;
            }
            
            NSXMLDocument *document = [[NSXMLDocument alloc] initWithContentsOfURL:[NSURL URLWithString:url] options:NSXMLDocumentTidyHTML error:NULL];
            if(document == nil) {
                NSLog(@"no document at %@ ?", url);
                return;
            }
            
            NSMutableDictionary *newRegion = [region mutableCopy];
            [newRegion setObject:[NSString stringWithFormat:@"%@/[SEARCH]/[CATEGORY]?[QUERY]", url] forKey:@"url"];
            [allRegions setObject:newRegion forKey:regionName];
            
            NSArray *subregionNodes = [document nodesForXPath:@"//span/a" error:NULL];
            if(subregionNodes == nil || subregionNodes.count < 1) {
                NSLog(@"no subregions at %@ ?", url);
                return;
            }
            
            for(NSXMLNode *subregionNode in subregionNodes) {
                NSString *partialUrl = [[[subregionNode nodesForXPath:@"@href" error:NULL] objectAtIndex:0] stringValue];
                partialUrl = [partialUrl substringToIndex:partialUrl.length - 1];
                NSString *subregionName = [[[[subregionNode nodesForXPath:@"@title" error:NULL] objectAtIndex:0] stringValue] stringByCapitalizingEveryWord];
                NSString *fullUrl = [NSString stringWithFormat:@"%@/[SEARCH]/[CATEGORY]%@?[QUERY]", url, partialUrl];
                
                NSDictionary *subregion = [NSDictionary dictionaryWithObjectsAndKeys:fullUrl, @"url", @"Subregion", @"category", regionName, @"parent", nil];
                [allRegions setObject:subregion forKey:subregionName];
            }
        });
    }

    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    dispatch_release(group);
    
    [allRegions writeToFile:@"/Users/joshaber/Desktop/regions.plist" atomically:YES];
}

@end
