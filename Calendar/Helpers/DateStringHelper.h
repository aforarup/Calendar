//
//  DateStringHelper.h
//  Calendar
//
//  Created by Arup Saha on 8/31/17.
//  Copyright © 2017 arupsaha.tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DateManager.h"

@interface DateStringHelper : NSObject
+ (instancetype) helperWithDateManager:(DateManager *) dateManager;

/*!
 Abbreviated Month String for a date
 
 @param index number Of Days from the startDate of dateManager
 
 @return short month string
 */
- (NSString *) shortMonthStringForIndex: (NSUInteger) index;

/*!
 Title Display String for a date
 
 @param index number Of Days from the startDate of dateManager
 
 @return title string
 */
- (NSString *) controllerTitleStringForIndex: (NSUInteger) index;

/*!
 Day of the month for a date
 
 @param index number Of Days from the startDate of dateManager
 
 @return day of the month
 */
- (NSInteger) dayOfMonthForIndex: (NSUInteger) index;

/*!
 Display String for a date
 
 @param index number Of Days from the startDate of dateManager
 
 @return display string in for the Table Section
 
 @return section title
 */
- (NSString *) sectionTitleStringForIndex: (NSUInteger) index;

/*!
 Unique string for a date
 
 @param index number Of Days from the startDate  of dateManager
 
 @return unique key string
 */
- (NSString *) keyStringForIndex: (NSUInteger) index;
@end
