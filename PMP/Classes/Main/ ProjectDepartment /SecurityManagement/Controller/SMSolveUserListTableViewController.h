//
//  SMSolveUserListTableViewController.h
//  PMP
//
//  Created by mac on 15/12/14.
//  Copyright © 2015年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMSolveUserList.h"
@interface SMSolveUserListTableViewController : UITableViewController

@property(nonatomic,copy) void(^passSolveUser)(SMSolveUserList *);

@property(nonatomic,strong)SMSolveUserList *solveuserlist;
@end
