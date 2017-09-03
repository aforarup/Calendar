//
//  EventManager.h
//  Calendar
//
//  Created by Arup Saha on 8/18/17.
//  Copyright © 2017 arupsaha.tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EventDataModels.h"

@interface EventManager : NSObject
+ (instancetype) sharedInstance;

/*!
 Events on a day. Returns 0 is no events found for the day.
 @param dateKey key for the date
 @return Array of events on that date
 */
- (NSArray *) eventsForTheDay:(NSString *)dateKey;

/*!
 Set up event manager
 */
- (void) setUp;

/*!
 Set up event manager
 @param onComplete block to excute after set up is complete
 */
- (void) setUpWithCompletion:(void(^)(void)) onComplete;
@end
