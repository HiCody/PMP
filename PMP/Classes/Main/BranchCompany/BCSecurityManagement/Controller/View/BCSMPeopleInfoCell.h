//
//  BCSMPeopleInfoCell.h
//  PMP
//
//  Created by mac on 16/1/13.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BCSMSafetyCheckDetailModel.h"
@interface BCSMPeopleInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *managerNameLbale;
@property (weak, nonatomic) IBOutlet UILabel *managerTelLbale;

@property (weak, nonatomic) IBOutlet UILabel *technicalDirectorLabel;

@property (weak, nonatomic) IBOutlet UILabel *qualityInspectorLabel;

@property (weak, nonatomic) IBOutlet UILabel *securityOfficerLabel;
@property (weak, nonatomic) IBOutlet UILabel *technicalPhoneNum;
@property (weak, nonatomic) IBOutlet UILabel *qualityPhoneNum;
@property (weak, nonatomic) IBOutlet UILabel *securityPhoneNum;

@property(nonatomic,strong)BCSMSafetyCheckDetailModel *safetyCheckDetail;

+(instancetype)cell;
@end
