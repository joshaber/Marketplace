//
//  NSXMLNode+JAAdditions.h
//  Marketplace
//
//  Created by Josh Abernathy on 3/21/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface NSXMLNode (JAAdditions)
- (NSString *)stringValueForFirstNodeForXPath:(NSString *)xpath;
@end
