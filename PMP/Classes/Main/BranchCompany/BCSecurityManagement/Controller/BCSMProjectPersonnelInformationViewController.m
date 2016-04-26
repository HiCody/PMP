//
//  BCSMProjectPersonnelInformationViewController.m
//  PMP
//
//  Created by mac on 16/1/14.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "BCSMProjectPersonnelInformationViewController.h"

@interface BCSMProjectPersonnelInformationViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>{

}

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSArray *positionArr;
@property(nonatomic,strong)UITextField *nameText;
@end

@implementation BCSMProjectPersonnelInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.title = @"项目人员信息编辑";
    [self addTabelView];
     [self configRightBtn];
    self.positionArr =@[@"姓名：",@"电话："];
 }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configRightBtn{
    UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(passInfos)];
    self.navigationItem.rightBarButtonItem  = btn;
}


- (void)passInfos{
    [self configData];
    
    if (!self.detailModel.manageManName.length) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入项目经理姓名且不要有空格"  delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        
    }else if(!self.detailModel.manageManTel.length||![self checkTel:self.detailModel.manageManTel]){
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入正确的手机号码（项目经理）"  delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        
    }else if(!self.detailModel.technologyManName.length){
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入技术负责人姓名且不要有空格"  delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        
    }else if(!self.detailModel.technologyManTel.length||![self checkTel:self.detailModel.technologyManTel]){
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入正确的手机号码（技术负责人）"  delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        
    }else if(!self.detailModel.qualityManName.length){
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入质检员姓名且不要有空格"  delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        
    }else if(!self.detailModel.qualityManTel.length||![self checkTel:self.detailModel.qualityManTel]){
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入正确的手机号码（质检员）"   delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        
    }else if(!self.detailModel.safetyManName.length){
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入安全员姓名且不要有空格"  delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        
    }else if(!self.detailModel.safetyManTel.length ||![self checkTel:self.detailModel.safetyManTel]){
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入正确的手机号码（安全员）"   delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        
    }else{
        
        self.passPersonnelInfo(self.detailModel);
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    
}

- (BOOL)checkTel:(NSString *)str{
//    if ([str length] == 0) {
//        
//        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"data_null_prompt", nil) message:NSLocalizedString(@"tel_no_null", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        
//        [alert show];
//    
//        return NO;
//        
//    }
    
    NSString *regex = @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0,5-9]))\\d{8}$";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    BOOL isMatch = [pred evaluateWithObject:str];
    
    if (!isMatch) {
        
//        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入正确的手机号码" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        
//        [alert show];
        
        return NO;
        
    }

    return YES;
}


- (NSString *)replacingOccurrences:(NSString *)str{
    NSString *strUrl = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    return  strUrl;
}

-(void)addTabelView{
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0,WinWidth, self.view.height-CGRectGetMaxY(self.navigationController.navigationBar.frame)) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, WinWidth, 40)];
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
}
#pragma mark UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return  4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
       return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 40;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
  switch (section) {
    case 0:
        return @"    项目经理";
        break;
    case 1:
        return @"    技术负责人";
        break;
    case 2:
        return @"    质检员";
        break;
    case 3:
        return @"    安全员";
        break;
    
    default:
        break;
  }
     return nil;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //1,定义一个共同的标识
    static NSString *ID = @"cell";
    //2,从缓存中取出可循环利用的cell
    UITableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:ID];
    //3,如果缓存中没有可利用的cell，新建一个。
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    else{
        while ([cell.contentView.subviews lastObject] != nil) {
            [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];
            //删除并进行重新分配
        }
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.textLabel.font   =  [UIFont systemFontOfSize:15.0];
    cell.textLabel.text =self.positionArr[indexPath.row];

    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(60, 2, WinWidth-80, 40)];
    
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.adjustsFontSizeToFitWidth = YES;
    textField.font   =  [UIFont systemFontOfSize:15.0];
    textField.delegate =self;
    
    if (indexPath.row %2 ==0) {
        
        textField.placeholder =@"请输入姓名";
        
   }else{
       
        textField.placeholder =@"请输入电话";
       
        textField.keyboardType = UIKeyboardTypeNumberPad;
    }

    if (indexPath.section==0) {
        if (indexPath.row ==0) {
            textField.tag = 100;
            textField.text = self.detailModel.manageManName;
            
        }else{
             textField.tag = 101;
            textField.text = self.detailModel.manageManTel;
            
        }
    }
    
    if (indexPath.section==1) {
        if (indexPath.row ==0) {
            textField.tag = 102;
            textField.text = self.detailModel.technologyManName;
            
        }else{
            textField.tag = 103;
            textField.text = self.detailModel.technologyManTel;
            
        }
    }
    
    if (indexPath.section==2) {
        if (indexPath.row ==0) {
            textField.tag = 104;
            textField.text = self.detailModel.qualityManName;
            
        }else{
            textField.tag = 105;
            textField.text = self.detailModel.qualityManTel;
            
        }
    }
    
    if (indexPath.section==3) {
        if (indexPath.row ==0) {
            textField.tag = 106;
            textField.text = self.detailModel.safetyManName;
            
        }else{
            textField.tag = 107;
            textField.text = self.detailModel.safetyManTel;
            
        }
    }
    
    
    
    [cell.contentView addSubview:textField];
    
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  
    return 44.0;
}

- (void)textFieldDidEndEditing:(UITextField *)textfield{

    [self configData];

}

- (void)configData{
    UITextField *textField = (UITextField *)[self.view viewWithTag:100];
    self.detailModel.manageManName =[self replacingOccurrences:textField.text];
    
    UITextField *textField1 = (UITextField *)[self.view viewWithTag:101];
    self.detailModel.manageManTel = [self replacingOccurrences:textField1.text];
    
    UITextField *textField2 = (UITextField *)[self.view viewWithTag:102];
    self.detailModel.technologyManName = [self replacingOccurrences:textField2.text];
    
    UITextField *textField3 = (UITextField *)[self.view viewWithTag:103];
    self.detailModel.technologyManTel = [self replacingOccurrences:textField3.text];
    
    UITextField *textField4 = (UITextField *)[self.view viewWithTag:104];
    self.detailModel.qualityManName = [self replacingOccurrences:textField4.text];
    
    UITextField *textField5 = (UITextField *)[self.view viewWithTag:105];
    self.detailModel.qualityManTel = [self replacingOccurrences:textField5.text];
    
    UITextField *textField6 = (UITextField *)[self.view viewWithTag:106];
    self.detailModel.safetyManName = [self replacingOccurrences:textField6.text];
    
    UITextField *textField7 = (UITextField *)[self.view viewWithTag:107];
    self.detailModel.safetyManTel = [self replacingOccurrences:textField7.text];
}


@end
