//
//  BCSMSecurityCheckListCell.h
//  PMP
//
//  Created by mac on 16/1/13.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BCSMSafetyCheckDetailModel.h"

@interface BCSMSecurityCheckListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UILabel *progressLable;
@property (weak, nonatomic) IBOutlet UILabel *spotLable;

@property (weak, nonatomic) IBOutlet UILabel *dateLable;
@property (weak, nonatomic) IBOutlet UILabel *dayLable;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backWidth;

@property (strong,nonatomic) BCSMSafetyCheckDetailModel *detailModel;

+ (instancetype)cell;

@end
