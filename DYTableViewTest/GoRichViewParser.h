//
//  GoRichViewParser.h
//  DYTableViewTest
//
//  Created by tony on 15/6/7.
//  Copyright (c) 2015年 launch.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GoRichViewConfig.h"
#import "GoCommentModel.h"
#import "GoRichViewCommentData.h"

@interface GoRichViewParser : NSObject

+ (NSMutableDictionary *)attributesWithConfig:(GoRichViewConfig *)config;
+ (GoRichViewCommentData *)parseCommentModel:(GoCommentModel *)commentModel config:(GoRichViewConfig *)config;
+ (GoRichViewCommentData *)parseCommentModels:(NSArray *)commentModels config:(GoRichViewConfig *)config;

@end
