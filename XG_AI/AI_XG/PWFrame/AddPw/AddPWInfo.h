//
//  AddPWInfo.h
//  AI_XG
//
//  Created by jrweid on 2018/6/26.
//  Copyright © 2018年 小马哥. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddPWInfo : NSObject

@property (nonatomic, copy) NSString * leftTitle;

@property (nonatomic, copy) NSString * titlePlace;

@property (nonatomic, copy) NSString * titleInput;

@property (nonatomic) NSInteger isEdited;

///顶部创建、编辑时间
@property (nonatomic, copy) NSString * editTime;

@property (nonatomic, strong) NSData * imageData;

@end

//@property (nonatomic, strong) NSData * imageData;
