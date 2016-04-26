//
//  SMSafeCheckThirdLevelViewController.h
//  PMP
//
//  Created by mac on 15/12/24.
//  Copyright © 2015年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMSafetyContent.h"
@interface SMSafeCheckThirdLevelViewController : UIViewController

@property(nonatomic,strong)SMSafetyContentSecondDetail *secondDetail;


@property(nonatomic,copy)void(^passThirdPro)(NSArray *);
@end
