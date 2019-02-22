//
//  XGDataRequest.h
//  AI_XG
//
//  Created by 小马哥 on 2017/9/18.
//  Copyright © 2017年 小马哥. All rights reserved.
//

#import "YTKBaseRequest.h"

typedef NS_ENUM(NSUInteger, XMGRequestType) {
    XMGRequestGET    = 0,
    XMGRequestPOST   = 1,
    XMGRequestHEAD   = 2,
    XMGRequestPUT    = 3,
    XMGRequestDELETE = 4,
    XMGRequestPATCH  = 5,
};

@interface XGDataRequest : YTKBaseRequest


/**
 *  请求封装
 *
 *  @param url    请求路径
 *  @param method 请求方法
 *  @param params  要传的参数
 *
 */
+ (void)requestWithUrl:(NSString *)url withMethod:(XMGRequestType)method withParams:(NSDictionary *)params withSuccessBlock:(void(^)(NSInteger code, NSString * msg, NSString * loginToken, id jsonData))successBlock withErrorBlock:(void(^)(NSError * error))errorBlock;

///处理加密
+ (NSDictionary *)getParamsWith:(NSDictionary *)params;

///处理解密
+ (id)DecodeResponseDataWithResponse:(NSDictionary *)response;

@end
