//
//  ViewController.m
//  DYTableViewTest
//
//  Created by libin on 15/6/6.
//  Copyright (c) 2015年 launch.com. All rights reserved.
//

#import "ViewController.h"
#import "DYTableViewCell.h"
#import "CommentModel.h"

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
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, UIScreenHeight - 64.0) style:UITableViewStylePlain];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.backgroundView = nil;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    CommentModel *commentModel = [[CommentModel alloc] init];
    commentModel.fName = @"张三";
    commentModel.tName = @"李四";
    commentModel.content = @"testtttttttttttsdfaea";
    commentModel.fUserId = @"123";
    commentModel.tUserId = @"456";
    _models = @[commentModel];

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
    return [DYTableViewCell heightForCommentModel:[_models firstObject]];
//    return 44.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"DYTableViewCell";
    DYTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[DYTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
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
