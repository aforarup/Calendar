//
//  ViewController.h
//  Calendar
//
//  Created by Arup Saha on 8/16/17.
//  Copyright © 2017 arupsaha.tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

- (void) notifyCalendarForDateIndex: (NSUInteger) dateIndex fromViewController:(UIViewController *)requestingViewController;
- (void) contractCalendarView:(BOOL) contract;
- (void) viewController:(UIViewController *)focussedViewController isMoving:(BOOL) isMoving;
@end

