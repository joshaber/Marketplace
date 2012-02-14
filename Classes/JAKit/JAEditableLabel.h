//
//  JAEditableLabel.h
//  Marketplace
//
//  Created by Josh Abernathy on 8/11/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class JAShadowedViewContainer;


@interface JAEditableLabel : NSTextField {
    BOOL isFirstResponder;
    JAShadowedViewContainer *shadowedView;
    NSRect originalFrame;
    NSString *defaultValue;
}

@end
