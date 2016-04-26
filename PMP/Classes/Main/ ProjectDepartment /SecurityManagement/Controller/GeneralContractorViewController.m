//
//  GeneralContractorViewController.m
//  PMP
//
//  Created by mac on 15/12/7.
//  Copyright © 2015年 mac. All rights reserved.
//

#import "GeneralContractorViewController.h"
#import "SMPhotosViewController.h"
#import "NetRequestClass.h"
#import "NotfindView.h"
#import "UserInfo.h"
#import "SMMenuWithParentIdModel.h"
@interface GeneralContractorViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
@property(nonatomic,strong)UITableView *generalContractorTableView;
@property(nonatomic,strong)NSArray *dataArr;
@property(nonatomic,strong)NotfindView *notfindView;
@property(nonatomic,strong)NSMutableArray *numArr;
@end

@implementation GeneralContractorViewController
- (NSMutableArray *)numArr{
    if (!_numArr) {
        _numArr = [[NSMutableArray alloc] init];
    }
    return _numArr;
}

-(NSMutableArray *)pagesCount{
    if (!_pagesCount) {
        _pagesCount =[[NSMutableArray alloc]init];
    }
  
    return  _pagesCount;

}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    //self.title=@"总包单位证书采集";
    
//    UserInfo *userInfo=[UserInfo shareUserInfo];
//    NSArray *arr =[userInfo.right componentsSeparatedByString:@";"];
//    NSMutableArray *tempArr=[[NSMutableArray alloc] init];
//    if ([arr containsObject:@"10019"]) {
//        [tempArr addObject:@"项目经理资质资格证书"];
//        [self.numArr addObject:@"4_1"];
//    }
//    if ([arr containsObject:@"10020"]) {
//        [tempArr addObject:@"管理人员证书"];
//        [self.numArr addObject:@"4_2"];
//    }
//    if ([arr containsObject:@"10021"]) {
//        [tempArr addObject:@"特种工作人员证书"];
//        [self.numArr addObject:@"4_3"];
//    }
//    
//    if ([arr containsObject:@"10022"]) {
//        [tempArr addObject:@"企业和项目经理安全生产协议书"];
//        [self.numArr addObject:@"4_4"];
//    }
//    if ([arr containsObject:@"10023"]) {
//        [tempArr addObject:@"资质资格证书"];
//        [self.numArr addObject:@"4_5"];
//    }
//    
//    self.dataArr  =[tempArr copy];
    [self coustomNavigtion];
    
    [self setUpTableView];
    
    [self requestData];
    
   
    

    
}

- (void)viewWillAppear:(BOOL)animated{
    

}

- (void)restartLogin{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"非法请求,请重新登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
    }
}


-(void)requestData{
    NSDictionary *parameters =@{@"page":@"1",
                                @"rows":@"4",
                                @"menuId":self.menuId
                                };
    
    [NetRequestClass NetRequestGETWithRequestURL:kQueryMenuWithParentId WithParameter:parameters WithReturnValeuBlock:^(id returnValue) {
        NSDictionary *dic=returnValue;
        NSDictionary *dict=dic[@"items"];
        
        NSArray *tempArr =dict[@"rows"];
        
        NSArray *arr = [SMMenuWithParentIdModel mj_objectArrayWithKeyValuesArray:tempArr];
        
        
        self.dataArr  = arr;
        
        [self.generalContractorTableView reloadData];
       
        if (self.dataArr.count ==0) {
            
            [self.generalContractorTableView addSubview:self.notfindView];
        }
        else{
            [self.notfindView removeFromSuperview];
        }
        
    } WithErrorCodeBlock:^(id errorCode) {
        //NSLog(@"%@",errorCode);
        
        NSDictionary *dict=errorCode;
        if ([dict[@"msg"] isEqualToString:@"非法请求!"]) {
            [self restartLogin];
        }
        
    } WithFailureBlock:^{
        
    }];
    

}

-(void)setUpTableView{
    self.generalContractorTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    self.generalContractorTableView.dataSource=self;
    self.generalContractorTableView.delegate=self;
    
    [self.view addSubview:self.generalContractorTableView];
    
    
    //添加没有数据时候的视图
    self.notfindView=[[NotfindView alloc]initWithFrame:CGRectMake(0, 0, WinWidth, WinHeight)];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)coustomNavigtion{
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    
    
    UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSeperator.width = -10;
    
    //使 self.title 居中
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@" "]  style:UIBarButtonItemStylePlain target:self action:nil];
    
    self.navigationItem.rightBarButtonItems =@[negativeSeperator, rightBarButtonItem];
    
    
}



#pragma mark TableViewDelegate

//每个 section 的行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

//section 的个数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArr.count;
}

//cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}


//选中事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SMPhotosViewController *pohotoVC=[[SMPhotosViewController alloc]init];
     SMMenuWithParentIdModel *menu  = self.dataArr[indexPath.section];
    pohotoVC.title=menu.menuName;
    pohotoVC.securityMemuid=menu.securityMemuId;
    [self.navigationController pushViewController:pohotoVC animated:YES];
}

//cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID=@"cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    SMMenuWithParentIdModel *menu  = self.dataArr[indexPath.section];
    cell.textLabel.text=menu.menuName;
    
    NSString *str;
    if (menu.count) {
         str=menu.count;
    }
   

    if (str) {
         cell.detailTextLabel.text=[NSString stringWithFormat:@"%@ 张",str];
    }else{
        cell.detailTextLabel.text=@"0 张";
    }
    
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}





@end
