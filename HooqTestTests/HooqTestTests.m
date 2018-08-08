//
//  HooqTestTests.m
//  HooqTestTests
//
//  Created by Taufik Rohmat on 06/08/18.
//  Copyright © 2018 Taufik Rohmat. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "HomeCollectionViewController.h"
#import "Constant.h"

@interface HooqTestTests : XCTestCase

@property HomeCollectionViewController *homeVC;

@end

@interface HomeCollectionViewController (HooqTestTests)

@property (nonatomic, retain) NSMutableArray *listMovie;

- (void)loadMovie:(NSUInteger)page completion:(void (^)(NSArray* movieList, NSUInteger totalPage))completion;
@end

@implementation HooqTestTests

- (void)setUp {
    [super setUp];
    
    _homeVC = [[HomeCollectionViewController alloc]init];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testGetNowPlayingMovie {
    
    int expectedTotalMovieLoaded = 20;
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
    [_homeVC loadMovie:1 completion:^(NSArray *movieList, NSUInteger totalPage) {
        [expectation fulfill];
        XCTAssertEqual(expectedTotalMovieLoaded, movieList.count);
        
    }];
    
    [self waitForExpectationsWithTimeout:2.0 handler:nil];
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testIfThatURLIsValid{
    NSString *expectedURL = @"https://api.themoviedb.org/3/movie/now_playing?api_key=bbf0dad367e90819abfe49a65cb586ed";

    NSString *nowPlayingURL = NOW_PLAYING_URL;
    
    XCTAssertEqualObjects(expectedURL, nowPlayingURL);
}

@end
