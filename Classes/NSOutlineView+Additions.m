//
//  NSOutlineView+Additions.m
//  Marketplace
//
//  Created by Josh Abernathy on 3/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "NSOutlineView+Additions.h"


@implementation NSOutlineView (Additions)

- (id)selectedItem {
	return [self itemAtRow:[self selectedRow]];
}

@end
