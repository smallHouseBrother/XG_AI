//
//  AddPWCell.m
//  AI_XG
//
//  Created by jrweid on 2018/6/26.
//  Copyright © 2018年 小马哥. All rights reserved.
//

#import "AddPWCell.h"
#import "AddPWInfo.h"

@interface AddPWCell () <UITextFieldDelegate>
{
    UITextField * _textInput;
    UILabel     * _titleLabel;
    AddPWInfo   * _addInfo;
}
@end

@implementation AddPWCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        [self addSubViews];
    }
    return self;
}

- (void)addSubViews
{
    UILabel * titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont systemFontOfSize:17];
    [self.contentView addSubview:_titleLabel = titleLabel];
    titleLabel.sd_layout.leftSpaceToView(self.contentView, 20).centerYEqualToView(self.contentView).widthIs(60).heightIs(44);
    
    UITextField * textInput = [[UITextField alloc] init];
    textInput.textColor = [UIColor blackColor];
    textInput.font = [UIFont systemFontOfSize:18];
    textInput.returnKeyType = UIReturnKeyDone;
    textInput.clearButtonMode = UITextFieldViewModeWhileEditing;
    textInput.delegate = self;
    [self.contentView addSubview:_textInput = textInput];
    textInput.sd_layout.leftSpaceToView(titleLabel, 0).centerYEqualToView(titleLabel).rightSpaceToView(self.contentView, 44).heightIs(44);
    
    UIButton * copy = [[UIButton alloc] init];
    [copy setImage:[UIImage imageNamed:@"copy"] forState:UIControlStateNormal];
    copy.imageEdgeInsets = UIEdgeInsetsMake(11, 11, 11, 11);
    [copy addTarget:self action:@selector(copyAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:copy];
    copy.sd_layout.topEqualToView(self.contentView).rightEqualToView(self.contentView).bottomEqualToView(self.contentView).widthIs(44);
}

- (void)reloadAddPWCellWithInfo:(AddPWInfo *)info
{
    _addInfo = info;
    _titleLabel.text = info.leftTitle;
    _textInput.placeholder = info.titlePlace;
    _textInput.text = info.titleInput;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    _addInfo.titleInput = textField.text;
}

- (void)copyAction:(UIButton *)button
{
    UIPasteboard * paste = [UIPasteboard generalPasteboard];
    paste.string = _textInput.text;
    [UIAlertView showAlertMessage:@"已复制到粘贴板~_~" andDelay:1.0f];
}

@end
