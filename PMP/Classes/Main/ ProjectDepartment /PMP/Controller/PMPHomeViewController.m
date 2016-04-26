//
//  PMPHomeViewController.m
//  PMP
//
//  Created by mac on 15/11/30.
//  Copyright © 2015年 mac. All rights reserved.
//

#import "PMPHomeViewController.h"
#import "SINavigationMenuView.h"
#import "PMPAccountManagementViewController.h"
#import "GridView.h"
#import "GridItemModel.h"
#import "PMPMoreAppViewController.h"
#import "SMDatacheckViewController.h"
#import "GridViewListItemView.h"
#import "ZMYVersionNotes.h"
#import "UIImage+Circle.h"
#import "PMPMessageCenterViewController.h"
#import "APService.h"
#import <AudioToolbox/AudioToolbox.h>
#import "SMCheckdetailViewController.h"
#import "AppDelegate.h"
#import "UIBarButtonItem+Badge.h"
#import <WZLBadgeImport.h>
#import "SMMessageCenterModel.h"
#import "UserInfo.h"
#import "BCSMDatacheckViewController.h"
@interface PMPHomeViewController ()<SINavigationMenuDelegate,GridViewDelegate,UIAlertViewDelegate>{
    NSString *url;
}
@property(nonatomic,strong)SINavigationMenuView *menu;
@property(nonatomic,strong)NSArray *listArr;//导航栏选项数组
@property (nonatomic, strong) GridView *gridView;
@property (nonatomic, strong) NSMutableArray *dataArray;//GriView的内容
@property (nonatomic,strong) NSMutableArray *deletateArr;//保存删除的grid
@property (nonatomic,strong)NSArray *gridListArr;
@property (nonatomic,strong)UserInfo *userInfo;
@property (nonatomic,strong)NSArray *subCompanyArr;

@property (nonatomic,strong)NSString *compangyType;//公司类型
@property (nonatomic,strong)NSArray *belongCompanyList;
@end

