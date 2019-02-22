//
//  NSString+XMGCrypt.m
//  AI_XG
//
//  Created by 小马哥 on 2017/11/16.
//  Copyright © 2017年 小马哥. All rights reserved.
//

#import "NSString+XMGCrypt.h"
#import "NSData+CommonCrypto.h"
#import "NSData+Base64.h"

@implementation NSString (XMGCrypt)

+ (NSString *)encrypt:(NSString *)message password:(NSString *)password
{
    NSData * encryptedData = [[message dataUsingEncoding:NSUTF8StringEncoding] AES256EncryptedDataUsingKey:[[password dataUsingEncoding:NSUTF8StringEncoding] SHA256Hash] error:nil];
    NSString *base64EncodedString = [NSString base64StringFromData:encryptedData length:[encryptedData length]];
    return base64EncodedString;
}

+ (NSString *)decrypt:(NSString *)base64EncodedString password:(NSString *)password
{
    NSData *encryptedData = [NSData base64DataFromString:base64EncodedString];
    NSData *decryptedData = [encryptedData decryptedAES256DataUsingKey:[[password dataUsingEncoding:NSUTF8StringEncoding] SHA256Hash] error:nil];
    return [[NSString alloc] initWithData:decryptedData encoding:NSUTF8StringEncoding];
}

@end
