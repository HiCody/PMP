//
//  SMSafetyCheckFirstLevelViewController.h
//  PMP
//
//  Created by mac on 15/12/24.
//  Copyright © 2015年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMSafetyContent.h"
@interface SMSafetyCheckFirstLevelViewController : UIViewController

@property(nonatomic,copy)void(^passFirstPro)(SMSafetyContent *);

@property(nonatomic,strong)SMSafetyContent *safetycontent;

@property(nonatomic,strong)NSArray *compareArr;
@end
