//
//  BCSMSecurityCheckListTableView.h
//  PMP
//
//  Created by mac on 16/1/13.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BCSMSafetyCheckDetailModel.h"
@interface BCSMSecurityCheckListTableView : UITableView

@property(nonatomic,strong)NSArray *datalist;

@property(nonatomic,strong)NSArray *sectionArr;

@property(nonatomic,copy)void(^segureToSafetyDetailVC)(BCSMSafetyCheckDetailModel *);
@end
