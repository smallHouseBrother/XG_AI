//
//  DataRequest.m
//  AI_XG
//
//  Created by 小马哥 on 2017/9/23.
//  Copyright © 2017年 Zhao Chen. All rights reserved.
//

#import "DataRequest.h"
#import "AFNetworking.h"
#import "XGDataRequest.h"

@implementation DataRequest

+ (void)getWithBaseURL:(NSString *)baseURL withPath:(NSString *)path withParams:(id)params withSuccess:(void (^)(id jsonData))success withFailure:(void (^)(NSError *))failure
{
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 60.0f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/json", @"application/json", @"text/javascript", @"text/html", nil];
    
    NSString * url = nil;
    
    if (path && ![path isEqualToString:@""])
    {
        url = [baseURL stringByAppendingPathComponent:path];
    }
    else
    {
        url = baseURL;
    }
    
    [manager GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary * jsonData = nil;
        if ([responseObject isKindOfClass:[NSData class]]) {
            jsonData = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        }
        XMGLog(@"data=%@", jsonData);
        success(jsonData);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        XMGLog(@"url=%@, error=%@", url, error.localizedDescription);
        failure(error);
    }];
}

+ (void)postWithBaseURL:(NSString *)baseURL withPath:(NSString *)path withParams:(id)params withSuccess:(void (^)(id jsonData))success withFailure:(void (^)(NSError * error))failure
{
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 60.0f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/json", @"application/json", @"text/javascript", @"text/html", nil];
    
    NSString * url = nil;
    
    if (path && ![path isEqualToString:@""])
    {
        url = [baseURL stringByAppendingPathComponent:path];
    }
    else
    {
        url = baseURL;
    }

    [manager POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        XMGLog(@"data=%@", responseObject);
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        XMGLog(@"url=%@, error=%@", url, error.localizedDescription);
        failure(error);
    }];
}

+ (void)postUrlencodedWithBaseURL:(NSString *)baseURL withPath:(NSString *)path withParams:(id)params withSuccess:(void (^)(id jsonData))success withFailure:(void (^)(NSError * error))failure
{
    NSString * url = nil;
    if (path && ![path isEqualToString:@""])
    {
        url = [baseURL stringByAppendingPathComponent:path];
    }
    else
    {
        url = baseURL;
    }
    
    NSURLRequest * request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:url parameters:params error:nil];
    NSURLSessionConfiguration * configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSURLSessionDataTask * dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            failure(error); return;
        }
        success(responseObject);
    }];
    [dataTask resume];
}

+ (void)deleteWithBaseURL:(NSString *)baseURL withPath:(NSString *)path withParams:(id)params withSuccess:(void (^)(NSInteger code, NSString * msg, NSString * loginToken, id jsonData))success withFailure:(void (^)(NSError * error))failure
{
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 60.0f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.HTTPMethodsEncodingParametersInURI = [NSSet setWithObjects:@"GET", @"HEAD", nil];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/json", @"application/json", @"text/javascript", @"text/html", nil];
    
    NSString * url = nil;
    
    if (path && ![path isEqualToString:@""])
    {
        url = [baseURL stringByAppendingPathComponent:path];
    }
    else
    {
        url = baseURL;
    }
    
    NSDictionary * token_param = [XGDataRequest getParamsWith:params];
    [manager DELETE:url parameters:token_param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        XMGLog(@"请求成功:%@", responseObject);
        
        NSDictionary * JSON = nil;
        if ([responseObject isKindOfClass:[NSData class]])
        {
            JSON = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        }
        else if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            JSON = responseObject;
        }
        NSInteger code = [[JSON objectForKey:@"status"] integerValue];
        NSString * message = [[JSON objectForKey:@"message"] reviewEmpty];
        NSString * loginToken = [[JSON objectForKey:@"login_token"] reviewEmpty];
        
        id returnData = [XGDataRequest DecodeResponseDataWithResponse:JSON];
        
        XMGLog(@"url=%@, code=%@, msg=%@, loginToken=%@, data=%@", url, @(code), message, loginToken, returnData);
        
        success(code, message, loginToken, returnData);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        XMGLog(@"url=%@, error=%@", url, error.localizedDescription);
        
        failure(error);
        
    }];
}

@end
