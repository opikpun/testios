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
#import "Movie.h"
#import "MovieCollectionViewCell.h"
#import "SessionManager.h"

@interface HooqTestTests : XCTestCase

@property HomeCollectionViewController *homeVC;

@end

@interface HomeCollectionViewController (HooqTestTests)

- (void)loadMovie:(NSUInteger)page completion:(void (^)(NSArray* movieList, NSUInteger totalPage))completion;
- (void)refreshAndLoadData;
@end

@implementation HooqTestTests

- (void)setUp {
    [super setUp];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:NSBundle.mainBundle];
    UINavigationController *navVC =  [storyboard instantiateViewControllerWithIdentifier:@"navVC"];
    _homeVC = (HomeCollectionViewController *) navVC.topViewController;
 
    UIApplication.sharedApplication.keyWindow.rootViewController = _homeVC;
    
    XCTAssertNotNil(navVC.view);
    XCTAssertNotNil(_homeVC.view);
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

- (void)testIfColorCorrect{
    UIColor *expectedColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    
    UIColor *resultColor = UIColorFromRGB(0xFFFFFF);
    
    XCTAssert(CGColorEqualToColor(expectedColor.CGColor, resultColor.CGColor));
}

- (void)testCollectionViewMovieImage{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
    [[SessionManager manager]GET:NOW_PLAYING_URL parameters:@{@"page":@(1)} success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *results = responseObject[@"results"];
        NSMutableArray *movies = [[NSMutableArray alloc]init];
        for(NSDictionary *movieDict in results){
            [movies addObject:[[Movie alloc]initWithDictionary:movieDict error:nil]];
        }
        
        [expectation fulfill];
        
        
        
        NSArray *cells = self->_homeVC.collectionView.visibleCells;
        
        for(int i = 0; i < cells.count; i++){
            MovieCollectionViewCell *cell = cells[i];
            Movie *movie = movies[i];
            XCTAssertEqualObjects([cell.imagePoster.image accessibilityIdentifier], movie.posterPath);
        }
    } failure:^(NSError *error, NSDictionary *responseObject) {
        
    }];
    
    [self waitForExpectationsWithTimeout:5.0 handler:nil];
}


@end
