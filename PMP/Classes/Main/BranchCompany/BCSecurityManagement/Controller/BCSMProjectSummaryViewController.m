//
//  BCSMProjectSummaryViewController.m
//  PMP
//
//  Created by mac on 16/1/14.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "BCSMProjectSummaryViewController.h"
#import "NetRequestClass.h"
#import "BCSMStructTypeModel.h"
#import "BCSMStructureTypeViewController.h"
@interface BCSMProjectSummaryViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UITextFieldDelegate>{

}
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSArray *nameArr;
@property(nonatomic,strong)UITextField *nameText;
@property (nonatomic,strong)BCSMStructTypeModel *typeModel;
@property(nonatomic,strong)NSArray *placeholderArr;
@end

@implementation BCSMProjectSummaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.title = @"工程概况编辑";
    self.nameArr =@[@"建筑面积：",@"造       价：",@"结构层数 地上：",@"                地下：",@"结构类型：",@"参建人数："];
    
    self.placeholderArr = @[@"请输入建筑面积尺寸",@"请输入造价",@"请输入结构层数",@"请输入结构层数",@"请选择结构类型",@"请输入参建人数"];
    
    
    self.typeModel = [[BCSMStructTypeModel alloc] init];
    self.typeModel.strutClassId = self.detailModel.strutClass;
    self.typeModel.strutClassName = self.detailModel.strutClassName;
    
    [self addTabelView];
    [self configRightBtn];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configRightBtn{
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:self action:nil];
    
    UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(passInfos)];
    self.navigationItem.rightBarButtonItem  = btn;
}

- (void)configData{
    
    UITextField *textField = (UITextField *)[self.view viewWithTag:100];
    self.detailModel.buildAreaSize = textField.text;
    
    UITextField *textField2 = (UITextField *)[self.view viewWithTag:101];
    self.detailModel.costOfConstruction = textField2.text;
    
    UITextField *textField3 = (UITextField *)[self.view viewWithTag:102];
    self.detailModel.landUp = textField3.text;
    
    UITextField *textField4 = (UITextField *)[self.view viewWithTag:103];
    self.detailModel.landDown = textField4.text;
    
    UITextField *textField5 = (UITextField *)[self.view viewWithTag:105];
    self.detailModel.buildPersons = textField5.text;
}


- (void)passInfos{

    self.detailModel.strutClass = self.typeModel.strutClassId;
    self.detailModel.strutClassName = self.typeModel.strutClassName;
    
    [self configData];

    
    if (!self.detailModel.buildAreaSize.length) {
        
        NSString *str = self.placeholderArr[0];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:str  delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        
    }else if (!self.detailModel.costOfConstruction.length) {
        
        NSString *str = self.placeholderArr[1];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:str  delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        
    }else if (!self.detailModel.landUp.length) {
        
        NSString *str = self.placeholderArr[2];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:str  delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        
    }else if (!self.detailModel.landDown.length) {
        
        NSString *str = self.placeholderArr[3];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:str  delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        
    }else if (!self.detailModel.strutClassName.length) {
        
        NSString *str = self.placeholderArr[4];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:str  delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        
    }else if (!self.detailModel.buildPersons.length) {
        
        NSString *str = self.placeholderArr[5];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:str  delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        
    }else{
        
        self.passProjectSummary(self.detailModel);
        
        [self.navigationController popViewControllerAnimated:YES];
    }


}


-(void)addTabelView{
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0,WinWidth, self.view.height-CGRectGetMaxY(self.navigationController.navigationBar.frame)) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];

    self.tableView.tableFooterView =[[UIView alloc] init];
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
}
#pragma mark UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return  1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.nameArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 40;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    return @"    工程概况";
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
    cell.detailTextLabel.font   =  [UIFont systemFontOfSize:15.0];
    cell.textLabel.text =self.nameArr[indexPath.row];
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(W(150), 0, WinWidth-W(170), 44)];
    textField.textAlignment = NSTextAlignmentLeft;
    textField.adjustsFontSizeToFitWidth = YES;
    textField.tag =100+indexPath.row;
    textField.placeholder =self.placeholderArr[indexPath.row];
    textField.font   =  [UIFont systemFontOfSize:15.0];
    textField.delegate =self;
    textField.keyboardType = UIKeyboardTypeNumberPad;
    
    if (indexPath.row==0) {
        textField.text = self.detailModel.buildAreaSize;
        cell.detailTextLabel.text  = @"㎡";
    }
    if (indexPath.row == 1) {
         textField.text = self.detailModel.costOfConstruction;
        cell.detailTextLabel.text  = @"万元";
    }
    
    if (indexPath.row == 2) {
        textField.frame = CGRectMake(W(160), 0, WinWidth-W(180), 44);
        textField.text = self.detailModel.landUp;
        cell.detailTextLabel.text  = @"层";
    }
    
    if (indexPath.row == 3) {
         textField.frame = CGRectMake(W(160), 0, WinWidth-W(180), 44);
        textField.text = self.detailModel.landDown;
        cell.detailTextLabel.text  = @"层";
    }
    
    if (indexPath.row ==4) {
        if (self.typeModel.strutClassName) {
            cell.detailTextLabel.text  = self.typeModel.strutClassName;
        }
        cell.accessoryType  =UITableViewCellAccessoryDisclosureIndicator;
    }
    
    if (indexPath.row == 5) {
        textField.text = self.detailModel.buildPersons;
        cell.detailTextLabel.text  = @"人";
    }
    
    
    if (indexPath.row!=4) {
        
         [cell.contentView addSubview:textField];
        
    }
   

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 4) {
 
        BCSMStructureTypeViewController *structTypeVC  = [[BCSMStructureTypeViewController alloc] init];
        
        __weak typeof(self)weakself  = self;
        structTypeVC.passStructTypeModel = ^(BCSMStructTypeModel *typeModel){
            
            weakself.typeModel =  typeModel;
            [weakself.tableView reloadData];
        };
        
        structTypeVC.typeModel  = self.typeModel;
        
        [self.navigationController pushViewController:structTypeVC animated:YES];
       
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textfield{
    
    [self configData];
    
}


@end
