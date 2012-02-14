//
//  RegionSelectionView.h
//  Layers
//
//  Created by Josh Abernathy on 12/16/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "JAView.h"

@class RegionView;

@protocol RegionSelectionDataSource <NSObject>
- (NSUInteger)numberOfRows;
- (NSView *)viewForRegionSelectionRow:(NSUInteger)row;
@end

@protocol RegionSelectionDelegate <NSObject>
- (void)regionViewClicked:(RegionView *)view;
- (void)regionViewAdded:(RegionView *)view;
@end


@interface RegionSelectionView : JAView {
	id<RegionSelectionDataSource> dataSource;
	id<RegionSelectionDelegate> delegate;
	RegionView *selectedView;
	
	NSSize originalSize;
}

- (void)reloadData;
- (void)animateReloadData;

- (void)viewClicked:(RegionView *)view;
- (void)selectNextView;
- (void)selectPreviousView;

@property (assign, nonatomic) id<RegionSelectionDataSource> dataSource;
@property (assign, nonatomic) id<RegionSelectionDelegate> delegate;
@property (assign, nonatomic) RegionView *selectedView;

@end
