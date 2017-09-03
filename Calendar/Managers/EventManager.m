//
//  EventManager.m
//  Calendar
//
//  Created by Arup Saha on 8/18/17.
//  Copyright © 2017 arupsaha.tech. All rights reserved.
//

#import "EventManager.h"


@interface EventManager()
@property (nonatomic, strong) NSMutableDictionary *calendarEntries;
@property (nonatomic, strong) NSString *filePath;
@end

@implementation EventManager

+ (instancetype) sharedInstance {
    static EventManager *eventManager;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        eventManager = [[self alloc] init];
        
        // Set the file path for the instance
        eventManager.filePath = [[NSBundle mainBundle] pathForResource:@"calendar" ofType:@"json"];
        
    });
    return eventManager;
}

- (void) setUp {
    
    // Read the JSON data from the file
    NSData *data = [NSData dataWithContentsOfFile:_filePath];
    NSArray *jsonData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    
    for(NSDictionary *jsonDictionary in jsonData) {
        // Parse JSON to events
        Calendar *calendarEntry = [Calendar modelObjectWithDictionary:jsonDictionary];
        
        // Store events in InMemory dictionary
        [self.calendarEntries setObject:calendarEntry.events forKey:calendarEntry.registered];
        
    }
}

- (void) setUpWithCompletion:(void(^)(void)) onComplete {
    [self setUp];
    if(onComplete)
        onComplete();
}


- (instancetype)init {
    if(self = [super init]) {
        self.calendarEntries = [NSMutableDictionary dictionary];
    }
    return self;
}

- (NSArray *)eventsForTheDay:(NSString *)dateKey {
    
    //Fetch events from the InMemory dictionary
    id events = [_calendarEntries objectForKey:dateKey];
    
    if(!events)
        // Return empty array is no events are found
        return @[];
    
    return events;
}

@end
