//
//  SMDatacheckViewController.m
//  PMP
//
//  Created by mac on 15/11/30.
//  Copyright © 2015年 mac. All rights reserved.
//

#import "SMDatacheckViewController.h"
#import "SMCheckedTableView.h"
#import "SMAddSafetyCheckViewController.h"
#import "SMPhotosViewController.h"
#import "SMSafetySourceView.h"
#import "SMCheckdetailViewController.h"
#import "NetRequestClass.h"
#import "SMIssureListModel.h"
#import "GeneralContractorViewController.h"
#import "SMDraftViewController.h"
#import "SMSafetySourceItem.h"
#import "NotfindView.h"
#import "SMSafetySourceItem.h"
#import "SMSafetySourceTableViewDetailCell.h"
#import "SMSafetySourceTableViewItemCell.h"
#import "SMIssureAnalysisModel.h"
#import "UIBarButtonItem+Badge.h"
#import "XIOptionSelectorView.h"
#import "XIOptionView.h"
#import "XIOtherOptionsView.h"
#import "XIColorHelper.h"
#import "SMFilterTableView.h"
#import "SMFilterRequset.h"

static NSString *itemCellIdentifier=@"cell1";//item的cell
static NSString *detailCellIdentifier=@"cell2";//detail的cell


@interface SMDatacheckViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchControllerDelegate,UISearchResultsUpdating,CheckedDelegate,UIGestureRecognizerDelegate,UIScrollViewDelegate,UIAlertViewDelegate,XIDropdownlistViewProtocol,SMFilterDelegate>{
    
    
    NSInteger index,lastIndex;//判断当前显示第几个tableView
    
    NSInteger page;//tableview的加载数
    
    NSInteger total;//各个tableview对应的总的页数
    
    XIOptionSelectorView *ddltView;
    
   // WHUCalendarPopView* _pop;
    
}
@property(nonatomic,strong)SMCheckedTableView *checkedTableView;
@property(nonatomic,strong)NotfindView *noDataView;
@property(nonatomic,strong)SMFilterRequset *filterRequest;//请求条件
@property(nonatomic,strong)SMFilterTableView *filterTableView;//筛选界面

@property(nonatomic,strong)UITableView   *safetySourceView;
@property(nonatomic,strong)NSMutableArray *contentArr;
@property(nonatomic,strong)NSMutableArray *contentForShowArr;
@property(nonatomic,strong)UISearchController *searchContoller;//搜索的controller，用来处理搜索功能
@property(nonatomic,strong)UITableViewController *searchTableVC;
@property(nonatomic,strong)NSMutableArray *filterArr;

@property(nonatomic,strong)UIButton *btn;
@property(nonatomic,strong)UserInfo *userInfo;

//@property(nonatomic,strong)KLCPopup* popup;

@property(nonatomic,assign)BOOL isHasPro;
//日期
@property(nonatomic,strong)NSString *dateString;
@property(nonatomic,strong)NSString *endDateString;


@property(nonatomic,strong)NSString *typeStr;

@end

@implementation SMDatacheckViewController
-(NSMutableArray *)contentArr{
    if (!_contentArr) {
        
        _contentArr=[SMSafetySourceItem allItems];
        
    }
    return _contentArr;
}

-(NSMutableArray *)contentForShowArr{
    if (!_contentForShowArr) {
        _contentForShowArr=[[NSMutableArray alloc]init];
    }
    return _contentForShowArr;
}

- (NSMutableArray *)filterArr{
    if (!_filterArr) {
        _filterArr = [[NSMutableArray alloc] init];
    }
    return _filterArr;
}

