//
//  MainWindowController.m
//  Marketplace
//
//  Created by Josh Abernathy on 7/26/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "MainWindowController.h"
#import <Growl/Growl.h>

#import "FavoritesViewController.h"
#import "ResultsViewController.h"
#import "SplashViewController.h"
#import "SearchWindowController.h"
#import "FavoritesRowView.h"
#import "Search.h"
#import "NSObject+JAAdditions.h"
#import "JATableView.h"
#import "JAViewController.h"
#import "BasicSearchViewController.h"
#import "AppDelegate.h"
#import "PleaseRegisterPanelController.h"
#import "SearchCell.h"
#import "NSOutlineView+Additions.h"
#import "NSArray+JAAdditions.h"
#import "Region.h"
#import "JAOutlineView.h"
#import "SearchController.h"
#import "Result.h"
#import "SearchResult.h"

@interface MainWindowController ()
- (void)setupControllers;
- (void)addBuyNowButton;
- (void)deleteSelectedSearch:(id)sender;
- (void)editSelectedSearch:(id)sender;
- (void)refreshSelectedSearch:(id)sender;
- (void)searchesChanged;
- (void)searchSelectionChanged;
- (void)swapInViewController:(JAViewController *)viewController;
- (void)showNagSheet;
- (void)showNagSheetWithMessage:(NSString *)message;
- (void)useTallLayout:(id)sender;
- (void)useWideLayout:(id)sender;
- (void)setUseVerticalLayout:(BOOL)vertical;
- (void)unreadCountChanged:(NSNotification *)notification;
- (Search *)currentSearch;
@end


@implementation MainWindowController

+ (MainWindowController *)defaultController {
	return [[[MainWindowController alloc] initWithWindowNibName:@"MainWindow"] autorelease];
}

- (void)windowDidLoad {
	if(![[NSApp delegate] isLicensed]) {
		[self addBuyNowButton];
		
		NSInteger days = [[NSApp delegate] daysUntilExpiration];
		NSString *message = [NSString stringWithFormat:@"If you like it, buy it! You have %ld days left in your trial.", (long) days];
		if(days <= 0) {
			message = @"The trial period is over. Please buy Marketplace to continue using it.";
		}

		[self showNagSheetWithMessage:message];
	}
		
	[sourcesView setDoubleAction:@selector(editSelectedSearch:)];
		
	[self setupControllers];
	[self setUseVerticalLayout:[[NSUserDefaults standardUserDefaults] boolForKey:JAResultsViewVertical]];
	
	[searches addObserver:self 
			   forKeyPath:@"selection" 
				  options:NSKeyValueObservingOptionNew 
				  context:@selector(searchSelectionChanged)];
	
	[searches addObserver:self 
			   forKeyPath:@"arrangedObjects" 
				  options:NSKeyValueObservingOptionNew 
				  context:@selector(searchesChanged)];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(unreadCountChanged:) name:JAUnreadCountChangedNotification object:nil];

    [sourcesView registerForDraggedTypes:[NSArray arrayWithObject:PasteboardType]];
    
    [sourcesView expandItem:[sourcesView itemAtRow:0]];
}

- (void)unreadCountChanged:(NSNotification *)notification {
	[sourcesView reloadItem:[[notification userInfo] objectForKey:@"search"]];
}

