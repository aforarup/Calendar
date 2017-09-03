//
//  EventManagerTests.m
//  CalendarTests
//
//  Created by Arup Saha on 8/31/17.
//  Copyright © 2017 arupsaha.tech. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "EventManager.h"
#import "DateManager.h"
#import "DateStringHelper.h"
#import "EventDataModels.h"

@interface EventManagerTests : XCTestCase
@property (nonatomic, strong) DateManager *dm;
@property (nonatomic, strong) DateStringHelper *dateHelper;
@property (nonatomic, strong) EventManager *em;
@end

@implementation EventManagerTests

- (void)setUp {
    [super setUp];
    self.dm = [DateManager sharedInstance];
    self.dateHelper = [DateStringHelper helperWithDateManager:self.dm];
    self.em = [EventManager sharedInstance];
    [self.em setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testEventForToday {
    // Parsing check. Number of events for today should be greater than 0
    NSArray *events = [self.em eventsForTheDay:[self.dateHelper keyStringForIndex:[self.dm indexForToday]]];
    XCTAssert([events count] > 0);
        
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        [[EventManager sharedInstance] setUp];
    }];
}

@end
