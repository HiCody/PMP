//
//  BCSMImproveCell.m
//  PMP
//
//  Created by mac on 16/1/20.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "BCSMImproveCell.h"

@implementation BCSMImproveCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setImproveContent:(NSString *)improveContent{
    _improveContent  = improveContent;
    
    [self setUpFrame];
    
}

- (void)setUpFrame{
    [self removeSubViews];
    CGSize size = [self sizeWithText:self.improveContent font:[UIFont systemFontOfSize:14.0] maxSize:CGSizeMake(WinWidth-12*2, MAXFLOAT)];
    
    if (size.height<44) {
        size.height = 44;
    }
    CGFloat padding=0;
    if (size.height>44) {
        padding=4;
    }
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(12, padding, WinWidth-12*2, size.height)];
    
    lable.text = self.improveContent;
    lable.numberOfLines = 0;
    lable.font = [UIFont systemFontOfSize:14.0];
    lable.textColor = [UIColor blackColor];
    [self.contentView addSubview:lable];
    
    self.cellHeight = size.height+padding*2;

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
