//
//  BasicSearchViewController.m
//  Marketplace
//
//  Created by Josh Abernathy on 1/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "BasicSearchViewController.h"

#import "RegionView.h"
#import "JAPopupWindow.h"
#import "RegionSelectionView.h"
#import "MAAttachedWindow.h"
#import "Search.h"
#import "SearchWindowController.h"
#import "SearchController.h"
#import "NSObject+JAAdditions.h"
#import "JATableView.h"
#import "JAGradientView.h"
#import "Region.h"
#import "OptionsViewController.h"
#import "AppDelegate.h"
#import "NSArray+JAAdditions.h"
#import "AllRegionsView.h"
#import "RegionsController.h"

@interface BasicSearchViewController () <NSTextFieldDelegate>
- (void)saveSearch;
- (void)addSearch;
- (void)createCompletionWindow;
- (void)removeCompletionWindow;
- (void)loadCategories;
- (NSString *)URLAttributes;
- (void)updateGUIWithURLAttributesFromSearch:(Search *)search;
- (void)updateOptionsView;
- (void)updateSubcategories;
- (BOOL)GUIToSearch:(Search *)search;
- (void)closeSearchWindow;
- (void)useNewRegions:(NSArray *)regions;
- (void)addRegion:(Region *)newRegion;
@end


@implementation BasicSearchViewController

- (void)viewDidLoad {
	topBarView.gradient = [[NSGradient alloc] initWithStartingColor:[NSColor colorWithDeviceRed:(150.0f/255.0f) 
																						  green:(165.0f/255.0f) 
																						   blue:(178.0f/255.0f) 
																						  alpha:1.0f] 
														endingColor:[NSColor colorWithDeviceRed:(150.0f/255.0f) 
																						  green:(165.0f/255.0f) 
																						   blue:(178.0f/255.0f) 
																						  alpha:1.0f]];
	
	regionSelectionView.dataSource = self;
	regionSelectionView.delegate = self;
	[regionSelectionView reloadData];
	
	regionField.delegate = self;
	
	previousSearch = [[[NSApp delegate] persistentData] valueForKey:@"lastSearch"];
	
	[self loadCategories];
}

- (void)loadCategories {
	[categoryPopUp removeAllItems];
	
	categories = [NSDictionary dictionaryWithContentsOfFile:
				  [[NSBundle mainBundle] pathForResource:@"categories" ofType:@"plist"]];
	
	[categoryPopUp addItemsWithTitles:[[categories allKeys] alphabeticallySortedArray]];
	[categoryPopUp selectItemWithTitle:@"For Sale"];
	[self categoryChanged:nil];
}

- (void)newSearch {	
	[searchButton setTarget:self];
	[searchButton setAction:@selector(addSearch)];
	
	[searchRegions removeObjects:[searchRegions arrangedObjects]];
	[searchRegions addObjects:previousSearch.regions];
	[searchRegions setSelectionIndex:0];
}

- (void)editSearch:(Search *)search {
	[searchButton setTarget:self];
	[searchButton setAction:@selector(saveSearch)];
	
	[searchRegions removeObjects:[searchRegions arrangedObjects]];
	[searchRegions addObjects:search.regions];
	[searchRegions setSelectionIndex:0];

	[categoryPopUp selectItemWithTitle:search.category];
	[self categoryChanged:nil];
	
	if(search.subcategory != nil) {
		[subcategoryPopUp selectItemWithTitle:search.subcategory];
	} else {
		[subcategoryPopUp selectItemWithTitle:@"All"];
	}
	
    [searchNameField setStringValue:search.title];
	[searchField setStringValue:search.text];
	[self updateGUIWithURLAttributesFromSearch:search];
	[regionField setStringValue:@""];
    
    previousSearch = search;
}

- (void)addSearch {
	Search *search = [Search search];
	BOOL shouldSave = [self GUIToSearch:search];
	if(!shouldSave) {
		return;
	}
	
	[searchField setStringValue:@""];
	[regionField setStringValue:@""];
    [searchNameField setStringValue:@""];
    [currentOptionsViewController clearValues];
	
	[[SearchController sharedInstance] addSearch:search];
	[self.representedObject setSelectedObjects:[NSArray arrayWithObject:search]];
	
	previousSearch = search;
}

