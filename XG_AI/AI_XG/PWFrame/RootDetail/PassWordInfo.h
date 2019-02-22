//
//  PassWordInfo.h
//  AI_XG
//
//  Created by jrweid on 2018/6/21.
//  Copyright © 2018年 小马哥. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PassWordInfo : NSObject

///@[@"all", @"login", @"email", @"wallet", @"game", @"chat", @"bank", @"other"];
@property (nonatomic, copy) NSString * typeId;

///创建时的时间戳
@property (nonatomic) NSInteger pwId;

@property (nonatomic, copy) NSString * createTime;

@property (nonatomic, copy) NSString * titleName;

///新建还是更新保存
@property (nonatomic) NSInteger isEdited;

@property (nonatomic, copy) NSString * webSite;

@property (nonatomic, copy) NSString * account;

@property (nonatomic, copy) NSString * passWord;

@property (nonatomic, copy) NSString * beiZhu;

@property (nonatomic, strong) NSData * imageData;

@end