- (UIButton *)btn{
    if (!_btn) {
        _btn = [[UIButton alloc] init];
        [_btn setImage:[UIImage imageNamed:@"new_application.png"] forState:UIControlStateNormal];
        _btn.frame = CGRectMake(W(300), WinHeight-H(160),W(60), H(60));
        _btn.layer.cornerRadius = 5.0;
        _btn.layer.shadowOffset = CGSizeMake(4.0f, 4.0f);
        _btn.layer.shadowOpacity = 0.5;
        _btn.layer.shadowColor =  [UIColor blackColor].CGColor;
        [_btn addTarget:self action:@selector(target:) forControlEvents:UIControlEventTouchUpInside];
    }
    return  _btn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    
    [self addSegmentedControl];
    
    [self  configTableView];

    [self coustomNavigtion];
    
    [self configData];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
}

-(void)viewTapped:(UITapGestureRecognizer*)tap
{
    
    [self.view endEditing:YES];
    
}


-(void)configData{
    page  = 1;
    self.userInfo = [UserInfo shareUserInfo];
    self.filterRequest = [[SMFilterRequset alloc] init];
    self.filterRequest.userId =@"-1";
    self.filterRequest.checkTypeId = @"-1";
    self.filterRequest.hasProblem  =@"-1";
    self.filterRequest.state = @"-1";
    self.filterRequest.checkUserName=@"";
    self.filterRequest.beginDate = @"";
    self.filterRequest.endDate   =@"";
    self.filterRequest.solveUserName = @"";
    
}


//导航栏上添加SegmentedControl视图控制器
-(void)addSegmentedControl{
    
    UISegmentedControl *segmentedControl=[[UISegmentedControl alloc] initWithFrame:CGRectMake(W(40), 0,W(200), 26) ];
    
    [segmentedControl insertSegmentWithTitle:@"安全资料" atIndex:0 animated:YES];
    [segmentedControl insertSegmentWithTitle:@"安全检查" atIndex:1 animated:YES];
    segmentedControl.momentary = NO;
    
    segmentedControl.selectedSegmentIndex = 0;
    segmentedControl.multipleTouchEnabled=NO;
    
    segmentedControl.layer.borderWidth = 1;
    segmentedControl.layer.borderColor =[UIColor whiteColor].CGColor;
    segmentedControl.layer.cornerRadius = 13;
    segmentedControl.layer.masksToBounds = YES;
    [segmentedControl addTarget:self action:@selector(Selectbutton:) forControlEvents:UIControlEventValueChanged];
    
    [self.navigationItem setTitleView:segmentedControl];
}


