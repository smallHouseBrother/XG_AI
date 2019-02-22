//
//  DataRequest.h
//  AI_XG
//
//  Created by 小马哥 on 2017/9/23.
//  Copyright © 2017年 Zhao Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataRequest : NSObject

+ (void)getWithBaseURL:(NSString *)baseURL withPath:(NSString *)path withParams:(id)params withSuccess:(void (^)(id jsonData))success withFailure:(void (^)(NSError * error))failure;

+ (void)postWithBaseURL:(NSString *)baseURL withPath:(NSString *)path withParams:(id)params withSuccess:(void (^)(id jsonData))success withFailure:(void (^)(NSError * error))failure;

+ (void)postUrlencodedWithBaseURL:(NSString *)baseURL withPath:(NSString *)path withParams:(id)params withSuccess:(void (^)(id jsonData))success withFailure:(void (^)(NSError * error))failure;

+ (void)deleteWithBaseURL:(NSString *)baseURL withPath:(NSString *)path withParams:(id)params withSuccess:(void (^)(NSInteger code, NSString * msg, NSString * loginToken, id jsonData))success withFailure:(void (^)(NSError * error))failure;

@end
