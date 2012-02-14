//
//  MainWindowController.h
//  Marketplace
//
//  Created by Josh Abernathy on 7/26/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#define PasteboardType @"MarketplaceSearchRow"

@class FavoritesViewController;
@class ResultsViewController;
@class SplashViewController;
@class FavoritesRowView;
@class SearchWindowController;

@class JAViewController;
@class Search;


@interface MainWindowController : NSWindowController {
	NSView *mainView;
	NSButton *buyNowButton;
	NSSegmentedControl *resultsViewOrientationControl;
	
	NSArrayController *searches;
	NSArrayController *favorites;
	
	NSOutlineView *sourcesView;
		
	FavoritesRowView *favoritesRowView;
	
	JAViewController *currentViewController;
	
	FavoritesViewController *favoritesViewController;
	ResultsViewController *resultsViewController;
	SplashViewController *splashViewController;
	SearchWindowController *searchWindowController;
    
    id clickedItem;
}

+ (MainWindowController *)defaultController;

- (void)showResultsView;
- (void)showFavoritesView;
- (void)showSplashView;
- (void)showAddSearch:(id)sender;
- (void)highlightFavorites;

- (void)removeBuyNowButton;

- (void)refreshAllSearches:(id)sender;

- (IBAction)addOrRemoveClicked:(id)sender;
- (IBAction)goToStore:(id)sender;
- (IBAction)changeResultsViewOrientation:(id)sender;

- (Search *)lastSearch;

@property (assign) JAViewController *currentViewController;

@property (assign) IBOutlet NSArrayController *searches;
@property (assign) IBOutlet NSArrayController *favorites;
@property (assign) IBOutlet FavoritesRowView *favoritesRowView;
@property (assign) IBOutlet NSView *mainView;
@property (assign) IBOutlet NSButton *buyNowButton;
@property (assign) IBOutlet NSSegmentedControl *resultsViewOrientationControl;
@property (assign) IBOutlet NSOutlineView *sourcesView;

@end
