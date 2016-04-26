//
//  BCSMSpotCheckListCell.m
//  PMP
//
//  Created by mac on 16/1/13.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "BCSMSpotCheckListCell.h"

@implementation BCSMSpotCheckListCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setInfoList:(NSArray *)infoList{
    _infoList = infoList;

    [self setUpFrame];
}

- (void)setUpFrame{
    [self removeSubViews];
    self.cellHeight=5;
    
    CGFloat width=0;
    for (int i=0;i<self.infoList.count;i++) {
        NSArray *tempArr = self.infoList[i];
        CGFloat lableHeight=0;
  
        if (i!=0) {
            self.cellHeight+=5;
        }
        CGFloat tempHeight =self.cellHeight-5;
        for (int j=1; j<tempArr.count;j++ ) {
            UILabel *lable =[[UILabel alloc] init];
            CGSize size  =[self sizeWithText:tempArr[j] font:[UIFont systemFontOfSize:14.0] maxSize:CGSizeMake(W(240), MAXFLOAT)];
            lable.font = [UIFont systemFontOfSize:14.0];
            lable.numberOfLines=0;
            lable.text  =tempArr[j];
            lable.frame = CGRectMake(50, self.cellHeight, size.width, size.height);
            self.cellHeight+=size.height+4;
            lableHeight+=size.height+4;
            [self.contentView addSubview:lable];
        }
        self.cellHeight+=5;
        if (self.cellHeight<70) {
            self.cellHeight=70;
            
        }
        if (i!=0&&lableHeight<70) {
            self.cellHeight=self.cellHeight-lableHeight+70;
        }
        
        UILabel *titleLable =[[UILabel alloc] initWithFrame:CGRectMake(11, tempHeight, 14, self.cellHeight-tempHeight)];
        titleLable.textAlignment =NSTextAlignmentCenter;
        titleLable.numberOfLines =0;
        titleLable.text = tempArr.firstObject;
        titleLable.font =[UIFont systemFontOfSize:14.0];
        [self.contentView addSubview:titleLable];
        
        UIView *lineView =[[UIView alloc] initWithFrame:CGRectMake(39.5, 0, 0.5, self.cellHeight)];
        lineView.backgroundColor=[UIColor lightGrayColor];
        [self.contentView addSubview:lineView];
        
        UIView *lineView2 =[[UIView alloc] initWithFrame:CGRectMake(50+W(240)+10, 0, 0.5, self.cellHeight)];
        lineView2.backgroundColor=[UIColor lightGrayColor];
        [self.contentView addSubview:lineView2];
        
        UIView *lineView3 =[[UIView alloc] initWithFrame:CGRectMake(0, self.cellHeight-0.5, CGRectGetMaxX(lineView2.frame), 0.5)];
        lineView3.backgroundColor=[UIColor lightGrayColor];
        [self.contentView addSubview:lineView3];
        
        width=CGRectGetMaxX(lineView2.frame);
   
    }
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(width, 0, WinWidth-width, self.cellHeight)];
    btn.enabled = self.isEditing;
    [btn setTitleColor:[UIColor colorWithHexString:@"#007AFF"] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [btn setTitle:@"请选择" forState:UIControlStateNormal];
    [self.contentView addSubview:btn];
    [btn addTarget:self action:@selector(pleaseSelect:) forControlEvents:UIControlEventTouchUpInside];
    
     CGSize size  =[self sizeWithText:@"请选择" font:[UIFont systemFontOfSize:14.0] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    
    if (self.spotInfos) {
        NSArray *arr = @[@"有",@"无",@"齐全",@"不齐全"];
        [btn setTitle:arr[self.spotInfos.spotId-1] forState:UIControlStateNormal];
    }else{
        [btn setTitle:@"请选择" forState:UIControlStateNormal];

    }
    
    
    UIView *lineView3 =[[UIView alloc] initWithFrame:CGRectMake(width+(WinWidth-width-size.width)/2, (self.cellHeight+size.height+3)/2, size.width, 1)];
    lineView3.backgroundColor=[UIColor colorWithHexString:@"#007AFF"];
    [self.contentView addSubview:lineView3];
  
}

-(void)pleaseSelect:(UIButton *)button{

    self.chooseSpotCheck(button);

}

//获取文字处理后的尺寸
-(CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize{
    NSDictionary *attrs=@{NSFontAttributeName:font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

-(void)removeSubViews{
    for (UIView *subView in self.contentView.subviews) {
        [subView removeFromSuperview];
    }
}

@end
