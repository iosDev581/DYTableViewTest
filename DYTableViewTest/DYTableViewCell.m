//
//  DYTableViewCell.m
//  DYTableViewTest
//
//  Created by libin on 15/6/6.
//  Copyright (c) 2015年 launch.com. All rights reserved.
//

#import "DYTableViewCell.h"
//#import "CTDisplayView.h"
#import "GoCommentRichView.h"

@interface DYTableViewCell ()

@property (nonatomic, strong) GoCommentRichView *commentView;

@end

@implementation DYTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _commentView = [[GoCommentRichView alloc] init];
        [self addSubview:_commentView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

+ (CGFloat)heightForCommentModel:(CommentModel *)commentModel
{
    return [GoCommentRichView heightForCommentModel:commentModel];
}

- (void)setupByCommentModel:(CommentModel *)commentModel
{
    [_commentView setupByCommentModel:commentModel];
}

@end
