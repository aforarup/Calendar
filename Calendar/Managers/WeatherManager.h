//
//  WeatherManager.h
//  Calendar
//
//  Created by Arup Saha on 8/28/17.
//  Copyright © 2017 arupsaha.tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "WeatherDataModels.h"

@interface WeatherManager : NSObject<CLLocationManagerDelegate>
+ (instancetype) sharedInstance;
- (void) refreshWeatherData;
- (BOOL) hasWeatherData;
- (NSString *) temperature;
- (NSString *) iconString;
@end
