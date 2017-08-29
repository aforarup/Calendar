//
//  Events.m
//
//  Created by   on 8/19/17
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "Event.h"
#import "Participant.h"


NSString *const kEventsAgenda = @"agenda";
NSString *const kEventsAddress = @"address";
NSString *const kEventsTime = @"time";
NSString *const kEventsAllDay = @"all_day";
NSString *const kEventsDuration = @"duration";
NSString *const kEventsParticipants = @"participants";
NSString *const kEventsConfirmed = @"confirmed";


@interface Event ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation Event

@synthesize agenda = _agenda;
@synthesize address = _address;
@synthesize time = _time;
@synthesize allDay = _allDay;
@synthesize duration = _duration;
@synthesize participants = _participants;
@synthesize confirmed = _confirmed;


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
            self.agenda = [[self objectOrNilForKey:kEventsAgenda fromDictionary:dict] capitalizedString];
            self.address = [self objectOrNilForKey:kEventsAddress fromDictionary:dict];
            self.time = [[self objectOrNilForKey:kEventsTime fromDictionary:dict] doubleValue];
            self.allDay = [[self objectOrNilForKey:kEventsAllDay fromDictionary:dict] boolValue];
            self.duration = [[self objectOrNilForKey:kEventsDuration fromDictionary:dict] doubleValue];
        
            self.confirmed = [[self objectOrNilForKey:kEventsConfirmed fromDictionary:dict] boolValue];
        NSObject *receivedObjects = [self objectOrNilForKey:kEventsParticipants fromDictionary:dict];
        NSMutableArray *parsedParticipants = [NSMutableArray array];
        if ([receivedObjects isKindOfClass:[NSArray class]]) {
            for (NSDictionary *item in (NSArray *)receivedObjects) {
                if ([item isKindOfClass:[NSDictionary class]]) {
                    [parsedParticipants addObject:[Participant modelObjectWithDictionary:item]];
                }
            }
        } else if ([receivedObjects isKindOfClass:[NSDictionary class]]) {
            [parsedParticipants addObject:[Participant modelObjectWithDictionary:(NSDictionary *)receivedObjects]];
        }
        self.participants = [NSArray arrayWithArray:parsedParticipants];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.agenda forKey:kEventsAgenda];
    [mutableDict setValue:self.address forKey:kEventsAddress];
    [mutableDict setValue:[NSNumber numberWithDouble:self.time] forKey:kEventsTime];
    [mutableDict setValue:[NSNumber numberWithBool:self.allDay] forKey:kEventsAllDay];
    [mutableDict setValue:[NSNumber numberWithDouble:self.duration] forKey:kEventsDuration];
    NSMutableArray *tempArrayForParticipants = [NSMutableArray array];
    for (NSObject *subArrayObject in self.participants) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForParticipants addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForParticipants addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForParticipants] forKey:kEventsParticipants];
    [mutableDict setValue:[NSNumber numberWithBool:self.confirmed] forKey:kEventsConfirmed];

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

    self.agenda = [aDecoder decodeObjectForKey:kEventsAgenda];
    self.address = [aDecoder decodeObjectForKey:kEventsAddress];
    self.time = [aDecoder decodeDoubleForKey:kEventsTime];
    self.allDay = [aDecoder decodeBoolForKey:kEventsAllDay];
    self.duration = [aDecoder decodeDoubleForKey:kEventsDuration];
    self.participants = [aDecoder decodeObjectForKey:kEventsParticipants];
    self.confirmed = [aDecoder decodeBoolForKey:kEventsConfirmed];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_agenda forKey:kEventsAgenda];
    [aCoder encodeObject:_address forKey:kEventsAddress];
    [aCoder encodeDouble:_time forKey:kEventsTime];
    [aCoder encodeBool:_allDay forKey:kEventsAllDay];
    [aCoder encodeDouble:_duration forKey:kEventsDuration];
    [aCoder encodeObject:_participants forKey:kEventsParticipants];
    [aCoder encodeBool:_confirmed forKey:kEventsConfirmed];
}

- (id)copyWithZone:(NSZone *)zone
{
    Event *copy = [[Event alloc] init];
    
    if (copy) {

        copy.agenda = [self.agenda copyWithZone:zone];
        copy.address = [self.address copyWithZone:zone];
        copy.time = self.time;
        copy.allDay = self.allDay;
        copy.duration = self.duration;
        copy.participants = [self.participants copyWithZone:zone];
        copy.confirmed = self.confirmed;
    }
    
    return copy;
}

- (NSString *)displayTime {
    if(self.allDay)
        return @"ALL DAY";
    int hour = self.time / 60;
    NSString *ampm = @"";
    if (hour > 12) {
        ampm = @"PM";
        if(hour > 13)
            hour -= 12;
    } else {
        ampm = @"AM";
        if(hour == 0)
            hour = 12;
    }
        
    int minutes = self.time % 60;
    return [NSString stringWithFormat:@"%d:%2d %@", hour, minutes, [ampm uppercaseString]];
}

- (NSString *)displayDuration {
    if(self.allDay)
        return @"";
    if(self.duration < 60)
        return [NSString stringWithFormat:@"%dmins", self.duration];
    int hours = self.duration / 60;
    int minutes = self.duration % 60;
    return [NSString stringWithFormat:@"%dhr %dmins", hours, minutes];
}

- (BOOL) hasParticipants {
    return self.participants.count > 0;
}


@end
