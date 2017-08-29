//
//  Weather.h
//
//  Created by   on 8/28/17
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CurrentStatus;

@interface Weather : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *timezone;
@property (nonatomic, strong) CurrentStatus *currently;
@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) double longitude;
@property (nonatomic, assign) double offset;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
