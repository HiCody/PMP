//
//  BCSMSecurityCheckListViewController.m
//  PMP
//
//  Created by mac on 16/1/13.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "BCSMSecurityCheckListViewController.h"
#import "BCSMSecurityCheckListTableView.h"
#import "BCSMSafetyCheckModel.h"
#import "BCSMSafetyCheckDetailViewController.h"
#import "BCSMAddSafetyCheckViewController.h"
#import "NetRequestClass.h"
#import "BCSMSafetyCheckDetailModel.h"
#import "NotfindView.h"
@interface BCSMSecurityCheckListViewController (){
    
    NSInteger page;//tableview的加载数
    
    NSInteger total;//各个tableview对应的总的页数
    
}
@property(nonatomic,strong)BCSMSecurityCheckListTableView *tableView;
@property(nonatomic,strong)UIButton *editBtn;//编辑按钮
@property(nonatomic,strong)NSMutableArray *infoList;
@property(nonatomic,strong)NSMutableArray *sectionList;
@property(nonatomic,strong)NotfindView *notfindView;
@end

@implementation BCSMSecurityCheckListViewController
- (NSMutableArray *)infoList{
    if (!_infoList) {
        _infoList = [[NSMutableArray alloc] init];
    }
    return _infoList;
}

- (NSMutableArray *)sectionList{
    if (!_sectionList) {
        _sectionList = [[NSMutableArray alloc] init];
    }
    return _sectionList;
}

- (UIButton *)editBtn{
    if (!_editBtn) {
        _editBtn = [[UIButton alloc] init];
        
        UserInfo *userInfo=[UserInfo shareUserInfo];
        NSArray *arr =[userInfo.right componentsSeparatedByString:@";"];
        if ([arr containsObject:@"10053"]) {
            
            [_editBtn setImage:[UIImage imageNamed:@"new_application.png"] forState:UIControlStateNormal];
            _editBtn.frame = CGRectMake(W(300), WinHeight-H(160),W(60), H(60));
            _editBtn.layer.cornerRadius = 5.0;
            _editBtn.layer.shadowOffset = CGSizeMake(4.0f, 4.0f);
            _editBtn.layer.shadowOpacity = 0.5;
            _editBtn.layer.shadowColor =  [UIColor blackColor].CGColor;
            [_editBtn addTarget:self action:@selector(editProject:) forControlEvents:UIControlEventTouchUpInside];
            
        }
       
    }
    return  _editBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    self.title = @"安全检查一览";
    page = 1;
    [self configTableView];
    [self setUpBackBtn];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTableView:) name:@"kSecurityCheckList" object:nil];
}

- (void)refreshTableView:(NSNotification *)notification{
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUpBackBtn{
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
}

- (void)configTableView{
    
    self.tableView = [[BCSMSecurityCheckListTableView alloc] initWithFrame:CGRectMake(0,0 , WinWidth, WinHeight-CGRectGetMaxY(self.navigationController.navigationBar.frame)) style:UITableViewStylePlain];
    [self.view addSubview: self.tableView];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadNewData];
    }];
    self.notfindView =[[NotfindView alloc]initWithFrame:CGRectMake(0, 0, WinWidth, WinHeight)];
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadLastData方法）
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreDate)];
    
    [self.tableView.mj_header beginRefreshing];
    
    __weak typeof(self)weakself = self;
    self.tableView.segureToSafetyDetailVC=^(BCSMSafetyCheckDetailModel *safetyCheck){
        
        BCSMSafetyCheckDetailViewController *checkDetailVC =[[BCSMSafetyCheckDetailViewController alloc] init];
        
//        for (BCSMCompanycheckdetails *checkDetails in safetyCheck.companyCheckDetails) {
//            NSLog(@"%li-%li",safetyCheck.companyCheckDetails.count,checkDetails.classType);
// 
//        }
        
        checkDetailVC.detailModel  = safetyCheck;
        [weakself.navigationController pushViewController:checkDetailVC animated:YES];
    }; 

     [ self.view addSubview:self.editBtn];
}

