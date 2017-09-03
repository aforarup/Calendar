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
       [date compare:_startDate] == NSOrderedAscending) {
        NSException* exception = [NSException
                                    exceptionWithName:NSRangeException
                                    reason:@"Date provided is outside the range of start and end dates"
                                    userInfo:nil];
        @throw exception;
    }
    return [date timeIntervalSinceDate:_startDate] / kSecondsInADay;
}

- (NSUInteger) indexForToday {
    @try {
        return [self indexForDate:[NSDate date]];
    } @catch(NSException *exception) {
        @throw exception;
    }
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

@end
