//
//  PMPAccountManagementViewController.m
//  PMP
//
//  Created by mac on 15/11/30.
//  Copyright © 2015年 mac. All rights reserved.
//

#import "PMPAccountManagementViewController.h"
#import "AccountModel.h"
@interface PMPAccountManagementViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSArray *listArr;
@end

@implementation PMPAccountManagementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"账号管理";
    self.listArr = @[@"清除缓存",@"关于与帮助"];
    
    [self configTableView];
    [self setUpNavBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUpNavBar{
    
    self.navigationController.navigationBar.barTintColor=[UIColor colorWithHexString:Navi_hexcolor];
    
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    NSMutableDictionary *attrs=[[NSMutableDictionary alloc]init];
    attrs[NSForegroundColorAttributeName]=[UIColor whiteColor];
    attrs[NSFontAttributeName]=[UIFont boldSystemFontOfSize:19];
    [self.navigationController.navigationBar setTitleTextAttributes:attrs];
}



- (void)configTableView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0,WinWidth, self.view.height) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.bounces=NO;
    [self.view addSubview:self.tableView];
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    loginBtn.frame =CGRectMake(20, 0, WinWidth-2*20, 40);
    
    [loginBtn setTitle:@"退出账号" forState:UIControlStateNormal];
    
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    loginBtn.backgroundColor = [UIColor redColor];
    
    [loginBtn addTarget:self action:@selector(signOut:) forControlEvents:UIControlEventTouchUpInside];
 
    UIView *aView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WinWidth, 50)];
    
    [aView addSubview:loginBtn];
    [self.tableView setTableFooterView:aView];
   
  
}

- (void)signOut:(UIButton *)button{
    UIActionSheet *sheet=[[UIActionSheet alloc]initWithTitle:@"是否退出" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确认" otherButtonTitles:nil, nil];
    [sheet showInView:self.view];
}

#pragma mark UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text =self.listArr[indexPath.row];
    cell.textLabel.font= [UIFont systemFontOfSize:15.0];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 50.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        
    }else{
        
    }
}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        AccountModel *account=[AccountModel shareAccount];
        [account loadAccountFromSanbox];
        account.userName=nil;
        account.passWord=nil;
        [account saveAccountToSanbox];
        
       [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
        
    }
}

@end