//导航栏上的segmentedControl点击事件
-(void)Selectbutton:(UISegmentedControl *)Seg{
    NSInteger Index = Seg.selectedSegmentIndex;
    switch (Index) {
        case 0:
            ddltView.hidden=YES;
            self.checkedTableView.hidden=YES;
            self.btn.hidden=YES;
            self.noDataView.hidden=YES;
            [ddltView closeView];
            
            if (!self.safetySourceView) {
                [self configTableView];
            }else{
                self.safetySourceView.hidden=NO;
            }
            [self.view endEditing:YES];
            
            break;
        case 1:{
            
            UserInfo *userInfo=[UserInfo shareUserInfo];
            
            NSArray *arr =[userInfo.right componentsSeparatedByString:@";"];
            if ([arr containsObject:@"10035"]) {
                
                self.safetySourceView.hidden=YES;
                
                if (!ddltView) {
                    [self setUpMenu];
                    [self addCheckedTableView];
                }else{
                    ddltView.hidden=NO;
                    for(UIButton *btn in ddltView.items){
                        btn.selected = NO;
                    }
                    self.checkedTableView.hidden=NO;
                    self.btn.hidden=NO;
                    self.noDataView.hidden=NO;
                }
    
            }else{
                 Seg.selectedSegmentIndex = 0;
                UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"提示" message:@"你没有该权限" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
         
            
        }
            break;
    }
}

//下拉菜单
- (void)setUpMenu{
    
    ddltView = [[XIOptionSelectorView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    ddltView.parentView = self.view;
    __weak typeof(self) weakSelf = self;

    ddltView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:ddltView];
    [ddltView setTitle:@"全部" forItem:0];
    [ddltView setTitle:@"筛选" forItem:1];
    
    [ddltView setViewAtIndex:^UIView<XIDropdownlistViewProtocol> *(NSInteger index1, XIOptionSelectorView*opView) {
        
        XIOptionSelectorView *strongOpSelectorRef = opView;
        CGFloat py = strongOpSelectorRef.frame.size.height+strongOpSelectorRef.frame.origin.y;
        CGFloat dpW = weakSelf.view.frame.size.width;
        
        if(index1==0){
            
            UIView<XIDropdownlistViewProtocol> *aView;
    
            aView = [[XIOptionView alloc] initWithFrame:CGRectMake(0, py, dpW, 280)];
            aView.backgroundColor = [UIColor whiteColor];
            aView.delegate = weakSelf;
            aView.viewIndex = index1;
            
            NSArray *tmpArray = @[@"全部",@"未发现问题",@"待处理",@"待复查",@"复查未通过",@"复查通过",@"我提交的"];
            [aView setFetchDataSource:^NSArray *{
                return tmpArray;
            }];
            aView.hidden = YES;
            [weakSelf.view addSubview:aView];
            return aView;
            
        }
        else {
            
            weakSelf.filterTableView = [[SMFilterTableView alloc] initWithFrame:CGRectMake(0, py, WinWidth, WinHeight-py-CGRectGetMaxY(self.navigationController.navigationBar.frame))];
            weakSelf.filterTableView.filterDelegate=weakSelf;
            weakSelf.filterTableView.tableFooterView =[[UIView alloc]init];
      
            weakSelf.filterTableView.hidden = YES;
           [weakSelf.view   addSubview:weakSelf.filterTableView];
            weakSelf.filterTableView.bounces =NO;
            
            if ([weakSelf.filterTableView respondsToSelector:@selector(setSeparatorInset:)]) {
                [weakSelf.filterTableView setSeparatorInset:UIEdgeInsetsZero];
            }
            if ([weakSelf.filterTableView respondsToSelector:@selector(setLayoutMargins:)]) {
                [weakSelf.filterTableView setLayoutMargins:UIEdgeInsetsZero];
            }


            return  weakSelf.filterTableView;
            
        }
  
    }];
    
    
}

#pragma XIDropdownlistViewProtocol method

- (void)didSelectItemAtIndex:(NSInteger)index1 inSegment:(NSInteger)segment
{
    if(segment==0){
         NSArray *tmpArry = @[@"全部",@"未发现问题",@"待处理",@"待复查",@"复查未通过",@"复查通过",@"我提交的"];
        index = index1;
        [ddltView setTitle:tmpArry[index1] forItem:segment];

        if (index1 ==0) {
            self.filterRequest.userId=@"-1";
            self.filterRequest.state = @"-1";
            
        }else if(index1 ==6){
            self.filterRequest.userId=self.userInfo.userId;
            self.filterRequest.state = @"-1";

        }else{
            self.filterRequest.userId=self.userInfo.userId;
            self.filterRequest.state =[NSString stringWithFormat:@"%li",index1];
        }
        
        if (!self.checkedTableView) {
            
            [self addCheckedTableView];
            
        }else{
            
            [self.noDataView removeFromSuperview];
            
             [self.checkedTableView beginRefresh];
            
        }
        
        [ddltView closeView];
        
    }
    else if(segment==1){

         
        
    }
}

- (void)addCheckedTableView{
    self.checkedTableView = [[SMCheckedTableView alloc] initWithFrame:CGRectMake(0,40 , WinWidth, WinHeight-CGRectGetMaxY(self.navigationController.navigationBar.frame))];
    self.checkedTableView.checkedDelegate =self;
    [self.view addSubview: self.checkedTableView];
    
    UserInfo *userInfo=[UserInfo shareUserInfo];
    
    NSArray *arr =[userInfo.right componentsSeparatedByString:@";"];
    
    if ([arr containsObject:@"10036"]) {
          [ self.view addSubview:self.btn];
    }
    
    self.noDataView = [[NotfindView alloc] initWithFrame:CGRectMake(0,40, WinWidth,  WinHeight-CGRectGetMaxY(self.navigationController.navigationBar.frame))];
    
    
    self.checkedTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
    self.checkedTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadNewData];
    }];
    
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadLastData方法）
    self.checkedTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreDate)];

    [self.checkedTableView beginRefresh];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self setUpNavBar];
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc]init]];
    NSUserDefaults *userDefaults  =[NSUserDefaults standardUserDefaults];
    NSArray *arr=[userDefaults objectForKey:kDraft];
    if (arr) {
         self.navigationItem.rightBarButtonItem.badgeValue = [NSString stringWithFormat:@"%li",arr.count];
    }else{
        self.navigationItem.rightBarButtonItem.badgeValue =nil;
    }
    //通知跳转
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jumpToSecondView:) name:@"kSafetySource" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData:) name:kCheckInformationRefresh object:nil];
}

