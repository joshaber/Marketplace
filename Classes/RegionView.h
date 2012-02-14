//
//  RegionView.h
//  Layers
//
//  Created by Josh Abernathy on 12/16/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "JAView.h"


@interface RegionView : JAView {	
	NSString *label;
	NSString *category;
	NSTrackingArea *trackingArea;
	
	BOOL shouldDrawCategory;
	BOOL doesExpand;
}

+ (RegionView *)regionViewWithLabel:(NSString *)l inCategory:(NSString *)c;

- (BOOL)isSelected;

@property (assign, nonatomic) NSString *label;
@property (assign, nonatomic) NSString *category;
@property (assign, nonatomic) BOOL shouldDrawCategory;
@property (assign, nonatomic) BOOL doesExpand;

@end
