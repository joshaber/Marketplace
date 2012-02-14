//
//  FavoritesViewController.h
//  Marketplace
//
//  Created by Josh Abernathy on 7/27/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

#import "JAViewController.h"

@class JAGradientView;


@interface FavoritesViewController : JAViewController {
	NSTableView *favoritesTable;
	NSArrayController *favorites;
	WebView *webView;
	NSSplitView *splitView;
	
	JAGradientView *topBarView;
	JAGradientView *bottomBarView;
}

- (void)goToSelectedPage;

@property (assign, nonatomic) IBOutlet NSTableView *favoritesTable;
@property (assign, nonatomic) IBOutlet NSArrayController *favorites;
@property (assign, nonatomic) IBOutlet WebView *webView;
@property (assign, nonatomic) IBOutlet NSSplitView *splitView;
@property (assign, nonatomic) IBOutlet JAGradientView *topBarView;
@property (assign, nonatomic) IBOutlet JAGradientView *bottomBarView;

@end
