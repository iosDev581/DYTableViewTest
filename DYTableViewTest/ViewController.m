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
    
    GoCommentModel *commentModel1 = [[GoCommentModel alloc] init];
    commentModel1.fName = @"张三";
    commentModel1.tName = @"李四";
    commentModel1.content = @"123456789123456789123456789132456789123456789";
    commentModel1.fUserId = @"123";
    commentModel1.tUserId = @"456";
    
    GoCommentModel *commentModel2 = [[GoCommentModel alloc] init];
    commentModel2.fName = @"张三";
    commentModel2.tName = @"王五";
    commentModel2.content = @"123456789123456789123456789123456789123456789123456789123456789123456789123456789123456789123456789123456789123456789123456789123456789123456789123456789123456789123456789123456789123456789123456789123456789123456789123456789123456789123456789123456789123456789123456789";
    commentModel2.fUserId = @"123";
    commentModel2.tUserId = @"456";
    
    GoCommentModel *commentModel3 = [[GoCommentModel alloc] init];
    commentModel3.fName = @"王五";
    commentModel3.tName = @"李四";
    commentModel3.content = @"内容王五李四";
    commentModel3.fUserId = @"123";
    commentModel3.tUserId = @"456";
    
    _models = @[commentModel1, commentModel2, commentModel3];
    
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
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [TestTableViewCell heightForCommentModels:_models];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"DYTableViewCell";
    TestTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[TestTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    [cell setupByCommentModels:_models];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
