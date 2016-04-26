//
//  SMAddSafetyCheckCell.m
//  PMP
//
//  Created by mac on 15/12/2.
//  Copyright © 2015年 mac. All rights reserved.
//

#import "SMAddSafetyCheckCell.h"

@implementation SMAddSafetyCheckCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setSelectState:(MultiSelectTableViewSelectState)selectState
{
    _selectState = selectState;
    
    switch (selectState) {
        case MultiSelectTableViewSelectStateNoSelected:
            self.selectImageView.image = [UIImage imageNamed:@"arrow_unselected"];
            break;
        case MultiSelectTableViewSelectStateSelected:
            self.selectImageView.image = [UIImage imageNamed:@"arrow_selected"];
            break;
        
        default:
            break;
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.selectImageView.frame = CGRectMake(15, (self.frame.size.height-20)/2, 20, 20);
    
    
    CGSize textSize=[self sizeWithText:self.nameLable.text font:self.nameLable.font maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    
    self.nameLable.frame = CGRectMake(CGRectGetMaxX(self.selectImageView.frame) + 30,(self.frame.size.height-textSize.height)/2, textSize.width, textSize.height);

    
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        _selectImageView = [[UIImageView alloc] init];
        self.selectImageView.image = [UIImage imageNamed:@"arrow_unselected"];
        [self.contentView addSubview:_selectImageView];
        
        
        _nameLable = [[UILabel alloc] init];
        [self.contentView addSubview:_nameLable];
        
        _nameLable.font=[UIFont systemFontOfSize:15.0];
        
       
    }
    return self;
}


//获取文字处理后的尺寸
- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize{
    NSDictionary *attrs=@{NSFontAttributeName:font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}


@end
