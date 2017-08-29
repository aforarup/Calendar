//
//  Events.h
//
//  Created by   on 8/19/17
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface Event : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *agenda;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, assign) int time;
@property (nonatomic, assign) BOOL allDay;
@property (nonatomic, assign) int duration;
@property (nonatomic, strong) NSArray *participants;
@property (nonatomic, assign) BOOL confirmed;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;
- (NSString *) displayTime;
- (NSString *)displayDuration;
- (BOOL) hasParticipants;
@end
