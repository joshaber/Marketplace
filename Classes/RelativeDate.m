//
//  RelativeDate.m
//  Marketplace
//
//  Created by Josh Abernathy on 2/24/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "RelativeDate.h"


@implementation RelativeDate

- (id)initWithDateDifference:(NSInteger)difference units:(RelativeDateUnits)units {
	self = [super init];
	
	dateDifferenceFromNow = difference;
	dateUnits = units;
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:MPAppVersion forKey:@"version"];
	[coder encodeInteger:dateDifferenceFromNow forKey:@"dateDifferenceFromNow"];
	[coder encodeInteger:dateUnits forKey:@"dateUnits"];
}

- (id)initWithCoder:(NSCoder *)coder {
	self = [self init];
	
	dateDifferenceFromNow = [coder decodeIntegerForKey:@"dateDifferenceFromNow"];
	dateUnits = (RelativeDateUnits) [coder decodeIntegerForKey:@"dateUnits"];
	
	return self;
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (NSDate *)dateFromDateDifference {
	NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    if(dateUnits == DAYS) {
		[dateComponents setDay:-dateDifferenceFromNow];
	} else if(dateUnits == WEEKS) {
		[dateComponents setWeek:-dateDifferenceFromNow];
	} else if(dateUnits == MONTHS) {
		[dateComponents setMonth:-dateDifferenceFromNow];
	}
    
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    return [gregorianCalendar dateByAddingComponents:dateComponents toDate:[NSDate date] options:0];
}

- (NSInteger)dateDifferenceFromNow {
    return dateDifferenceFromNow;
}

- (RelativeDateUnits)dateUnits {
    return dateUnits;
}

- (NSTimeInterval)timeIntervalSinceReferenceDate {
	return [[self dateFromDateDifference] timeIntervalSinceReferenceDate];
}

- (NSInteger)valueOfDateDifferenceInUnits {
    NSDate *fixedDate = [self dateFromDateDifference];
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *dateDifference = [gregorianCalendar components:CalendarUnitForDateUnit[dateUnits] 
															fromDate:fixedDate 
															  toDate:[NSDate date] 
															 options:0];
    
    if(dateUnits == DAYS) {
		return [dateDifference day];
	} else if (dateUnits == WEEKS) {
		return [dateDifference week];
	} else if (dateUnits == MONTHS) {
		return [dateDifference month];
	}
	
	return [dateDifference month];
}

- (BOOL)isEqual:(id)object {
    if(![object isKindOfClass:[RelativeDate class]]) return NO;
	
    RelativeDate *date = (RelativeDate *) object;
    return date->dateDifferenceFromNow == dateDifferenceFromNow && date->dateUnits == dateUnits;
}

@end
