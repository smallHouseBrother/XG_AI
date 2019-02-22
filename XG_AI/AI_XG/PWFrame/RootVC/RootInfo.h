//
//  RootInfo.h
//  AI_XG
//
//  Created by 马红杰 on 2018/5/31.
//  Copyright © 2018年 小马哥. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RootInfo : NSObject

///类型
@property (nonatomic, copy) NSString * typeId;

///类型
@property (nonatomic, copy) NSString * titleString;

///icon名
@property (nonatomic, copy) NSString * imageName;

///账户数量
@property (nonatomic) NSInteger accountNum;

@end
