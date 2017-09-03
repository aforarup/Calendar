//
//  EventTableViewCell.h
//  Calendar
//
//  Created by Arup Saha on 8/19/17.
//  Copyright © 2017 arupsaha.tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventDataModels.h"

@interface EventTableViewCell : UITableViewCell

/*!
 Calculates the height of the cell for a specific event
 @param event Event for which the height is required
 @return height for the cell
 */
+ (CGFloat) heightForEvent:(Event *) event;

/*!
 Fill the values of the event in the cell
 @param event Event for which the cell is rendered
 */
- (void) fillCellWithDataOfEvent:(Event *) event;

@end
