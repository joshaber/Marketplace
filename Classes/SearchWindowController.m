//
//  SearchWindowController.m
//  Marketplace
//
//  Created by Josh Abernathy on 8/3/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "SearchWindowController.h"

#import "BasicSearchViewController.h"
#import "JAPopupWindow.h"


@implementation SearchWindowController

+ (SearchWindowController *)defaultControllerWithParent:(NSWindow *)parent {
	SearchWindowController *controller = [[[SearchWindowController alloc] initWithWindowNibName:@"SearchWindow"] autorelease];
	controller->parent = parent;
	
	return controller;
}

- (void)windowDidLoad {
	[[self window] setValue:parent forKey:@"parent"];
	
	basicSearchViewController = [BasicSearchViewController defaultController];
	basicSearchViewController.windowController = self;
	basicSearchViewController.representedObject = searchesController;
	
	[self.window setFrame:basicSearchViewController.view.frame display:NO];
	self.window.backgroundColor = [NSColor clearColor];
	self.window.contentView = [basicSearchViewController view];
}

- (void)showNewBasicSearch {
    if(basicSearchViewController == nil) {
        (void) self.window;
    }
    
    [basicSearchViewController newSearch];
	[self.window animateOpen:nil];
}

- (void)showEditSearch:(Search *)search {
    if(basicSearchViewController == nil) {
        (void) self.window;
    }
    
    [basicSearchViewController editSearch:search];
	[self.window animateOpen:nil];
}

- (JAPopupWindow *)window {
    return (JAPopupWindow *) [super window];
}

@synthesize searchesController;
@synthesize basicSearchViewController;

@end
