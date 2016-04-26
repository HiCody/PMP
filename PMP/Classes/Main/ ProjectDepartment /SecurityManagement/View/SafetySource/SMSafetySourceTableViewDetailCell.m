//
//  SMSafetySourceTableViewDetailCell.m
//  PMP
//
//  Created by mac on 15/12/1.
//  Copyright © 2015年 mac. All rights reserved.
//

#import "SMSafetySourceTableViewDetailCell.h"
#import "SMSafetySourceItem.h"
#define K_Orignx 0
#define K_ImageWidth (WinWidth-3*1)/4.0
#define K_Count 4
#define K_Space 1

@interface CustomBtn : UIButton

@end

@implementation CustomBtn

- (instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        self.backgroundColor=[UIColor whiteColor];
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


@implementation SMSafetySourceTableViewDetailCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
    }
    return self;
}

-(void)setDetailList:(NSArray *)detailList{
    [self removeSubViews];//因为复用cell的关系，移除之前正在被复用的cell中的视图，然后通过代码重新给cell添加子视图
    _detailList=detailList;
    NSInteger detailCount=_detailList.count;
    for (int i=0; i<detailCount; i++) {
        int row=i/K_Count;
        int col=i%K_Count;
        
        int x=K_Orignx+(K_ImageWidth+K_Space)*col;
        int y=K_Orignx+(K_ImageWidth+K_Space)*row;
        CustomBtn *btn=[[CustomBtn alloc] initWithFrame:CGRectMake(x, y, K_ImageWidth, K_ImageWidth)];
        btn.tag=i;
        [self.contentView addSubview:btn];
        SMSafetySourceDetail *detail=_detailList[i];
        if (detail.imageName.length) {
            UIImage *img=[UIImage imageNamed:detail.imageName];
            [btn setImage:img forState:UIControlStateNormal];
        }
        
        [btn setTitle:detail.name forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        if (i==detailCount-1) {
            _cellHeight=CGRectGetMaxY(btn.frame)+K_Orignx;
        }
    }
}


-(void)removeSubViews{
    for (UIView *subView in self.contentView.subviews) {
        [subView removeFromSuperview];
    }
}



-(void)btnClicked:(id)sender{
    UIButton *btn=sender;
    SMSafetySourceDetail *detail=self.detailList[btn.tag];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kSafetySource" object:detail];
    
    
}


@end
