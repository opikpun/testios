//
//  HomeCollectionViewController.m
//  HooqTest
//
//  Created by Taufik Rohmat on 06/08/18.
//  Copyright © 2018 Taufik Rohmat. All rights reserved.
//

#import "HomeCollectionViewController.h"
#import "Movie.h"
#import "MovieCollectionViewCell.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "DetailViewController.h"

@interface HomeCollectionViewController ()<UICollectionViewDelegateFlowLayout, UICollectionViewDataSourcePrefetching>{
    CGSize sizeCollection;
    NSInteger totalPage;
    NSInteger currentPage;
    Movie *selectedMovie;
    UIRefreshControl *refreshControl;
    NSMutableArray *listMovie;
}

@end

@implementation HomeCollectionViewController

static NSString * const reuseIdentifier = @"MovieCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
     self.clearsSelectionOnViewWillAppear = NO;
    
    //add pull to load refresh
    refreshControl = [[UIRefreshControl alloc]init];
    [refreshControl addTarget:self action:@selector(refreshAndLoadData) forControlEvents:UIControlEventValueChanged];
    refreshControl.tintColor = [UIColor whiteColor];
    self.collectionView.alwaysBounceVertical = true;
    [self.collectionView addSubview:refreshControl];
    
    
    //get size of screen for size cell
    float widthScreen = [UIScreen mainScreen].bounds.size.width;
    float widthCell = floor((widthScreen-36) / TOTAL_COLUMN_MOVIE); //20 is space between cell 10 8 8 10
    sizeCollection = CGSizeMake(widthCell, 1.5 * widthCell);
    
    [self refreshAndLoadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.title = @" ";
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.title = @"NOW PLAYING";
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"segueToDetail"]){
        DetailViewController *detailVC = segue.destinationViewController;
        [detailVC setMovie:selectedMovie];
    }
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return listMovie.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MovieCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    Movie *movie = listMovie[indexPath.row];
    [cell.imagePoster setImageWithURL:[NSURL URLWithString:SMALL_IMAGE_URL(movie.posterPath)]];
    [cell.imagePoster.image setAccessibilityIdentifier:movie.posterPath];
    cell.layer.shadowRadius  = 1.5f;
    cell.layer.shadowColor   = UIColor.lightGrayColor.CGColor;
    cell.layer.shadowOffset  = CGSizeMake(0.0f, 0.0f);
    cell.layer.shadowOpacity = 0.9f;
    cell.layer.masksToBounds = NO;
    
    // Configure the cell
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    selectedMovie = listMovie[indexPath.row];
    [self performSegueWithIdentifier:@"segueToDetail" sender:self];
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return sizeCollection;
}

#pragma mark - Collection Prefetch Data Sources
- (void)collectionView:(UICollectionView *)collectionView prefetchItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths{
   
    NSIndexPath *lastIndex = indexPaths.lastObject;
    if(lastIndex.row == listMovie.count-1 ){
        [self callAPINowPlayingMovie];
    }
}


#pragma mark - Connection
- (void)refreshAndLoadData{
    
    //load movie
    listMovie = [[NSMutableArray alloc]init];
    currentPage = 0;
    totalPage = 0;
    [self callAPINowPlayingMovie];
}

- (void)callAPINowPlayingMovie{
    currentPage++;
    if(currentPage == totalPage){
        return;
    }
    [self loadMovie:currentPage completion:^(NSArray *movieList, NSUInteger totalPage) {
        [self->listMovie addObjectsFromArray:movieList];
        self->totalPage = totalPage;
        [self.collectionView reloadData];
        [self->refreshControl endRefreshing];
    }];
}

- (void)loadMovie:(NSUInteger)page completion:(void (^)(NSArray* movieList, NSUInteger totalPage))completion{
    [[SessionManager sharedManager]GET:NOW_PLAYING_URL parameters:@{@"page":@(page)} success:^(NSURLSessionDataTask *task, NSDictionary *responseObject) {
        NSArray *results = responseObject[@"results"];
        NSMutableArray *movies = [[NSMutableArray alloc]init];
        for(NSDictionary *movieDict in results){
            [movies addObject:[[Movie alloc]initWithDictionary:movieDict error:nil]];
        }
        completion(movies, [responseObject[@"total_pages"]integerValue]);
        
    } failure:^(NSError *error, NSDictionary *responseObject) {
        completion(nil, 0);
    }];
}


@end
