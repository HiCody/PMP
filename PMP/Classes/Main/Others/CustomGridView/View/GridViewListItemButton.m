//
//  GridViewListItemButton.m
//  jsce
//
//  Created by mac on 15/9/14.
//  Copyright (c) 2015年 Yuantu. All rights reserved.
//

#import "GridViewListItemButton.h"

@implementation GridViewListItemButton

- (instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        
        [self setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:12.0];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        
    }
    return self;
}


- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    CGFloat h = self.height * 0.5;
    CGFloat w = h;
    CGFloat x = (self.width - w) * 0.5;
    CGFloat y = self.height * 0.2;
    return CGRectMake(x, y, w, h);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    return CGRectMake(0, self.height * 0.7, self.width, self.height * 0.3);
}


@end
