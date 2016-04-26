//
//  DCSMDataCheckCell.h
//  PMP
//
//  Created by mac on 16/1/12.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BCSMSafetyCheckModel.h"
@interface DCSMDataCheckCell : UITableViewCell<UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *projectNameLable;

@property (weak, nonatomic) IBOutlet UILabel *projectManagerLable;
@property (weak, nonatomic) IBOutlet UILabel *checkTimeLable;
@property (weak, nonatomic) IBOutlet UILabel *directorLable;
@property (weak, nonatomic) IBOutlet UILabel *safetyCheckLable;
@property (weak, nonatomic) IBOutlet UILabel *checkerLable;
@property (weak, nonatomic) IBOutlet UILabel *quantityCheckLable;

@property(nonatomic,strong)BCSMSafetyCheckModel *safetyCheck;

@property(nonatomic,strong)NSString *titleStr;
@property(nonatomic,strong)NSString *telPhone;

@property(nonatomic,copy)void(^makePhone)(NSString *,NSString *);
@property (weak, nonatomic) IBOutlet UIImageView *projectManagerImage;
@property (weak, nonatomic) IBOutlet UIImageView *directorImage;
@property (weak, nonatomic) IBOutlet UIImageView *quantityImage;

@property (weak, nonatomic) IBOutlet UIImageView *safetyImage;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineWidth;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineWidth2;


+ (instancetype)cell;
@end