- (void)saveSearch {
	BOOL shouldSave = [self GUIToSearch:previousSearch];
	if(!shouldSave) {
		return;
	}
	
    [currentOptionsViewController clearValues];
    
	[previousSearch reset];
	
	[self.representedObject postValueChangedForKey:@"arrangedObjects"];
}

- (BOOL)GUIToSearch:(Search *)search {	
	if([[searchRegions arrangedObjects] count] < 1) {
		NSRunAlertPanel(@"No Region Selected", @"Please choose the region you would like to search.", nil, nil, nil);
		return NO;
	}
	
	if([[searchField stringValue] length] == 0) {
		[searchField setStringValue:@" "];
	}
	
	[self closeSearchWindow];
		
	search.regions = [[searchRegions arrangedObjects] copy];
	search.text = [searchField stringValue];
	search.category = [categoryPopUp titleOfSelectedItem];
	search.subcategory = [subcategoryPopUp titleOfSelectedItem];
	search.URLAttributes = [self URLAttributes];
    search.title = [searchNameField stringValue];
	if([search.subcategory isEqualToString:@"All"]) {
		search.subcategory = nil;
	}
	
	return YES;
}

- (void)updateOptionsView {
	BOOL wasVisible = currentOptionsViewController.view.superview != nil;
	if(wasVisible) {
		[self toggleAdvancedOptions:nil];
	}
	
	NSString *categoryName = [[categoryPopUp titleOfSelectedItem] stringByReplacingOccurrencesOfString:@" " withString:@""];
	NSString *className = [categoryName stringByAppendingString:@"OptionsViewController"];
	self.currentOptionsViewController = [NSClassFromString(className) defaultController];
    
    if(self.currentOptionsViewController == nil) {
        NSString *subcategoryName = [[subcategoryPopUp titleOfSelectedItem] stringByReplacingOccurrencesOfString:@" " withString:@""];
        className = [[NSString stringWithFormat:@"%@%@", categoryName, subcategoryName] stringByAppendingString:@"OptionsViewController"];
        self.currentOptionsViewController = [NSClassFromString(className) defaultController];
    }
    
    originalOptionsViewSize = currentOptionsViewController.view.frame.size;
	
	if(wasVisible) {
		[self toggleAdvancedOptions:nil];
	}
}

- (void)updateSubcategories {	
	[subcategoryPopUp removeAllItems];
	
	[subcategoryPopUp addItemWithTitle:@"All"];
	[subcategoryPopUp.menu addItem:[NSMenuItem separatorItem]];
	
	NSDictionary *category = [categories objectForKey:[categoryPopUp titleOfSelectedItem]];
	NSDictionary *subcategories = [category objectForKey:@"subcategories"];
	
	[subcategoryPopUp setEnabled:[subcategories count] > 0];
	[subcategoryPopUp selectItemAtIndex:0];
	[subcategoryPopUp addItemsWithTitles:[[subcategories allKeys] alphabeticallySortedArray]];
}

- (void)closeSearchWindow {
	[self removeCompletionWindow];
	
	if([disclosureButton state] == NSOnState) {
		[disclosureButton performClick:nil];
	}
	
	[(JAPopupWindow *)[self.windowController window] animateClose:nil];
}

- (IBAction)cancelSearch:(id)sender {
	[searchField setStringValue:@""];
	[regionField setStringValue:@""];
    [currentOptionsViewController clearValues];
	
	[self closeSearchWindow];
}

- (IBAction)removeRegion:(id)sender {
	[searchRegions removeObjects:[searchRegions selectedObjects]];
}

- (IBAction)categoryChanged:(id)sender {
	[self updateSubcategories];
	[self updateOptionsView];
	
	if(currentOptionsViewController == nil) {
		[disclosureButton setState:NSOffState];
	}
}

- (IBAction)subcategoryChanged:(id)sender {
    [self updateOptionsView];
	
	if(currentOptionsViewController == nil) {
		[disclosureButton setState:NSOffState];
	}
}

