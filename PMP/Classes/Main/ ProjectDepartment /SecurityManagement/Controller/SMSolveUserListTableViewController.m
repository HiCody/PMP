//
//  SMSolveUserListTableViewController.m
//  PMP
//
//  Created by mac on 15/12/14.
//  Copyright © 2015年 mac. All rights reserved.
//

#import "SMSolveUserListTableViewController.h"
#import "NetRequestClass.h"

@interface SMSolveUserListTableViewController ()<UIAlertViewDelegate>
@property(nonatomic,strong)NSArray *solveUserArr;
@end

@implementation SMSolveUserListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"处理人员列表";
    self.tableView.tableFooterView=[[UIView alloc] init];
    [self requestQuerySolveUserList];
    
    [self coustomNavigtion];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)coustomNavigtion{
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];

//    UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
//    negativeSeperator.width = -10;
//    
//    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@""]  style:UIBarButtonItemStylePlain target:self action:@selector(searchFor:)];
//    
//    self.navigationItem.rightBarButtonItems =@[negativeSeperator, rightBarButtonItem];
//    
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.solveUserArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    SMSolveUserList *userList =self.solveUserArr[indexPath.row];
    
    if (self.solveuserlist.userId==userList.userId) {
        cell.accessoryType  =UITableViewCellAccessoryCheckmark;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.textLabel.text = userList.realName;
    

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    SMSolveUserList *userlist =self.solveUserArr[indexPath.row];
    self.passSolveUser(userlist);
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)restartLogin{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"非法请求,请重新登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag=10;
    [alert show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==10) {
        
        if (buttonIndex==1) {
            [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
        }
        
    }
    
}


- (void)requestQuerySolveUserList{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [NetRequestClass NetRequestPOSTWithRequestURL:kQuerySolveUserList WithParameter:nil WithReturnValeuBlock:^(id returnValue) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSDictionary *dict =returnValue;
        NSArray *arr = [SMSolveUserList mj_objectArrayWithKeyValuesArray:dict[@"items"]];
    
        self.solveUserArr =arr;
 
        [self.tableView reloadData];
        
    } WithErrorCodeBlock:^(id errorCode) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        NSDictionary *dict=errorCode;
        if ([dict[@"msg"] isEqualToString:@"非法请求!"]) {
            [self restartLogin];
        }
        
    } WithFailureBlock:^{
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
    }];
    
}


@end
