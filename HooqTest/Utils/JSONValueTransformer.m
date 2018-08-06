//
//  JSONValueTransformer.m
//  HooqTest
//
//  Created by Taufik Rohmat on 06/08/18.
//  Copyright © 2018 Taufik Rohmat. All rights reserved.
//

#import "JSONValueTransformer.h"

@implementation JSONValueTransformer (CustomTransformer)

- (NSDate *)NSDateFromNSString:(NSString *)string
{
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = @"Y-m-d";
    return [formatter dateFromString:string];
}

- (NSString *)JSONObjectFromNSDate:(NSDate *)date
{
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = @"Y-m-d";
    return [formatter stringFromDate:date];
}

@end
