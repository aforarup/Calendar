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

/* An array of Events objects for a input date. If there are no events in the specific it will return an empty array. The date passed should be in 'd MMMM y' format
 */
- (NSArray *) eventsForTheDay:(NSString *)date;
- (void) setUp;
- (void) setUpWithCompletion:(void(^)(void)) onComplete;
@end
