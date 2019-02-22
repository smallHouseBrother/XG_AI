//
//  XGDataRequest.m
//  AI_XG
//
//  Created by 小马哥 on 2017/9/18.
//  Copyright © 2017年 小马哥. All rights reserved.
//

#import "XGDataRequest.h"
#import "AESCrypt.h"
#import "DataRequest.h"

@interface XGDataRequest ()

@property (nonatomic, copy) NSString * url;

@property (nonatomic, assign) NSInteger method;

@property (nonatomic) NSDictionary * params;

@end

@implementation XGDataRequest

/**
 *  请求封装
 *
 *  @param url    请求路径
 *  @param method 请求方法
 *  @param params  要传的参数
 *
 */
+ (void)requestWithUrl:(NSString *)url withMethod:(XMGRequestType)method withParams:(NSDictionary *)params withSuccessBlock:(void(^)(NSInteger code, NSString * msg, NSString * loginToken, id jsonData))successBlock withErrorBlock:(void(^)(NSError * error))errorBlock
{
    NSDictionary * dic = [self getParamsWith:params];
    
    XGDataRequest * dataRequest = [[XGDataRequest alloc] initWithUrl:url withMethod:method withParams:dic];
    
    [dataRequest startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        NSDictionary * jsonDic = request.responseJSONObject;
        
        NSInteger code = [[jsonDic objectForKey:@"status"] integerValue];
        NSString * message = [[jsonDic objectForKey:@"message"] reviewEmpty];
        NSString * loginToken = [[jsonDic objectForKey:@"login_token"] reviewEmpty];
        
        id returnData = [self DecodeResponseDataWithResponse:request.responseJSONObject];
        
        XMGLog(@"url=%@, code=%@, msg=%@, loginToken=%@, data=%@", url, @(code), message, loginToken, returnData);
        
        successBlock(code, message, loginToken, returnData);
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        XMGLog(@"url=%@, error=%@", url, request.error.localizedDescription);
        
        errorBlock(request.error);
        
    }];
}

//参数、
+ (NSDictionary *)getParamsWith:(NSDictionary *)params
{
    NSMutableDictionary * token_param = [params mutableCopy];
    if (!token_param) {
        token_param = [NSMutableDictionary dictionary];
    }
    NSDictionary * infoDic   = [[NSBundle mainBundle] infoDictionary];
    NSInteger      build     = [[infoDic objectForKey:@"CFBundleVersion"] integerValue];
    [token_param setObject:@(build) forKey:@"app_version"];

    NSString * iv = [NSString dynamicGenerate16BitString];
    if (!iv || [iv isEqualToString:@""] || iv.length != 16)
    {
        iv = @"16-Bytes--String"; ///初始向量，需与后台统一
    }

    NSString * uuid = [[UIDevice currentDevice].identifierForVendor UUIDString];
    [token_param setValue:uuid forKey:@"loginToken"];
    NSData   * data = [NSJSONSerialization dataWithJSONObject:token_param options:NSJSONWritingPrettyPrinted error:nil];
    NSString * dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSString * string1 = [dataString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    NSString * string2 = [string1 stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString * base64 = [AESCrypt encrypt:string2 withKey:Encode_key withIv:iv];
    NSDictionary * dic = @{@"iv":iv, @"data":base64};
    return dic;
}

///默认data为字符串就解密
+ (id)DecodeResponseDataWithResponse:(NSDictionary *)response
{
    id data = [response objectForKey:@"data"];
    id iv   = [response objectForKey:@"iv"];
    
    ///有加密
    if ([response.allKeys containsObject:@"iv"] && [response.allKeys containsObject:@"data"] && ![[iv reviewNil] isEqualToString:@""] && ![[data reviewEmpty] isEqualToString:@""] && [data isKindOfClass:[NSString class]])
    {
        NSString * base64 = [NSString URLDecodedString:(NSString *)data];
        NSString * result = [AESCrypt decrypt:base64 withKey:Encode_key withIv:iv];
        
        NSData * backData = [result dataUsingEncoding:NSUTF8StringEncoding];
        id back = [NSJSONSerialization JSONObjectWithData:backData options:NSJSONReadingMutableContainers error:nil];
        return back;
    }
    ///无加密
    return data;
}














- (instancetype)initWithUrl:(NSString *)url withMethod:(NSInteger)method withParams:(NSDictionary *)params
{
    self = [super init];
    if (self)
    {
        self.url = url;
        self.method = method;
        self.params = params;
    }
    return self;
}

- (NSString *)baseUrl
{
    return @"";
}

- (NSString *)requestUrl
{
    return _url;
}

- (YTKRequestMethod)requestMethod
{
    switch (_method)
    {
        case 0:
            return YTKRequestMethodGET;
            break;
        case 2:
            return YTKRequestMethodHEAD;
            break;
        case 3:
            return YTKRequestMethodPUT;
            break;
        case 4:
            return YTKRequestMethodDELETE;
            break;
        case 5:
            return YTKRequestMethodPATCH;
            break;
        default:
            return YTKRequestMethodPOST;
            break;
    }
}

- (id)requestArgument
{
    return _params;
}

- (id)jsonValidator
{
    return nil;
}

@end
