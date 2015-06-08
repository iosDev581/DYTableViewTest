//
//  GoCommentRichView.m
//  DYTableViewTest
//
//  Created by libin on 15/6/7.
//  Copyright (c) 2015年 launch.com. All rights reserved.
//

#import "GoCommentRichView.h"
#import "GoRichViewParser.h"

typedef NS_ENUM(NSInteger, GoCommentRichViewState) {
    GoCommentRichViewStateNormal,       // 普通状态
    GoCommentRichViewStateTouching,     // 正在按下，需要弹出放大镜
    GoCommentRichViewStateSelecting     // 选中了一些文本，需要弹出复制菜单
};

@interface GoCommentRichView ()

@property (nonatomic) GoCommentRichViewState state;
@property (nonatomic, strong) GoRichViewCommentData *commentData;

@property (nonatomic) NSInteger selectionStartPosition;
@property (nonatomic) NSInteger selectionEndPosition;

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
        [self setBackgroundColor:[UIColor lightGrayColor]];
        [self setupEvents];
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

- (void)setState:(GoCommentRichViewState)state
{
    _state = state;
    [self setNeedsDisplay];
}

- (void)setupEvents {
    UIGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                  action:@selector(tapGestureAction:)];
    [self addGestureRecognizer:tapRecognizer];
    
//    UIGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self
//                                                                                             action:@selector(userLongPressedGuestureDetected:)];
//    [self addGestureRecognizer:longPressRecognizer];
    
//    UIGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
//                                                                                 action:@selector(userPanGuestureDetected:)];
//    [self addGestureRecognizer:panRecognizer];
    self.userInteractionEnabled = YES;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    if (_commentData) {

        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetTextMatrix(context, CGAffineTransformIdentity);
        CGContextTranslateCTM(context, 0, _commentData.height);
        CGContextScaleCTM(context, 1.0, -1.0);
        
        if (_state == GoCommentRichViewStateTouching) {
            [self drawBackGroudAtSelectionArea];
        }
        CTFrameDraw(_commentData.ctFrame, context);
    }
}

- (void)drawBackGroudAtSelectionArea
{
    if (_selectionStartPosition < 0 || _selectionEndPosition > self.commentData.content.length) {
        return;
    }
    CTFrameRef textFrame = self.commentData.ctFrame;
    CFArrayRef lines = CTFrameGetLines(self.commentData.ctFrame);
    if (!lines) {
        return;
    }
    CFIndex count = CFArrayGetCount(lines);
    // 获得每一行的origin坐标
    CGPoint origins[count];
    CTFrameGetLineOrigins(textFrame, CFRangeMake(0,0), origins);
    for (int i = 0; i < count; i++) {
        CGPoint linePoint = origins[i];
        CTLineRef line = CFArrayGetValueAtIndex(lines, i);
        CFRange range = CTLineGetStringRange(line);
        // 1. start和end在一个line,则直接弄完break
        if ([self isPosition:_selectionStartPosition inRange:range] && [self isPosition:_selectionEndPosition inRange:range]) {
            CGFloat ascent, descent, leading, offset, offset2;
            offset = CTLineGetOffsetForStringIndex(line, _selectionStartPosition, NULL);
            offset2 = CTLineGetOffsetForStringIndex(line, _selectionEndPosition, NULL);
            CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
            CGRect lineRect = CGRectMake(linePoint.x + offset, linePoint.y - descent, offset2 - offset, ascent + descent);
            [self fillSelectionAreaInRect:lineRect];
            break;
        }
        
        // 2. start和end不在一个line
        // 2.1 如果start在line中，则填充Start后面部分区域
        if ([self isPosition:_selectionStartPosition inRange:range]) {
            CGFloat ascent, descent, leading, width, offset;
            offset = CTLineGetOffsetForStringIndex(line, _selectionStartPosition, NULL);
            width = CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
            CGRect lineRect = CGRectMake(linePoint.x + offset, linePoint.y - descent, width - offset, ascent + descent);
            [self fillSelectionAreaInRect:lineRect];
        } // 2.2 如果 start在line前，end在line后，则填充整个区域
        else if (_selectionStartPosition < range.location && _selectionEndPosition >= range.location + range.length) {
            CGFloat ascent, descent, leading, width;
            width = CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
            CGRect lineRect = CGRectMake(linePoint.x, linePoint.y - descent, width, ascent + descent);
            [self fillSelectionAreaInRect:lineRect];
        } // 2.3 如果start在line前，end在line中，则填充end前面的区域,break
        else if (_selectionStartPosition < range.location && [self isPosition:_selectionEndPosition inRange:range]) {
            CGFloat ascent, descent, leading, width, offset;
            offset = CTLineGetOffsetForStringIndex(line, _selectionEndPosition, NULL);
            width = CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
            CGRect lineRect = CGRectMake(linePoint.x, linePoint.y - descent, offset, ascent + descent);
            [self fillSelectionAreaInRect:lineRect];
        }
    }
}