//安全检查通知刷新
- (void)refreshData:(NSNotification *)notification{
    BOOL isRefresh  = [notification.object boolValue];
    if (isRefresh) {
        [self.noDataView removeFromSuperview];
        [self.checkedTableView beginRefresh];
        
    }
    
}

//安全资料通知方法
- (void)jumpToSecondView:(NSNotification *)notification{
    SMSafetySourceDetail *item =(SMSafetySourceDetail *)notification.object;
    NSString *nameStr=item.name;
    
    UserInfo *userInfo=[UserInfo shareUserInfo];
    
    NSArray *arr =[userInfo.right componentsSeparatedByString:@";"];
    
    if (nameStr.length) {
        
        if ([nameStr isEqualToString:@"总包单位"]||[nameStr isEqualToString:@"分包单位"]||[nameStr isEqualToString:@"管理网络"]) {
    
            if ([arr containsObject:item.right]) {
                GeneralContractorViewController *generalVC=[[GeneralContractorViewController alloc]init];
                generalVC.title = nameStr;
                generalVC.menuId = [NSString stringWithFormat:@"%li",item.classID];
                [self.navigationController pushViewController:generalVC animated:YES];
            }else{
                UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"提示" message:@"你没有该权限" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
            
           
        }
        else{
            if ([arr containsObject:item.right]) {
                if (item.classID<15) {
                    SMPhotosViewController *photoVC=[[SMPhotosViewController alloc] init];
                    photoVC.title = nameStr;
                    
                    photoVC.securityMemuid =[NSString stringWithFormat:@"%li",item.classID];
                    
                    [self.navigationController pushViewController:photoVC animated:YES];
                }
 
            }else{
                UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"提示" message:@"你没有该权限" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }

      
        }
        
    }
    
    
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

- (void)setUpBackBtn{
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
}

- (void)configTableView{
    
    self.searchTableVC=[[UITableViewController alloc]init];
    self.searchTableVC.tableView.delegate=self;
    self.searchTableVC.tableView.dataSource=self;
    [self.searchTableVC.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    //2、创建searchContoller
    self.searchContoller=[[UISearchController alloc]initWithSearchResultsController:self.searchTableVC];
    self.searchContoller.delegate=self;
    self.searchContoller.searchResultsUpdater=self;
    
    [self.searchContoller.searchBar sizeToFit];
    // self.searchContoller.dimsBackgroundDuringPresentation = NO;
    self.definesPresentationContext = YES;
    
    self.safetySourceView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0,WinWidth ,WinHeight-CGRectGetMaxY(self.navigationController.navigationBar.frame))];
    if ([self.safetySourceView respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [self.safetySourceView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
    if ([self.safetySourceView respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [self.safetySourceView setLayoutMargins:UIEdgeInsetsZero];
        
    }
    self.safetySourceView.tableHeaderView=self.searchContoller.searchBar;
    self.safetySourceView.dataSource=self;
    self.safetySourceView.delegate=self;
    [self reloadShowIngData];
    [self.view addSubview: self.safetySourceView];
    
}



    


-(void)reloadShowIngData{
    [self.contentForShowArr removeAllObjects];
    [self reloadVisiableDataFrom:self.contentArr toTagertArr:self.contentForShowArr];
}

-(void)reloadVisiableDataFrom:(NSMutableArray *)initialArr toTagertArr:(NSMutableArray *)tagertArr{
    for (SMSafetySourceItem *item in initialArr) {
        [tagertArr addObject:item];
        if ([item isOpen]) {
            [tagertArr addObject:item.sections];
        }
    }
}


#pragma mark UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==self.safetySourceView) {
        return self.contentForShowArr.count;
    }else{
        return self.filterArr.count;
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==self.safetySourceView) {
        id value=self.contentForShowArr[indexPath.row];
        UITableViewCell *cell=[self getCellWithTableView:tableView andIndexpath:indexPath];
        if ([cell isKindOfClass:[SMSafetySourceTableViewItemCell class]]) {
            [(SMSafetySourceTableViewItemCell *)cell setCellItem:value];
        }
        else{
            
            [(SMSafetySourceTableViewDetailCell *)cell setDetailList:value];
        }
        cell.backgroundColor=[UIColor colorWithRed:243/255.0 green:243/255.0 blue:243/255.0 alpha:1.0];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        static NSString *identifier = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell  =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        SMSafetySourceDetail *detail = self.filterArr[indexPath.row];
        
        UIImage *icon = [UIImage imageNamed:detail.imageName];
        CGSize itemSize = CGSizeMake(30, 30);
        UIGraphicsBeginImageContextWithOptions(itemSize, NO ,0.0);
        CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
        [icon drawInRect:imageRect];
        
        cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        cell.imageView.contentMode =UIViewContentModeScaleToFill;
        cell.textLabel.text=detail.name;
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    
}

-(UITableViewCell *)getCellWithTableView:(UITableView *)tableView andIndexpath:(NSIndexPath *)indexPath{
    id value=self.contentForShowArr[indexPath.row];
    UITableViewCell *cell;
    //如果value是BouceTableViewItem类型，复用itemCellIdentifier
    if ([value isKindOfClass:[SMSafetySourceItem class]]) {
        cell=[tableView dequeueReusableCellWithIdentifier:itemCellIdentifier];
        if (cell==nil) {
            cell=[[SMSafetySourceTableViewItemCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:itemCellIdentifier];
        }
    }
    //否则复用detailCellIdentifier
    else{
        cell=[tableView dequeueReusableCellWithIdentifier:detailCellIdentifier];
        if (cell==nil) {
            cell=[[SMSafetySourceTableViewDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:detailCellIdentifier];
        }
    }
    return cell;
}

//tableView行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView ==self.safetySourceView) {
        id value=self.contentForShowArr[indexPath.row];
        CGFloat height=0;
        if ([value isKindOfClass:[SMSafetySourceItem class]]) {
            height=30;
        }
        else{
            UITableViewCell *cell=[self getCellWithTableView:tableView andIndexpath:indexPath];
            [(SMSafetySourceTableViewDetailCell *)cell setDetailList:value];
            height=[(SMSafetySourceTableViewDetailCell *)cell cellHeight];
        }
        return height;
    }else{
        
        return 55.0;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView!=self.safetySourceView) {
        SMSafetySourceDetail *detail = self.filterArr[indexPath.row];
        NSString *nameStr=detail.name;
        
        UserInfo *userInfo=[UserInfo shareUserInfo];
        
        NSArray *arr =[userInfo.right componentsSeparatedByString:@";"];

        if ([nameStr isEqualToString:@"总包单位"]) {

            if ([arr containsObject:detail.right]) {
        
                GeneralContractorViewController *generalVC=[[GeneralContractorViewController alloc]init];
                generalVC.title = nameStr;
                [self.navigationController pushViewController:generalVC animated:YES];
                
            }else{
                UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"提示" message:@"你没有该权限" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
     
        }
        else{
            
            if ([arr containsObject:detail.right]) {
                if (detail.classID<15) {
                    SMPhotosViewController *photoVC=[[SMPhotosViewController alloc] init];
                    photoVC.title = nameStr;
                    photoVC.securityMemuid =[NSString stringWithFormat:@"%li",detail.classID];
                    [self.navigationController pushViewController:photoVC animated:YES];
                }
            }else{
                
                UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"提示" message:@"你没有该权限" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                
            }
            
    
        }
        
    }

}


//使cell的下划线顶头，沾满整个屏幕宽
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    NSString *searchString=searchController.searchBar.text;
    [self.filterArr removeAllObjects];
    if (searchString.length>0) {
        //创建一个搜索的谓词
        NSPredicate *pre=[NSPredicate predicateWithBlock:^BOOL(SMSafetySourceDetail *detail, NSDictionary *bindings) {
            NSRange range=[detail.name rangeOfString:searchString options:NSCaseInsensitiveSearch];
            return range.location!=NSNotFound;
        }];
        
        //遍历每一条数据
        NSArray *arr = [SMSafetySourceItem allItems];
        
        for (int i=0; i<arr.count; i++) {
            SMSafetySourceItem *item = arr[i];
            NSArray *allArr= item.sections;
            NSArray *tempArr = [allArr filteredArrayUsingPredicate:pre];
            [self.filterArr addObjectsFromArray:tempArr];
        }
    }
    
    [self.searchTableVC.tableView reloadData];
    
}


-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    [searchBar setShowsCancelButton:YES animated:YES];
    
 }



// 取消按钮被按下时，执行的方法
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self.searchContoller resignFirstResponder];
    // 放弃第一响应者
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
   
}

//导航栏上的搜索按钮
-(void)coustomNavigtion{
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    
    UIImage *image = [UIImage imageNamed:@"manuscript.png"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(WinWidth-50,0,image.size.width, image.size.height);
    [button addTarget:self action:@selector(searchFor:) forControlEvents:UIControlEventTouchDown];
    [button setBackgroundImage:image forState:UIControlStateNormal];

    UIBarButtonItem *navLeftButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = navLeftButton;
    self.navigationItem.rightBarButtonItem.badgeBGColor = [UIColor redColor];
    self.navigationItem.rightBarButtonItem.shouldHideBadgeAtZero=YES;
   }

//跳转到保存草稿 页面
- (void)searchFor:(UIButton *)button{
    
    SMDraftViewController *smdraftVC= [[SMDraftViewController alloc] init];
    [self.navigationController pushViewController:smdraftVC animated:YES];
    [ddltView closeView];
}

//跳转到新增安全详细界面
-(void)target:(UIButton *)button{
        
    SMAddSafetyCheckViewController *smAscVC=[[SMAddSafetyCheckViewController alloc] init];
    [self.navigationController pushViewController:smAscVC animated:YES];
}


//刷新
- (void)loadNewData{
    
    page = 1;
    
    [self issuresListRequestData];
 
}

//加载
- (void)loadMoreDate{
        if (page<total) {
            
            page++;
            
            [self issuresListRequestData];
            
        }else{
            page =total;
            
            // 拿到当前的上拉刷新控件，变为没有更多数据的状态
            [self.checkedTableView.mj_footer endRefreshingWithNoMoreData];
            
        }
    
}

//筛选界面的代理
#pragma mark  ApplicationsDelegate
//代理点击push下一个页面
- (void)JumpToFilter:(NSIndexPath *)indexPath{
    
    NSLog(@"111");
    
}

- (void)requestWithFilterData:(SMFilterRequset *)filterRequset{
    [ddltView closeView];
    [self.noDataView removeFromSuperview];
    
    self.filterRequest.checkUserName =filterRequset.checkUserName;
    self.filterRequest.solveUserName =filterRequset.solveUserName;
    self.filterRequest.checkTypeId   =filterRequset.checkTypeId;
    self.filterRequest.hasProblem    =filterRequset.hasProblem;
    self.filterRequest.beginDate     =filterRequset.beginDate;
    self.filterRequest.endDate       =filterRequset.endDate;
    if (filterRequset.checkUserName.length||filterRequset.solveUserName.length||filterRequset.beginDate.length||filterRequset.endDate.length||filterRequset.checkTypeId.integerValue!=-1||filterRequset.hasProblem.integerValue!=-1) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"FilterShowBadge" object:@"1"];
    }
    [self.checkedTableView beginRefresh];
}

