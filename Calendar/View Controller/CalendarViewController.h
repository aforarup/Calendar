//
//  CalendarViewController.h
//  Calendar
//
//  Created by Arup Saha on 8/17/17.
//  Copyright © 2017 arupsaha.tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalendarViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate>


// Select the date Calendar CollectionView for an Index Date. Index date is number of days from the start date set in Date Manager
- (void) showDateIndex:(NSUInteger) date animated:(BOOL) animated;

// Inform the Calendar Colelction View when performing scrolling
- (void) layoutForAutoScrolling:(BOOL) shouldScroll;

// Compress calendar Height
- (void) compressCalendar : (BOOL) compress;
@end
