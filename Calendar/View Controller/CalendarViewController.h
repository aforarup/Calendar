//
//  CalendarViewController.h
//  Calendar
//
//  Created by Arup Saha on 8/17/17.
//  Copyright © 2017 arupsaha.tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalendarViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate>


/*! Select the date Calendar CollectionView for an Index Date. Index date is number of days from the start date set in Date Manager
 @param dateIndex index of the date
 @param animated should scroll with animation
 */
- (void) showDateIndex:(NSUInteger) dateIndex animated:(BOOL) animated;

/*! Inform the Calendar Colelction View when performing scrolling
 @param shouldScroll whether scrolling is being started or finished
 */
- (void) layoutForAutoScrolling:(BOOL) shouldScroll;

/*!
 Compress calendar view
 @param compress compress calendar view or change it to default
 */
- (void) compressCalendar : (BOOL) compress;
@end