+ (CGFloat)heightForCommentModels:(NSArray *)commentModels
{
    GoRichViewConfig *config = [[GoRichViewConfig alloc] init];
    config.width = [UIScreen mainScreen].bounds.size.width;
    
    GoRichViewCommentData *commentData = [GoRichViewParser parseCommentModels:commentModels config:config];
    return commentData.height;
}

- (void)setupByCommentModels:(NSArray *)commentModels
{
    GoRichViewConfig *config = [[GoRichViewConfig alloc] init];
    config.width = [UIScreen mainScreen].bounds.size.width;
    
    _commentData = [GoRichViewParser parseCommentModels:commentModels config:config];
    [self setNeedsDisplay];
    
    CGRect frame = self.frame;
    frame.size.height = _commentData.height;
    self.frame = frame;
}

+ (CGFloat)heightForCommentModel:(GoCommentModel *)commentModel
{
    GoRichViewConfig *config = [[GoRichViewConfig alloc] init];
    config.width = [UIScreen mainScreen].bounds.size.width;
    
    GoRichViewCommentData *commentData = [GoRichViewParser parseCommentModel:commentModel config:config];
    return commentData.height;
}

- (void)setupByCommentModel:(GoCommentModel *)commentModel
{
    GoRichViewConfig *config = [[GoRichViewConfig alloc] init];
    config.width = [UIScreen mainScreen].bounds.size.width;
    
    _commentData = [GoRichViewParser parseCommentModel:commentModel config:config];
    [self setNeedsDisplay];
    
    CGRect frame = self.frame;
    frame.size.height = _commentData.height;
    self.frame = frame;
}

- (void)userTapGestureDetected:(UIGestureRecognizer *)recognizer
{
//    CGPoint point = [recognizer locationInView:self];
    
//    for (CoreTextImageData * imageData in self.data.imageArray) {
//        // 翻转坐标系，因为imageData中的坐标是CoreText的坐标系
//        CGRect imageRect = imageData.imagePosition;
//        CGPoint imagePosition = imageRect.origin;
//        imagePosition.y = self.bounds.size.height - imageRect.origin.y - imageRect.size.height;
//        CGRect rect = CGRectMake(imagePosition.x, imagePosition.y, imageRect.size.width, imageRect.size.height);
//        // 检测点击位置 Point 是否在rect之内
//        if (CGRectContainsPoint(rect, point)) {
//            NSLog(@"hint image");
//            // 在这里处理点击后的逻辑
//            NSDictionary *userInfo = @{ @"imageData": imageData };
//            [[NSNotificationCenter defaultCenter] postNotificationName:CTDisplayViewImagePressedNotification
//                                                                object:self userInfo:userInfo];
//            return;
//        }
        
//        CoreTextLinkData *linkData = [CoreTextUtils touchLinkInView:self atPoint:point data:self.data];
//        if (linkData) {
//            NSLog(@"hint link!");
//            NSDictionary *userInfo = @{ @"linkData": linkData };
//            [[NSNotificationCenter defaultCenter] postNotificationName:CTDisplayViewLinkPressedNotification
//                                                                object:self userInfo:userInfo];
//            return;
//        }
//        CoreTextCommentData *commentData = [CoreTextUtils touchCommentInView:self atPoint:point data:self.data];
//        if (commentData) {
//            NSLog(@"commentData = %@", commentData);
//        }
    
        
//    }
//else {
//        self.state = CTDisplayViewStateNormal;
//    }
}

