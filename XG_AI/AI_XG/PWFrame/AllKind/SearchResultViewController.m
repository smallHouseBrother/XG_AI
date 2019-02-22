//
//  SearchViewController.m
//  AI_XG
//
//  Created by jrweid on 2018/6/13.
//  Copyright © 2018年 小马哥. All rights reserved.
//

#import "SearchResultViewController.h"

@interface SearchResultViewController () //<UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchControllerDelegate>

@property (nonatomic, strong) UITableView * tableView;

// 数据源数组
@property (nonatomic, strong) NSArray * dataArray;
// 搜索结果数组

@end

@implementation SearchResultViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setBackItem];
    
    self.title = @"搜索";
    
    self.view.backgroundColor = [UIColor greenColor];
    /*self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView = [[UITableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(64, 0, 0, 0));
    
    self.dataArray = [NSMutableArray arrayWithObjects:@"大兴", @"丰台", @"海淀", @"朝阳", @"东城", @"崇文", @"西城", @"石景山",@"通州", @"密云", @"迪拜", @"华仔", @"三胖子", @"大连",  nil];*/
}


/*- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
    }

        cell.textLabel.text = [self.dataArray objectAtIndex:indexPath.row];
 
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    NSLog(@"选择了列表中的%@", [self.dataArray objectAtIndex:indexPath.row]);
}*/

@end
