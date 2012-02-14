//
//  ParserController.h
//  CLParser
//
//  Created by Josh Abernathy on 10/25/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface ParserController : NSObject {
	IBOutlet NSTextField *url;
}

- (IBAction)parse:(id)sender;

@end
