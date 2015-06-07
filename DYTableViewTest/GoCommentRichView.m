//
//  GoCommentRichView.m
//  DYTableViewTest
//
//  Created by libin on 15/6/7.
//  Copyright (c) 2015年 launch.com. All rights reserved.
//

#import "GoCommentRichView.h"

@interface GoCommentRichViewDataSourceImage : NSObject

@property (strong, nonatomic) NSString * name;
@property (nonatomic) int position;
// 此坐标是 CoreText 的坐标系，而不是UIKit的坐标系
@property (nonatomic) CGRect imagePosition;

@end

@implementation GoCommentRichViewDataSourceImage

@end

@interface GoCommentRichViewDataSourceComment : NSObject

@property (strong, nonatomic) NSString *fName;
@property (strong, nonatomic) NSString *tName;

@property (strong, nonatomic) NSString *fUserId;
@property (strong, nonatomic) NSString *tUserId;

@property (strong, nonatomic) NSString *content;

@property (nonatomic) NSRange fNameRange;
@property (nonatomic) NSRange tNameRange;

@end

@implementation GoCommentRichViewDataSourceComment

@end

@interface GoCommentRichViewDataSource : NSObject

@property (assign, nonatomic) CTFrameRef ctFrame;
@property (assign, nonatomic) CGFloat height;
@property (strong, nonatomic) NSArray *imageArray;
@property (strong, nonatomic) NSArray *commentArray;

@property (strong, nonatomic) NSAttributedString *content;

@end

@implementation GoCommentRichViewDataSource

@end

@interface GoCommentRichView ()

@property (nonatomic, strong) GoCommentRichViewDataSource *dataSource;

@end

@implementation GoCommentRichView

- (id)init
{
    return [self initWithFrame:CGRectZero];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        [self setupEvents];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
//        [self setupEvents];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    if (_dataSource) {
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetTextMatrix(context, CGAffineTransformIdentity);
        CGContextTranslateCTM(context, 0, _dataSource.height);
        CGContextScaleCTM(context, 1.0, -1.0);
        
        CTFrameDraw(_dataSource.ctFrame, context);
    }
}

+ (CGFloat)heightForCommentModel:(CommentModel *)commentModel
{
    GoCommentRichViewDataSource *dataSource = [GoCommentRichView dataSourceByCommentModel:commentModel];
    return dataSource.height;
}

- (void)setupByCommentModel:(CommentModel *)commentModel
{
    _dataSource = [GoCommentRichView dataSourceByCommentModel:commentModel];
    [self setNeedsDisplay];
}

+ (GoCommentRichViewDataSource *)dataSourceByCommentModel:(CommentModel *)commentModel
{
//    NSMutableArray *imageArray = [NSMutableArray array];
    NSMutableArray *commentArray = [NSMutableArray array];
    
    NSMutableAttributedString *result = [[NSMutableAttributedString alloc] init];
    if ([commentModel.fName length] > 0) {
        NSDictionary *config = [GoCommentRichView attributesConfig];
        NSAttributedString *nameAttriString = [[NSAttributedString alloc] initWithString:commentModel.fName attributes:config];
        [result appendAttributedString:nameAttriString];
        
        GoCommentRichViewDataSourceComment *comment = [[GoCommentRichViewDataSourceComment alloc] init];
        comment.fName = commentModel.fName;
        comment.fUserId = commentModel.fUserId;
        comment.fNameRange = NSMakeRange(0, [commentModel.fName length]);
        [commentArray addObject:comment];
        
        if ([commentModel.tName length] > 0) {
            [result appendAttributedString:[[NSAttributedString alloc] initWithString:@"---"]];
            
            nameAttriString = [[NSAttributedString alloc] initWithString:commentModel.tName attributes:config];
            [result appendAttributedString:nameAttriString];
            
            comment.tName = commentModel.tName;
            comment.tUserId = commentModel.tUserId;
            comment.tNameRange = NSMakeRange([commentModel.fName length] + 3, [commentModel.tName length]);
        }
    }
    
    if ([commentModel.content length] > 0) {
        [result appendAttributedString:[[NSAttributedString alloc] initWithString:commentModel.content]];
    }
    
    // 创建CTFramesetterRef实例
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)result);
    
    // 获得要缓制的区域的高度
    CGSize restrictSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, CGFLOAT_MAX);
    CGSize coreTextSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0,0), nil, restrictSize, nil);
    CGFloat textHeight = coreTextSize.height;
    
    // 生成CTFrameRef实例
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, textHeight));
    
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
    CFRelease(path);
    
    // 将生成好的CTFrameRef实例和计算好的缓制高度保存到CoreTextData实例中，最后返回CoreTextData实例
    GoCommentRichViewDataSource *dataSource = [[GoCommentRichViewDataSource alloc] init];
    dataSource.ctFrame = frame;
    dataSource.height = textHeight;
    dataSource.content = result;
    dataSource.commentArray = commentArray;
    
    // 释放内存
    CFRelease(frame);
    CFRelease(framesetter);
    
    return dataSource;
}

+ (NSMutableDictionary *)attributesConfig {
    CGFloat fontSize = 14.f;
    CTFontRef fontRef = CTFontCreateWithName((CFStringRef)@"ArialMT", fontSize, NULL);
    CGFloat lineSpacing = 3.f;
    const CFIndex kNumberOfSettings = 3;
    CTParagraphStyleSetting theSettings[kNumberOfSettings] = {
        { kCTParagraphStyleSpecifierLineSpacingAdjustment, sizeof(CGFloat), &lineSpacing },
        { kCTParagraphStyleSpecifierMaximumLineSpacing, sizeof(CGFloat), &lineSpacing },
        { kCTParagraphStyleSpecifierMinimumLineSpacing, sizeof(CGFloat), &lineSpacing }
    };
    
    CTParagraphStyleRef theParagraphRef = CTParagraphStyleCreate(theSettings, kNumberOfSettings);
    
    UIColor * textColor = [UIColor redColor];
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    dict[(id)kCTForegroundColorAttributeName] = (id)textColor.CGColor;
    dict[(id)kCTFontAttributeName] = (__bridge id)fontRef;
    dict[(id)kCTParagraphStyleAttributeName] = (__bridge id)theParagraphRef;
    
    CFRelease(theParagraphRef);
    CFRelease(fontRef);
    return dict;
}


@end
