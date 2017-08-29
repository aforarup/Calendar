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

+ (CGFloat) heightForEvent:(Event *) event;
- (void) fillCellWithDataOfEvent:(Event *) event;

@end
