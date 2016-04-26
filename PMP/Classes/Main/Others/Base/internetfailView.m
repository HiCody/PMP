//
//  internetfailView.m
//  PMP
//
//  Created by mac on 16/1/22.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "internetfailView.h"

@implementation internetfailView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(WinWidth/3,20,WinWidth/3, 80)];
        img.contentMode =  UIViewContentModeCenter;
        img.image = [UIImage imageNamed:@"pic_page_netnotwork(1).png"];
        [self addSubview:img];
        
        UILabel* lbl = [[UILabel alloc] init];
        lbl.text = @"网络好像有点不给力哦。";
        lbl.textColor = [UIColor lightGrayColor];
        lbl.font = [UIFont systemFontOfSize:15];
        lbl.frame = CGRectMake(W(80),CGRectGetMaxY(img.frame), WinWidth-W(160), H(60));
        lbl.textAlignment = NSTextAlignmentCenter;
         [self addSubview:lbl];
        
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [btn setTitle:@"重试" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.frame =  CGRectMake(W(80),CGRectGetMaxY(lbl.frame), WinWidth-W(160), H(60));
        btn.backgroundColor =  [UIColor lightGrayColor];
        [ btn.layer setMasksToBounds:YES];
        [btn.layer setBorderWidth:1.0];//边框宽度
        btn.layer.cornerRadius = 8.0;
        btn.layer.borderColor =[[UIColor lightGrayColor]CGColor];
        [btn addTarget:self action:@selector(reload:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];

        
       
    }
    return self;
}

-(void)reload:(UIButton *)btn{
  
    

}


@end
