//
//  SMSafetyCheckDetailCell.h
//  PMP
//
//  Created by mac on 15/12/4.
//  Copyright © 2015年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMIssureDetailModel.h"

@interface SMSafetyCheckDetailCell : UITableViewCell
@property(nonatomic,strong)Checkinfoproblemclasslist  *infoProLst;
@property(nonatomic,strong)Recheckproblemlist *recheckProList;
@property(nonatomic,strong)NSArray *recheckProArr;
@property(nonatomic,assign)CGFloat cellHeight;
@property(nonatomic,copy)void(^showImageView)(NSArray *,NSInteger);

@property(nonatomic,assign)NSInteger  proInteger;//判断是否有问题

- (void)setInfoProLst:(Checkinfoproblemclasslist *)infoProLst andRecheckproblemlist:(NSArray *)recheckProArr;

@end
