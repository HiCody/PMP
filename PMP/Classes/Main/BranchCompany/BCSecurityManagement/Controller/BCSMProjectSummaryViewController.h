//
//  BCSMProjectSummaryViewController.h
//  PMP
//
//  Created by mac on 16/1/14.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BCSMSafetyCheckDetailModel.h"
@interface BCSMProjectSummaryViewController : UIViewController

@property(nonatomic,strong)BCSMSafetyCheckDetailModel *detailModel;

@property(nonatomic,copy)void(^passProjectSummary)(BCSMSafetyCheckDetailModel *);

@end
