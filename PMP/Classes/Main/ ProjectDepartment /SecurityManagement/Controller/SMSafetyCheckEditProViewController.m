//
//  SMSafetyCheckEditProViewController.m
//  PMP
//
//  Created by mac on 15/12/24.
//  Copyright © 2015年 mac. All rights reserved.
//

#import "SMSafetyCheckEditProViewController.h"

@interface SMSafetyCheckEditProViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UITextView *textView;
@end

@implementation SMSafetyCheckEditProViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"新增检查问题";
    self.textView= [[UITextView alloc] initWithFrame:CGRectMake(0, 0, WinWidth, 150)];
    self.textView.font = [UIFont systemFontOfSize:17.0];
    if (self.proStr) {
        self.textView.text=self.proStr;
    }
    [self configTableView];
    
    [self confingRightBtn];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)confingRightBtn{
    self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    
    UIBarButtonItem *rightBarBtn = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(passNewProblem)];
    self.navigationItem.rightBarButtonItem  =rightBarBtn;
}

//添加新增问题
- (void)passNewProblem{
    NSString *strUrl = [self.textView.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (strUrl.length) {
        SMSafetyContentThirdDetail *thirdDetail = [[SMSafetyContentThirdDetail alloc] init];
        thirdDetail.name = strUrl;
        thirdDetail.isOpen=YES;
        thirdDetail.classID=@"-1";
        self.passNewPro(thirdDetail);
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"检查问题不能为空!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
    }
    
}

- (void)configTableView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WinWidth, WinHeight-CGRectGetMaxY(self.navigationController.navigationBar.frame)) style:UITableViewStyleGrouped];
    self.tableView.dataSource =self;
    self.tableView.delegate=self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:self.tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier =@"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }

 
    [cell.contentView addSubview:self.textView];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
 
        return 150;
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return  @"自定义检查问题:";
}

@end
