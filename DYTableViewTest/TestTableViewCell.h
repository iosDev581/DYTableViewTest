//
//  DYTableViewCell.h
//  DYTableViewTest
//
//  Created by libin on 15/6/6.
//  Copyright (c) 2015年 launch.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoCommentModel.h"

@interface TestTableViewCell : UITableViewCell

+ (CGFloat)heightForCommentModel:(GoCommentModel *)commentModel;
- (void)setupByCommentModel:(GoCommentModel *)commentModel;

@end
