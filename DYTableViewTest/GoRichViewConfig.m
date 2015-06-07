//
//  GoRichViewConfig.m
//  DYTableViewTest
//
//  Created by tony on 15/6/7.
//  Copyright (c) 2015年 launch.com. All rights reserved.
//

#import "GoRichViewConfig.h"

@implementation GoRichViewConfig

- (id)init {
    self = [super init];
    if (self) {
        _width = 200.0f;
        _fontSize = 16.0f;
        _lineSpace = 8.0f;
        _textColor = RGB(108, 108, 108);
//        _textColor = [UIColor blueColor];
    }
    return self;
}

@end
