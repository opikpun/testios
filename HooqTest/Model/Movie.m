//
//  Movie.m
//  HooqTest
//
//  Created by Taufik Rohmat on 06/08/18.
//  Copyright © 2018 Taufik Rohmat. All rights reserved.
//

#import "Movie.h"

@implementation Movie

+ (JSONKeyMapper *)keyMapper
{
    return [JSONKeyMapper mapperForSnakeCase];
}

@end