- (void)setupControllers {
	searchWindowController = [SearchWindowController defaultControllerWithParent:self.window];
	searchWindowController.searchesController = searches;
	
	favoritesViewController = [FavoritesViewController defaultController];
	[favoritesViewController setRepresentedObject:favorites];
	
	resultsViewController = [ResultsViewController defaultController];
	[resultsViewController setRepresentedObject:searches];
	
	splashViewController = [SplashViewController defaultController];
	[splashViewController setRepresentedObject:self];
	
	currentViewController = splashViewController;
	
	[currentViewController.view setFrame:mainView.bounds];
	[currentViewController.view setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
	[mainView addSubview:currentViewController.view];
}

- (void)searchesChanged {
	[sourcesView reloadData];
}

- (void)searchSelectionChanged {
	favoritesRowView.isHighlighted = NO;
	
	if([[searches selectedObjects] count] > 0) {
		[self showResultsView];
		if([sourcesView selectedRow] != (NSInteger) [searches selectionIndex]+1) {
            [sourcesView selectRowIndexes:[NSIndexSet indexSetWithIndex:[searches selectionIndex] + 1] byExtendingSelection:NO];
		}
	} else {
		[self showSplashView];
	}
}

- (void)addBuyNowButton {
	// nifty little hack to put stuff in the title bar
	NSWindow *window = [self window];
	NSButton *titleBarButton = [window standardWindowButton:NSWindowCloseButton];
	
	NSPoint loc = titleBarButton.frame.origin;
	loc.x = window.frame.size.width - buyNowButton.frame.size.width/2;
	
	[buyNowButton.cell setBackgroundStyle:NSBackgroundStyleRaised];
	[buyNowButton setFrameOrigin:loc];
	[titleBarButton.superview addSubview:buyNowButton];
}

- (void)removeBuyNowButton {
	[buyNowButton removeFromSuperview];
}

- (void)showFavoritesView {
	[self swapInViewController:favoritesViewController];
}

- (void)showResultsView {
	[self swapInViewController:resultsViewController];
}

- (void)showSplashView {
	[self swapInViewController:splashViewController];
}

- (void)showNagSheet {
	[self showNagSheetWithMessage:nil];
}

- (void)showNagSheetWithMessage:(NSString *)message {
	PleaseRegisterPanelController *controller = [PleaseRegisterPanelController defaultController];
	NSWindow *registerWindow = controller.window;
	if(message != nil) {
		[controller.messageField setStringValue:message];
	}
		
	if(registerWindow != nil) {
		[NSApp beginSheet:registerWindow 
		   modalForWindow:self.window 
			modalDelegate:nil 
		   didEndSelector:nil 
			  contextInfo:NULL];
	} else {
		NSRunAlertPanel(@"Hey!", 
						@"Did you delete the nag window? That's not nice...", 
						@"I am ashamed of myself", nil, nil);
		[NSApp terminate:nil];
	}
}

- (IBAction)goToStore:(id)sender {
	[[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:STORE_URL]];
}

- (IBAction)addOrRemoveClicked:(id)sender {
	if([sender selectedSegment] == 0) {
		[self showAddSearch:nil];
	} else {
		[self deleteSelectedSearch:nil];
	}
}

- (IBAction)changeResultsViewOrientation:(id)sender {
	[self setUseVerticalLayout:[sender selectedSegment] != 0];
}

- (void)useTallLayout:(id)sender {
	[self setUseVerticalLayout:NO];
}

- (void)useWideLayout:(id)sender {
	[self setUseVerticalLayout:YES];
}

- (void)setUseVerticalLayout:(BOOL)vertical {
	[resultsViewController.splitView setVertical:vertical];
	[resultsViewController.splitView adjustSubviews];
	[resultsViewController.splitView setNeedsDisplay:YES];
	
	[favoritesViewController.splitView setVertical:vertical];
	[favoritesViewController.splitView adjustSubviews];
	[favoritesViewController.splitView setNeedsDisplay:YES];
	
	[resultsViewOrientationControl setSelectedSegment:vertical != NO];
	[[NSUserDefaults standardUserDefaults] setBool:vertical forKey:JAResultsViewVertical];
}

- (void)showAddSearch:(id)sender {
	[searchWindowController showNewBasicSearch];
}

- (void)editSelectedSearch:(id)sender {
	[searchWindowController showEditSearch:[self currentSearch]];
}

- (void)duplicateSelectedSearch:(id)sender {
    Search *duplicatedSearch = [[self currentSearch] copy];
    [searches addObject:duplicatedSearch];
    [sourcesView selectRowIndexes:[NSIndexSet indexSetWithIndex:[[searches arrangedObjects] count]] byExtendingSelection:NO];
    clickedItem = duplicatedSearch;
    [sourcesView reloadData];
}
	
- (void)deleteSelectedSearch:(id)sender {
	if([[searches selectedObjects] count] > 0) {
        [[searches selectedObjects] makeObjectsPerformSelector:@selector(stopSearch)];
		[searches removeObjects:[searches selectedObjects]];
        clickedItem = nil;
        [sourcesView deselectAll:nil];
        [sourcesView reloadData];
	}
}

- (void)refreshSelectedSearch:(id)sender {
	[[self currentSearch] reset];
}

- (void)markAllAsRead:(id)sender {
    Search *search = [self currentSearch];
    for(id<Result> result in search.results) {
        if([result isKindOfClass:[SearchResult class]]) {
            SearchResult *searchResult = (SearchResult *) result;
            [search markResultAsRead:searchResult];
        }
    }
    
    [resultsViewController.view setNeedsDisplay:YES];
}

- (void)highlightFavorites {
	[sourcesView deselectAll:nil];
    clickedItem = nil;
	
	favoritesRowView.isHighlighted = YES;
	
	[self showFavoritesView];
}

- (void)swapInViewController:(JAViewController *)viewController {
	// don't perform useless swapping
	if(currentViewController == viewController) return;
	
	NSView *currentView = [currentViewController view];
	NSView *newView = [viewController view];
	
	[mainView replaceSubview:currentView with:newView];
	
	self.currentViewController = viewController;
	currentView = newView;
	
	[currentView setFrame:[mainView bounds]];
	[currentView setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
}

- (void)refreshAllSearches:(id)sender {
	Search *selectedSearch = [self currentSearch];
    
	for(Search *search in [[searches arrangedObjects] copy]) {
		[search reset];
		
		if(search != selectedSearch) {
//            [[NSApp delegate] enqueueSearch:search];
            [search search];
		}
	}
}

- (Search *)currentSearch {
    NSArray *selectedSearches = [searches selectedObjects];
	if([selectedSearches count] < 1) return nil;
	
	return [selectedSearches firstObject];
}

- (Search *)lastSearch {
	return searchWindowController.basicSearchViewController.previousSearch;
}

- (void)observeValueForKeyPath:(NSString *)keyPath 
					  ofObject:(id)object 
						change:(NSDictionary *)change 
					   context:(void *)context {
	SEL selector = (SEL)context;
	if([self respondsToSelector:selector]) {
		[self performSelector:selector];
	}
}

- (BOOL)validateMenuItem:(NSMenuItem *)menuItem {
	SEL action = [menuItem action];
	if(action == @selector(editSelectedSearch:) ||
	   action == @selector(deleteSelectedSearch:) ||
	   action == @selector(refreshSelectedSearch:) ||
       action == @selector(duplicateSelectedSearch:)) {
		return [[searches selectedObjects] count] > 0;
	} else if(action == @selector(useTallLayout:)) {
		[menuItem setState:![[NSUserDefaults standardUserDefaults] boolForKey:JAResultsViewVertical]];
	} else if(action == @selector(useWideLayout:)) {
		[menuItem setState:[[NSUserDefaults standardUserDefaults] boolForKey:JAResultsViewVertical]];
	}
	
	return YES;
}


#pragma mark Window delegate

- (BOOL)windowShouldClose:(id)window {
	// don't close the window, just hide it
	// that way it re-opens when the app is clicked
	[NSApp hide:self];
	return NO;
}


#pragma mark Outline delegate & data source

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item {
	if(item == nil) {
		if(index == 0) return @"SEARCHES";
		if(index == 1) return @"POSTS";
	} else if([item isEqualToString:@"SEARCHES"]) {
		return [[searches arrangedObjects] objectAtIndex:index];
	}
	
	return nil;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item {
	return [item isKindOfClass:[NSString class]];
}

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item {
	if(item == nil) {
		return 1;
	} else if([item isEqualToString:@"SEARCHES"]) {
		return [[searches arrangedObjects] count];
	}
	
	return 0;
}

- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item {
	if([[tableColumn identifier] isEqualToString:@"Image"]) {
        if(item != clickedItem) {
            return [NSImage imageNamed:@"find"];
        } else {
            return [NSImage imageNamed:@"find_white"];
        }
	} else if([[tableColumn identifier] isEqualToString:@"Count"]) {
		return [NSNumber numberWithInteger:[item unreadCount]];
	}
	
	return item;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldSelectItem:(id)item {
    BOOL selectable = ![item isKindOfClass:[NSString class]];
    if(!selectable) return NO;

    id oldClickedItem = clickedItem;
    clickedItem = item;
    if(oldClickedItem != nil) {
        [outlineView reloadItem:oldClickedItem];
    }
    
	return YES;
}

- (NSCell *)outlineView:(NSOutlineView *)outlineView dataCellForTableColumn:(NSTableColumn *)tableColumn item:(id)item {
	if([item isKindOfClass:[NSString class]] && tableColumn == nil) {
		return [[NSTextFieldCell alloc] init];
	}
	
	return [tableColumn dataCell];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isGroupItem:(id)item {
	return [item isKindOfClass:[NSString class]];
}

- (CGFloat)outlineView:(NSOutlineView *)outlineView heightOfRowByItem:(id)item {
	if(![item isKindOfClass:[Search class]]) return 20;
	
	return 45;
}

- (void)outlineViewSelectionDidChange:(NSNotification *)notification {   
	id selectedItem = [sourcesView selectedItem];    
	if(selectedItem != nil) {
		[searches setSelectedObjects:[NSArray arrayWithObject:selectedItem]];
	} else {
		[searches setSelectedObjects:nil];
	}
    
    clickedItem = selectedItem;
    [sourcesView reloadData];
}

- (NSString *)outlineView:(NSOutlineView *)outlineView 
		   toolTipForCell:(NSCell *)cell 
					 rect:(NSRectPointer)rect 
			  tableColumn:(NSTableColumn *)tableColumn 
					 item:(id)item 
			mouseLocation:(NSPoint)mouseLocation {
	if([item isKindOfClass:[NSString class]]) return nil;
	
	NSMutableString *tooltip = [NSMutableString string];
	NSArray *regions = [item regions];
	for(Region *region in regions) {
		if([tooltip length] > 0) {
			[tooltip appendString:@"\n"];
		}
		
		[tooltip appendString:region.name];
	}
	
	return tooltip;
}

- (void)outlineView:(JAOutlineView *)outlineView rightMouseDown:(NSEvent *)event {
    NSPoint eventPoint = [outlineView convertPoint:[event locationInWindow] fromView:nil];
    NSInteger row = [outlineView rowAtPoint:eventPoint];
    [searches setSelectedObjects:[NSArray arrayWithObject:[outlineView itemAtRow:row]]];
	
	if([searches selectedObjects].count == 0) return;
	
	NSMenu *menu = [[NSMenu alloc] initWithTitle:@"Contextual"];
	
    [menu addItemWithTitle:@"Mark All As Read" 
					action:@selector(markAllAsRead:) 
			 keyEquivalent:@""];
    [menu addItem:[NSMenuItem separatorItem]];
	[menu addItemWithTitle:@"Edit" 
					action:@selector(editSelectedSearch:) 
			 keyEquivalent:@""];
    [menu addItemWithTitle:@"Duplicate" 
					action:@selector(duplicateSelectedSearch:) 
			 keyEquivalent:@""];
	[menu addItemWithTitle:@"Delete" 
					action:@selector(deleteSelectedSearch:) 
			 keyEquivalent:@""];
	[menu addItem:[NSMenuItem separatorItem]];
	[menu addItemWithTitle:@"Refresh" 
					action:@selector(refreshSelectedSearch:) 
			 keyEquivalent:@""];
	
	[NSMenu popUpContextMenu:menu 
				   withEvent:event 
					 forView:outlineView];
}

- (void)outlineView:(JAOutlineView *)outlineView mouseDown:(NSEvent *)event {
    NSPoint eventPoint = [outlineView convertPoint:[event locationInWindow] fromView:nil];
    NSInteger row = [outlineView rowAtPoint:eventPoint];
    if(row == -1) {
        clickedItem = nil;
        favoritesRowView.isHighlighted = NO;
        [sourcesView deselectAll:nil];
        [self showSplashView];
    }
    
    [outlineView forwardMouseDown:event];
}

- (BOOL)outlineView:(JAOutlineView *)outlineView shouldDrawDisclosureArrowForRow:(NSInteger)row {
    return NO;
}

- (id)outlineView:(NSOutlineView *)outlineView persistentObjectForItem:(id)item {
	return [NSKeyedArchiver archivedDataWithRootObject:item];
}

- (id)outlineView:(NSOutlineView *)outlineView itemForPersistentObject:(id)object {
	return [NSKeyedUnarchiver unarchiveObjectWithData:object];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView writeItems:(NSArray *)items toPasteboard:(NSPasteboard *)pasteboard {
    NSInteger row = [outlineView rowForItem:[items firstObject]] - 1;
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:[NSIndexSet indexSetWithIndex:row]];
    [pasteboard declareTypes:[NSArray arrayWithObject:PasteboardType] owner:self];
    [pasteboard setData:data forType:PasteboardType];
    
    if([items firstObject] == clickedItem) {
        resultsViewController.isDraggingSelectedItem = YES;
    }
    
    return YES;
}

- (NSDragOperation)outlineView:(NSOutlineView *)outlineView 
                  validateDrop:(id<NSDraggingInfo>)info 
                  proposedItem:(id)item 
            proposedChildIndex:(NSInteger)index {
    if(index < 0) return NSDragOperationNone;
        
    return NSDragOperationAll;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView acceptDrop:(id<NSDraggingInfo>)info item:(id)item childIndex:(NSInteger)index {
    NSPasteboard *pasteboard = [info draggingPasteboard];
    NSData *rowData = [pasteboard dataForType:PasteboardType];
    NSIndexSet *indexSet = [NSKeyedUnarchiver unarchiveObjectWithData:rowData];
    
    id oldItem = [[searches arrangedObjects] objectAtIndex:[indexSet firstIndex]];
    [searches removeObjectAtArrangedObjectIndex:[indexSet firstIndex]];
    
    if(index > (NSInteger) [indexSet firstIndex]) {
        index--;
    }
    
    [searches insertObject:oldItem atArrangedObjectIndex:index];
    
    resultsViewController.isDraggingSelectedItem = NO;
    
    clickedItem = oldItem;
    [outlineView reloadData];
    
    return YES;
}

@synthesize currentViewController;
@synthesize searches;
@synthesize favorites;
@synthesize favoritesRowView;
@synthesize mainView;
@synthesize buyNowButton;
@synthesize resultsViewOrientationControl;
@synthesize sourcesView;

@end
