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

- (instancetype)initWithFrame:(CGRect)frame withIconName:(NSString *)iconName title:(NSString *)title
{
    if (self = [super initWithFrame:frame]) {
        _iconName = iconName;
        _title = title;
        [self setUpViews];
    }
    return self;
}

- (void)setUpViews
{
//    CGFloat kItemWidth = self.bounds.size.width;
    CGFloat kItemHeight = self.bounds.size.height;
    CGFloat iconHeight = kItemHeight / 3;
    [self addSubview:self.iconImage];
    self.iconImage.frame = CGRectMake(iconHeight, iconHeight, iconHeight, iconHeight);
    [self addSubview:self.titleLab];
    CGFloat iconMaxY = CGRectGetMaxY(self.iconImage.frame);
    self.titleLab.frame = CGRectMake(iconMaxY + (iconHeight * 3 / 4), iconHeight, iconHeight * 3, iconHeight);
    [self addSubview:self.titleLab];
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
        _titleLab.font = [UIFont systemFontOfSize:15.0];
        _titleLab.backgroundColor = [UIColor clearColor];
        
    }
    return _titleLab;
}

@end
