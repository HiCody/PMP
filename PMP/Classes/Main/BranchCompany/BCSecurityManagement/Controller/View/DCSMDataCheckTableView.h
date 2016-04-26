//
//  SMDataCheckTableView.h
//  PMP
//
//  Created by mac on 16/1/12.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BCSMSafetyCheckModel.h"
@interface DCSMDataCheckTableView : UITableView

@property(nonatomic,strong)NSArray *datalist;


@property(nonatomic,copy)void(^segureToSecurityCheckListVC)(BCSMSafetyCheckModel *);
@end
