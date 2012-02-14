//
//  PleaseRegisterPanelController.m
//  Marketplace
//
//  Created by Josh Abernathy on 1/20/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PleaseRegisterPanelController.h"

#import "AppDelegate.h"
#import "JAGradientView.h"


@implementation PleaseRegisterPanelController

+ (PleaseRegisterPanelController *)defaultController {
	return [[[PleaseRegisterPanelController alloc] initWithWindowNibName:@"PleaseRegisterPanel"] autorelease];
}

- (void)windowDidLoad {
	topView.gradient = [[NSGradient alloc] initWithStartingColor:[NSColor colorWithDeviceRed:(150.0f/255.0f) 
																					   green:(165.0f/255.0f) 
																						blue:(178.0f/255.0f) 
																					   alpha:1.0f] 
													 endingColor:[NSColor colorWithDeviceRed:(150.0f/255.0f) 
																					   green:(165.0f/255.0f) 
																						blue:(178.0f/255.0f) 
																					   alpha:1.0f]];
	bottomView.gradient = [[NSGradient alloc] initWithStartingColor:[NSColor colorWithDeviceRed:(150.0f/255.0f) 
																						  green:(165.0f/255.0f) 
																						   blue:(178.0f/255.0f) 
																						  alpha:1.0f] 
														endingColor:[NSColor colorWithDeviceRed:(150.0f/255.0f) 
																						  green:(165.0f/255.0f) 
																						   blue:(178.0f/255.0f) 
																						  alpha:1.0f]];
}

- (IBAction)buy:(id)sender {
	[[NSApp delegate] goToStore:sender];
	
	if([[NSApp delegate] daysUntilExpiration] > 0) {
		[NSApp endSheet:self.window];
		[self.window orderOut:sender];
	}
}

- (IBAction)enterLicense:(id)sender {
	[self.window orderOut:sender];
	[NSApp endSheet:self.window];
	[[NSApp delegate] showEnterLicense:sender];
}

- (IBAction)closeSheet:(id)sender {
	[self.window orderOut:sender];
	[NSApp endSheet:self.window];
	
	if([[NSApp delegate] daysUntilExpiration] <= 0) {
		[NSApp terminate:nil];
	}
}

@synthesize topView;
@synthesize bottomView;
@synthesize messageField;

@end
