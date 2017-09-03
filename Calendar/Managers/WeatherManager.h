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

/*!
 Refresh Weather Data
 */
- (void) refreshWeatherData;

/*!
 Check if valid weather data is present
 */
- (BOOL) hasWeatherData;

/*!
 Weather Temperature
 @return Display Temperature (in Farenheit)
 */
- (NSString *) temperature;

/*!
 Weather Icon
 @return Icon String (Status) of the present weather
 */
- (NSString *) iconString;
@end
