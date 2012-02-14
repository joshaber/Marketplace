//
//  EnterLicenseWindowController.h
//  Marketplace
//
//  Created by Josh Abernathy on 11/4/09.
//  Copyright 2009 Dandy Code. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface EnterLicenseWindowController : NSWindowController {
    NSTextField *nameField;
	NSTextField *emailField;
	NSTextField *keyField;
}

+ (EnterLicenseWindowController *)defaultController;

- (IBAction)cancelEnterLicense:(id)sender;
- (IBAction)saveLicense:(id)sender;

@property (assign, nonatomic) IBOutlet NSTextField *nameField;
@property (assign, nonatomic) IBOutlet NSTextField *emailField;
@property (assign, nonatomic) IBOutlet NSTextField *keyField;

@end