@implementation PMPHomeViewController
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        
        _dataArray=[[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (NSMutableArray *)deletateArr{
    if (!_deletateArr) {
        
        _deletateArr=[[NSMutableArray alloc] init];
    }
    return _deletateArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getCompangyType];
   
   //  NSString *identifier = [[NSBundle mainBundle] bundleIdentifier];
    [self updateVersion];
    [self configGridView];
    [self configureJPush];
    
    [self JpushJump];
}

- (void)getCompangyType{
    
    UserInfo *userInfo=[UserInfo shareUserInfo];
    self.belongCompanyList = userInfo.belongCompanyListList;
    
    for (Belongcompanylistlist *companyList in self.belongCompanyList) {
        
        if (companyList.companyId == userInfo.companyId) {
            self.compangyType = companyList.type;
        }
        
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.userInfo = [UserInfo shareUserInfo];
    NSMutableArray *tempArr=[[NSMutableArray alloc] init];
    for (Belongcompanylistlist *list in self.userInfo.belongCompanyListList) {
        [tempArr addObject:list.companyName];
    }
    self.listArr=[tempArr copy];
    
    [self configBarBtn];
    [self setUpNavBar];
    
    if (self.compangyType.integerValue==3) {
        
        [self getDataListFromSand];
        self.gridView.gridModelsArray = self.dataArray;

    }
  
}

- (void)JpushJump{
    AppDelegate *delegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    if (delegate.userInfo) {
        NSDictionary *userInfo=delegate.userInfo;
        SMCheckdetailViewController *checkDetailVC=[[SMCheckdetailViewController alloc] init];
        NSString *checkId =userInfo[@"checkId"];
        checkDetailVC.checkId = checkId.integerValue;
        [self.navigationController pushViewController:checkDetailVC animated:YES];
    }
}

- (void)configBarBtn{
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [leftBtn setImage:[UIImage circleImageWithName:@"initial_head_portrait-1" borderWidth:0 borderColor:[UIColor blackColor]] forState:UIControlStateNormal];
    
    [leftBtn addTarget:self action:@selector(managerAccount) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    
    if (self.navigationItem) {
        CGRect frame = CGRectMake(0.0, 0.0, W(200), self.navigationController.navigationBar.bounds.size.height);
        self.menu = [[SINavigationMenuView alloc] initWithFrame:frame title:self.userInfo.companyName];
        [self.menu displayMenuInView:self.navigationController.view];
        self.menu.items = self.listArr;
        self.menu.delegate = self;
        
        self.navigationItem.titleView = self.menu;
    }
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"messagePush"] style:UIBarButtonItemStyleDone target:self action:@selector(messagePush)];
    self.navigationItem.rightBarButtonItem.badgeCenterOffset = CGPointMake(-11, 6);
 
    [self queryCheckMsgRequset];
    
    self.navigationItem.backBarButtonItem =[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:self action:nil];
    

}

//点击推送后的跳转
- (void)messagePush{
    [self.menu onHideMenu];
    PMPMessageCenterViewController  *messagecenterVC=[[PMPMessageCenterViewController alloc] init];
    [self.navigationController pushViewController:messagecenterVC animated:YES];
}

//检测版本更新
- (void)updateVersion{
    [ZMYVersionNotes isAppVersionUpdatedWithAppIdentifier:kVersion updatedInformation:^(NSString *releaseNoteText, NSString *releaseVersionText, NSDictionary *resultDic) {
        
        UIAlertView *createUserResponseAlert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"已更新版本:%@", releaseVersionText] message:releaseNoteText delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        createUserResponseAlert.tag = 1101;
        [createUserResponseAlert show];
        
    } latestVersionInformation:^(NSString *releaseNoteText, NSString *releaseVersionText, NSDictionary *resultDic) {
        UIAlertView *createUserResponseAlert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"有新版本:%@", releaseVersionText] message:releaseNoteText delegate:self cancelButtonTitle:@"忽略" otherButtonTitles: @"进行下载", @"下次再说",nil];
        url = [resultDic objectForKey:@"trackViewUrl"];
        createUserResponseAlert.tag = 1102;
        [createUserResponseAlert show];
    } completionBlockError:^(NSError *error) {
        NSLog(@"An error occurred: %@", [error localizedDescription]);
    }];
}


- (void)managerAccount{
    [self.menu onHideMenu];
    PMPAccountManagementViewController *pmpAMVC=[[PMPAccountManagementViewController alloc] init];
    [self.navigationController pushViewController:pmpAMVC animated:YES];
}

