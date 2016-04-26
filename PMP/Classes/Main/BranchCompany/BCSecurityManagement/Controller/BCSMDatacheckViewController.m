//
//  BCSMDatacheckViewController.m
//  PMP
//
//  Created by mac on 16/1/12.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "BCSMDatacheckViewController.h"
#import "BCSMAddSafetyCheckViewController.h"
#import "DCSMDataCheckTableView.h"
#import "BCSMSafetyCheckModel.h"
#import "BCSMSafetyCheckDetailViewController.h"
#import "BCSMSecurityCheckListViewController.h"
#import "BCSMSpotCheckListViewController.h"
#import "NetRequestClass.h"
#import "NotfindView.h"
@interface BCSMDatacheckViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchControllerDelegate,UISearchBarDelegate>{
    
    NSInteger page;//tableview的加载数
    
    NSInteger total;//各个tableview对应的总的页数
    
    BOOL isSearch;
}

@property (nonatomic,strong)DCSMDataCheckTableView *tableView;


@property(nonatomic,strong)NSMutableArray *searchArr;

@property(nonatomic,strong)NSString *searchStr;

@property(nonatomic,strong)NSMutableArray *infoList;

@property(nonatomic,strong)UISearchBar *searchBar;

@property(nonatomic,strong)NotfindView *notfindView;

@end

@implementation BCSMDatacheckViewController
- (NSMutableArray *)searchArr{
    if (!_searchArr) {
        _searchArr = [[NSMutableArray alloc] init];
    }
    return _searchArr;
}

- (NSMutableArray *)infoList{
    if (!_infoList) {
        _infoList = [[NSMutableArray alloc] init];
    }
    return _infoList;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"安全检查项目一览";
    page = 1;
    [self setUpBackBtn];
    [self configTableView];
    
    self.notfindView =[[NotfindView alloc]initWithFrame:CGRectMake(0, 0, WinWidth, WinHeight)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self setUpNavBar];
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc]init]];
}

- (void)setUpBackBtn{
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
}


- (void)setUpNavBar{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,
                                   [NAVI_SECOND_COLOR CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *imge = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.navigationController.navigationBar setBackgroundImage:imge forBarMetrics:UIBarMetricsDefault];
    
    self.navigationController.navigationBar.barTintColor = NAVI_SECOND_COLOR;
    
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    NSMutableDictionary *attrs=[[NSMutableDictionary alloc]init];
    attrs[NSForegroundColorAttributeName]=[UIColor whiteColor];
    attrs[NSFontAttributeName]=[UIFont boldSystemFontOfSize:19];
    [self.navigationController.navigationBar setTitleTextAttributes:attrs];
}

- (void)configSearchBar{

    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, WinWidth, 44.0)];
    self.searchBar.placeholder = @"请输入项目名称";
    self.searchBar.delegate = self;
    [self.view addSubview:self.searchBar];
    
}



#pragma mark UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    
    if (searchBar.showsCancelButton&&searchBar.text.length) {
        searchBar.text=nil;
        self.searchStr=@"";
        searchBar.showsCancelButton=NO;
        [self.tableView.mj_header beginRefreshing];
        return NO;
    }
    searchBar.showsCancelButton=YES;
    return YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    self.searchStr = searchBar.text;
    
    if (searchBar.text==nil) {
        self.searchStr=@"";
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    searchBar.showsCancelButton=NO;
    [self.view endEditing:YES];
    
    searchBar.text = nil;
    
    self.searchStr =@"";
    [self.tableView.mj_header beginRefreshing];
   

}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    self.searchStr = searchBar.text;
    
    if (searchBar.text==nil) {
        self.searchStr=@"";
    }
    //searchBar.showsCancelButton=NO;
    [self.tableView.mj_header beginRefreshing];
}

- (void)configTableView{
    
    [self configSearchBar];
    
    self.tableView = [[DCSMDataCheckTableView alloc] initWithFrame:CGRectMake(0,44 , WinWidth, WinHeight-CGRectGetMaxY(self.navigationController.navigationBar.frame)-44) style:UITableViewStyleGrouped];

    [self.view addSubview: self.tableView];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadNewData];
    }];
    
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadLastData方法）
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreDate)];
    
    [self.tableView.mj_header beginRefreshing];
    
    __weak typeof(self)weakself = self;
    
    self.tableView.segureToSecurityCheckListVC=^(BCSMSafetyCheckModel *safetyCheck){
  //跳转到安全检查一览
         BCSMSecurityCheckListViewController*checkDetailVC =[[BCSMSecurityCheckListViewController alloc] init];
        
        checkDetailVC.companyId  =[NSString stringWithFormat:@"%li",(long)safetyCheck.companyCheckBaseInfoHistory.companyId];
        
        [weakself.navigationController pushViewController:checkDetailVC animated:YES];
        
    };
    

}


//刷新
- (void)loadNewData{
    
    page = 1;
    

    [self queryProjectInfosRequest];
    
}

//加载
- (void)loadMoreDate{
    isSearch = NO;
    
    if (page<total) {
        
        page++;
        
        [self queryProjectInfosRequest];
        
    }else{
        
        page =total;
        
        // 拿到当前的上拉刷新控件，变为没有更多数据的状态
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        
    }
    
}


//项目一览请求
- (void)queryProjectInfosRequest{
    
    NSString *deptName;
    if (self.searchStr) {
        deptName = self.searchStr;
    }else{
        deptName = @"";
    }
   
    
    NSString *pageStr = [NSString stringWithFormat:@"%li",page];
    NSDictionary *parameters  = @{@"page":pageStr,
                                  @"rows":@"10",
                                  @"deptName":deptName
                                  };
    [NetRequestClass NetRequestGETWithRequestURL:kQueryProjectInfos WithParameter:parameters WithReturnValeuBlock:^(id returnValue) {
       
        [self.view endEditing:YES];
        
        NSDictionary *dict= returnValue;
        
        NSDictionary *contentDict=dict[@"items"];
        
        NSString *totalStr = contentDict[@"total"];
        total = totalStr.integerValue;
        
        NSArray *tempArr=contentDict[@"rows"];
        
        
            NSMutableArray *templist = [[NSMutableArray alloc] init];
            for (NSDictionary *dict1 in tempArr) {
                BCSMSafetyCheckModel *safetyCheck = [[BCSMSafetyCheckModel alloc] init];
                safetyCheck.companyName = dict1[@"companyName"];
                NSString *companyId = dict1[@"companyId"];
                safetyCheck.companyId   =companyId.integerValue;
                NSString *pCompanyId = dict1[@"pCompanyId"];
                safetyCheck.pCompanyId  = pCompanyId.integerValue;
                
                BCSMCompanycheckbaseinfohistory *infohistory = [BCSMCompanycheckbaseinfohistory mj_objectWithKeyValues:dict1[@"companyCheckBaseInfoHistory"]];
                safetyCheck.companyCheckBaseInfoHistory = infohistory;
                
                [templist addObject:safetyCheck];
            }
        
     
            
            if ([self.tableView.mj_header isRefreshing]) {
                [self.infoList removeAllObjects];
            }
            [self.infoList addObjectsFromArray:templist];
            self.tableView.datalist  = [self.infoList copy];
            
            [self.tableView reloadData];
            
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        if (self.tableView.datalist.count ==0) {
            
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
@end
