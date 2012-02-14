//
//  RelativeDate.h
//  Marketplace
//
//  Created by Josh Abernathy on 2/24/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


typedef enum {
    DAYS = 0,
    WEEKS = 1,
    MONTHS = 2
} RelativeDateUnits;

static const NSCalendarUnit CalendarUnitForDateUnit[] = { NSDayCalendarUnit, NSWeekCalendarUnit, NSMonthCalendarUnit };

@interface RelativeDate : NSObject <NSCopying, NSCoding> {
    RelativeDateUnits dateUnits;
	NSInteger dateDifferenceFromNow;
}

- (id)initWithDateDifference:(NSInteger)difference units:(RelativeDateUnits)units;

- (RelativeDateUnits)dateUnits;
- (NSInteger)dateDifferenceFromNow;
- (NSInteger)valueOfDateDifferenceInUnits;
- (NSDate *)dateFromDateDifference;
- (NSTimeInterval)timeIntervalSinceReferenceDate;

@end
