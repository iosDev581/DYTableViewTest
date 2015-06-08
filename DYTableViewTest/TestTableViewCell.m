//
//  DYTableViewCell.m
//  DYTableViewTest
//
//  Created by libin on 15/6/6.
//  Copyright (c) 2015年 launch.com. All rights reserved.
//

#import "TestTableViewCell.h"
#import "GoCommentRichView.h"

@interface TestTableViewCell ()

@property (nonatomic, strong) GoCommentRichView *commentView;

@end

@implementation TestTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setBackgroundColor:[UIColor yellowColor]];
        _commentView = [[GoCommentRichView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [self addSubview:_commentView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

+ (CGFloat)heightForCommentModel:(GoCommentModel *)commentModel
{
    return [GoCommentRichView heightForCommentModel:commentModel];
}

- (void)setupByCommentModel:(GoCommentModel *)commentModel
{
    [_commentView setupByCommentModel:commentModel];
}

+ (CGFloat)heightForCommentModels:(NSArray *)commentModels
{
    return [GoCommentRichView heightForCommentModels:commentModels];
}
- (void)setupByCommentModels:(NSArray *)commentModels
{
    [_commentView setupByCommentModels:commentModels];
}

@end
