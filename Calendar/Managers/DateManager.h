//
//  DateDataSource.h
//  Calendar
//
//  Created by Arup Saha on 8/18/17.
//  Copyright © 2017 arupsaha.tech. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NSUInteger DateIndex;

@interface DateManager : NSObject
@property (nonatomic, strong, readonly) NSDate *startDate;
@property (nonatomic, strong, readonly) NSDate *endDate;

+ (instancetype) sharedInstance;

/*!
 Number of days from the startDate for today's date. If today's date is out of range, exception is thrown
 */
- (NSUInteger) indexForToday;

/*!
 Number of days from the startDate for a date. If the date is out of range, exception is thrown
 @param date The input date provided
 */
- (NSUInteger) indexForDate:(NSDate *) date;

/*!
 Total days between startDate & endDate
 */
- (NSUInteger) totalDays;


/*!
 Date from the startDate after provided number of days. If the date is out of range, nil is returned
 @param index number of days from startDate
 @return date from startDate
 */
- (NSDate *) dateForIndex:(NSUInteger) index;

@end
