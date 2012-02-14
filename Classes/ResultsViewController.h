//
//  ResultsViewController.h
//  Marketplace
//
//  Created by Josh Abernathy on 7/19/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

#import "JAViewController.h"

@class JAGradientView;


@interface ResultsViewController : JAViewController {
	NSTableView *resultsTable;
	NSArrayController *results;
	WebView *webView;
	
	JAGradientView *bottomBarView;
	JAGradientView *topBarView;
	
	NSSplitView *splitView;
	NSView *filterView;
	
	NSButton *filterButton;
	
	NSPredicateEditor *predicateEditor;
	
	NSSize filterViewSize;
    
    BOOL isDraggingSelectedItem;
}

- (void)goToSelectedPage;

- (IBAction)showFilter:(NSButton *)sender;

@property (assign) BOOL isDraggingSelectedItem;

@property (assign) IBOutlet NSTableView *resultsTable;
@property (assign) IBOutlet NSArrayController *results;
@property (assign) IBOutlet WebView *webView;

@property (assign) IBOutlet JAGradientView *bottomBarView;
@property (assign) IBOutlet JAGradientView *topBarView;

@property (assign) IBOutlet NSSplitView *splitView;
@property (assign) IBOutlet NSView *filterView;

@property (assign) IBOutlet NSButton *filterButton;

@property (assign) IBOutlet NSPredicateEditor *predicateEditor;

@end
