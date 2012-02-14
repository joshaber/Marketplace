//
//  RegionsController.h
//  Marketplace
//
//  Created by Josh Abernathy on 10/24/09.
//  Copyright 2009 Dandy Code. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RegionsController : NSObject {
    NSMutableDictionary *allRegions;
    NSMutableDictionary *expandableRegions;
}

+ (RegionsController *)sharedInstance;

@property (nonatomic, readonly) NSDictionary *allRegions;
@property (nonatomic, readonly) NSDictionary *expandableRegions;

@end