- (IBAction)toggleAdvancedOptions:(id)sender {
	NSView *optionsView = currentOptionsViewController.view;
	if(optionsView == nil) return;
	
	BOOL areAdding = optionsView.superview == nil;
	CGFloat yOffset = areAdding ? originalOptionsViewSize.height : -originalOptionsViewSize.height;
	NSMutableArray *animationList = [NSMutableArray array];
	
	// if we're adding the view then we need to animate the options view too
	// otherwise we just have to animate the window
	if(areAdding) {
		NSRect targetFrame = NSMakeRect(0, 0, originalOptionsViewSize.width, originalOptionsViewSize.height);
		
		[optionsView setFrameOrigin:NSMakePoint(0, -originalOptionsViewSize.height)];
		[optionsView setFrameSize:NSZeroSize];
		
		[optionsBox addSubview:optionsView];
		
		[animationList addObject:[NSDictionary dictionaryWithObjectsAndKeys:
								  optionsView, NSViewAnimationTargetKey, 
								  [NSValue valueWithRect:targetFrame], NSViewAnimationEndFrameKey, nil]];
	}
		
	NSRect windowRect = self.view.window.frame;
	NSRect newRect = NSMakeRect(windowRect.origin.x, windowRect.origin.y - (yOffset / 2), 
								windowRect.size.width, windowRect.size.height + yOffset);
	[animationList addObject:[NSDictionary dictionaryWithObjectsAndKeys:
							  self.view.window, NSViewAnimationTargetKey, 
							  [NSValue valueWithRect:newRect], NSViewAnimationEndFrameKey, nil]];
	
	NSViewAnimation *animation = [[NSViewAnimation alloc] initWithViewAnimations:animationList];
	[animation setAnimationBlockingMode:NSAnimationBlocking];
	[animation setDuration:0.25];
	[animation startAnimation];
	
	// if we're not adding then remove the options view
	if(!areAdding) {
		[optionsView removeFromSuperviewWithoutNeedingDisplay];
	}
}

- (NSString *)URLAttributes {
	NSMutableString *options = [NSMutableString string];
	
	if(currentOptionsViewController != nil) {
		[options appendString:[currentOptionsViewController URLAttributes]];
	}
	
	if([searchTitleOnlyButton state] == NSOnState) {
		[options appendString:@"&srchType=T"];
	}
	
	if([imageResultsOnlyButton state] == NSOnState) {
		[options appendString:@"&hasPic=1"];
	}
	
	return options;
}

- (void)updateGUIWithURLAttributesFromSearch:(Search *)search {
	NSString *url = search.URLAttributes;
	NSArray *pieces = [url componentsSeparatedByString:@"&"];
	for(NSString *piece in pieces) {
		if([piece isEqualToString:@"srchType=T"]) {
			[searchTitleOnlyButton setState:NSOnState];
		} else if([piece isEqualToString:@"hasPic=1"]) {
			[imageResultsOnlyButton setState:NSOnState];
		}
	}
		
	[currentOptionsViewController parseURLAttributes:url];
}

- (void)createCompletionWindow {
	NSRect tokenFrame = regionField.frame;
	NSPoint point = NSMakePoint(tokenFrame.origin.x + tokenFrame.size.width, 
								tokenFrame.origin.y + tokenFrame.size.height/2);
	point = [regionField.superview convertPoint:point toView:self.windowController.window.contentView];
	
	completionWindow = [[MAAttachedWindow alloc] initWithView:regionSelectionView.superview.superview
											  attachedToPoint:point 
													 inWindow:self.windowController.window
													   onSide:MAPositionRight 
												   atDistance:10];
    completionWindow.canBecomeKeyWindow = YES;
	completionWindow.cornerRadius = 4;
	completionWindow.backgroundColor = [NSColor colorWithDeviceWhite:1.0f alpha:0.90f];
}

- (void)removeCompletionWindow {
	if(completionWindow != nil) {
		[self.windowController.window removeChildWindow:completionWindow];
		[completionWindow orderOut:nil];
		completionWindow = nil;
	}
}

- (void)useNewRegions:(NSArray *)regions {
    for(NSString *region in regions) {
		NSDictionary *result = [[RegionsController sharedInstance].allRegions objectForKey:region];
		RegionView *view = [RegionView regionViewWithLabel:region inCategory:[result objectForKey:@"category"]];
		view.doesExpand = [result objectForKey:@"expandable"] != nil;
		[completionViews addObject:view];
	}
    
    NSSortDescriptor *categorySort = [[NSSortDescriptor alloc] initWithKey:@"category" ascending:NO];
    NSSortDescriptor *labelSort = [[NSSortDescriptor alloc] initWithKey:@"label" ascending:YES];
    [completionViews sortUsingDescriptors:[NSArray arrayWithObjects:categorySort, labelSort, nil]];
    
    if(completionViews.count > 0) {
        [completionViews insertObject:[AllRegionsView allRegionsView] atIndex:0];
    }
}


