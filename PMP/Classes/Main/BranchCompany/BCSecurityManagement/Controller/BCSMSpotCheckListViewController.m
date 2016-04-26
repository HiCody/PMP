//
//  BCSMSpotCheckListViewController.m
//  PMP
//
//  Created by mac on 16/1/13.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "BCSMSpotCheckListViewController.h"
#import "BCSMSpotCheckListTableView.h"
#import "BCSMSafetyCheckDetailModel.h"

@interface BCSMSpotCheckListViewController ()<UIAlertViewDelegate>{
    UIButton *chooseBtn;
    NSInteger chooseOrder;
}
@property(nonatomic,strong)BCSMSpotCheckListTableView *tableView;

@end

@implementation BCSMSpotCheckListViewController
- (NSMutableArray *)spotInfos{
    if (!_spotInfos) {
        _spotInfos = [[NSMutableArray alloc] init];
    }
    
    return _spotInfos;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"抽查一览表";
    
    [self configTableView];
    
    [self configRightBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configRightBtn{
    
    if (self.isEdit) {
        UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(passSpotInfos)];
        self.navigationItem.rightBarButtonItem  = btn;
    }

}

- (void)passSpotInfos{
    
    if (self.spotInfos.count==13) {
        
         self.passSpotCheck(self.spotInfos);
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请继续选择!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    
    }

}

- (void)configTableView{
    
    self.tableView   = [[BCSMSpotCheckListTableView alloc] initWithFrame:CGRectMake(0, 0, WinWidth, WinHeight-CGRectGetMaxY(self.navigationController.navigationBar.frame))];
    self.tableView.isEditing = self.isEdit;
    [self.view addSubview:self.tableView];
    
    if (self.spotInfos.count) {
        self.tableView.spotInfoArr = self.spotInfos;
    }
    
    __weak typeof(self)weakself = self;
    self.tableView.chooseBySpotCheck= ^(UIButton *btn,NSInteger order){
        chooseBtn =btn;
        chooseOrder = order;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请选择" message:nil delegate:weakself cancelButtonTitle:@"取消" otherButtonTitles:@"有",@"无",@"齐全",@"不齐全", nil];
        [alert show];
    };
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSArray *arr = @[@"有",@"无",@"齐全",@"不齐全"];
    if (buttonIndex!=0) {
        
        NSInteger num = 0;
        for (BCSMSpotinfos *spot in self.spotInfos) {
            if (spot.order == chooseOrder) {
                num++;
                spot.spotId = buttonIndex;
            }
        }
        if (num==0) {
            BCSMSpotinfos *spot = [[BCSMSpotinfos alloc] init];
            spot.spotId = buttonIndex;
            spot.order  = chooseOrder;
            [self.spotInfos addObject:spot];
        }
        
        [chooseBtn setTitle:arr[buttonIndex-1] forState:UIControlStateNormal];
    }
    self.tableView.spotInfoArr = self.spotInfos;
    
}

@end
