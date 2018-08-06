//
//  Movie.h
//  HooqTest
//
//  Created by Taufik Rohmat on 06/08/18.
//  Copyright © 2018 Taufik Rohmat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Movie : JSONModel

@property (nonatomic) BOOL adult;
@property (nonatomic) NSString<Optional> *backdropPath;
@property (nonatomic) NSNumber *id;
@property (nonatomic) NSArray<Optional> *genreIds;
@property (nonatomic) NSString<Optional> *originalLanguage;
@property (nonatomic) NSString<Optional> *originalTitle;
@property (nonatomic) NSString<Optional> *overview;
@property (nonatomic) NSString<Optional> *popularity;
@property (nonatomic) NSString<Optional> *posterPath;
@property (nonatomic) NSDate<Optional> *releaseDate;
@property (nonatomic) NSString<Optional> *title;
@property (nonatomic) BOOL video;
@property (nonatomic) NSString<Optional> *voteAverage;
@property (nonatomic) int voteCount;


@end



