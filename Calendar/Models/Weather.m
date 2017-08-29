//
//  Weather.m
//
//  Created by   on 8/28/17
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "Weather.h"
#import "CurrentStatus.h"


NSString *const kWeatherTimezone = @"timezone";
NSString *const kWeatherCurrently = @"currently";
NSString *const kWeatherLatitude = @"latitude";
NSString *const kWeatherLongitude = @"longitude";
NSString *const kWeatherOffset = @"offset";


@interface Weather ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation Weather

@synthesize timezone = _timezone;
@synthesize currently = _currently;
@synthesize latitude = _latitude;
@synthesize longitude = _longitude;
@synthesize offset = _offset;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
            self.timezone = [self objectOrNilForKey:kWeatherTimezone fromDictionary:dict];
            self.currently = [CurrentStatus modelObjectWithDictionary:[dict objectForKey:kWeatherCurrently]];
            self.latitude = [[self objectOrNilForKey:kWeatherLatitude fromDictionary:dict] doubleValue];
            self.longitude = [[self objectOrNilForKey:kWeatherLongitude fromDictionary:dict] doubleValue];
            self.offset = [[self objectOrNilForKey:kWeatherOffset fromDictionary:dict] doubleValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.timezone forKey:kWeatherTimezone];
    [mutableDict setValue:[self.currently dictionaryRepresentation] forKey:kWeatherCurrently];
    [mutableDict setValue:[NSNumber numberWithDouble:self.latitude] forKey:kWeatherLatitude];
    [mutableDict setValue:[NSNumber numberWithDouble:self.longitude] forKey:kWeatherLongitude];
    [mutableDict setValue:[NSNumber numberWithDouble:self.offset] forKey:kWeatherOffset];

    return [NSDictionary dictionaryWithDictionary:mutableDict];
}

- (NSString *)description 
{
    return [NSString stringWithFormat:@"%@", [self dictionaryRepresentation]];
}

#pragma mark - Helper Method
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict
{
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}


#pragma mark - NSCoding Methods

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];

    self.timezone = [aDecoder decodeObjectForKey:kWeatherTimezone];
    self.currently = [aDecoder decodeObjectForKey:kWeatherCurrently];
    self.latitude = [aDecoder decodeDoubleForKey:kWeatherLatitude];
    self.longitude = [aDecoder decodeDoubleForKey:kWeatherLongitude];
    self.offset = [aDecoder decodeDoubleForKey:kWeatherOffset];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_timezone forKey:kWeatherTimezone];
    [aCoder encodeObject:_currently forKey:kWeatherCurrently];
    [aCoder encodeDouble:_latitude forKey:kWeatherLatitude];
    [aCoder encodeDouble:_longitude forKey:kWeatherLongitude];
    [aCoder encodeDouble:_offset forKey:kWeatherOffset];
}

- (id)copyWithZone:(NSZone *)zone
{
    Weather *copy = [[Weather alloc] init];
    
    if (copy) {

        copy.timezone = [self.timezone copyWithZone:zone];
        copy.currently = [self.currently copyWithZone:zone];
        copy.latitude = self.latitude;
        copy.longitude = self.longitude;
        copy.offset = self.offset;
    }
    
    return copy;
}


@end
