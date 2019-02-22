//
//  FixPassWordCell.m
//  AI_XG
//
//  Created by ydz on 2019/1/30.
//  Copyright © 2019年 小马哥. All rights reserved.
//

#import "FixPassWordCell.h"

@implementation FixPassWordInfo
@end

@interface FixPassWordCell () <UITextFieldDelegate>
{
    UITextField * _inputField;
    UILabel     * _titleLabel;
    FixPassWordInfo * _info;
}
@end

@implementation FixPassWordCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.accessoryType = UITableViewCellAccessoryNone;
        
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
    _titleLabel.sd_layout.leftSpaceToView(self.contentView, 20).centerYEqualToView(self.contentView).widthIs(96).heightRatioToView(self.contentView, 1);

    _inputField = [[UITextField alloc] init];
    _inputField.font = [UIFont systemFontOfSize:18];
    _inputField.textColor = [UIColor blackColor];
    _inputField.keyboardType = UIKeyboardTypeNumberPad;
    _inputField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _inputField.returnKeyType = UIReturnKeyDone;
    UIView * leftView = [[UIView alloc] init];
    leftView.width = 20;
    _inputField.leftView = leftView;
    _inputField.leftViewMode = UITextFieldViewModeAlways;
    _inputField.secureTextEntry = YES;
    _inputField.delegate = self;
    [self.contentView addSubview:_inputField];
    _inputField.sd_layout.leftSpaceToView(_titleLabel, 0).topEqualToView(self.contentView).rightSpaceToView(self.contentView, 0).bottomEqualToView(self.contentView);
}

- (void)reloadFixPassWordCellWithInfo:(FixPassWordInfo *)info
{
    _info = info;
    _titleLabel.text = info.titleString;
    _inputField.placeholder = info.placeString;
    _inputField.text = info.inputString;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    _info.inputString = textField.text;
}

@end
