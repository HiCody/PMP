//
//  BCSMPeopleInfoCell.m
//  PMP
//
//  Created by mac on 16/1/13.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "BCSMPeopleInfoCell.h"

@implementation BCSMPeopleInfoCell

+ (instancetype)cell{
    return [[NSBundle mainBundle] loadNibNamed:@"BCSMPeopleInfoCell" owner:nil options:nil].lastObject;
}

- (void)setSafetyCheckDetail:(BCSMSafetyCheckDetailModel *)safetyCheckDetail{
    _safetyCheckDetail = safetyCheckDetail;
    _managerNameLbale.text = safetyCheckDetail.manageManName;
    _managerTelLbale.text = safetyCheckDetail.manageManTel;
    _technicalDirectorLabel.text  =safetyCheckDetail.technologyManName;
    _technicalPhoneNum.text  =safetyCheckDetail.technologyManTel;
    _qualityInspectorLabel.text  =safetyCheckDetail.qualityManName;
    _qualityPhoneNum.text  = safetyCheckDetail.qualityManTel;
    _securityOfficerLabel.text = safetyCheckDetail.safetyManName;
    _securityPhoneNum.text = safetyCheckDetail.safetyManTel;
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
