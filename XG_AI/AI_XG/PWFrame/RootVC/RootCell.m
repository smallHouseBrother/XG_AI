//
//  RootCell.m
//  AI_XG
//
//  Created by 马红杰 on 2018/5/31.
//  Copyright © 2018年 小马哥. All rights reserved.
//

#import "RootCell.h"
#import "RootInfo.h"

@interface RootCell ()
{
    UIImageView * _imageView;
    UILabel     * _titleName;
}
@end

@implementation RootCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.contentView.backgroundColor = [UIColor whiteColor];
     
        self.layer.cornerRadius = 5.0f;
        
        self.layer.masksToBounds = YES;
        
        [self addSubViews];
    }
    return self;
}

- (void)addSubViews
{
    _imageView = [[UIImageView alloc] init];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    _imageView.layer.cornerRadius = 5.f;
    _imageView.layer.masksToBounds = YES;
    [self.contentView addSubview:_imageView];
    _imageView.sd_layout.centerXEqualToView(self.contentView).
    centerYEqualToView(self.contentView).offset(-10).widthIs(40).heightIs(40);
    
    _titleName = [[UILabel alloc] init];
    _titleName.textColor = [UIColor blackColor];
    _titleName.font = [UIFont systemFontOfSize:17];
    _titleName.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_titleName];
    _titleName.sd_layout.leftEqualToView(self.contentView).rightEqualToView(self.contentView).topSpaceToView(_imageView, 15).heightIs(20);
}

- (void)reloadRootCellWithInfo:(RootInfo *)info
{
    _imageView.image = [UIImage imageNamed:info.imageName];
    _titleName.text = info.titleString;
}

@end
