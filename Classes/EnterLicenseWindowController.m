//
//  EnterLicenseWindowController.m
//  Marketplace
//
//  Created by Josh Abernathy on 11/4/09.
//  Copyright 2009 Dandy Code. All rights reserved.
//

#import "EnterLicenseWindowController.h"
#import "AppDelegate.h"


@implementation EnterLicenseWindowController

+ (EnterLicenseWindowController *)defaultController {
	return [[[EnterLicenseWindowController alloc] initWithWindowNibName:@"EnterLicenseWindow"] autorelease];
}

- (IBAction)cancelEnterLicense:(id)sender {
	[NSApp endSheet:self.window];
	[self.window orderOut:nil];
	
	if([[NSApp delegate] daysUntilExpiration] <= 0) {
		[NSApp terminate:nil];
	}
}

- (IBAction)saveLicense:(id)sender {
	[NSApp endSheet:self.window];
	[self.window orderOut:nil];
    
	NSData *newLicenseData = [[NSApp delegate] licenseDataForName:[nameField stringValue] email:[emailField stringValue] key:[keyField stringValue]];
	if([[NSApp delegate] isValidLicenseData:newLicenseData]) {
		[[NSApp delegate] validateAndStoreLicense:newLicenseData];
	} else {
		[[NSApp delegate] validateAndStoreLicense:nil];
		
		if([[NSApp delegate] daysUntilExpiration] <= 0) {
			[NSApp terminate:nil];
		}
	}
}

@synthesize nameField;
@synthesize emailField;
@synthesize keyField;

@end