//跳转到新增安全详细界面
-(void)editProject:(UIButton *)button{
    
    BCSMAddSafetyCheckViewController *smAscVC=[[BCSMAddSafetyCheckViewController alloc] init];
    smAscVC.companyId = self.companyId;
    [self.navigationController pushViewController:smAscVC animated:YES];
    
}

//刷新
- (void)loadNewData{
    
    page = 1;
    
    [self queryCompanyCheckInfoRequset];
    
}

//加载
- (void)loadMoreDate{
    if (page<total) {
        
        page++;
        
        [self queryCompanyCheckInfoRequset];
        
    }else{
        page =total;
        
        // 拿到当前的上拉刷新控件，变为没有更多数据的状态
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        
    }
    
}

- (void)queryCompanyCheckInfoRequset{
    NSString *pageStr = [NSString stringWithFormat:@"%li",(long)page];
    NSDictionary *parameters  = @{@"page":pageStr,
                                  @"rows":@"6",
                                  @"companySubId":self.companyId,
                                  @"strutClass":@"-1"
                                  };
    [NetRequestClass NetRequestGETWithRequestURL:kQueryCompanyCheckInfo WithParameter:parameters WithReturnValeuBlock:^(id returnValue) {
        
        NSDictionary *dict= returnValue;
        
        NSDictionary *contentDict=dict[@"items"];
        
        NSString *totalStr = contentDict[@"total"];
        total = totalStr.integerValue;
        
        NSArray *tempArr=contentDict[@"rows"];
        NSMutableArray *templist = [[NSMutableArray alloc] init];
        NSMutableArray *sectionlist = [[NSMutableArray alloc] init];
        for (NSDictionary *dict1 in tempArr) {
            NSString *ym = dict1[@"ym"];
            NSArray *companyCheckInfosArr =dict1[@"companyCheckInfos"];
            
            NSMutableArray *tempArr2=[[NSMutableArray alloc] init];
            for (NSDictionary *dict2 in companyCheckInfosArr) {
                 BCSMSafetyCheckDetailModel *detail = [BCSMSafetyCheckDetailModel mj_objectWithKeyValues:dict2];
                
                for (BCSMCompanycheckdetails *detail1 in detail.companyCheckDetails) {
                    NSArray *arr = dict2[@"companyCheckDetails"];
                    
                    for (NSDictionary *dict4 in arr) {
                         NSString *detailId = dict4[@"detailId"];
                        if (detail1.detailId== detailId.integerValue) {
                            NSString *classType = dict4[@"classType"];
                            detail1.classType = classType.integerValue;
                        }
             
                    }

                }
                
                [tempArr2 addObject:detail];
            }
            [sectionlist addObject:ym];
            [templist addObject:tempArr2];
        }
        if ([self.tableView.mj_header isRefreshing]) {
            [self.infoList removeAllObjects];
            [self.sectionList removeAllObjects];
        }
        [self.infoList addObjectsFromArray:templist];
        [self.sectionList addObjectsFromArray:sectionlist];
        self.tableView.datalist  = [self.infoList copy];
        self.tableView.sectionArr = [self.sectionList copy];
        [self.tableView reloadData];
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        if (self.tableView.sectionArr.count ==0) {
            
            [self.tableView addSubview:self.notfindView];
             self.tableView.mj_footer.hidden = YES;
        }
        else{
            [self.notfindView  removeFromSuperview];
        }
        
    } WithErrorCodeBlock:^(id errorCode) {
        
        NSDictionary *dict=errorCode;
        if ([dict[@"msg"] isEqualToString:@"非法请求!"]) {
            [self restartLogin];
        }
        
    } WithFailureBlock:^{
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [MBProgressHUD showError:@"请求失败"];


    }];
}

//重新登录
- (void)restartLogin{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"非法请求,请重新登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
    }
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

@end
