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

// Since the weather calls are made using CLLocation callbacks, we are just making a location call here
- (void) refreshWeatherData {
    if([CLLocationManager authorizationStatus] == 0)
        [self.locationManager requestWhenInUseAuthorization];
    else
        [self.locationManager requestLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    [self.locationManager stopUpdatingLocation];
    CLLocation *currentLocation = [locations lastObject];
    [self fetchWeatherForCoordinate:currentLocation.coordinate];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if(status >= kCLAuthorizationStatusAuthorizedAlways) {
        [self.locationManager requestLocation];
    }
}


- (void)fetchWeatherForCoordinate:(CLLocationCoordinate2D ) coordinate{
    if(self.fetchWeatherTask && self.fetchWeatherTask.state == NSURLSessionTaskStateRunning)
        return;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:kWeatherUpdateUrl, kDarkSkyKey, coordinate.latitude, coordinate.longitude]];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration ephemeralSessionConfiguration]];
    NSURLSessionDataTask *fetchWeatherTask = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(!error) {
        NSObject *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            if(!error) {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    if([jsonObject isKindOfClass:[NSDictionary class]]) {
                        Weather * weather = [Weather modelObjectWithDictionary:(NSDictionary *)jsonObject];
                        self.weatherData = weather;
                        [[NSNotificationCenter defaultCenter] postNotificationName:kWeatherUpdateNotification object:self];
                    }
                });
            }
        }
    }];
    self.fetchWeatherTask = fetchWeatherTask;
    [fetchWeatherTask resume];
}


// Check if there is weather data refreshed in last 10 minutes
- (BOOL) hasWeatherData {
    return (self.weatherData && self.weatherData.currently && [[NSDate date] timeIntervalSince1970] - self.weatherData.currently.time <= 10 * 60);
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
