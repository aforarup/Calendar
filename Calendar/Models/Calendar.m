//
//  Calendar.m
//
//  Created by   on 8/19/17
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "Calendar.h"
#import "Event.h"
#import "DateStringHelper.h"


NSString *const kCalendarRegistered = @"registered";
NSString *const kCalendarEvents = @"events";


@interface Calendar ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation Calendar

@synthesize registered = _registered;
@synthesize events = _events;


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
        NSString *registeredDate = [self objectOrNilForKey:kCalendarRegistered fromDictionary:dict];
        if([registeredDate isEqualToString:@"today"]) {
            DateStringHelper *dateHelper = [DateStringHelper helperWithDateManager:[DateManager sharedInstance]];
            registeredDate = [dateHelper keyStringForIndex:[[DateManager sharedInstance] indexForToday]];
        }
        self.registered = registeredDate;
    NSObject *receivedEvents = [dict objectForKey:kCalendarEvents];
    NSMutableArray *parsedEvents = [NSMutableArray array];
    if ([receivedEvents isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedEvents) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedEvents addObject:[Event modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedEvents isKindOfClass:[NSDictionary class]]) {
       [parsedEvents addObject:[Event modelObjectWithDictionary:(NSDictionary *)receivedEvents]];
    }

        NSArray *array = [NSArray arrayWithArray:parsedEvents];
        NSSortDescriptor *allDaySortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"allDay" ascending:NO];
        NSSortDescriptor *timeSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"time" ascending:YES];
        self.events = [array sortedArrayUsingDescriptors:@[allDaySortDescriptor, timeSortDescriptor]];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.registered forKey:kCalendarRegistered];
    NSMutableArray *tempArrayForEvents = [NSMutableArray array];
    for (NSObject *subArrayObject in self.events) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForEvents addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForEvents addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForEvents] forKey:kCalendarEvents];

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

    self.registered = [aDecoder decodeObjectForKey:kCalendarRegistered];
    self.events = [aDecoder decodeObjectForKey:kCalendarEvents];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_registered forKey:kCalendarRegistered];
    [aCoder encodeObject:_events forKey:kCalendarEvents];
}

- (id)copyWithZone:(NSZone *)zone
{
    Calendar *copy = [[Calendar alloc] init];
    
    if (copy) {

        copy.registered = [self.registered copyWithZone:zone];
        copy.events = [self.events copyWithZone:zone];
    }
    
    return copy;
}


@end
