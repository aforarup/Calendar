//
//  DateManagerTests.m
//  CalendarTests
//
//  Created by Arup Saha on 8/30/17.
//  Copyright © 2017 arupsaha.tech. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DateManager.h"


@interface DateManagerTests : XCTestCase
@property (nonatomic, weak) DateManager *dm;
@property (nonatomic, strong) NSCalendar *currentCalendar;
@end

@implementation DateManagerTests

- (void)setUp {
    [super setUp];
    self.dm = [DateManager sharedInstance];
    self.currentCalendar = [NSCalendar currentCalendar];
}

- (void)testDateManagerStartAndEndDates {
    
    //Test End date is after Start Date
    XCTAssert([self.dm
               .startDate compare:self.dm.endDate] == NSOrderedAscending);
    
    //test Start date falls on a Sunday
    XCTAssert([self.currentCalendar component:NSCalendarUnitWeekday fromDate: self.dm.startDate] == 1);
}

- (void)testTodayDateIndex {
    //Check if the present date returns correct index
    NSDate *startDate = self.dm.startDate;
    NSDate *today = [NSDate date];
    NSDateComponents *components = [self.currentCalendar components:NSCalendarUnitDay fromDate:startDate toDate:today options:NSCalendarWrapComponents];
    XCTAssert(components.day == [self.dm indexForToday]);
}

- (void)testForDateIndexExceptions {
    NSDate *earlyDate = [NSDate dateWithTimeIntervalSince1970:0];
    XCTAssertThrows([self.dm indexForDate:earlyDate]);
    
    NSDate *laterDate = [NSDate dateWithTimeInterval:100000 sinceDate:self.dm.endDate];
    XCTAssertThrows([self.dm indexForDate:laterDate]);
}
    

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}



@end
