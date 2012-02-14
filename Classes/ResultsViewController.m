//
//  ResultsViewController.m
//  Marketplace
//
//  Created by Josh Abernathy on 7/19/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "ResultsViewController.h"
#import "JAViewCell.h"
#import "JACellView.h"
#import "JAGradientView.h"
#import "JATableView.h"
#import "SearchResult.h"
#import "DividerResult.h"
#import "Search.h"
#import "AppDelegate.h"

#import "NSWorkspace+JAAdditions.h"
#import "NSObject+JAAdditions.h"
#import "NSArray+JAAdditions.h"
#import "NSString+Additions.h"

@interface ResultsViewController ()
- (void)cleanCellViews;
- (void)updatePredicate;
- (void)resultsChanged;
- (void)selectedSearchChanged;
- (void)loadPredicate;
- (Search *)representedSearch;
- (void)emailSelectedPage;
@end


@implementation ResultsViewController

- (void)viewDidLoad {
	filterViewSize = [filterView frame].size;
	
	bottomBarView.gradient = [[NSGradient alloc] initWithStartingColor:[NSColor colorWithCalibratedRed:(209.0f/255.0f) 
																								 green:(209.0f/255.0f) 
																								  blue:(209.0f/255.0f) 
																								 alpha:1.0f] 
														   endingColor:[NSColor colorWithCalibratedRed:(233.0f/255.0f) 
																								 green:(233.0f/255.0f) 
																								  blue:(233.0f/255.0f) 
																								 alpha:1.0f]];
	
	topBarView.gradient = [[NSGradient alloc] initWithStartingColor:[NSColor colorWithCalibratedRed:(208.0f/255.0f) 
																							  green:(208.0f/255.0f) 
																							   blue:(208.0f/255.0f) 
																							  alpha:1.0f] 
														endingColor:[NSColor colorWithCalibratedRed:(233.0f/255.0f) 
																							  green:(233.0f/255.0f) 
																							   blue:(233.0f/255.0f) 
																							  alpha:1.0f]];
	
	[resultsTable setDoubleAction:@selector(goToSelectedPage)];
    [resultsTable setIntercellSpacing:NSMakeSize(0, 0)];
	[[[resultsTable tableColumns] firstObject] setDataCell:[[JAViewCell alloc] init]];
	
	[results addObserver:self 
			  forKeyPath:@"arrangedObjects" 
				 options:NSKeyValueObservingOptionNew 
				 context:@selector(resultsChanged)];
	
	[results setSortDescriptors:[NSArray arrayWithObjects:[[NSSortDescriptor alloc] initWithKey:@"region" ascending:YES], [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO], [[NSSortDescriptor alloc] initWithKey:@"dateFound" ascending:YES], nil]];
		
	[webView setPolicyDelegate:self];
    [webView setMaintainsBackForwardList:NO];
    
    // override Craigslist's fugly css
    NSString *styleFilePath = [[NSApp delegate] pathForDataFile:@"style.css"];
    if(![[NSFileManager defaultManager] fileExistsAtPath:styleFilePath]) {
        NSError *error = nil;
        BOOL success = [[NSFileManager defaultManager] copyItemAtPath:[[NSBundle mainBundle] pathForResource:@"style" ofType:@"css"] toPath:styleFilePath error:&error];
        if(!success) {
            NSLog(@"Failed copying style css: %@", error);
        }
    }
    
    [webView setPreferencesIdentifier:[[NSBundle mainBundle] bundleIdentifier]];
    WebPreferences *prefs = [webView preferences];
    [prefs setAutosaves:YES];
    [prefs setUserStyleSheetEnabled:YES];
    [prefs setUserStyleSheetLocation:[NSURL fileURLWithPath:styleFilePath]];
    [prefs setCacheModel:WebCacheModelPrimaryWebBrowser];
    [prefs setUsesPageCache:NO];
	
	[[self representedObject] addObserver:self 
							   forKeyPath:@"selection" 
								  options:NSKeyValueObservingOptionNew
								  context:@selector(selectedSearchChanged)];
	
	[splitView setVertical:[[NSUserDefaults standardUserDefaults] boolForKey:JAResultsViewVertical]];
	[filterView setFrameSize:NSMakeSize(self.view.frame.size.width, 0)];
	
	[self performSelector:@selector(selectedSearchChanged) withObject:nil afterDelay:0.1];
		
	[NSTimer scheduledTimerWithTimeInterval:0.5 
									 target:self 
								   selector:@selector(updatePredicate) 
								   userInfo:nil 
									repeats:YES];
    self.isDraggingSelectedItem = NO;
}

