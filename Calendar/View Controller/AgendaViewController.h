//
//  AgendaViewController.h
//  Calendar
//
//  Created by Arup Saha on 8/17/17.
//  Copyright © 2017 arupsaha.tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AgendaViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

// Scroll the Agenda Table to specific index date at top. Index date is number of days from the start date set in Date Manager
- (void) showDateIndex:(NSUInteger) date animated:(BOOL) animated;
@end
