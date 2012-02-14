//
//  BasicSearchViewController.h
//  Marketplace
//
//  Created by Josh Abernathy on 1/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "JAViewController.h"
#import "RegionSelectionView.h"

@class MAAttachedWindow;
@class Search;
@class JAGradientView;
@class Search;
@class OptionsViewController;


@interface BasicSearchViewController : JAViewController <RegionSelectionDataSource, RegionSelectionDelegate> {
	NSSearchField *regionField;
	NSPopUpButton *categoryPopUp;
	NSPopUpButton *subcategoryPopUp;
	NSTextField *searchField;
	NSButton *searchButton;
	NSBox *optionsBox;
	NSButton *searchTitleOnlyButton;
	NSButton *imageResultsOnlyButton;
	NSButton *disclosureButton;
    NSTextField *searchNameField;
	
	NSArrayController *searchRegions;
	
	MAAttachedWindow *completionWindow;
	RegionSelectionView *regionSelectionView;
	JAGradientView *topBarView;
	OptionsViewController *currentOptionsViewController;
	
	NSDictionary *categories;
	NSMutableArray *completionViews;
	
	NSSize originalOptionsViewSize;
	
	Search *previousSearch;
}

- (IBAction)cancelSearch:(id)sender;
- (IBAction)removeRegion:(id)sender;

- (IBAction)categoryChanged:(id)sender;
- (IBAction)subcategoryChanged:(id)sender;

- (IBAction)toggleAdvancedOptions:(id)sender;

- (void)newSearch;
- (void)editSearch:(Search *)search;

@property (assign) Search *previousSearch;
@property (assign, nonatomic) IBOutlet NSSearchField *regionField;
@property (assign, nonatomic) IBOutlet NSPopUpButton *categoryPopUp;
@property (assign, nonatomic) IBOutlet NSPopUpButton *subcategoryPopUp;
@property (assign, nonatomic) IBOutlet NSTextField *searchField;
@property (assign, nonatomic) IBOutlet NSButton *searchButton;
@property (assign, nonatomic) IBOutlet RegionSelectionView *regionSelectionView;
@property (assign, nonatomic) IBOutlet NSArrayController *searchRegions;
@property (assign, nonatomic) IBOutlet JAGradientView *topBarView;
@property (assign, nonatomic) IBOutlet NSBox *optionsBox;
@property (assign, nonatomic) OptionsViewController *currentOptionsViewController;
@property (assign, nonatomic) IBOutlet NSButton *searchTitleOnlyButton;
@property (assign, nonatomic) IBOutlet NSButton *imageResultsOnlyButton;
@property (assign, nonatomic) IBOutlet NSButton *disclosureButton;
@property (assign, nonatomic) IBOutlet NSTextField *searchNameField;

@end
