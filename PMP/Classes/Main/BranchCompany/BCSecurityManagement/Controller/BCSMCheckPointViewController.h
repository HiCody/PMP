//
//  BCSMCheckPointViewController.h
//  PMP
//
//  Created by mac on 16/1/15.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BCSMCheckPointModel.h"

@interface BCSMCheckPointViewController : UIViewController

@property(nonatomic,copy)void(^passValue)(BCSMCheckPointModel *);

@property(nonatomic,strong)BCSMCheckPointModel *checkpoint;

@end