- (void)resultsChanged {
	[self postValueChangedForKey:@"searchableResults"];
	[self postValueChangedForKey:@"displayableResults"];
	[self cleanCellViews];
}

- (void)selectedSearchChanged {
    if(self.isDraggingSelectedItem) return;
    
	if(filterView.superview != nil && ![self representedSearch].isFiltered) {
		[filterButton setState:NSOffState];
		[self showFilter:nil];
	} else if(filterView.superview == nil && [self representedSearch].isFiltered) {
		[filterButton setState:NSOnState];
		[self showFilter:nil];
	}
	
	[self loadPredicate];
	[[webView mainFrame] loadHTMLString:@"" baseURL:nil];
}

- (IBAction)showFilter:(NSButton *)sender {
	NSRect splitViewRect = splitView.superview.frame;
	
	if([filterView superview] == nil) {		
		[filterView setFrameOrigin:NSMakePoint(0, 0)];
		[filterView setFrameSize:NSMakeSize(topBarView.frame.size.width, 0)];
		
		[[splitView.superview animator] setFrameSize:NSMakeSize(splitViewRect.size.width, splitViewRect.size.height - filterViewSize.height)];
		
		[[topBarView animator] addSubview:filterView];
		[[topBarView animator] setFrame:NSMakeRect(topBarView.frame.origin.x, topBarView.frame.origin.y - filterViewSize.height, 
												   topBarView.frame.size.width, topBarView.frame.size.height + filterViewSize.height)];
		
		if(sender != nil) [self representedSearch].isFiltered = YES;
	} else {
		CGFloat height = filterView.frame.size.height;
				
		[[splitView.superview animator] setFrameSize:NSMakeSize(splitViewRect.size.width, splitViewRect.size.height + height)];
		
		[filterView removeFromSuperviewWithoutNeedingDisplay];
		
		[[topBarView animator] setFrame:NSMakeRect(topBarView.frame.origin.x, topBarView.frame.origin.y + height, 
												   topBarView.frame.size.width, topBarView.frame.size.height - height)];
		if(sender != nil) [self representedSearch].isFiltered = NO;
	}
	
	[self.view setNeedsDisplay:YES];
}

- (void)goToSelectedPage {
	NSArray *selected = [results selectedObjects];
	NSMutableArray *urls = [NSMutableArray array];
	for(SearchResult *item in selected) {
		[urls addObject:[NSURL URLWithString:item.url]];
	}
	
	if([[NSUserDefaults standardUserDefaults] boolForKey:JAOpenLinksInBackground]) {
		[[NSWorkspace sharedWorkspace] openURLsInBackground:urls];
	} else {
		[[NSWorkspace sharedWorkspace] openURLs:urls];
	}
}

- (void)emailSelectedPage {
	NSArray *selected = [results selectedObjects];
	if(selected.count < 1) return;
	
	SearchResult *result = [selected firstObject];
	NSMutableString *subject = [NSMutableString string];
	NSMutableString *body = [NSMutableString string];
	[subject appendFormat:@"Craig's List: %@", result.title];
	[body appendFormat:@"Hi!\n\nYou are receiving this email because %@ wanted to let you know about a posting on Craig's List:\n\n", NSFullUserName()];
	[body appendFormat:@"%@ (%@): %@\n\nEnjoy!\n\n--------\n\n", result.title, result.region, result.url];
	[body appendFormat:@"Email created by Marketplace (http://www.marketplacemac.com/). Craig's List, without the Ugly.\n\n"];
	    
	subject = [[subject stringByEscapingForURLArgument] mutableCopy];
	body = [[body stringByEscapingForURLArgument] mutableCopy];
	
	NSString *urlString = [NSString stringWithFormat:@"mailto:?subject=%@&body=%@", subject, body];
	[[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:urlString]];
}

- (void)cleanCellViews {
	NSArray *subviews = [[resultsTable subviews] copy];
	for(NSView *view in subviews) {
		if([view isKindOfClass:[JACellView class]]) {
			[view removeFromSuperviewWithoutNeedingDisplay];
		}
	}
}

