//
//  NSString+urlEncode.h
//  AI_XG
//
//  Created by 小马哥 on 2017/9/21.
//  Copyright © 2017年 Zhao Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (urlEncode)

/**
 *  URLEncode
 */
+ (NSString *)URLEncodedString:(NSString *)string;


/**
 *  URLDecode
 */
+ (NSString *)URLDecodedString:(NSString *)string;

@end
