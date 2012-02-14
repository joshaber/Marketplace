//
//  LicenseCommand.m
//  Marketplace
//
//  Created by Josh Abernathy on 3/21/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "URLLicenseCommand.h"
#import "NSArray+JAAdditions.h"
#import "AppDelegate.h"


@implementation URLLicenseCommand

- (id)performDefaultImplementation {
	NSString *name = @"";
	NSString *email = @"";
	NSString *signature = @"";
	
    NSString *urlString = [self directParameter];
	NSArray *pairs = [[[urlString componentsSeparatedByString:@"://"] objectAtIndex:1] componentsSeparatedByString:@"&"];
	for(NSString *pair in pairs) {
		NSArray *pieces = [pair componentsSeparatedByString:@"="];
		NSString *key = [pieces firstObject];
		NSString *value = [[pieces objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
		if([key isEqualToString:@"name"]) {
			name = value;
		} else if([key isEqualToString:@"email"]) {
			email = value;
		} else if([key isEqualToString:@"key"]) {
			signature = [value stringByAppendingString:@"="];
		}
	}
    	
	[[NSApp delegate] validateAndStoreLicense:[[NSApp delegate] licenseDataForName:name email:email key:signature]];
	
    return nil;
}

@end
