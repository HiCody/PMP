//
//  BCSMStructureTypeViewController.m
//  PMP
//
//  Created by mac on 16/1/19.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "BCSMStructureTypeViewController.h"
#import "NetRequestClass.h"


@interface BCSMStructureTypeViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

@property(nonatomic,strong)NSArray *datalist;

@property(nonatomic,strong)UITableView *tableView;

@end

@implementation BCSMStructureTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.title = @"结构类型";
    
    [self queryStrutClassRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configTableView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, WinHeight-CGRectGetMaxY(self.navigationController.navigationBar.frame)) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate =self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:self.tableView];
}

#pragma mark UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datalist.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier  =@"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    BCSMStructTypeModel *typeModel = self.datalist[indexPath.row];
    
    if ([typeModel.strutClassName isEqualToString:self.typeModel.strutClassName]) {
        
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        
    }
    
    cell.textLabel.text = typeModel.strutClassName;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    cell.accessoryType  = UITableViewCellAccessoryCheckmark;
    
    BCSMStructTypeModel *typeModel  = self.datalist[indexPath.row];
    
    self.passStructTypeModel(typeModel);
    
    [self.navigationController popViewControllerAnimated:YES];
}

//结构类型
- (void)queryStrutClassRequest{
    MBProgressHUD *hud =  [MBProgressHUD showMessage:@"加载中..."];
    [NetRequestClass NetJsonRequestPOSTWithRequestURL:kQueryStrutClass WithParameter:nil WithReturnValeuBlock:^(id returnValue) {
        hud.hidden = YES;
        NSDictionary *dict = returnValue;
        NSArray *tempArr = dict[@"items"];
        
        NSArray *listArr = [BCSMStructTypeModel mj_objectArrayWithKeyValuesArray:tempArr];
        self.datalist = listArr;
        
        [self configTableView];
        
    } WithErrorCodeBlock:^(id errorCode) {
        hud.hidden = YES;
        [MBProgressHUD showError:@"请求失败" toView:self.view];
        
        NSDictionary *dict=errorCode;
        if ([dict[@"msg"] isEqualToString:@"非法请求!"]) {
            [self restartLogin];
        }
        
    } WithFailureBlock:^{
        hud.hidden = YES;
        
    }];
}

- (void)restartLogin{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"非法请求,请重新登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag=10;
    [alert show];
    
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==10) {
        
        if (buttonIndex==1) {
            [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
        }
        
    }
}


@end
