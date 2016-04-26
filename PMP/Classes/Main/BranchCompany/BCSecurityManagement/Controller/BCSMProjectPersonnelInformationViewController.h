//
//  BCSMProjectPersonnelInformationViewController.h
//  PMP
//
//  Created by mac on 16/1/14.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BCSMSafetyCheckDetailModel.h"
@interface BCSMProjectPersonnelInformationViewController : UIViewController

@property(nonatomic,strong)BCSMSafetyCheckDetailModel *detailModel;

@property(nonatomic,copy)void(^passPersonnelInfo)(BCSMSafetyCheckDetailModel *);

@end
