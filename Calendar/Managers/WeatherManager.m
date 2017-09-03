//
//  WeatherManager.m
//  Calendar
//
//  Created by Arup Saha on 8/28/17.
//  Copyright © 2017 arupsaha.tech. All rights reserved.
//

#import "WeatherManager.h"
#import <CoreLocation/CoreLocation.h>
#import "Constants.h"

@interface WeatherManager()
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) Weather * weatherData;
@property (nonatomic, strong) NSURLSessionDataTask* fetchWeatherTask;
@end

@implementation WeatherManager

- (void) baseInit {
    [self initLocationManager];
}

- (void) initLocationManager {
    self.locationManager = [[CLLocationManager alloc] init];
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyThreeKilometers];
    self.locationManager.delegate = self;
    
}

- (instancetype)init {
    if(self = [super init]) {
        [self baseInit];
        
    }
    return self;
}

+ (instancetype) sharedInstance {
    static WeatherManager *weatherManager;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        weatherManager = [[self alloc] init];
    });
    return weatherManager;
}

// Since the weather calls are made using CLLocation callbacks,
//    we are just making a location refresh call here
- (void) refreshWeatherData {
    
    // If the authorization status is not known, request authorization status
    if([CLLocationManager authorizationStatus] == 0)
        [self.locationManager requestWhenInUseAuthorization];
    else
        // request location update
        [self.locationManager requestLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    [self.locationManager stopUpdatingLocation];
    CLLocation *currentLocation = [locations lastObject];
    
    // Location is found. Fetch Weather Data
    [self fetchWeatherForCoordinate:currentLocation.coordinate];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    // Not handling the error because the weather display feature is just add-on
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    // If the user has authorised, request location
    if(status >= kCLAuthorizationStatusAuthorizedAlways) {
        [self.locationManager requestLocation];
    }
    // Not handling the negative cases
}


- (void)fetchWeatherForCoordinate:(CLLocationCoordinate2D ) coordinate{
    
    // If there is already a Weather Network Fetch Request running, return
    if(self.fetchWeatherTask && self.fetchWeatherTask.state == NSURLSessionTaskStateRunning)
        return;
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:kWeatherUpdateUrl, kDarkSkyKey, coordinate.latitude, coordinate.longitude]];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration ephemeralSessionConfiguration]];
    
    NSURLSessionDataTask *fetchWeatherTask = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(!error) {
            
            // Parse JSON
            NSObject *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            if(!error) {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    if([jsonObject isKindOfClass:[NSDictionary class]]) {
                        
                        
                        Weather * weather = [Weather modelObjectWithDictionary:(NSDictionary *)jsonObject];
                        
                        //Save the weather data in Memory
                        self.weatherData = weather;
                        
                        // Alert Observers that new Weather Data is available
                        [[NSNotificationCenter defaultCenter] postNotificationName:kWeatherUpdateNotification object:self];
                    }
                });
            }
            // Not handling the error as wether display is just add on
        }
    }];
    self.fetchWeatherTask = fetchWeatherTask;
    [fetchWeatherTask resume];
}



- (BOOL) hasWeatherData {
    
    // Check if there is weather data is present. Weather data is valid if it was refershed in last 5 minutes
    return (self.weatherData && self.weatherData.currently && [[NSDate date] timeIntervalSince1970] - self.weatherData.currently.time <= 5 * 60);
}

- (NSString *) temperature {
    if([self hasWeatherData]) {
        return [NSString stringWithFormat:@"%0.1f ℉", self.weatherData.currently.temperature];
    }
    return @"";
}

- (NSString *) iconString {
    if([self hasWeatherData]) {
        return self.weatherData.currently.icon;
    }
    return @"";
}



@end
