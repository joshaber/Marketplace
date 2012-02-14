//
//  HasBeenReadRowTemplate.m
//  Marketplace
//
//  Created by Josh Abernathy on 3/26/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "HasBeenReadRowTemplate.h"

@interface HasBeenReadRowTemplate ()
- (NSPopUpButton *)popUpButton;
@end


@implementation HasBeenReadRowTemplate

- (NSArray *)templateViews {
    return [NSArray arrayWithObject:self.popUpButton];
}

- (NSPopUpButton *)popUpButton {
	if(popUpButton == nil) {
		popUpButton = [[NSPopUpButton alloc] initWithFrame:NSMakeRect(0, 0, 1, 1) pullsDown:NO];
		[popUpButton addItemWithTitle:@"has been read"];
		[popUpButton addItemWithTitle:@"has not been read"];
	}
	
	return popUpButton;
}

- (double)matchForPredicate:(id)predicate {
    if([predicate isKindOfClass:[NSComparisonPredicate class]]) {
		NSExpression *left = [predicate leftExpression];
		if([[left keyPath] isEqualToString:@"hasBeenRead"]) {
			return 2.0;
		}
    }
	
    return 0.0;
}

- (void)setPredicate:(NSPredicate *)untypedPredicate {
    NSComparisonPredicate *predicate = (NSComparisonPredicate *) untypedPredicate;
	    
    NSNumber *hasBeenRead = [[predicate rightExpression] constantValue];
    if([hasBeenRead boolValue]) {
		[self.popUpButton selectItemAtIndex:0];
	} else {
		[self.popUpButton selectItemAtIndex:1];
	}
	
    NSPredicate *superPredicate = [NSComparisonPredicate predicateWithLeftExpression:[predicate leftExpression] 
																	 rightExpression:[NSExpression expressionForConstantValue:hasBeenRead] 
																			modifier:[predicate comparisonPredicateModifier] 
																				type:[predicate predicateOperatorType] 
																			 options:[predicate options]];
    [super setPredicate:superPredicate];
}

- (NSPredicate *)predicateWithSubpredicates:(NSArray *)subpredicates {
    NSComparisonPredicate *superPredicate = (NSComparisonPredicate *) [super predicateWithSubpredicates:subpredicates];
	
	NSNumber *value = [NSNumber numberWithBool:YES];
    if([self.popUpButton indexOfSelectedItem] == 1) {
		value = [NSNumber numberWithBool:NO];
	}
	
    NSPredicate *resultPredicate = [NSComparisonPredicate predicateWithLeftExpression:[superPredicate leftExpression] 
																	  rightExpression:[NSExpression expressionForConstantValue:value] 
																			 modifier:[superPredicate comparisonPredicateModifier] 
																				 type:[superPredicate predicateOperatorType] 
																			  options:[superPredicate options]];
		
    return resultPredicate;
}

@end