- (void)tapGestureAction:(UITapGestureRecognizer *)recognizer
{
    CGPoint point = [recognizer locationInView:self];
    debugMethod();
    debugLog(@"state = %d", recognizer.state);
    debugLog(@"point = %@", NSStringFromCGPoint(point));
    
    CFIndex index = [GoCommentRichView touchContentOffsetInView:self atPoint:point data:self.commentData];
    if (index != -1 && index < self.commentData.content.length) {
        _selectionStartPosition = index;
        _selectionEndPosition = index + 2;
    }
    self.state = GoCommentRichViewStateTouching;
    
//    if (recognizer.state == UIGestureRecognizerStateBegan ||
//        recognizer.state == UIGestureRecognizerStateChanged) {
//        CFIndex index = [CoreTextUtils touchContentOffsetInView:self atPoint:point data:self.data];
//        if (index != -1 && index < self.data.content.length) {
//            _selectionStartPosition = index;
//            _selectionEndPosition = index + 2;
//        }
//        self.magnifierView.touchPoint = point;
//        self.state = CTDisplayViewStateTouching;
//    } else {
//        if (_selectionStartPosition >= 0 && _selectionEndPosition <= self.data.content.length) {
//            self.state = CTDisplayViewStateSelecting;
//            [self showMenuController];
//        } else {
//            self.state = CTDisplayViewStateNormal;
//        }
//    }
}

+ (CFIndex)touchContentOffsetInView:(UIView *)view atPoint:(CGPoint)point data:(GoRichViewCommentData *)data
{
    CTFrameRef textFrame = data.ctFrame;
    CFArrayRef lines = CTFrameGetLines(textFrame);
    if (!lines) {
        return -1;
    }
    CFIndex count = CFArrayGetCount(lines);
    
    // 获得每一行的origin坐标
    CGPoint origins[count];
    CTFrameGetLineOrigins(textFrame, CFRangeMake(0,0), origins);
    
    // 翻转坐标系
    CGAffineTransform transform =  CGAffineTransformMakeTranslation(0, view.bounds.size.height);
    transform = CGAffineTransformScale(transform, 1.f, -1.f);
    
    CFIndex idx = -1;
    for (int i = 0; i < count; i++) {
        CGPoint linePoint = origins[i];
        CTLineRef line = CFArrayGetValueAtIndex(lines, i);
        // 获得每一行的CGRect信息
        CGRect flippedRect = [self getLineBounds:line point:linePoint];
        CGRect rect = CGRectApplyAffineTransform(flippedRect, transform);
        
        if (CGRectContainsPoint(rect, point)) {
            // 将点击的坐标转换成相对于当前行的坐标
            CGPoint relativePoint = CGPointMake(point.x-CGRectGetMinX(rect),
                                                point.y-CGRectGetMinY(rect));
            // 获得当前点击坐标对应的字符串偏移
            idx = CTLineGetStringIndexForPosition(line, relativePoint);
        }
    }
    return idx;
}

+ (CGRect)getLineBounds:(CTLineRef)line point:(CGPoint)point {
    CGFloat ascent = 0.0f;
    CGFloat descent = 0.0f;
    CGFloat leading = 0.0f;
    CGFloat width = (CGFloat)CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
    CGFloat height = ascent + descent;
    return CGRectMake(point.x, point.y - descent, width, height);
}


- (BOOL)isPosition:(NSInteger)position inRange:(CFRange)range
{
    if (position >= range.location && position < range.location + range.length) {
        return YES;
    } else {
        return NO;
    }
}

- (void)fillSelectionAreaInRect:(CGRect)rect
{
    UIColor *bgColor = RGB(204, 221, 236);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, bgColor.CGColor);
    CGContextFillRect(context, rect);
}

@end
