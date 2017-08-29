//
//  Currently.h
//
//  Created by   on 8/28/17
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface CurrentStatus : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) double temperature;
@property (nonatomic, assign) double windSpeed;
@property (nonatomic, assign) double humidity;
@property (nonatomic, assign) double windBearing;
@property (nonatomic, assign) double cloudCover;
@property (nonatomic, assign) double time;
@property (nonatomic, assign) double dewPoint;
@property (nonatomic, assign) double uvIndex;
@property (nonatomic, strong) NSString *summary;
@property (nonatomic, assign) double precipIntensity;
@property (nonatomic, assign) double visibility;
@property (nonatomic, strong) NSString *icon;
@property (nonatomic, assign) double apparentTemperature;
@property (nonatomic, assign) double pressure;
@property (nonatomic, assign) double precipProbability;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
