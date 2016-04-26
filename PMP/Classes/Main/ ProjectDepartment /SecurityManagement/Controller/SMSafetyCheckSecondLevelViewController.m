//
//  SMSafetyCheckSecondLevelViewController.m
//  PMP
//
//  Created by mac on 15/12/24.
//  Copyright © 2015年 mac. All rights reserved.
//

#import "SMSafetyCheckSecondLevelViewController.h"
#import "SMAddSafetyCheckCell.h"
@interface SMSafetyCheckSecondLevelViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)NSArray *contentArr;

@property(nonatomic,strong)UITableView *tableView;

@end

@implementation SMSafetyCheckSecondLevelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加检查项目";
    self.contentArr = self.safetycontent.sections;
    [self configTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configTableView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WinWidth, WinHeight-CGRectGetMaxY(self.navigationController.navigationBar.frame))];
    self.tableView.dataSource =self;
    self.tableView.delegate=self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:self.tableView];
}

#pragma mark UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.contentArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    SMAddSafetyCheckCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell=[[SMAddSafetyCheckCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    SMSafetyContentSecondDetail *smsc=self.contentArr[indexPath.row];
    
    cell.nameLable.text=smsc.name;
    
    if (smsc.isOpen) {
        cell.nameLable.textColor = [UIColor lightGrayColor];
        cell.selectState=1;
    }else{
        cell.selectState=0;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SMSafetyContentSecondDetail *smsc=self.contentArr[indexPath.row];
    
    if (!smsc.isOpen) {
        smsc.isOpen=YES;
        
        self.passSecondPro(smsc);
        
        [tableView reloadRowsAtIndexPaths:@[indexPath]withRowAnimation:UITableViewRowAnimationNone];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
   
    
}


@end
