//
//  SplashViewController.m
//  Marketplace
//
//  Created by Josh Abernathy on 8/21/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "SplashViewController.h"

#import "MainWindowController.h"


@implementation SplashViewController

- (IBAction)addSearch:(id)sender {
	[(MainWindowController *)[self representedObject] showAddSearch:nil];
}

@end
