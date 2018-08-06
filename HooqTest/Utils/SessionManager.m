//
//  SessionManager.m
//  HooqTest
//
//  Created by Taufik Rohmat on 06/08/18.
//  Copyright © 2018 Taufik Rohmat. All rights reserved.
//

#import "SessionManager.h"

@implementation SessionManager

- (instancetype)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (self) {
        
        [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
        self.requestSerializer = [AFJSONRequestSerializer serializer];
        [self.requestSerializer setValue:@"iOS" forHTTPHeaderField:@"Source"];
        [self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        
        [self setResponseSerializer:[AFJSONResponseSerializer serializer]];
    }
    return self;
}

#pragma mark - Singleton Methods

+ (SessionManager *)sharedManager
{
    static dispatch_once_t pred;
    static SessionManager *_sharedManager = nil;
    
    dispatch_once(&pred, ^{ _sharedManager = [[self alloc] initWithBaseURL:[NSURL URLWithString:BASE_URL]]; });
    return _sharedManager;
}

- (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(id)parameters
                      success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                      failure:(void (^)(NSError *error, NSDictionary *responseObject))failure{
    
    return [self GET:URLString useKey:true parameters:parameters success:success failure:failure];
}

- (NSURLSessionDataTask *)GET:(NSString *)URLString useKey:(BOOL)useKey parameters:(id)parameters success:(void (^)(NSURLSessionDataTask *, id))success failure:(void (^)(NSError *, NSDictionary *))failure{
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];

    return [super GET:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(task, responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if([AFNetworkReachabilityManager sharedManager].reachable){
            NSDictionary *result = nil;
            if(error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey]){
                NSDictionary *tempresult = [NSJSONSerialization JSONObjectWithData:error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey]
                                                                           options:kNilOptions
                                                                             error:&error];
                result = [Utils cleanNullInJsonDic:tempresult];
                
                //check for error message
            }
            failure(error, result);
        }else{
            failure(nil, nil);
        }
    }];
}
- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
                       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                       failure:(void (^)(NSError *, NSDictionary *))failure{
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    
    self.requestSerializer = [AFJSONRequestSerializer serializer];
    
    return [super POST:URLString parameters:parameters progress:nil success:success failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if([AFNetworkReachabilityManager sharedManager].reachable){
            
            
            NSDictionary *result = nil;
            if(error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey]){
                result = [NSJSONSerialization JSONObjectWithData:error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey]
                                                         options:kNilOptions
                                                           error:&error];
                
            }
            failure(error, result);
        }else{
            //            [UIUtils showAlertNavBar:@"No internet Connection"];
            failure(nil, nil);
        }
    }];
}

@end
