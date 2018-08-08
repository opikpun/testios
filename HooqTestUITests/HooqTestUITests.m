//
//  HooqTestUITests.m
//  HooqTestUITests
//
//  Created by Taufik Rohmat on 06/08/18.
//  Copyright © 2018 Taufik Rohmat. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface HooqTestUITests : XCTestCase

@end

@implementation HooqTestUITests

- (void)setUp {
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;
    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    [[[XCUIApplication alloc] init] launch];
    
    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testNavigationUI {
    
    XCUIApplication *app = [[XCUIApplication alloc] init];
    [[[[app.collectionViews childrenMatchingType:XCUIElementTypeCell] elementBoundByIndex:4] childrenMatchingType:XCUIElementTypeOther].element tap];
    
    XCUIElementQuery *collectionViewsQuery = app.scrollViews.otherElements.collectionViews;
    [[[[collectionViewsQuery childrenMatchingType:XCUIElementTypeCell] elementBoundByIndex:2] childrenMatchingType:XCUIElementTypeOther].element tap];
    [[[[collectionViewsQuery childrenMatchingType:XCUIElementTypeCell] elementBoundByIndex:1] childrenMatchingType:XCUIElementTypeOther].element tap];
    [app.navigationBars.buttons[@"Back"] tap];
    [app.navigationBars.buttons[@"Back"] tap];
    [app.navigationBars.buttons[@"Back"] tap];

}

@end
