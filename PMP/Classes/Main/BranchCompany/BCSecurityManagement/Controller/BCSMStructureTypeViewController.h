//
//  BCSMStructureTypeViewController.h
//  PMP
//
//  Created by mac on 16/1/19.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BCSMStructTypeModel.h"

@interface BCSMStructureTypeViewController : UIViewController

@property (nonatomic,strong)BCSMStructTypeModel *typeModel;

@property (nonatomic,copy)void(^passStructTypeModel)(BCSMStructTypeModel *);

@end
