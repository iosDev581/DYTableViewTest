//
//  ViewController.m
//  DYTableViewTest
//
//  Created by libin on 15/6/6.
//  Copyright (c) 2015年 launch.com. All rights reserved.
//

#import "ViewController.h"
#import "TestTableViewCell.h"
#import "GoCommentModel.h"

#define UIScreenHeight [UIScreen mainScreen].bounds.size.height
#define UIScreenWidth [UIScreen mainScreen].bounds.size.width

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *models;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    GoCommentModel *commentModel = [[GoCommentModel alloc] init];
    commentModel.fName = @"张三张三张三张三张三张三张三张三三张三张三张三三张三张三张三三张三张三张三三张三张三张三三张三张三张三";
    commentModel.tName = @"李四李四李四李四李四李四";
    commentModel.content = @"前面前面前面前面前面前面ttttttttsdfaeatesttttttttttttsdfaeatesttt 前面前面前面前面 前面前面前面前面ttt 前面 前面    前面前面前面前面前面前面前面前面 中间 中间ttttttttttttsdfaeatesttttttttttttsdfaeatesttttttttttttsdfaeatestttt前面前面前面前面前面！！！！";
    commentModel.fUserId = @"123";
    commentModel.tUserId = @"456";
    _models = @[commentModel];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, UIScreenHeight - 64.0) style:UITableViewStylePlain];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.backgroundView = nil;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDataSource,UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_models count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ([TestTableViewCell heightForCommentModel:[_models firstObject]]);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"DYTableViewCell";
    TestTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[TestTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    [cell setupByCommentModel:[_models firstObject]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
