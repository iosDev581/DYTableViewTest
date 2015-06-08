//
//  GoCommentRichView.h
//  DYTableViewTest
//
//  Created by libin on 15/6/7.
//  Copyright (c) 2015年 launch.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoCommentModel.h"

@interface GoCommentRichView : UIView

+ (CGFloat)heightForCommentModel:(GoCommentModel *)commentModel;
- (void)setupByCommentModel:(GoCommentModel *)commentModel;

+ (CGFloat)heightForCommentModels:(NSArray *)commentModels;
- (void)setupByCommentModels:(NSArray *)commentModels;
@end
