//
//  XYMenuView.m
//  XYMenu
//
//  Created by FireHsia on 2018/1/18.
//  Copyright © 2018年 FireHsia. All rights reserved.
//

#import "XYMenuView.h"
#import "XYMenuItem.h"

#define kXYMenuContentWidth self.bounds.size.width
#define kXYMenuContentHeight self.bounds.size.height

@interface XYMenuView()

@property (nonatomic, strong) UIView *contentView; // 容器View
@property (nonatomic, strong) NSArray *imagesArr;
@property (nonatomic, strong) NSArray *titlesArr;

@end

@implementation XYMenuView

#pragma mark --- 共通初始化方法
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.6];
        [self addSubview:self.contentView];
        self.contentView.frame = frame;
    }
    return self;
}

- (void)setImagesArr:(NSArray *)imagesArr titles:(NSArray *)titles
{
    _imagesArr = [NSArray arrayWithArray:imagesArr];
    _titlesArr = [NSArray arrayWithArray:titles];
    [self setMenuItems];
}

- (instancetype)init
{
    return [self initWithFrame:CGRectZero];
}

- (void)setMenuItems
{
    NSInteger count = self.titlesArr.count;
    for (int i = 0; i < count; i++) {
        XYMenuItem *item = [[XYMenuItem alloc] initWithFrame:CGRectMake(0, i * (kXYMenuContentHeight / count), kXYMenuContentWidth, kXYMenuContentHeight / count) withIconName:self.imagesArr[i] title:self.titlesArr[i]];
        [self.contentView addSubview:item];
    }
}

- (UIView *)contentView
{
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor clearColor];
    }
    return _contentView;
}

@end
