//
//  Constant.h
//  HooqTest
//
//  Created by Taufik Rohmat on 06/08/18.
//  Copyright © 2018 Taufik Rohmat. All rights reserved.
//

#ifndef Constant_h
#define Constant_h


#define BASE_URL @"https://api.themoviedb.org/3/"
#define IMAGE_URL @"https://image.tmdb.org/t/p/"
#define API_URL [NSString stringWithFormat:@"%@/api/", BASE_URL]
#define API_KEY_IMDB @"bbf0dad367e90819abfe49a65cb586ed"

#define NOW_PLAYING_URL [NSString stringWithFormat:@"%@movie/now_playing?api_key=%@", BASE_URL, API_KEY_IMDB]
#define SIMILAR_MOVIE_URL(movieId) [NSString stringWithFormat:@"%@movie/%@/similar?api_key=%@", BASE_URL, movieId, API_KEY_IMDB]

#define SMALL_IMAGE_URL(path) [NSString stringWithFormat:@"%@w300%@", IMAGE_URL, path]
#define ORIGINAL_IMAGE_URL(path) [NSString stringWithFormat:@"%@original%@", IMAGE_URL, path]


#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


#define TOTAL_RELATED_MOVIE 9
#define TOTAL_COLUMN_MOVIE 3

#endif /* Constant_h */
