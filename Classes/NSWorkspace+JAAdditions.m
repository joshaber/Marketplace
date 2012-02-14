//
//  NSWorkspace+JAAdditions.m
//  Marketplace
//
//  Created by Josh Abernathy on 3/21/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "NSWorkspace+JAAdditions.h"


@implementation NSWorkspace (JAAdditions)

- (void)openURLInBackground:(NSURL *)url {
	[self openURLsInBackground:[NSArray arrayWithObject:url]];
}

- (void)openURLsInBackground:(NSArray *)urls {
	LSLaunchURLSpec urlSpec;
	
	urlSpec.appURL = nil;
	urlSpec.itemURLs = (CFArrayRef) urls;
	urlSpec.passThruParams = nil;
	
	urlSpec.launchFlags = kLSLaunchDontSwitch;	
	urlSpec.asyncRefCon = nil;
	
	LSOpenFromURLSpec(&urlSpec, nil);
}

- (void)openURLs:(NSArray *)urls {
	for(NSURL *url in urls) {
		[[NSWorkspace sharedWorkspace] openURL:url];
	}
}

- (NSString *)applicationSupportDirectory {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
	return (paths.count > 0) ? [paths objectAtIndex:0] : NSTemporaryDirectory();
}

- (NSString *)preferencesDirectory {
    FSRef desktopFolderRef;
	
    FSFindFolder(kUserDomain, kPreferencesFolderType, kDontCreateFolder, &desktopFolderRef);
    CFURLRef url = CFURLCreateFromFSRef(kCFAllocatorSystemDefault, &desktopFolderRef);
    CFMakeCollectable(url);
    
	return (NSString *) CFMakeCollectable(CFURLCopyFileSystemPath(url, kCFURLPOSIXPathStyle));
}

@end
