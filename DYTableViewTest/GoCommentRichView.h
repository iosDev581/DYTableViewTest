//
//  GoCommentRichView.h
//  DYTableViewTest
//
//  Created by libin on 15/6/7.
//  Copyright (c) 2015年 launch.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentModel.h"

@interface GoCommentRichView : UIView

+ (CGFloat)heightForCommentModel:(CommentModel *)commentModel;
- (void)setupByCommentModel:(CommentModel *)commentModel;

@end
