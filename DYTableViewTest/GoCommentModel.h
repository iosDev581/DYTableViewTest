//
//  CommentModel.h
//  DYTableViewTest
//
//  Created by libin on 15/6/6.
//  Copyright (c) 2015年 launch.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoCommentModel : NSObject

@property (nonatomic, strong) NSString *fName;
@property (nonatomic, strong) NSString *tName;

@property (nonatomic, strong) NSString *content;

@property (nonatomic, strong) NSString *fUserId;
@property (nonatomic, strong) NSString *tUserId;

@end