- (void)updatePredicate {
	NSPredicate *predicate = [predicateEditor objectValue];
		
	if([filterView superview] != nil && predicate != nil) {
		[self representedSearch].filter = predicate;
		
		NSPredicate *isSearchable = [NSComparisonPredicate 
									 predicateWithLeftExpression:[NSExpression expressionForKeyPath:@"isSearchable"]
									 rightExpression:[NSExpression expressionForConstantValue:[NSNumber numberWithBool:YES]]
									 modifier:NSDirectPredicateModifier
									 type:NSEqualToPredicateOperatorType
									 options:0];
		NSPredicate *firstHalf = [NSCompoundPredicate andPredicateWithSubpredicates:
								  [NSArray arrayWithObjects:isSearchable, predicate, nil]];
		NSPredicate *notSearchable = [NSComparisonPredicate 
									  predicateWithLeftExpression:[NSExpression expressionForKeyPath:@"isSearchable"]
									  rightExpression:[NSExpression expressionForConstantValue:[NSNumber numberWithBool:NO]]
									  modifier:NSDirectPredicateModifier
									  type:NSEqualToPredicateOperatorType
									  options:0];
		NSPredicate *fullPredicate = [NSCompoundPredicate orPredicateWithSubpredicates:
									  [NSArray arrayWithObjects:firstHalf, notSearchable, nil]];
							
		[results setFilterPredicate:fullPredicate];
	} else {
		[results setFilterPredicate:nil];
	}
	
	[self cleanCellViews];
}

- (void)loadPredicate {
	NSPredicate *savedPredicate = [self representedSearch].filter;
	[predicateEditor setObjectValue:savedPredicate];
	
	if(savedPredicate == nil) {
		[predicateEditor addRow:nil];
	}
}

- (NSArray *)displayableResults {
	return [results arrangedObjects];
}

- (NSArray *)searchableResults {
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isSearchable == YES"];
	return [[results arrangedObjects] filteredArrayUsingPredicate:predicate];
}

- (NSArray *)totalResults {
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isSearchable == YES"];
	return [[self.representedSearch results] filteredArrayUsingPredicate:predicate];
}

- (Search *)representedSearch {
	if([[self.representedObject selectedObjects] count] > 0) {
		return [[self.representedObject selectedObjects] firstObject];
	}
	
	return nil;
}

- (void)observeValueForKeyPath:(NSString *)keyPath 
					  ofObject:(id)object 
						change:(NSDictionary *)change 
					   context:(void *)context {
	SEL selector = (SEL)context;
	if([self respondsToSelector:selector]) {
		[self performSelector:selector];
	} else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}


#pragma mark Table methods

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
    if([[[results arrangedObjects] objectAtIndex:row] isKindOfClass:[DividerResult class]]) {
        return 40.0f;
    }
    
    return 55.0f;
}

- (void)tableView:(JATableView *)tableView keyDown:(NSEvent *)event {
	unichar key = [[event charactersIgnoringModifiers] characterAtIndex:0];
	
	if(key == NSRightArrowFunctionKey) {
		[self goToSelectedPage];
	} else if(key == ' ') {
        if([event modifierFlags] & NSShiftKeyMask) {
            [webView scrollPageUp:nil];
        } else {
            [webView scrollPageDown:nil];
        }
	} else {
		[tableView forwardKeyDown:event];
	}
}

- (void)tableView:(JATableView *)tableView mouseDown:(NSEvent *)event {
	if([event clickCount] > 1) {
		[self goToSelectedPage];
	} else {
		[tableView forwardMouseDown:event];
	}
}

- (BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)rowIndex {
	if([[[results arrangedObjects] objectAtIndex:rowIndex] isKindOfClass:[SearchResult class]]) {
		return YES;
	}
	
	return NO;
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification {
	NSArray *selectedObjects = [results selectedObjects];

	if([selectedObjects count] > 0) {
		SearchResult *selected = [selectedObjects firstObject];
		[webView setMainFrameURL:selected.url];
		[[self representedSearch] markResultAsRead:selected];
	} else {
		[[webView mainFrame] loadHTMLString:@"" baseURL:nil];
	}
}


#pragma mark Web policy delegate

// open links in the actual browser
- (void)webView:(WebView *)sender 
decidePolicyForNavigationAction:(NSDictionary *)actionInformation 
		request:(NSURLRequest *)request 
		  frame:(WebFrame *)frame 
decisionListener:(id <WebPolicyDecisionListener>)listener {	
	if ([[actionInformation objectForKey:WebActionNavigationTypeKey] integerValue] != WebNavigationTypeOther) {
		[listener ignore];
		[[NSWorkspace sharedWorkspace] openURL:[request URL]];
	} else {
		[listener use];
	}
}

@synthesize isDraggingSelectedItem;

@synthesize resultsTable;
@synthesize results;
@synthesize webView;

@synthesize bottomBarView;
@synthesize topBarView;

@synthesize splitView;
@synthesize filterView;

@synthesize filterButton;

@synthesize predicateEditor;

@end
