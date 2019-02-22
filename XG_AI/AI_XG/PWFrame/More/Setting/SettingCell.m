//
//  SettingCell.m
//  AI_XG
//
//  Created by ydz on 2018/11/9.
//  Copyright © 2018年 小马哥. All rights reserved.
//

#import "SettingCell.h"

@implementation SettingInfo
@end

@interface SettingCell ()
{
    UILabel     * _titleLabel;
    UILabel     * _rightLabel;
    UISwitch    * _aSwitch;
}
@end

@implementation SettingCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        self.backgroundColor = [UIColor whiteColor];
        
        [self addSubViews];
    }
    return self;
}

- (void)addSubViews
{
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.font = [UIFont systemFontOfSize:17];
    [self.contentView addSubview:_titleLabel];
    _titleLabel.sd_layout.leftSpaceToView(self.contentView, 20).centerYEqualToView(self.contentView).rightEqualToView(self.contentView).heightRatioToView(self.contentView, 1);
    
    _rightLabel = [[UILabel alloc] init];
    _rightLabel.textColor = COLOR_HEX(@"#8e8e8e");
    _rightLabel.font = [UIFont systemFontOfSize:18];
    _rightLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_rightLabel];
    _rightLabel.sd_layout.rightEqualToView(self.contentView).centerYEqualToView(self.contentView).widthIs(100).heightRatioToView(self.contentView, 1);
    
    _aSwitch = [[UISwitch alloc] init];
    _aSwitch.onTintColor = Main_Color;
    [_aSwitch addTarget:self action:@selector(aSwitchSwitchStatus:) forControlEvents:UIControlEventValueChanged];
    [self.contentView addSubview:_aSwitch];
    _aSwitch.sd_layout.rightEqualToView(self.contentView).offset(-12).centerYEqualToView(self.contentView);
}

- (void)reloadSettingCellWithInfo:(SettingInfo *)info
{
    _titleLabel.text = info.leftName;
    _rightLabel.text = info.rightName;
    _aSwitch.hidden = !info.isSwitch;
    _rightLabel.hidden = info.isSwitch;
    [_aSwitch setOn:info.isOn animated:YES];
    self.accessoryType = info.isSwitch ? 0 : 1;
    self.selectionStyle = info.isSwitch ? UITableViewCellSelectionStyleNone : UITableViewCellSelectionStyleDefault;
}

- (void)aSwitchSwitchStatus:(UISwitch *)aSwitch
{
    [self.delegate SettingCellSwitchStatus:self withSwitch:aSwitch];
}

@end
