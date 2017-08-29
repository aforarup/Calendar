//
//  DateDataSource.h
//  Calendar
//
//  Created by Arup Saha on 8/18/17.
//  Copyright © 2017 arupsaha.tech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateManager : NSObject
@property (nonatomic, strong, readonly) NSDate *startDate;
@property (nonatomic, strong, readonly) NSDate *endDate;

+ (instancetype) sharedInstance;
- (NSUInteger) indexForToday;
- (NSUInteger) indexForDate:(NSDate *) date;
- (NSUInteger) totalDays;
- (NSString *) shortMonthForIndex: (NSUInteger) index;
- (NSString *) longMonthForIndex: (NSUInteger) index;
- (NSString *) monthDisplayForIndex: (NSUInteger) index;
- (NSInteger) dayOfMonthForIndex: (NSUInteger) index;
- (NSString *) displayDateForIndex: (NSUInteger) index;
- (NSString *) keyDateForIndex: (NSUInteger) index;
@end
