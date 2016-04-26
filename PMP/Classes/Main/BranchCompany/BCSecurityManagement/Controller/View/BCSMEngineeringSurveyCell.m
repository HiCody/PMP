//
//  BCSMEngineeringSurveyCell.m
//  PMP
//
//  Created by mac on 16/1/13.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "BCSMEngineeringSurveyCell.h"

@implementation BCSMEngineeringSurveyCell

+ (instancetype)cell{
    return [[NSBundle mainBundle] loadNibNamed:@"BCSMEngineeringSurveyCell" owner:nil options:nil].lastObject;
}

- (void)setSafetyCheckDetail:(BCSMSafetyCheckDetailModel *)safetyCheckDetail{
    _safetyCheckDetail = safetyCheckDetail;
    
    _areaLabel.text = [NSString stringWithFormat:@"%.1f",safetyCheckDetail.buildAreaSize];
    _costLabel.text =[NSString stringWithFormat:@"%.1f万元",safetyCheckDetail.costOfConstruction];
    _groundLabel.text =[NSString stringWithFormat:@"地上%li层",safetyCheckDetail.landUp];
    
    _undergroundLabel.text =[NSString stringWithFormat:@"地下%li层",safetyCheckDetail.landDown];
    _structureTypeLabel.text=safetyCheckDetail.strutClassName;
    _peopleNumber.text=[NSString stringWithFormat:@"%li人",safetyCheckDetail.buildPersons];
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
