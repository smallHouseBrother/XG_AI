//
//  ScaleImageView.h
//  AI_XG
//
//  Created by jrweid on 2018/8/6.
//  Copyright © 2018年 小马哥. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScaleImageView : UIView

@property (nonatomic, strong) UIScrollView * scrollView;

- (void)setImageViewFrameWithImage:(UIImage *)image;

@end
