//
//  MoreCell.m
//  AI_XG
//
//  Created by ydz on 2018/11/9.
//  Copyright © 2018年 小马哥. All rights reserved.
//

#import "MoreCell.h"

@implementation MoreInfo
@end

@interface MoreCell ()
{
    UIImageView * _imageView;
    UILabel     * _titleLabel;
    UILabel     * _rightLabel;
    UISwitch    * _aSwitch;
}
@end

@implementation MoreCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        self.backgroundColor = [UIColor clearColor];
        
        [self addSubViews];
    }
    return self;
}

- (void)addSubViews
{
    _imageView = [[UIImageView alloc] init];
    [self.contentView addSubview:_imageView];
    _imageView.sd_layout.leftSpaceToView(self.contentView, 15).centerYEqualToView(self.contentView).widthIs(24).heightIs(24);
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.font = [UIFont systemFontOfSize:19];
    [self.contentView addSubview:_titleLabel];
    _titleLabel.sd_layout.leftSpaceToView(_imageView, 15).centerYEqualToView(self.contentView).rightEqualToView(self.contentView).heightRatioToView(self.contentView, 1);
    
    _rightLabel = [[UILabel alloc] init];
    _rightLabel.textColor = COLOR_HEX(@"#8e8e8e");
    _rightLabel.font = [UIFont systemFontOfSize:17];
    _rightLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_rightLabel];
    _rightLabel.sd_layout.rightEqualToView(self.contentView).centerYEqualToView(self.contentView).widthIs(100).heightRatioToView(self.contentView, 1);
}

- (void)reloadMoreCellWithInfo:(MoreInfo *)info
{
    _imageView.image = [UIImage imageNamed:info.imageUrl];
    _titleLabel.text = info.leftName;
    _rightLabel.text = info.rightName;
    _rightLabel.hidden = !info.rightName;
    _rightLabel.textColor = [info.rightName isEqualToString:@"NEW"] ? COLOR_HEX(@"#ff0000") : COLOR_HEX(@"#8e8e8e");
}

@end
