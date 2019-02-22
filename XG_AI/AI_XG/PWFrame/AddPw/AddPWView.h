//
//  AddPWView.h
//  AI_XG
//
//  Created by jrweid on 2018/6/22.
//  Copyright © 2018年 小马哥. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddPWViewDelegate <NSObject>

- (void)AddPWViewSelectPhoto;

- (void)AddPWViewBroserCurrentPhotoWithImage:(UIImage *)image;

@end

@interface AddPWView : UIView

@property (nonatomic, weak) id <AddPWViewDelegate> delegate;

@property (nonatomic, strong) UIImageView * photoImg;

- (void)reloadAddPWCellWithArray:(NSArray *)dataArray withVC:(UIViewController *)rootVC;

@end
