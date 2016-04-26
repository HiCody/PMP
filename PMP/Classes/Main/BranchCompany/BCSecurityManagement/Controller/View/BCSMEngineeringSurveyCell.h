//
//  BCSMEngineeringSurveyCell.h
//  PMP
//
//  Created by mac on 16/1/13.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BCSMSafetyCheckDetailModel.h"
@interface BCSMEngineeringSurveyCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *areaLabel;
@property (weak, nonatomic) IBOutlet UILabel *costLabel;
@property (weak, nonatomic) IBOutlet UILabel *groundLabel;
@property (weak, nonatomic) IBOutlet UILabel *undergroundLabel;
@property (weak, nonatomic) IBOutlet UILabel *structureTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *peopleNumber;

@property(nonatomic,strong)BCSMSafetyCheckDetailModel *safetyCheckDetail;

+(instancetype)cell;

@end
