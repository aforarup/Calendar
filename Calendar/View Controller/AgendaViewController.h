//
//  AgendaViewController.h
//  Calendar
//
//  Created by Arup Saha on 8/17/17.
//  Copyright © 2017 arupsaha.tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AgendaViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

/*! Scroll the Agenda Table to specific index date at top. Index date is number of days from the start date set in Date Manager
 @param dateIndex Index of the date from Date Manager
 @param animated If the scroll should take place with animation
 */
- (void) showDateIndex:(NSUInteger) dateIndex animated:(BOOL) animated;
@end
