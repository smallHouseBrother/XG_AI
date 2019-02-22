//
//  photoMsgViewController.h
//  AI_XG
//
//  Created by jrweid on 2018/8/6.
//  Copyright © 2018年 小马哥. All rights reserved.
//

#import "XGBaseViewController.h"

@protocol photoMsgViewControllerDelegate <NSObject>

- (void)photoMsgViewControllerDidDeleteCurrentPasswordPhoto;

@end

@interface photoMsgViewController : XGBaseViewController

@property (nonatomic, strong) UIImage * image;

@property (nonatomic, weak) id <photoMsgViewControllerDelegate> delegate;

@end
