//
//  CalendarTests.m
//  CalendarTests
//
//  Created by Arup Saha on 8/16/17.
//  Copyright © 2017 arupsaha.tech. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DateManager.h"
#import "EventManager.h"
#import "EventDataModels.h"

@interface CalendarTests : XCTestCase
@end

@implementation CalendarTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testToCheckDateManagerStartDateAsSunday {
    DateManager *dm = [DateManager sharedInstance];
    NSDate *startDate = dm.startDate;
    NSCalendar *currentCalendar= [NSCalendar currentCalendar];
    NSInteger dayOfWeek = [currentCalendar component:NSCalendarUnitWeekday fromDate:startDate];
    XCTAssertEqual(dayOfWeek, 1, @"Date Manager doesn't start from a Sunday");
}


- (void)testEventForToday {
    DateManager *dm = [DateManager sharedInstance];
    EventManager *em = [EventManager sharedInstance];
    __weak typeof(em) weakEM = em;
    XCTestExpectation *completionExpectation = [self expectationWithDescription:@"There are 3 events for today"];
    [em setUpWithCompletion:^{
        NSArray *events = [weakEM eventsForTheDay:[dm keyDateForIndex:[dm indexForToday]]];
        XCTAssertEqual([events count], 3, @"Incorrect number of Events For Today");
        [completionExpectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:1.0 handler:nil];
}

- (void)testEventJsonLoadTime {
    [self measureBlock:^{
        [[EventManager sharedInstance] setUp];
    }];
}

@end
