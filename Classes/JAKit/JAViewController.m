//
//  JAViewController.m
//  Marketplace
//
//  Created by Josh Abernathy on 7/30/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "JAViewController.h"


@interface JAViewController ()
- (NSString *)nibNameFromClass;
@end


@implementation JAViewController

+ (id)defaultController {
	return [[[[self class] alloc] init] autorelease];
}

- (id)init {
	self = [super initWithNibName:[self nibNameFromClass] bundle:nil];
	
	return self;
}

- (NSString *)nibNameFromClass {
	NSString *className = NSStringFromClass([self class]);
	return [[className componentsSeparatedByString:@"Controller"] objectAtIndex:0];
}

- (void)loadView {
	[self viewWillLoad];
	[super loadView];
	[self viewDidLoad];
}

- (void)viewWillLoad {}
- (void)viewDidLoad {}

@synthesize windowController;

@end
