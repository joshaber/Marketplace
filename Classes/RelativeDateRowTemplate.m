//
//  RelativeDateRowTemplate.m
//  Marketplace
//
//  Created by Josh Abernathy on 2/24/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "RelativeDateRowTemplate.h"

#import "RelativeDate.h"


@interface RelativeDateRowTemplate ()
- (NSPopUpButton *)unitsPopUp;
@end


@implementation RelativeDateRowTemplate

- (NSArray *)templateViews {
    return [[super templateViews] arrayByAddingObject:self.unitsPopUp];
}

- (NSPopUpButton *)unitsPopUp {
	if(unitsPopUp == nil) {
		unitsPopUp = [[NSPopUpButton alloc] initWithFrame:NSMakeRect(0, 0, 1, 1) pullsDown:NO];
		[unitsPopUp addItemWithTitle:@"days"];
		[unitsPopUp addItemWithTitle:@"weeks"];
		[unitsPopUp addItemWithTitle:@"months"];
	}
	
	return unitsPopUp;
}

- (double)matchForPredicate:(id)predicate {
    if([predicate isKindOfClass:[NSComparisonPredicate class]]) {
		NSExpression *right = [predicate rightExpression];
		if([right expressionType] == NSConstantValueExpressionType) {
			id constantValue = [right constantValue];
			if([constantValue isKindOfClass:[RelativeDate class]]) {
				return 2.0;
			}
		}
    }

    return 0.0;
}

- (void)setPredicate:(NSPredicate *)untypedPredicate {
    NSComparisonPredicate *predicate = (NSComparisonPredicate *) untypedPredicate;
    
    RelativeDate *relativeDate = [[predicate rightExpression] constantValue];
    [self.unitsPopUp selectItemAtIndex:relativeDate.dateUnits];
	
    NSNumber *textFieldValue = [NSNumber numberWithInteger:[relativeDate valueOfDateDifferenceInUnits]];
    NSPredicate *superPredicate = [NSComparisonPredicate predicateWithLeftExpression:[predicate leftExpression] 
																	 rightExpression:[NSExpression expressionForConstantValue:textFieldValue] 
																			modifier:[predicate comparisonPredicateModifier] 
																				type:[predicate predicateOperatorType] 
																			 options:[predicate options]];
    [super setPredicate:superPredicate];
}

- (NSPredicate *)predicateWithSubpredicates:(NSArray *)subpredicates {
    NSComparisonPredicate *superPredicate = (NSComparisonPredicate *) [super predicateWithSubpredicates:subpredicates];
    NSInteger timeDifference = [[[superPredicate rightExpression] constantValue] integerValue];
	
    RelativeDateUnits dateUnits = (RelativeDateUnits) [self.unitsPopUp indexOfSelectedItem];
    RelativeDate *relativeDate = [[RelativeDate alloc] initWithDateDifference:timeDifference units:dateUnits];
    NSPredicate *resultPredicate = [NSComparisonPredicate predicateWithLeftExpression:[superPredicate leftExpression] 
																	  rightExpression:[NSExpression expressionForConstantValue:relativeDate] 
																			 modifier:[superPredicate comparisonPredicateModifier] 
																				 type:[superPredicate predicateOperatorType] 
																			  options:[superPredicate options]];
		
    return resultPredicate;
}

@end