- (void)setUpNavBar{
    
    self.navigationController.navigationBar.barTintColor=[UIColor colorWithHexString:Navi_hexcolor];
    
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    NSMutableDictionary *attrs=[[NSMutableDictionary alloc]init];
    attrs[NSForegroundColorAttributeName]=[UIColor blackColor];
    attrs[NSFontAttributeName]=[UIFont boldSystemFontOfSize:19];
    [self.navigationController.navigationBar setTitleTextAttributes:attrs];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark GrivView部分
//添加GridView
- (void)configGridView{
    self.gridView=[[GridView alloc] init];
    self.gridView.frame=self.view.frame;
    self.gridView.gridViewDelegate =self;
    self.gridView.showsHorizontalScrollIndicator=NO;
    [self.view addSubview:self.gridView];
    [self configGridViewData];
}

- (void)configGridViewData{
    //type 1=总公司 2=分公司 3=项目部
    [self.dataArray removeAllObjects];
    if (self.compangyType.integerValue == 3) {
        self.gridListArr =@[@{@"title":@"安全管理",
                              @"imageResString":@"engineering_inspection"},
                            @{@"title":@"材料管理",
                              @"imageResString":@"cailiao_guanli"},
                            @{@"title":@"设备管理",
                              @"imageResString":@"construction_schedule"},
                            @{@"title":@"进度管理",
                              @"imageResString":@"total_construction_plan"},
                            @{@"title":@"违章曝光",
                              @"imageResString":@"engineering_material_management"},
                            @{@"title":@"工程物资管理",
                              @"imageResString":@"engineering_forecast"},
                            @{@"title":@"工程预计算",
                              @"imageResString":@"engineering_knowledge_base"},
                            @{@"title":@"工程知识库",
                              @"imageResString":@"chengben_guanli"},
                            @{@"title":@"成本管理",
                              @"imageResString":@"cailiao_guanli"},
                            @{@"title":@"风险管理",
                              @"imageResString":@"common_project_project_review3"},
                            @{@"title":@"租赁管理",
                              @"imageResString":@"zulin_guanli"},
                            ];
        
       // [self getDataListFromSand];
        
        if (self.deletateArr.count==0&&self.dataArray.count==0) {
            for (NSDictionary *dict in self.gridListArr) {
                GridItemModel *gim=[GridItemModel gridWithDict:dict];
                [self.dataArray addObject:gim];
            }
        }
        
        self.gridView.gridModelsArray = self.dataArray;
        [self saveDataListToSand];
        
        
    }else if(self.compangyType.integerValue == 2){
        
        self.subCompanyArr =@[@{@"title":@"安全管理",
                                @"imageResString":@"engineering_inspection"},
                              @{@"title":@"材料管理",
                                @"imageResString":@"cailiao_guanli"}
                              ];
        for (NSDictionary *dict in self.subCompanyArr) {
            GridItemModel *gim=[GridItemModel gridWithDict:dict];
            [self.dataArray addObject:gim];
        }
        
        self.gridView.gridModelsArray = self.dataArray;
    }
    

}

//获取沙盒内的GridView
-(void)getDataListFromSand{
    [self.dataArray removeAllObjects];
    [self.deletateArr removeAllObjects];
    NSString *path = [self gridfilePath];
    self.dataArray = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    
    NSString *path2 = [self addGridfilePath];
    self.deletateArr = [NSKeyedUnarchiver unarchiveObjectWithFile:path2];
    
}

//保存现有的GriView
-(void)saveDataListToSand{
    
    NSString *path = [self gridfilePath];
    [NSKeyedArchiver archiveRootObject:self.dataArray toFile:path];
    
    NSString *path2 = [self addGridfilePath];
    [NSKeyedArchiver archiveRootObject:self.deletateArr toFile:path2];
}

//归档路径
- (NSString *)addGridfilePath
{
    return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"AddGrid.plist"];
}

- (NSString *)gridfilePath
{
    return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"Grid.plist"];
}


#pragma mark GridViewDelegate
- (void)grideViewPassDeleateValue:(GridItemModel *)model{
    [self.deletateArr addObject:model];
    [self.dataArray removeObject:model];
    [self saveDataListToSand];
}

- (void)grideViewMoveToPassValue:(NSArray *)arr{
    [self.dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray:arr];
    [self saveDataListToSand];
}

- (void)grideViewmoreItemButtonClicked:(GridView *)gridView
{
    PMPMoreAppViewController *pmpMoreAppVC = [[PMPMoreAppViewController alloc] init];
    pmpMoreAppVC.title = @"更多应用";
    
    [self.navigationController pushViewController:pmpMoreAppVC animated:YES];
}

