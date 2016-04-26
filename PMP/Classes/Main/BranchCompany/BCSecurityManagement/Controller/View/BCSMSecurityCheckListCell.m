//
//  BCSMSecurityCheckListCell.m
//  PMP
//
//  Created by mac on 16/1/13.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "BCSMSecurityCheckListCell.h"
#define kImageWidth 44
@implementation BCSMSecurityCheckListCell
+ (instancetype)cell{
    return [[NSBundle mainBundle] loadNibNamed:@"BCSMSecurityCheckListCell" owner:nil options:nil].lastObject;
}


- (void)setDetailModel:(BCSMSafetyCheckDetailModel *)detailModel{
    _detailModel  =detailModel;
    _progressLable.text = detailModel.progress;
    
    NSInteger spotProNum=0;
    for (BCSMSpotinfos *spot in detailModel.spotInfos) {
        if (spot.spotId==2||spot.spotId==4) {
            spotProNum++;
        }
    }
    if (spotProNum) {
        
        NSString *contentStr = [NSString stringWithFormat:@"%li项存在问题",(long)spotProNum];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:contentStr];
        //设置：在0-3个单位长度内的内容显示成红色
        if (spotProNum<10) {
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, 1)];
        }
        if (spotProNum<100&&spotProNum>=10) {
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, 2)];
        }
        if (spotProNum<1000&&spotProNum>=100) {
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, 3)];
        }
        _spotLable.attributedText = str;
    }else {
         _spotLable.text  = @"不存在问题";
    }
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(65, 0, 1, 90)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:lineView];

}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
