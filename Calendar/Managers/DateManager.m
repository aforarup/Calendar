//
//  DateDataSource.m
//  Calendar
//
//  Created by Arup Saha on 8/18/17.
//  Copyright © 2017 arupsaha.tech. All rights reserved.
//

#import "DateManager.h"

#define kSecondsInADay (24*60*60)

@interface DateManager()
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;
@end


@implementation DateManager

+ (instancetype) sharedInstance {
    static DateManager *dateManager = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateStyle = NSDateFormatterMediumStyle;
        formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
        dateManager = [[DateManager alloc] init];
        
        // Create Start date
        dateManager.startDate = [formatter dateFromString:@"Jan 1, 2006"];
        
        // Create End date
        dateManager.endDate = [formatter dateFromString:@"Dec 31, 2026"];
    });
    return dateManager;
}

- (void)setStartDate:(NSDate *)startDate {
    NSDate *tempDate = startDate;
    
    
    // Check if the startDate does not fall on a Sunday
    NSInteger dayOfWeek = [[NSCalendar currentCalendar] component:NSCalendarUnitWeekday fromDate:startDate];
    
    if(dayOfWeek != 1) {
        
        // If it is not a Sunday, then find the nearest previous date which falls on Sunday
        NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
        [offsetComponents setDay:-(dayOfWeek - 1)];
        tempDate = [[NSCalendar currentCalendar] dateByAddingComponents:offsetComponents toDate: startDate options:0];
        
    }
    _startDate = tempDate;
}



- (NSUInteger)indexForDate:(NSDate *)date {
    if([date compare:_endDate] ==  NSOrderedDescending ||
       [date compare:_startDate] == NSOrderedAscending)
        return -1;
    return [date timeIntervalSinceDate:_startDate] / kSecondsInADay;
}

- (NSUInteger)indexForToday {
    return [self indexForDate:[NSDate date]];
}

- (NSUInteger)totalDays {
    return [_endDate timeIntervalSinceDate:_startDate] / kSecondsInADay;
}

- (NSDate *) dateForIndex: (NSUInteger) index{
    NSDate *date = [_startDate dateByAddingTimeInterval:index * kSecondsInADay];
    if([date compare:_endDate] ==  NSOrderedDescending)
        return nil;
    return date;
}

- (NSString *) shortMonthForIndex: (NSUInteger) index {
    NSDate *date;
    if((date = [self dateForIndex:index])) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
        [dateFormatter setDateFormat:@"MMM"];
        return [dateFormatter stringFromDate:date];
    }
    return nil;
}

- (NSString *) longMonthForIndex: (NSUInteger) index {
    NSDate *date;
    if((date = [self dateForIndex:index])) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
        [dateFormatter setDateFormat:@"MMMM"];
        return [dateFormatter stringFromDate:date];
    }
    return nil;
}

- (NSString *) monthDisplayForIndex: (NSUInteger) index {
    NSDate *date;
    if((date = [self dateForIndex:index])) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
        [dateFormatter setDateFormat:@"MMM y"];
        return [dateFormatter stringFromDate:date];
    }
    return nil;
}

- (NSInteger) dayOfMonthForIndex: (NSUInteger) index {
    NSDate *date;
    if((date = [self dateForIndex:index])) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
        [dateFormatter setDateFormat:@"d"];
        NSString *dayString = [dateFormatter stringFromDate:date];
        return [dayString integerValue];
    }
    return 0;
}

- (NSString *) displayDateForIndex: (NSUInteger) index {
    NSDate *date;
    if((date = [self dateForIndex:index])) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
        [dateFormatter setDateFormat:@"EEEE, d MMMM y"];
        NSString *recentDayMarker = @"";
        NSUInteger indexForToday = [self indexForToday];
        if(index == indexForToday - 1)
            recentDayMarker  =@"Yesterday";
        else if (index == indexForToday)
            recentDayMarker = @"Today";
        else if (index == indexForToday + 1)
            recentDayMarker = @"Tomorrow";
        return [NSString stringWithFormat:@"%@%@", recentDayMarker.length ? [recentDayMarker stringByAppendingString:@" • "] : @"",[dateFormatter stringFromDate:date]];
    }
    return nil;
}

- (NSString *) keyDateForIndex: (NSUInteger) index {
    NSDate *date;
    if((date = [self dateForIndex:index])) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
        [dateFormatter setDateFormat:@"d MMMM y"];
        return [dateFormatter stringFromDate:date];
    }
    return nil;
}

@end
