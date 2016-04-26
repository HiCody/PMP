//
//  SMSafetyCheckSecondLevelViewController.h
//  PMP
//
//  Created by mac on 15/12/24.
//  Copyright © 2015年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMSafetyContent.h"
@interface SMSafetyCheckSecondLevelViewController : UIViewController

@property(nonatomic,strong)SMSafetyContent *safetycontent;

@property(nonatomic,copy)void(^passSecondPro)(SMSafetyContentSecondDetail *);

@end
