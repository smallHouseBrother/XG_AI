//
//  NSString+urlEncode.m
//  AI_XG
//
//  Created by 小马哥 on 2017/9/21.
//  Copyright © 2017年 Zhao Chen. All rights reserved.
//

#import "NSString+urlEncode.h"

@implementation NSString (urlEncode)

/**
 *  URLEncode
 */
+ (NSString *)URLEncodedString:(NSString *)string
{
    // CharactersToBeEscaped = @":/?&=;+!@#$()~',*";
    // CharactersToLeaveUnescaped = @"[].";

    CFStringRef stringRef = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)string, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8);
    NSString * encodedString = (__bridge NSString *)stringRef;
    CFBridgingRelease(stringRef);
    return encodedString;
}

/**
 *  URLDecode
 */
+ (NSString *)URLDecodedString:(NSString *)string
{
    ///[string stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]; 或者
    
    CFStringRef stringRef = CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (__bridge CFStringRef)string, CFSTR(""),CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    NSString * decode = (__bridge NSString *)stringRef;
    CFRelease(stringRef);
    return decode;
}

@end
