//
//  SMSafetySourceView.h
//  PMP
//
//  Created by mac on 15/12/1.
//  Copyright © 2015年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMSafetySourceView : UITableView

@property(nonatomic,copy)void(^jumpToSecondView)(NSString *str);

@end
