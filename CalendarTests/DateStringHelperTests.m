//
//  DateStringHelperTests.m
//  CalendarTests
//
//  Created by Arup Saha on 8/31/17.
//  Copyright © 2017 arupsaha.tech. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DateStringHelper.h"

@interface DateStringHelperTests : XCTestCase
@property (nonatomic, strong) DateStringHelper *dateHelper;
@property (nonatomic, strong) DateManager *dm;
@end

@implementation DateStringHelperTests

- (void)setUp {
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.dm = [DateManager sharedInstance];
    self.dateHelper = [DateStringHelper helperWithDateManager:self.dm];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void) testFormat {
    //Today's sectionTitleString must have "Today" at start
    XCTAssert([[self.dateHelper sectionTitleStringForIndex:[self.dm indexForToday]] rangeOfString:@"Today"].location == 0);
    
    //Yesterday's sectionTitleString must have "Yesterday" at start
    XCTAssert([[self.dateHelper sectionTitleStringForIndex:([self.dm indexForToday] - 1)] rangeOfString:@"Yesterday"].location == 0);
    
    //Tomorrow's sectionTitleString must have "Tomorrow" at start
    XCTAssert([[self.dateHelper sectionTitleStringForIndex:([self.dm indexForToday] + 1)] rangeOfString:@"Tomorrow"].location == 0);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
