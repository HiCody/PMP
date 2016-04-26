//
//  SMSafetyCheckEditProViewController.h
//  PMP
//
//  Created by mac on 15/12/24.
//  Copyright © 2015年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMSafetyContent.h"
@interface SMSafetyCheckEditProViewController : UIViewController

@property(nonatomic,copy)void(^passNewPro)(SMSafetyContentThirdDetail *);

@property(nonatomic,strong)NSString *proStr;
@end
