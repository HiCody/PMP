//
//  SMAddSafetyProCell.h
//  PMP
//
//  Created by mac on 15/12/28.
//  Copyright © 2015年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMSafetyContent.h"
@interface SMAddSafetyProCell : UITableViewCell

@property(nonatomic,strong)SMSafetyContent *content;

@property(nonatomic,assign)CGFloat cellHeight;

@property(nonatomic,copy) void(^deleteProCell)(SMSafetyContent *);
@end