//点击后跳转到应用界面
- (void)grideView:(GridView *)gridView selectItemAtIndex:(NSInteger)index{
   GridViewListItemView *itemView = self.gridView.itemsArray[index];
    GridItemModel *model = itemView.itemModel;
    UserInfo *userInfo=[UserInfo shareUserInfo];
    NSArray *arr =[userInfo.right componentsSeparatedByString:@";"];

    if ([model.title isEqualToString:@"安全管理"]) {
        if (self.compangyType.integerValue==3) {
            if ([arr containsObject:@"10031"]) {
                SMDatacheckViewController *smDataVC=[[SMDatacheckViewController alloc] init];
                [self.navigationController pushViewController:smDataVC animated:YES];
            }else{
                UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"提示" message:@"你没有该权限" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
        }else if(self.compangyType.integerValue==2){
            if ([arr containsObject:@"10051"]) {
                BCSMDatacheckViewController *smDataVC=[[BCSMDatacheckViewController alloc] init];
                [self.navigationController pushViewController:smDataVC animated:YES];
            }else{
                UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"提示" message:@"你没有该权限" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
        }

    
    }
}

//获取appKey
- (NSString *)getAppKey {
    NSURL *urlPushConfig = [[[NSBundle mainBundle] URLForResource:@"PushConfig"
                                                    withExtension:@"plist"] copy];
    NSDictionary *dictPushConfig =
    [NSDictionary dictionaryWithContentsOfURL:urlPushConfig];
    
    if (!dictPushConfig) {
        return nil;
    }
    
    // appKey
    NSString *strApplicationKey = [dictPushConfig valueForKey:(@"APP_KEY")];
    if (!strApplicationKey) {
        return nil;
    }
    
    return [strApplicationKey lowercaseString];
}


//极光推送设置tag，并获取自定义消息
- (void)configureJPush{
  //  NSLog(@"%@", [APService registrationID]);
    UserInfo *user=[UserInfo shareUserInfo];
    NSString *alias=[NSString stringWithFormat:@"r_%@",user.userId];
    
    [APService setTags:nil
                 alias:alias
      callbackSelector:@selector(tagsAliasCallback:tags:alias:)
                target:self];
    
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidSetup:)
                          name:kJPFNetworkDidSetupNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidClose:)
                          name:kJPFNetworkDidCloseNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidRegister:)
                          name:kJPFNetworkDidRegisterNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidLogin:)
                          name:kJPFNetworkDidLoginNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidReceiveMessage:)
                          name:kJPFNetworkDidReceiveMessageNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(serviceError:)
                          name:kJPFServiceErrorNotification
                        object:nil];

 //注册推送后跳转的通知
    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:@"RemoteNotification" object:nil];
}

- (void)tagsAliasCallback:(int)iResCode
                     tags:(NSSet *)tags
                    alias:(NSString *)alias {
    NSLog(@"alias----%@",alias);
}

#pragma mark 极光推送相关配置
- (void)dealloc {
    [self unObserveAllNotifications];
}

- (void)unObserveAllNotifications {
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter removeObserver:self
                             name:kJPFNetworkDidSetupNotification
                           object:nil];
    [defaultCenter removeObserver:self
                             name:kJPFNetworkDidCloseNotification
                           object:nil];
    [defaultCenter removeObserver:self
                             name:kJPFNetworkDidRegisterNotification
                           object:nil];
    [defaultCenter removeObserver:self
                             name:kJPFNetworkDidLoginNotification
                           object:nil];
    [defaultCenter removeObserver:self
                             name:kJPFNetworkDidReceiveMessageNotification
                           object:nil];
    [defaultCenter removeObserver:self
                             name:kJPFServiceErrorNotification
                           object:nil];
}

- (void)networkDidSetup:(NSNotification *)notification {

    NSLog(@"已连接");

}

- (void)networkDidClose:(NSNotification *)notification {

    NSLog(@"未连接");

}

- (void)networkDidRegister:(NSNotification *)notification {
    NSLog(@"%@", [notification userInfo]);

    NSLog(@"已注册");
}

- (void)networkDidLogin:(NSNotification *)notification {
    
      NSLog(@"已登录");
}

- (void)networkDidReceiveMessage:(NSNotification *)notification {
   
    NSDictionary *userInfo = notification.object;
    NSLog(@"%@",userInfo);
    
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
        
        NSString *path=[[NSBundle mainBundle]pathForResource:@"sound" ofType:@"caf"];
        NSURL *url1=[NSURL fileURLWithPath:path];
        SystemSoundID soundId;//声明一个系统音效的id
        //注册系统声音
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)url1, &soundId);
        //注册回调函数
        AudioServicesAddSystemSoundCompletion(soundId, NULL, NULL, MySoundFinishedPlayingCallBack, NULL);
        //播放系统音效
        AudioServicesPlaySystemSound(soundId);
        
        //震动
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        
         [self.navigationItem.rightBarButtonItem showBadge];

    }else{
        
        SMCheckdetailViewController *checkDetailVC=[[SMCheckdetailViewController alloc] init];
        NSString *checkId =userInfo[@"checkId"];
        checkDetailVC.checkId = checkId.integerValue;
        [self.navigationController pushViewController:checkDetailVC animated:YES];
    }
    
}

