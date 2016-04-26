//
//  SMSafetyCheckTableViewController.h
//  PMP
//
//  Created by mac on 15/12/2.
//  Copyright © 2015年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@protocol SMSafetyCheckViewDelegate<NSObject>

- (void)SMSafetyCheckViewPassData:(NSArray *)listArr  AtIndex:(NSInteger)index;

@end

@interface SMSafetyCheckTableViewController : UIViewController

@property(nonatomic,weak)id<SMSafetyCheckViewDelegate>delegate;


@property(nonatomic,assign)NSInteger index;
@end
