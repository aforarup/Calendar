//
//  DateStringHelper.m
//  Calendar
//
//  Created by Arup Saha on 8/31/17.
//  Copyright © 2017 arupsaha.tech. All rights reserved.
//

#import "DateStringHelper.h"
@interface DateStringHelper()
@property (nonatomic, strong) DateManager *dm;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@end

@implementation DateStringHelper

- (void) initFormatter {
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
}

+ (instancetype)helperWithDateManager:(DateManager *)dateManager {
    DateStringHelper *helper = [[self alloc] init];
    helper.dm = dateManager;
    [helper initFormatter];
    return helper;
}

- (NSString *) shortMonthStringForIndex: (NSUInteger) index {
    NSDate *date = [self.dm dateForIndex:index];
    if(date) {
        [self.dateFormatter setDateFormat:@"MMM"];
        return [self.dateFormatter stringFromDate:date];
    }
    return nil;
}

- (NSString *) controllerTitleStringForIndex: (NSUInteger) index {
    NSDate *date = [self.dm dateForIndex:index];
    if(date) {
        [self.dateFormatter setDateFormat:@"MMM y"];
        return [self.dateFormatter stringFromDate:date];
    }
    return nil;
}

- (NSInteger) dayOfMonthForIndex: (NSUInteger) index {
    NSDate *date = [self.dm dateForIndex:index];
    if(date) {
        [self.dateFormatter setDateFormat:@"d"];
        return [[self.dateFormatter stringFromDate:date] integerValue];
    }
    return 0;
}

- (NSString *) sectionTitleStringForIndex: (NSUInteger) index {
    NSDate *date = [self.dm dateForIndex:index];
    if(date) {
        [self.dateFormatter setDateFormat:@"EEEE, d MMMM y"];
        
        // If the date is between Yesterday and Tomorrow, we mention it
        NSString *recentDayMarker = @"";
        @try {
            NSUInteger indexForToday = [self.dm indexForToday];
            if(index == indexForToday - 1)
                recentDayMarker  =@"Yesterday";
            else if (index == indexForToday)
                recentDayMarker = @"Today";
            else if (index == indexForToday + 1)
                recentDayMarker = @"Tomorrow";
            
            return [NSString stringWithFormat:@"%@%@", recentDayMarker.length ? [recentDayMarker stringByAppendingString:@" • "] : @"",[self.dateFormatter stringFromDate:date]];
        }
        @catch(NSException *exception) {
            return nil;
        }
    }
    return nil;
}

- (NSString *) keyStringForIndex: (NSUInteger) index {
    @try {
    NSDate *date = [self.dm dateForIndex:index];
    if(date) {
        [self.dateFormatter setDateFormat:@"d MMMM y"];
        return [self.dateFormatter stringFromDate:date];
    }
    return nil;
    }
    @catch (NSException *exception) {
        @throw exception;
    }
}
@end