//播放系统音效完成执行的方法
void MySoundFinishedPlayingCallBack(SystemSoundID sound_id,void *user_data){
    //销毁系统音效
    AudioServicesDisposeSystemSoundID(sound_id);
}

// log NSSet with UTF8
// if not ,log will be \Uxxx
- (NSString *)logDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    [NSPropertyListSerialization propertyListFromData:tempData
                                     mutabilityOption:NSPropertyListImmutable
                                               format:NULL
                                     errorDescription:NULL];
    return str;
}

- (void)serviceError:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSString *error = [userInfo valueForKey:@"error"];
    NSLog(@"%@", error);
}


#pragma mark SINavigationMenuDelegate
- (void)didSelectItemAtIndex:(NSUInteger)index
{
    [self switchOrgRequsetWithIndex:index];
}

//组织切换
- (void)switchOrgRequsetWithIndex:(NSUInteger)index{
    Belongcompanylistlist *list = self.userInfo.belongCompanyListList[index];
    NSDictionary *parameters=@{@"companyId":[NSString stringWithFormat:@"%li",list.companyId]
                               };
    [NetRequestClass NetRequestGETWithRequestURL:kSwitchOrg WithParameter:parameters WithReturnValeuBlock:^(id returnValue) {
        
        self.menu.menuButton.title.text =self.listArr[index];
  
        [self getRightByloginInterface];
        
    } WithErrorCodeBlock:^(id errorCode) {
        NSDictionary *dict=errorCode;
        if ([dict[@"msg"] isEqualToString:@"非法请求!"]) {
            [self restartLogin];
        }
        
    } WithFailureBlock:^{
        
    }];

}

- (void)getRightByloginInterface{
    
    [NetRequestClass NetRequestPOSTWithRequestURL:kLoginCheck WithParameter:nil WithReturnValeuBlock:^(id returnValue) {
        
        NSDictionary *dic= returnValue;
        NSDictionary *dict = dic[@"items"];
        self.userInfo.right =dict[@"right"];
        self.userInfo.companyName =dict[@"companyName"];
        NSString *companyId =dict[@"companyId"];
        self.userInfo.companyId =companyId.integerValue;
        [self getCompangyType];
        [self configGridViewData];
        
    } WithErrorCodeBlock:^(id errorCode) {
        
    } WithFailureBlock:^{
        
    }];
}


- (void)queryCheckMsgRequset{

    NSDictionary *parameters=@{
                               @"page":@"1",
                               @"rows":@"10",
                               };
    [NetRequestClass NetRequestGETWithRequestURL:kQueryCheckMsg WithParameter:parameters WithReturnValeuBlock:^(id returnValue) {
        
        NSDictionary *dict= returnValue;
        
        NSDictionary *contentDict=dict[@"items"];
        NSArray *tempArr=[SMMessageCenterModel mj_objectArrayWithKeyValuesArray:contentDict[@"rows"]];
        NSInteger num=0;
        for (SMMessageCenterModel *message in tempArr) {
            if (!message.read) {
                num++;
            }
        }
        if (num) {
            [self.navigationItem.rightBarButtonItem showBadge];
        }else{
            [self.navigationItem.rightBarButtonItem clearBadge];
        }
        
        
    } WithErrorCodeBlock:^(id errorCode) {
        NSDictionary *dict=errorCode;
        if ([dict[@"msg"] isEqualToString:@"非法请求!"]) {
            [self restartLogin];
        }
        
    } WithFailureBlock:^{
        
    }];
    
}

- (void)restartLogin{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"非法请求,请重新登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1102) {
        switch (buttonIndex) {
            case 1:
                [[UIApplication sharedApplication]openURL:[NSURL URLWithString:url]];
                break;
                
            default:
                break;
        }
    }else{
        
        if (buttonIndex==1) {
            [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
        }
        
    }

}
@end
