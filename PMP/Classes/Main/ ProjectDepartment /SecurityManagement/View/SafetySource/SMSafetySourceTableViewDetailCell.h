//
//  SMSafetySourceTableViewDetailCell.h
//  PMP
//
//  Created by mac on 15/12/1.
//  Copyright © 2015年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SMSafetySourceDelegate <NSObject>

- (void)jumpToSecondView:(NSString *)titile;

@end

@interface SMSafetySourceTableViewDetailCell : UITableViewCell

@property(nonatomic,strong)NSArray *detailList;

@property(nonatomic,assign)CGFloat cellHeight;

@property(nonatomic,weak)id<SMSafetySourceDelegate>smDelegate;
@end
