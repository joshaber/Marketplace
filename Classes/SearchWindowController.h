//
//  SearchWindowController.h
//  Marketplace
//
//  Created by Josh Abernathy on 8/3/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class Search;
@class BasicSearchViewController;
@class JAPopupWindow;


@interface SearchWindowController : NSWindowController {
	NSArrayController *searchesController;
	
	__weak NSWindow *parent;
	
	BasicSearchViewController *basicSearchViewController;
}

+ (SearchWindowController *)defaultControllerWithParent:(NSWindow *)parent;

- (void)showNewBasicSearch;
- (void)showEditSearch:(Search *)search;

- (JAPopupWindow *)window;

@property (assign) NSArrayController *searchesController;
@property (assign) BasicSearchViewController *basicSearchViewController;

@end
