//
//  Calendar.h
//
//  Created by   on 8/19/17
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface Calendar : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *registered;
@property (nonatomic, strong) NSArray *events;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
