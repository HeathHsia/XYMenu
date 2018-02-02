//
//  XYMenuItem.m
//  XYMenu
//
//  Created by FireHsia on 2018/1/26.
//  Copyright © 2018年 FireHsia. All rights reserved.
//

#import "XYMenuItem.h"


@interface XYMenuItem ()

@property (nonatomic, strong) UIImageView *iconImage; // 图标icon
@property (nonatomic, strong) UILabel *titleLab; // title
@property (nonatomic, copy) NSString *iconName;
@property (nonatomic, copy) NSString *title;

@end

@implementation XYMenuItem

- (instancetype)initWithIconName:(NSString *)iconName title:(NSString *)title
{
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
        _iconName = iconName;
        _title = title;
    }
    return self;
}

- (void)setUpViewsWithRect:(CGRect)rect
{
    self.frame = rect;
    CGFloat kItemHeight = self.bounds.size.height;
    CGFloat iconHeight = kItemHeight / 3;
    [self addSubview:self.iconImage];
    [self addSubview:self.titleLab];
    self.iconImage.frame = CGRectMake(iconHeight, iconHeight, iconHeight, iconHeight);
    CGFloat iconMaxY = CGRectGetMaxY(self.iconImage.frame);
    self.titleLab.frame = CGRectMake(iconMaxY + (iconHeight * 3 / 4), iconHeight, iconHeight * 3, iconHeight);
}

- (UIImageView *)iconImage
{
    if (!_iconImage) {
        _iconImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:_iconName]];
    }
    return _iconImage;
}

- (UILabel *)titleLab
{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.textColor = [UIColor whiteColor];
        _titleLab.text = _title;
        _titleLab.font = [UIFont systemFontOfSize:16.0];
        _titleLab.backgroundColor = [UIColor clearColor];
    }
    return _titleLab;
}

@end
