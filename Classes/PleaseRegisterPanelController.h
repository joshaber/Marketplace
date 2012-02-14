//
//  PleaseRegisterPanelController.h
//  Marketplace
//
//  Created by Josh Abernathy on 1/20/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class JAGradientView;


@interface PleaseRegisterPanelController : NSWindowController {
	JAGradientView *topView;
	JAGradientView *bottomView;
	NSTextField *messageField;
}

+ (PleaseRegisterPanelController *)defaultController;

- (IBAction)buy:(id)sender;
- (IBAction)enterLicense:(id)sender;
- (IBAction)closeSheet:(id)sender;

@property (assign, nonatomic) IBOutlet JAGradientView *topView;
@property (assign, nonatomic) IBOutlet JAGradientView *bottomView;
@property (assign, nonatomic) IBOutlet NSTextField *messageField;

@end
