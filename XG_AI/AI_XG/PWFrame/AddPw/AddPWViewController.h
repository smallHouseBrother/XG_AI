//
//  AddPWViewController.h
//  AI_XG
//
//  Created by jrweid on 2018/6/4.
//  Copyright © 2018年 小马哥. All rights reserved.
//

#import "XGBaseViewController.h"

typedef void(^canDeleteBlock)(void);

@class PassWordInfo;

@protocol AddPWViewControllerDelegate <NSObject>

- (void)returnAddedPassWordWithInfo:(PassWordInfo *)info withIsEdit:(BOOL)isEdit;

@end

@interface AddPWViewController : XGBaseViewController

///查看
@property (nonatomic, strong) PassWordInfo * info;

///新增所属类型
@property (nonatomic, copy) NSString * typeId;

///3D Touch Can Delete block
@property (nonatomic, copy) canDeleteBlock block;

@property (nonatomic, weak) id <AddPWViewControllerDelegate> delegate;

@end