//代理点击push下一个页面
- (void)JumpToSecondView:(NSIndexPath *)indexPath{
    
    SMCheckdetailViewController *detailVC =[[SMCheckdetailViewController alloc]init];
    
    SMIssureAnalysisModel *model = self.checkedTableView.dataList[indexPath.row];
    detailVC.checkId=model.checkId;
    
    [self.navigationController pushViewController:detailVC animated:YES];
    
}

#pragma mark Requset
-(void)issuresListRequestData{
     NSString *pageStr = [NSString stringWithFormat:@"%li",page];
    NSDictionary *parameters=@{@"page":pageStr,
                               @"rows":@"10",
                               @"userId":self.filterRequest.userId,
                               @"checkTypeId":self.filterRequest.checkTypeId,
                               @"hasProblem":self.filterRequest.hasProblem,
                               @"state":self.filterRequest.state,
                               @"checkUserName":self.filterRequest.checkUserName,
                               @"beginDate":self.filterRequest.beginDate,
                               @"endDate":self.filterRequest.endDate,
                               @"solveUserName":self.filterRequest.solveUserName
                               };
    [NetRequestClass NetRequestGETWithRequestURL:kCheckResultInterface WithParameter:parameters WithReturnValeuBlock:^(id returnValue) {
        
        NSDictionary *dict= returnValue;
        
        NSDictionary *contentDict=dict[@"items"];
        
        if (contentDict) {
            NSString *totalStr = contentDict[@"total"];
            total = totalStr.integerValue;
            
            NSArray *tempArr=contentDict[@"rows"];
            
            NSMutableArray *dataArr = [[NSMutableArray alloc]init];
            for (int i=0; i<tempArr.count; i++) {
                SMIssureAnalysisModel *model =[SMIssureAnalysisModel mj_objectWithKeyValues:tempArr[i]];
                for (SMACheckinfoproblemclasslist *f in model.checkInfoProblemClassList) {
                    
                    for (SMACheckinfodetaillist *e in f.checkInfoDetailList) {
                        NSLog(@"%@",e.checkProblemName);
                    }
                }
                [dataArr addObject:model];
            }
            
            if ([self.checkedTableView.mj_header isRefreshing]) {
                [self.checkedTableView.dataList removeAllObjects];
                
            }
            [self.checkedTableView.dataList addObjectsFromArray:dataArr];
            
            [self.checkedTableView reloadData];
        }
        
        
        
        [self.checkedTableView.mj_header endRefreshing];
        [self.checkedTableView.mj_footer endRefreshing];
        
        //判断有无数据的时候的视图
        if (self.checkedTableView.dataList.count ==0) {
            
            [self.view addSubview: self.noDataView];
            self.checkedTableView.mj_footer.hidden =YES;
           
            UserInfo *userInfo=[UserInfo shareUserInfo];
            
            NSArray *arr =[userInfo.right componentsSeparatedByString:@";"];
            
            if ([arr containsObject:@"10036"]) {
                [self.btn removeFromSuperview];
                [ self.view addSubview:self.btn];
            }

        }
        else{
            [self.noDataView removeFromSuperview];
        }
        
        
    } WithErrorCodeBlock:^(id errorCode) {
        NSDictionary *dict=errorCode;
        if ([dict[@"msg"] isEqualToString:@"非法请求!"]) {
            [self restartLogin];
        }
        
    } WithFailureBlock:^{
        
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
    
//销毁通知
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"kSafetySource" object:nil];

}

- (void)dealloc {
   
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
@end
