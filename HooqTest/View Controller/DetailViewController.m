//
//  DetailViewController.m
//  HooqTest
//
//  Created by Taufik Rohmat on 06/08/18.
//  Copyright © 2018 Taufik Rohmat. All rights reserved.
//

#import "DetailViewController.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "MovieCollectionViewCell.h"

@interface DetailViewController ()<UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>{
    
    __weak IBOutlet UIImageView *imageViewBackground;
    __weak IBOutlet UIImageView *imageViewPoster;
    __weak IBOutlet UILabel *labelTitle;
    __weak IBOutlet UILabel *labelSubTitle;
    __weak IBOutlet UILabel *labelDescription;
    __weak IBOutlet UICollectionView *collectionViewRelated;
    __weak IBOutlet NSLayoutConstraint *heightCollectionViewRelated;
    
    NSMutableArray *listRelatedMovie;
    CGSize sizeCollection;
}

@end

@implementation DetailViewController

static NSString * const reuseIdentifier = @"MovieCell";
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    labelTitle.text = self.movie.originalTitle;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"Y"];
    labelSubTitle.text = [dateFormatter stringFromDate:self.movie.releaseDate];
    
    [imageViewBackground setImageWithURL:[NSURL URLWithString:ORIGINAL_IMAGE_URL(self.movie.backdropPath)]];
    [imageViewPoster setImageWithURL:[NSURL URLWithString:ORIGINAL_IMAGE_URL(self.movie.posterPath)]];
    
    labelDescription.text = self.movie.overview;
    
    
    //add border to image poster
    imageViewPoster.layer.borderColor = UIColor.blackColor.CGColor;
    imageViewPoster.layer.borderWidth = 2.0;
    
    //get size of screen for size cell
    float widthScreen = [UIScreen mainScreen].bounds.size.width;
    float widthCell = floor((widthScreen-36) / TOTAL_COLUMN_MOVIE); //20 is space between cell 10 8 8 10
    sizeCollection = CGSizeMake(widthCell, 1.5 * widthCell);
    
    //load related movie
    listRelatedMovie = [[NSMutableArray alloc]init];
    [self loadRelatedMovies];
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
    self.title = self.movie.title;
}

#pragma mark - Collection View Data Source
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return listRelatedMovie.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MovieCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    Movie *relatedMovie = listRelatedMovie[indexPath.row];
    [cell.imagePoster setImageWithURL:[NSURL URLWithString:SMALL_IMAGE_URL(relatedMovie.posterPath)]];
    return cell;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return sizeCollection;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    Movie *relatedMovie = listRelatedMovie[indexPath.row];
    DetailViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"detailVC"];
    [vc setMovie:relatedMovie];
    NSLog(@"called detail");
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Connection
- (void)loadRelatedMovies{
    [[SessionManager sharedManager]GET:SIMILAR_MOVIE_URL(self.movie.id) parameters:nil success:^(NSURLSessionDataTask *task, NSDictionary *responseObject) {
        NSArray *results = responseObject[@"results"];
        for(NSDictionary *movieDict in results){
            [self->listRelatedMovie addObject:[[Movie alloc]initWithDictionary:movieDict error:nil]];
            if(self->listRelatedMovie.count == TOTAL_RELATED_MOVIE ){
                break;
            }
        }
        [self->collectionViewRelated reloadData];
        self->heightCollectionViewRelated.constant = (self->sizeCollection.height * TOTAL_COLUMN_MOVIE) + 20;
        
    } failure:^(NSError *error, NSDictionary *responseObject) {
        
    }];
}

@end
