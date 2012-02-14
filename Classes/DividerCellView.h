//
//  DividerCellView.h
//  Marketplace
//
//  Created by Josh Abernathy on 7/4/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "JACellView.h"
#import "JAEtchedTextField.h"
#import "JAGradientView.h"


@interface DividerCellView : JACellView {
	JAGradientView *gradientView;
}

@property (retain) IBOutlet JAGradientView *gradientView;

@end
