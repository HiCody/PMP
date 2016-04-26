//
//  MaterialManagementViewController.m
//  PMP
//
//  Created by mac on 15/11/30.
//  Copyright © 2015年 mac. All rights reserved.
//

#import "MaterialManagementViewController.h"

@interface MaterialManagementViewController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>

@end

@implementation MaterialManagementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"材料管理";
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
