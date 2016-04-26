//
//  SMAddSafetyProCell.m
//  PMP
//
//  Created by mac on 15/12/28.
//  Copyright © 2015年 mac. All rights reserved.
//

#import "SMAddSafetyProCell.h"

#define k_LineColor [UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1.0]


#define kLableHeight2 38
#define kLableWidthLeft W(100)
#define kLableWidthRight W(200)
#define kLablePadding  15

@implementation SMAddSafetyProCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setContent:(SMSafetyContent *)content{
    _content = content;
    
    [self setUpFrame];
}

- (void)setUpFrame{
    [self removeSubViews];
    UIView *proView = [self problemViewWithSafetyContent:self.content];
    
    proView.top = 30;
    
    [self.contentView addSubview:proView];
    
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(WinWidth-80,0 , 80, 48)];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn setTitle:@"删除" forState:UIControlStateNormal];
    [btn setTitleColor:NAVI_SECOND_COLOR forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(deletePro:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:btn];
    
    self.cellHeight = CGRectGetMaxY(proView.frame);
    
}

- (UIView *)problemViewWithSafetyContent:(SMSafetyContent *)safetyContent{
    
    UIView *view = [[UIView alloc] init];
    
    CGFloat firstHeight=0;
    CGFloat proHeight = 0;
    
    SMSafetyContent *content=safetyContent;
    
    UILabel *contentLable =[[UILabel alloc] initWithFrame:CGRectMake(15,0, kLableWidthLeft, kLableHeight2)];
    
    contentLable.font =[UIFont systemFontOfSize:15.0];
    contentLable.text=@"检查内容";
    contentLable.textColor=[UIColor whiteColor];
    contentLable.textAlignment=NSTextAlignmentCenter;
    contentLable.backgroundColor=NAVI_SECOND_COLOR;
    contentLable.layer.cornerRadius=10.0;
    contentLable.layer.masksToBounds=YES;
    
    [view addSubview:contentLable];
    
    UILabel *contentDetailLable =[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(contentLable.frame)+kLablePadding, contentLable.frame.origin.y,kLableWidthRight,kLableHeight2)];
    contentDetailLable.font =[UIFont systemFontOfSize:14.0];
    contentDetailLable.text=content.name;
    contentDetailLable.textColor=[UIColor lightGrayColor];
    [view addSubview:contentDetailLable];
    
    CGFloat secondHeight=0;
    if (content.sections.count) {
        for (int j=0; j<content.sections.count; j++) {
            SMSafetyContentSecondDetail *secondDetail = content.sections[j];
            if (!secondDetail.isOpen) {
                continue;
            }
            UIView *dotView=[[UIView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(contentLable.frame)+secondHeight+(kLableHeight2-10)/2, 8, 8)];
            dotView.backgroundColor=NAVI_SECOND_COLOR;
            dotView.layer.cornerRadius=4.0;
            [view addSubview:dotView];
            UILabel *proLable =[[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(contentLable.frame)+secondHeight,kLableWidthLeft,kLableHeight2)];
            proLable.backgroundColor=[UIColor clearColor];
            proLable.textAlignment=NSTextAlignmentCenter;
            proLable.font =[UIFont systemFontOfSize:14.0];
            proLable.text=@"检查项目";
            proLable.textColor=NAVI_SECOND_COLOR;
            [view addSubview:proLable];
            
            UILabel *proDetailLable =[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(proLable.frame)+kLablePadding, proLable.frame.origin.y,kLableWidthRight,kLableHeight2)];
            proDetailLable.numberOfLines=0;
            proDetailLable.font =[UIFont systemFontOfSize:14.0];
            proDetailLable.text=secondDetail.name;
            proDetailLable.textColor=[UIColor lightGrayColor];
            [view addSubview:proDetailLable];
            
            CGFloat thirdHeight=0;
            if (secondDetail.sections.count) {
                for (int h=0; h<secondDetail.sections.count; h++) {
                    
                    SMSafetyContentThirdDetail *thirdDetail=secondDetail.sections[h];
                    if (!thirdDetail.isOpen) {
                        continue;
                    }
                    UILabel *issureLable =[[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(proLable.frame)+thirdHeight,kLableWidthLeft,kLableHeight2)];
                    issureLable.textAlignment=NSTextAlignmentCenter;
                    issureLable.font =[UIFont systemFontOfSize:14.0];
                    issureLable.text=@"检查问题";
                    issureLable.textColor=[UIColor lightGrayColor];
                    [view addSubview:issureLable];
                    
                    UILabel *issureDetailLable =[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(issureLable.frame)+kLablePadding, issureLable.frame.origin.y,kLableWidthRight,kLableHeight2)];
                    issureDetailLable.numberOfLines=0;
                    issureDetailLable.font =[UIFont systemFontOfSize:14.0];
                    issureDetailLable.text=thirdDetail.name;
                    issureDetailLable.textColor=[UIColor lightGrayColor];
                    [view addSubview:issureDetailLable];
                    
                    thirdHeight+=kLableHeight2;
                    
             
                        proHeight = CGRectGetMaxY(issureDetailLable.frame)+10;
                 
                    
                }
            }
           
             secondHeight+=thirdHeight+kLableHeight2;

    }
        
    }
    
    view.frame = CGRectMake(0, 0, WinWidth, proHeight);
    return view;
}

- (void)deletePro:(UIButton *)btn{
    
    self.deleteProCell(self.content);
    
}

-(void)removeSubViews{
    for (UIView *subView in self.contentView.subviews) {
        [subView removeFromSuperview];
    }
}

@end
