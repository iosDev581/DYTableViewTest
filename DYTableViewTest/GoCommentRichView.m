//
//  GoCommentRichView.m
//  DYTableViewTest
//
//  Created by libin on 15/6/7.
//  Copyright (c) 2015年 launch.com. All rights reserved.
//

#import "GoCommentRichView.h"
#import "GoRichViewParser.h"

@interface GoCommentRichView ()

@property (nonatomic, strong) GoRichViewCommentData *commentData;

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

- (void)setupEvents {
    UIGestureRecognizer * tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                  action:@selector(userLongPressedGuestureDetected:)];
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
        
        CTFrameDraw(_commentData.ctFrame, context);
    }
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

- (void)userLongPressedGuestureDetected:(UILongPressGestureRecognizer *)recognizer {
//    CGPoint point = [recognizer locationInView:self];
//    debugMethod();
//    debugLog(@"state = %d", recognizer.state);
//    debugLog(@"point = %@", NSStringFromCGPoint(point));
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

@end
