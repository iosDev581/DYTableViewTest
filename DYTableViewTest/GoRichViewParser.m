//
//  GoRichViewParser.m
//  DYTableViewTest
//
//  Created by tony on 15/6/7.
//  Copyright (c) 2015年 launch.com. All rights reserved.
//

#import "GoRichViewParser.h"

@implementation GoRichViewParser

+ (NSMutableDictionary *)attributesWithConfig:(GoRichViewConfig *)config
{
    CGFloat fontSize = config.fontSize;
    CTFontRef fontRef = CTFontCreateWithName((CFStringRef)@"ArialMT", fontSize, NULL);
    CGFloat lineSpacing = config.lineSpace;
    const CFIndex kNumberOfSettings = 3;
    CTParagraphStyleSetting theSettings[kNumberOfSettings] = {
        { kCTParagraphStyleSpecifierLineSpacingAdjustment, sizeof(CGFloat), &lineSpacing },
        { kCTParagraphStyleSpecifierMaximumLineSpacing, sizeof(CGFloat), &lineSpacing },
        { kCTParagraphStyleSpecifierMinimumLineSpacing, sizeof(CGFloat), &lineSpacing }
    };
    
    CTParagraphStyleRef theParagraphRef = CTParagraphStyleCreate(theSettings, kNumberOfSettings);
    
    UIColor * textColor = config.textColor;
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    dict[(id)kCTForegroundColorAttributeName] = (id)textColor.CGColor;
    dict[(id)kCTFontAttributeName] = (__bridge id)fontRef;
    dict[(id)kCTParagraphStyleAttributeName] = (__bridge id)theParagraphRef;
    
    CFRelease(theParagraphRef);
    CFRelease(fontRef);
    return dict;
}

+ (GoRichViewCommentData *)parseCommentModels:(NSArray *)commentModels config:(GoRichViewConfig *)config
{
    NSMutableArray *commentArray = [NSMutableArray array];
    NSMutableArray *imageArray = [NSMutableArray array];
    NSMutableAttributedString *result = [[NSMutableAttributedString alloc] init];

    GoRichViewCommentContentData *comment = nil;
    NSDictionary *attriDict = [GoRichViewParser attributesWithConfig:config];
    
    for (int i = 0; i < commentModels.count; i++) {
        GoCommentModel *commentModel = [commentModels objectAtIndex:i];
        NSUInteger location = result.length;
        
        if (i != 0) {
            [result appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"]];
            location += 1;
        }
        if ([commentModel.fName length] > 0) {
            
            NSAttributedString *nameAttriString = [[NSAttributedString alloc] initWithString:commentModel.fName attributes:attriDict];
            [result appendAttributedString:nameAttriString];
            
            comment = [[GoRichViewCommentContentData alloc] init];
            comment.fName = commentModel.fName;
            comment.fUserId = commentModel.fUserId;
            comment.fRange = NSMakeRange(0, [commentModel.fName length]);
            [commentArray addObject:comment];
            
            if ([commentModel.tName length] > 0) {
                
                nameAttriString = [[NSAttributedString alloc] initWithString:@"回复" attributes:attriDict];
                [result appendAttributedString:nameAttriString];
                
                nameAttriString = [[NSAttributedString alloc] initWithString:commentModel.tName attributes:attriDict];
                [result appendAttributedString:nameAttriString];
                
                comment.tName = commentModel.tName;
                comment.tUserId = commentModel.tUserId;
                comment.tRange = NSMakeRange([commentModel.fName length] + 2, [commentModel.tName length]);
            }
            
            if ([result length] > 0) {
                NSMutableDictionary * dict = [NSMutableDictionary dictionary];
                dict[(id)kCTForegroundColorAttributeName] = (id)[UIColor blueColor].CGColor;

                NSRange range = NSMakeRange(location + comment.fRange.location, comment.fRange.length);
                [result addAttribute:(id)kCTForegroundColorAttributeName value:(id)[UIColor blueColor].CGColor range:range];
                
                if ([comment.tName length] > 0) {
                    range = NSMakeRange(location + comment.tRange.location, comment.tRange.length);
                    [result addAttribute:(id)kCTForegroundColorAttributeName value:(id)[UIColor blueColor].CGColor range:range];
                }
            }
        }
        
        if ([commentModel.content length] > 0) {
            //        [contentStr appendString:commentModel.content];
            [result appendAttributedString:[[NSAttributedString alloc] initWithString:commentModel.content attributes:attriDict]];
        }
    }
    
    
    // 创建CTFramesetterRef实例
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)result);
    
    // 获得要缓制的区域的高度
    CGSize restrictSize = CGSizeMake(config.width, CGFLOAT_MAX);
    CGSize coreTextSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0,0), nil, restrictSize, nil);
    CGFloat textHeight = coreTextSize.height;
    
    // 生成CTFrameRef实例
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0, 0, config.width, textHeight));
    
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
    CFRelease(path);
    
    // 将生成好的CTFrameRef实例和计算好的缓制高度保存到CoreTextData实例中，最后返回CoreTextData实例
    GoRichViewCommentData *commentData = [[GoRichViewCommentData alloc] init];
    commentData.ctFrame = frame;
    commentData.height = textHeight;
    commentData.content = result;
    commentData.commentsArray = commentArray;
    commentData.imageArray = imageArray;
    
    // 释放内存
    //    CFRelease(frame);
    CFRelease(framesetter);
    
    return commentData;
}

