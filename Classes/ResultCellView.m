//
//  ResultCellView.m
//  Marketplace
//
//  Created by Josh Abernathy on 7/3/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "ResultCellView.h"


@implementation ResultCellView

const NSColor *hoverColor;

+ (void)initialize {
    if([self class] == [ResultCellView class]) {
        hoverColor = [NSColor colorWithDeviceRed:(246.0f/255.0f) 
                                           green:(245.0f/255.0f) 
                                            blue:1.0f 
                                           alpha:1.0f];
    }
}

@end
