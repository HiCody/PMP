//
//  SMIssureCell.m
//  PMP
//
//  Created by 顾佳洪 on 15/12/2.
//  Copyright © 2015年 mac. All rights reserved.
//

#import "SMIssureCell.h"
#import "SMSafetyContent.h"
#import "SMIssureListModel.h"
#define kLableHeight 38
#define kLableWidthLeft W(100)
#define kLableWidthRight W(200)
#define kLablePadding  15
@implementation SMIssureCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setItemArr:(NSMutableArray *)itemArr{
    _itemArr = itemArr;
    
    [self setUpFrame];
    
}



- (void)setUpFrame{
    CGFloat firstHeight=0;
    for (int i =0;i<self.itemArr.count ; i++) {
        SMSafetyContent *content=self.itemArr[i];
        
        UILabel *contentLable =[[UILabel alloc] initWithFrame:CGRectMake(15, 10+firstHeight, kLableWidthLeft, kLableHeight)];
        contentLable.font =[UIFont systemFontOfSize:15.0];
        contentLable.text=@"检查内容";
        contentLable.textColor=[UIColor whiteColor];
        contentLable.textAlignment=NSTextAlignmentCenter;
        contentLable.backgroundColor=NAVI_SECOND_COLOR;
        contentLable.layer.cornerRadius=10.0;
        contentLable.layer.masksToBounds=YES;
  
        [self.contentView addSubview:contentLable];
        
        UILabel *contentDetailLable =[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(contentLable.frame)+kLablePadding, contentLable.frame.origin.y,kLableWidthRight,kLableHeight)];
        contentDetailLable.font =[UIFont systemFontOfSize:14.0];
        contentDetailLable.text=content.name;
        contentDetailLable.textColor=[UIColor lightGrayColor];
        [self.contentView addSubview:contentDetailLable];
        
        CGFloat secondHeight=0;
        for (int j=0; j<content.sections.count; j++) {
            SMSafetyContentSecondDetail *secondDetail = content.sections[j];
            UIView *dotView=[[UIView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(contentLable.frame)+secondHeight+(kLableHeight-10)/2, 8, 8)];
            dotView.backgroundColor=NAVI_SECOND_COLOR;
            dotView.layer.cornerRadius=4.0;
            [self.contentView addSubview:dotView];
            UILabel *proLable =[[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(contentLable.frame)+secondHeight,kLableWidthLeft,kLableHeight)];
            proLable.backgroundColor=[UIColor clearColor];
            proLable.textAlignment=NSTextAlignmentCenter;
            proLable.font =[UIFont systemFontOfSize:14.0];
            proLable.text=@"检查项目";
            proLable.textColor=NAVI_SECOND_COLOR;
            [self.contentView addSubview:proLable];
            
            UILabel *proDetailLable =[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(proLable.frame)+kLablePadding, proLable.frame.origin.y,kLableWidthRight,kLableHeight)];
            proDetailLable.numberOfLines=0;
            proDetailLable.font =[UIFont systemFontOfSize:14.0];
            proDetailLable.text=secondDetail.name;
            proDetailLable.textColor=[UIColor lightGrayColor];
            [self.contentView addSubview:proDetailLable];
            
            CGFloat thirdHeight=0;
            for (int h=0; h<secondDetail.sections.count; h++) {
              
                SMSafetyContentThirdDetail *thirdDetail=secondDetail.sections[h];
                
                UILabel *issureLable =[[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(proLable.frame)+thirdHeight,kLableWidthLeft,kLableHeight)];
                 issureLable.textAlignment=NSTextAlignmentCenter;
                issureLable.font =[UIFont systemFontOfSize:14.0];
                issureLable.text=@"检查问题";
                issureLable.textColor=[UIColor lightGrayColor];
                [self.contentView addSubview:issureLable];
                
                UILabel *issureDetailLable =[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(issureLable.frame)+kLablePadding, issureLable.frame.origin.y,kLableWidthRight,kLableHeight)];
                 issureDetailLable.numberOfLines=0;
                issureDetailLable.font =[UIFont systemFontOfSize:14.0];
                issureDetailLable.text=thirdDetail.name;
                issureDetailLable.textColor=[UIColor lightGrayColor];
                [self.contentView addSubview:issureDetailLable];
                
                thirdHeight+=kLableHeight;
                
                if (j==content.sections.count-1&&h==secondDetail.sections.count-1) {
                    firstHeight+=CGRectGetMaxY(issureLable.frame);
                }
                if (i==self.itemArr.count-1&&j==content.sections.count-1&&h==secondDetail.sections.count-1) {
                    self.cellHeight = CGRectGetMaxY(issureDetailLable.frame)+10;
                }
                
            }
            secondHeight+=thirdHeight+kLableHeight;
        }
      
    }
    

    
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    
      
    }
    return self;
}

@end
