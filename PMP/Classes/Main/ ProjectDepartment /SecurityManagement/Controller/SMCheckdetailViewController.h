//
//  SMCheckdetailViewController.h
//  PMP
//
//  Created by mac on 15/12/1.
//  Copyright © 2015年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMIssureListModel.h"
#import "SMIssureAnalysisModel.h"
#import "SMIssureDetailModel.h"
#import "BaseViewController.h"
typedef NS_ENUM(NSInteger, SMCheckState) {
    IssureNotFound      = 1,
    WaitingForChecked   = 2,
    CheckUnPassed       = 3,
    CheckHasCompeleted  = 4,
};

@interface SMCheckdetailViewController : BaseViewController
@property(nonatomic,strong) Recheckproblemlist *recheckProList;

@property(nonatomic,assign)NSInteger checkId;//传入的请求参数
@property(nonatomic,assign)SMCheckState smcheckState;

@property(nonatomic,assign)BOOL read;//标记已读未读

@property(nonatomic,strong)NSString *msgId;
@end