+ (GoRichViewCommentData *)parseCommentModel:(GoCommentModel *)commentModel config:(GoRichViewConfig *)config
{
    NSMutableArray *commentArray = [NSMutableArray array];
    NSMutableArray *imageArray = [NSMutableArray array];
    
    NSMutableAttributedString *result = [[NSMutableAttributedString alloc] init];
    NSMutableString *contentStr = [NSMutableString string];
    
    GoRichViewCommentContentData *comment = nil;
    NSDictionary *attriDict = [GoRichViewParser attributesWithConfig:config];
    
    if ([commentModel.fName length] > 0) {
        
//        NSDictionary *attriDict = [GoRichViewParser attributesWithConfig:config];
//        [contentStr appendString:commentModel.fName];
        
        NSAttributedString *nameAttriString = [[NSAttributedString alloc] initWithString:commentModel.fName attributes:attriDict];
        [result appendAttributedString:nameAttriString];
        
        comment = [[GoRichViewCommentContentData alloc] init];
        comment.fName = commentModel.fName;
        comment.fUserId = commentModel.fUserId;
        comment.fRange = NSMakeRange(0, [commentModel.fName length]);
        [commentArray addObject:comment];
        
        if ([commentModel.tName length] > 0) {
//            [contentStr appendFormat:@"%@%@", @"回复", commentModel.tName];
            
            nameAttriString = [[NSAttributedString alloc] initWithString:@"回复" attributes:attriDict];
            [result appendAttributedString:nameAttriString];
             
            nameAttriString = [[NSAttributedString alloc] initWithString:commentModel.tName attributes:attriDict];
            [result appendAttributedString:nameAttriString];
            
            comment.tName = commentModel.tName;
            comment.tUserId = commentModel.tUserId;
            comment.tRange = NSMakeRange([commentModel.fName length] + 2, [commentModel.tName length]);
        }
    }
    
    if ([commentModel.content length] > 0) {
//        [contentStr appendString:commentModel.content];
        [result appendAttributedString:[[NSAttributedString alloc] initWithString:commentModel.content attributes:attriDict]];
    }
    
    if ([result length] > 0) {
        if (comment) {
            
            NSMutableDictionary * dict = [NSMutableDictionary dictionary];
            dict[(id)kCTForegroundColorAttributeName] = (id)[UIColor blueColor].CGColor;
            [result addAttribute:(id)kCTForegroundColorAttributeName value:(id)[UIColor blueColor].CGColor range:comment.fRange];
            
            if ([comment.tName length] > 0) {
                [result addAttribute:(id)kCTForegroundColorAttributeName value:(id)[UIColor blueColor].CGColor range:comment.tRange];
            }
        }
    }
    
//    if ([contentStr length] > 0) {
//        // 整个文本内容样式一致
//        NSAttributedString *contentAttri = [[NSAttributedString alloc] initWithString:contentStr attributes:attriDict];
//        [result appendAttributedString:contentAttri];
//        
//        // 部分内容新增颜色字体
//        NSMutableDictionary * dict = [NSMutableDictionary dictionary];
//        dict[(id)kCTForegroundColorAttributeName] = (id)[UIColor blueColor].CGColor;
//        CTFontRef fontRef = CTFontCreateWithName((CFStringRef)@"ArialMT", 18.f, NULL);
//        dict[(id)kCTFontAttributeName] = (__bridge id)fontRef;
//        [result setAttributes:dict range:comment.fRange];
//        
//        if ([commentModel.tName length] > 0) {
//            [result setAttributes:dict range:comment.tRange];
//        }
//    }
    
    // 创建CTFramesetterRef实例
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)result);
    
    // 获得要缓制的区域的高度
    CGSize restrictSize = CGSizeMake(config.width, CGFLOAT_MAX);
    CGSize coreTextSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0,0), nil, restrictSize, nil);
    CGFloat textHeight = coreTextSize.height;
    
    // 生成CTFrameRef实例
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0, 0, config.width, textHeight));
    
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
    CFRelease(path);
    
    // 将生成好的CTFrameRef实例和计算好的缓制高度保存到CoreTextData实例中，最后返回CoreTextData实例
    GoRichViewCommentData *commentData = [[GoRichViewCommentData alloc] init];
    commentData.ctFrame = frame;
    commentData.height = textHeight;
    commentData.content = result;
    commentData.commentsArray = commentArray;
    commentData.imageArray = imageArray;
    
    // 释放内存
    //    CFRelease(frame);
    CFRelease(framesetter);
    
    return commentData;
}


@end
