//
//  SMSafetySourceTableViewItemCell.m
//  PMP
//
//  Created by mac on 15/12/1.
//  Copyright © 2015年 mac. All rights reserved.
//

#import "SMSafetySourceTableViewItemCell.h"

@implementation SMSafetySourceTableViewItemCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setCellItem:(SMSafetySourceItem *)cellItem{
    _cellItem=cellItem;
    self.textLabel.font = [UIFont systemFontOfSize:14.0];
    self.textLabel.text=_cellItem.name;
}


@end
