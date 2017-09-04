//
//  ViewController.h
//  Calendar
//
//  Created by Arup Saha on 8/16/17.
//  Copyright © 2017 arupsaha.tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

/*!
 Notify for any change in date from child controllers
 @param dateIndex Index of the date
 @param requestingViewController ViewController making the request
 */
- (void) notifyCalendarForDateIndex: (NSUInteger) dateIndex fromViewController:(UIViewController *)requestingViewController;

/*!
 Contract or expand the calendar view
 @param contract send YES if calendar needs to be contracted, NO if it is being changed to default height
 */
- (void) contractCalendarView:(BOOL) contract;

/*!
 If a child viewcontroller scrolling is being scrolled
 @param focussedViewController viewController which is in focus
 @param isMoving if the focussedViewController is being scrolled
 */
- (void) viewController:(UIViewController *)focussedViewController isMoving:(BOOL) isMoving;
@end

