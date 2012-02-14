//
//  FavoritesView.h
//  Marketplace
//
//  Created by Josh Abernathy on 7/26/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class MainWindowController;


@interface FavoritesRowView : NSView {
	MainWindowController *mainWindowController;
    NSImageView *imageView;
	
	BOOL isHighlighted;
}

@property (assign) BOOL isHighlighted;
@property (assign) IBOutlet NSImageView *imageView;
@property (assign) IBOutlet MainWindowController *mainWindowController;

@end