#pragma mark Search field completion delegate

- (void)controlTextDidChange:(NSNotification *)notification {
	if([regionField stringValue].length == 0) {
		[self removeCompletionWindow];
		return;
	}
	
	if(completionWindow == nil) {
		[self createCompletionWindow];
		[self.windowController.window addChildWindow:completionWindow ordered:NSWindowAbove];
	}
	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF beginswith[cd] %@", [regionField stringValue]];
	NSArray *results = [[[RegionsController sharedInstance].allRegions allKeys] filteredArrayUsingPredicate:predicate];
	completionViews = [NSMutableArray array];
	[self useNewRegions:results];
	
	[regionSelectionView reloadData];
	[regionSelectionView scrollPoint:NSMakePoint(0, regionSelectionView.frame.size.height)];
}

- (void)controlTextDidEndEditing:(NSNotification *)notification {
	[self removeCompletionWindow];
}

- (BOOL)control:(NSControl *)control textView:(NSTextView *)textView doCommandBySelector:(SEL)command {
	// reinterpret the tab to change focus when we have something entered
	if((command == @selector(insertTab:) && [regionField stringValue].length > 0) || command == @selector(moveDown:)) {
		[completionWindow makeKeyAndOrderFront:nil];
		[regionSelectionView selectNextView];
		
		return YES;
	} else if(command == @selector(moveUp:)) {
		[completionWindow makeKeyAndOrderFront:nil];
		[regionSelectionView selectPreviousView];
	
		return YES;
	}
			
	return NO;
}


#pragma mark Region selection data source

- (NSView *)viewForRegionSelectionRow:(NSUInteger)row {
	return [completionViews objectAtIndex:row];
}

- (NSUInteger)numberOfRows {
	return completionViews.count;
}


#pragma mark Region selection delegate

- (void)regionViewClicked:(RegionView *)clickedView {
	completionViews = [NSMutableArray array];
	
	NSArray *siblingRegions = [[RegionsController sharedInstance].expandableRegions objectForKey:clickedView.label];
    [self useNewRegions:siblingRegions];
        
    [regionSelectionView animateReloadData];
    [regionSelectionView scrollPoint:NSMakePoint(0, regionSelectionView.frame.size.height)];
}

- (void)regionViewAdded:(RegionView *)clickedView {    
	NSDictionary *region = [[RegionsController sharedInstance].allRegions objectForKey:clickedView.label];
    Region *newRegion = [Region regionWithURL:[region objectForKey:@"url"] name:clickedView.label];
    [self addRegion:newRegion];
        
    if([[NSUserDefaults standardUserDefaults] boolForKey:JACloseRegionsWindowAfterAdding]) {
        [self removeCompletionWindow];
        [self.view.window makeKeyAndOrderFront:nil];
    }
    
    [regionSelectionView setSelectedView:nil];
}

- (void)addRegion:(Region *)newRegion {
    if(newRegion.url == nil) {
        NSDictionary *expandableRegions = [RegionsController sharedInstance].expandableRegions;
        NSArray *siblingRegions = [expandableRegions objectForKey:newRegion.name];
        for(NSString *sibling in siblingRegions) {
            NSDictionary *result = [[RegionsController sharedInstance].allRegions objectForKey:sibling];
            [self addRegion:[Region regionWithURL:[result objectForKey:@"url"] name:sibling]];
        }
    } else {
        if(![[searchRegions arrangedObjects] containsObject:newRegion]) {
            [searchRegions insertObject:newRegion atArrangedObjectIndex:0];
        }
    }
}


#pragma mark Table view delegate

- (void)tableView:(JATableView *)tableView keyDown:(NSEvent *)event {
	unichar key = [[event charactersIgnoringModifiers] characterAtIndex:0];
	
	if(key == NSDeleteFunctionKey || key == 127) {
		[self removeRegion:nil];
	} else {
		[tableView forwardKeyDown:event];
	}
}

@synthesize previousSearch;
@synthesize regionField;
@synthesize categoryPopUp;
@synthesize subcategoryPopUp;
@synthesize searchField;
@synthesize searchButton;
@synthesize regionSelectionView;
@synthesize searchRegions;
@synthesize topBarView;
@synthesize optionsBox;
@synthesize currentOptionsViewController;
@synthesize searchTitleOnlyButton;
@synthesize imageResultsOnlyButton;
@synthesize disclosureButton;
@synthesize searchNameField;

@end
