//
//  SMPhotoTableViewItemCell.m
//  PMP
//
//  Created by mac on 15/12/1.
//  Copyright © 2015年 mac. All rights reserved.
//

#import "SMPhotoTableViewItemCell.h"

@implementation SMPhotoTableViewItemCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setCellItem:(SMPhotoItem *)cellItem{
    _cellItem=cellItem;
    self.imageView.image=[UIImage imageNamed:@"arrow_down"];
    self.textLabel.text=cellItem.date;
    self.textLabel.textColor=[UIColor lightGrayColor];
}

@end
