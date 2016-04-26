//
//  SMSafetyCheckAddProViewController.h
//  PMP
//
//  Created by mac on 15/12/24.
//  Copyright © 2015年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMSafetyCheckFirstLevelViewController.h"
#import "SMSafetyContent.h"

@interface SMSafetyCheckAddProViewController : UIViewController

@property(nonatomic,strong)SMSafetyContent *safetyContent;

@property(nonatomic,copy)void(^passCheckPro)(SMSafetyContent *);

@property(nonatomic,strong)NSArray *compareArr;

@property(nonatomic,assign)BOOL isEditing;
@end
