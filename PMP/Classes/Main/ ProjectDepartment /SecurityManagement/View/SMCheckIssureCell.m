//
//  SMCheckIssureCell.m
//  PMP
//
//  Created by mac on 15/12/2.
//  Copyright © 2015年 mac. All rights reserved.
//

#import "SMCheckIssureCell.h"
#define TextFont [UIFont systemFontOfSize:15]
@implementation SMCheckIssureCell

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

- (void)setTitle:(NSString *)title{
    _title = title;
    
    _nameLable.text=title;
    
    [self setUpFrame];
}

- (void)setUpFrame{

    CGSize contentSize=[self sizeWithText:_title font:TextFont maxSize:CGSizeMake(WinWidth-15-20-10-30, MAXFLOAT)];
    if (contentSize.height<30) {
        contentSize.height=30;
    }
    _nameLable.frame=CGRectMake(15+20+30,5,contentSize.width, contentSize.height);
    _cellHeight=CGRectGetMaxY(_nameLable.frame)+5;
    
    self.selectImageView.frame = CGRectMake(15, (_cellHeight-20)/2, 20, 20);
    
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
        _nameLable.numberOfLines=0;
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
