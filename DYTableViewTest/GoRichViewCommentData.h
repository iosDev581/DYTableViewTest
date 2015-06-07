//
//  GoCommentData.h
//  DYTableViewTest
//
//  Created by tony on 15/6/7.
//  Copyright (c) 2015年 launch.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoRichViewCommentImageData : NSObject

@property (strong, nonatomic) NSString *name;
@property (nonatomic) int position;

// 此坐标是 CoreText 的坐标系，而不是UIKit的坐标系
@property (nonatomic) CGRect imagePosition;

@end

@interface GoRichViewCommentContentData : NSObject

@property (nonatomic) NSInteger uniqueId;

@property (strong, nonatomic) NSString *fName;
@property (strong, nonatomic) NSString *fUserId;

@property (strong, nonatomic) NSString *tName;
@property (strong, nonatomic) NSString *tUserId;

@property (assign, nonatomic) NSRange fRange;
@property (assign, nonatomic) NSRange tRange;

@property (strong, nonatomic) NSString *content;

@end

@interface GoRichViewCommentData : NSObject

@property (assign, nonatomic) CTFrameRef ctFrame;
@property (assign, nonatomic) CGFloat height;
@property (strong, nonatomic) NSArray *imageArray;
@property (strong, nonatomic) NSArray *commentsArray;
@property (strong, nonatomic) NSAttributedString *content;

@end
