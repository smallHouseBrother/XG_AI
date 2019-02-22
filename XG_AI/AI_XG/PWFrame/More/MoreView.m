//
//  MoreView.m
//  AI_XG
//
//  Created by 马红杰 on 2018/7/11.
//  Copyright © 2018年 小马哥. All rights reserved.
//

#import "MoreView.h"
#import "MoreCell.h"

@interface MoreView () <UITableViewDelegate, UITableViewDataSource>
{
    NSArray * _dataArray;
}
@end

@implementation MoreView

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        
        [self addSubViews];
    }
    return self;
}

- (void)addSubViews
{
    _imageView = [[UIImageView alloc] init];
    _imageView.userInteractionEnabled = YES;
    self.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_imageView];
    _imageView.sd_layout.leftEqualToView(self).offset((BubbleWidth-BingImgWidth) / 2).topEqualToView(self).bottomEqualToView(self).widthIs(BingImgWidth);
    _imageView.transform = CGAffineTransformMakeRotation(M_PI_2);

    _tableView = [[UITableView alloc] init];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.contentInset = UIEdgeInsetsMake(150, 0, 0, 0);
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 44;
    [self addSubview:_tableView];
    _tableView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, ScreenWidth/4));
    
    [_tableView registerClass:[MoreCell class] forCellReuseIdentifier:@"MoreCell"];
}

- (void)reloadMoreViewTableWithArray:(NSArray *)dataArray
{
    _dataArray = [dataArray copy];
    
    [_tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MoreCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MoreCell"];
    
    MoreInfo * info = _dataArray[indexPath.row];
    
    [cell reloadMoreCellWithInfo:info];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MoreInfo * info = _dataArray[indexPath.row];
    
    [self.delegate MoreViewSelectIndexWithInfo:info withIndex:indexPath.row];
}

@end

