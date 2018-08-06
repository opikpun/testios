//
//  Utils.m
//  HooqTest
//
//  Created by Taufik Rohmat on 06/08/18.
//  Copyright © 2018 Taufik Rohmat. All rights reserved.
//

#import "Utils.h"

@implementation Utils


+ (NSDictionary *)cleanNullInJsonDic:(NSDictionary *)dic{
    if (!dic || (id)dic == [NSNull null])
    {
        return dic;
    }
    NSMutableDictionary *mulDic = [[NSMutableDictionary alloc] init];
    for (NSString *key in [dic allKeys])
    {
        NSObject *obj = dic[key];
        if (!obj || obj == [NSNull null])
        {
            [mulDic setObject:@"" forKey:key];
        }else if ([obj isKindOfClass:[NSDictionary class]])
        {
            [mulDic setObject:[self cleanNullInJsonDic:(NSDictionary *)obj] forKey:key];
        }else if ([obj isKindOfClass:[NSArray class]])
        {
            NSArray *array = [self cleanNullInJsonArray:(NSArray *)obj];
            [mulDic setObject:array forKey:key];
        }else
        {
            [mulDic setObject:obj forKey:key];
        }
    }
    return mulDic;
}


+ (NSArray *)cleanNullInJsonArray:(NSArray *)array
{
    if (!array || (id)array == [NSNull null])
    {
        return array;
    }
    NSMutableArray *mulArray = [[NSMutableArray alloc] init];
    for (NSObject *obj in array)
    {
        if (!obj || obj == [NSNull null])
        {
            [mulArray addObject:@""];
        }else if ([obj isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *dic = [self cleanNullInJsonDic:(NSDictionary *)obj];
            [mulArray addObject:dic];
        }else if ([obj isKindOfClass:[NSArray class]])
        {
            NSArray *a = [self cleanNullInJsonArray:(NSArray *)obj];
            [mulArray addObject:a];
        }else
        {
            [mulArray addObject:obj];
        }
    }
    return mulArray;
}

@end
