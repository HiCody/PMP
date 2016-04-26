//
//  BCPMPHomeViewController.m
//  PMP
//
//  Created by mac on 16/1/12.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "BCPMPHomeViewController.h"
#import "PMPMoreAppViewController.h"
#import "GridViewListItemView.h"
#import "GridView.h"
#import "GridItemModel.h"
#import "ZMYVersionNotes.h"
#import "UIImage+Circle.h"
#import <AudioToolbox/AudioToolbox.h>
#import "UIBarButtonItem+Badge.h"
#import <WZLBadgeImport.h>
#import "PMPMessageCenterViewController.h"
#import "PMPAccountManagementViewController.h"
#import "BCSMDatacheckViewController.h"
#import "APService.h"
#import "BCPMPMoreAppViewController.h"
@interface BCPMPHomeViewController ()<GridViewDelegate,UIAlertViewDelegate>{
    NSString *url;
}
@property (nonatomic, strong) GridView *gridView;
@property (nonatomic, strong) NSMutableArray *dataArray;//GriView的内容
@property (nonatomic,strong) NSMutableArray *deletateArr;//保存删除的grid
@property (nonatomic,strong)NSArray *gridListArr;
@end

@implementation BCPMPHomeViewController
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
    self.title  =@"无锡建工分公司";
    [self updateVersion];
    [self configGridView];
   // [self configureJPush];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];

    [self configBarBtn];
    
    [self setUpNavBar];
    
    [self getDataListFromSand];
    
    self.gridView.gridModelsArray = self.dataArray;
    
}

- (void)configBarBtn{
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [leftBtn setImage:[UIImage circleImageWithName:@"initial_head_portrait" borderWidth:0 borderColor:[UIColor blackColor]] forState:UIControlStateNormal];
    
    [leftBtn addTarget:self action:@selector(managerAccount) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"messagePush"] style:UIBarButtonItemStyleDone target:self action:@selector(messagePush)];
    self.navigationItem.rightBarButtonItem.badgeCenterOffset = CGPointMake(-11, 6);
    
    self.navigationItem.backBarButtonItem =[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:self action:nil];
 
}

- (void)managerAccount{
   
    PMPAccountManagementViewController *pmpAMVC=[[PMPAccountManagementViewController alloc] init];
    [self.navigationController pushViewController:pmpAMVC animated:YES];
}

//点击推送后的跳转
- (void)messagePush{

    PMPMessageCenterViewController  *messagecenterVC=[[PMPMessageCenterViewController alloc] init];
    [self.navigationController pushViewController:messagecenterVC animated:YES];
    
}

- (void)setUpNavBar{
    
    self.navigationController.navigationBar.barTintColor=[UIColor colorWithHexString:Navi_hexcolor];
    
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    NSMutableDictionary *attrs=[[NSMutableDictionary alloc]init];
    attrs[NSForegroundColorAttributeName]=[UIColor whiteColor];
    attrs[NSFontAttributeName]=[UIFont boldSystemFontOfSize:19];
    [self.navigationController.navigationBar setTitleTextAttributes:attrs];
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

#pragma mark GrivView部分
//添加GridView
- (void)configGridView{
    self.gridView=[[GridView alloc] init];
    self.gridView.frame=self.view.frame;
    self.gridView.gridViewDelegate =self;
    self.gridView.showsHorizontalScrollIndicator=NO;
    [self.view addSubview:self.gridView];
    
    self.gridListArr =@[@{@"title":@"安全管理",
                          @"imageResString":@"engineering_inspection"},
                        @{@"title":@"材料管理",
                          @"imageResString":@"cailiao_guanli"},
//                        @{@"title":@"设备管理",
//                          @"imageResString":@"construction_schedule"},
//                        @{@"title":@"进度管理",
//                          @"imageResString":@"total_construction_plan"},
//                        @{@"title":@"违章曝光",
//                          @"imageResString":@"engineering_material_management"},
//                        @{@"title":@"工程物资管理",
//                          @"imageResString":@"engineering_forecast"},
//                        @{@"title":@"工程预计算",
//                          @"imageResString":@"engineering_knowledge_base"},
//                        @{@"title":@"工程知识库",
//                          @"imageResString":@"chengben_guanli"},
//                        @{@"title":@"成本管理",
//                          @"imageResString":@"cailiao_guanli"},
//                        @{@"title":@"风险管理",
//                          @"imageResString":@"common_project_project_review3"},
//                        @{@"title":@"租赁管理",
//                          @"imageResString":@"zulin_guanli"},
                        ];
    [self getDataListFromSand];
    
    if (self.deletateArr.count==0&&self.dataArray.count==0) {
        for (NSDictionary *dict in self.gridListArr) {
            GridItemModel *gim=[GridItemModel gridWithDict:dict];
            [self.dataArray addObject:gim];
        }
    }
    
    self.gridView.gridModelsArray = self.dataArray;
    [self saveDataListToSand];
    
    
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
    return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"AddGrid2.plist"];
}

- (NSString *)gridfilePath
{
    return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"Grid2.plist"];
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
    BCPMPMoreAppViewController *pmpMoreAppVC = [[BCPMPMoreAppViewController alloc] init];
    pmpMoreAppVC.title = @"更多应用";
    
    [self.navigationController pushViewController:pmpMoreAppVC animated:YES];
}

//点击后跳转到应用界面
- (void)grideView:(GridView *)gridView selectItemAtIndex:(NSInteger)index{
    GridViewListItemView *itemView = self.gridView.itemsArray[index];
    GridItemModel *model = itemView.itemModel;
    
    if ([model.title isEqualToString:@"安全管理"]) {
     
        BCSMDatacheckViewController *smDataVC=[[BCSMDatacheckViewController alloc] init];
        [self.navigationController pushViewController:smDataVC animated:YES];
 
    }
}

////获取appKey
//- (NSString *)getAppKey {
//    NSURL *urlPushConfig = [[[NSBundle mainBundle] URLForResource:@"PushConfig"
//                                                    withExtension:@"plist"] copy];
//    NSDictionary *dictPushConfig =
//    [NSDictionary dictionaryWithContentsOfURL:urlPushConfig];
//    
//    if (!dictPushConfig) {
//        return nil;
//    }
//    
//    // appKey
//    NSString *strApplicationKey = [dictPushConfig valueForKey:(@"APP_KEY")];
//    if (!strApplicationKey) {
//        return nil;
//    }
//    
//    return [strApplicationKey lowercaseString];
//}


////极光推送设置tag，并获取自定义消息
//- (void)configureJPush{
//    //  NSLog(@"%@", [APService registrationID]);
//    UserInfo *user=[UserInfo shareUserInfo];
//    NSString *alias=[NSString stringWithFormat:@"r_%@",user.userId];
//    
//    [APService setTags:nil
//                 alias:alias
//      callbackSelector:@selector(tagsAliasCallback:tags:alias:)
//                target:self];
//    
//    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
//    [defaultCenter addObserver:self
//                      selector:@selector(networkDidSetup:)
//                          name:kJPFNetworkDidSetupNotification
//                        object:nil];
//    [defaultCenter addObserver:self
//                      selector:@selector(networkDidClose:)
//                          name:kJPFNetworkDidCloseNotification
//                        object:nil];
//    [defaultCenter addObserver:self
//                      selector:@selector(networkDidRegister:)
//                          name:kJPFNetworkDidRegisterNotification
//                        object:nil];
//    [defaultCenter addObserver:self
//                      selector:@selector(networkDidLogin:)
//                          name:kJPFNetworkDidLoginNotification
//                        object:nil];
//    [defaultCenter addObserver:self
//                      selector:@selector(networkDidReceiveMessage:)
//                          name:kJPFNetworkDidReceiveMessageNotification
//                        object:nil];
//    [defaultCenter addObserver:self
//                      selector:@selector(serviceError:)
//                          name:kJPFServiceErrorNotification
//                        object:nil];
//    
//    //注册推送后跳转的通知
//    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:@"RemoteNotification" object:nil];
//}
//
//- (void)tagsAliasCallback:(int)iResCode
//                     tags:(NSSet *)tags
//                    alias:(NSString *)alias {
//    NSLog(@"alias----%@",alias);
//}
//
//#pragma mark 极光推送相关配置
//- (void)dealloc {
//    [self unObserveAllNotifications];
//}
//
//- (void)unObserveAllNotifications {
//    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
//    [defaultCenter removeObserver:self
//                             name:kJPFNetworkDidSetupNotification
//                           object:nil];
//    [defaultCenter removeObserver:self
//                             name:kJPFNetworkDidCloseNotification
//                           object:nil];
//    [defaultCenter removeObserver:self
//                             name:kJPFNetworkDidRegisterNotification
//                           object:nil];
//    [defaultCenter removeObserver:self
//                             name:kJPFNetworkDidLoginNotification
//                           object:nil];
//    [defaultCenter removeObserver:self
//                             name:kJPFNetworkDidReceiveMessageNotification
//                           object:nil];
//    [defaultCenter removeObserver:self
//                             name:kJPFServiceErrorNotification
//                           object:nil];
//}
//
//- (void)networkDidSetup:(NSNotification *)notification {
//    
//    NSLog(@"已连接");
//    
//}
//
//- (void)networkDidClose:(NSNotification *)notification {
//    
//    NSLog(@"未连接");
//    
//}
//
//- (void)networkDidRegister:(NSNotification *)notification {
//    NSLog(@"%@", [notification userInfo]);
//    
//    NSLog(@"已注册");
//}
//
//- (void)networkDidLogin:(NSNotification *)notification {
//    
//    NSLog(@"已登录");
//}
//
//- (void)networkDidReceiveMessage:(NSNotification *)notification {
//    
//    NSDictionary *userInfo = notification.object;
//    NSLog(@"%@",userInfo);
//    
//    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
//        
//        NSString *path=[[NSBundle mainBundle]pathForResource:@"sound" ofType:@"caf"];
//        NSURL *url1=[NSURL fileURLWithPath:path];
//        SystemSoundID soundId;//声明一个系统音效的id
//        //注册系统声音
//        AudioServicesCreateSystemSoundID((__bridge CFURLRef)url1, &soundId);
//        //注册回调函数
//        AudioServicesAddSystemSoundCompletion(soundId, NULL, NULL, MySoundFinishedPlayingCallBack, NULL);
//        //播放系统音效
//        AudioServicesPlaySystemSound(soundId);
//        
//        //震动
//        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
//        
//        [self.navigationItem.rightBarButtonItem showBadge];
//        
//    }else{
//
//        
//    }
//    
//}
//
////播放系统音效完成执行的方法
//void MySoundFinishedPlayingCallBack(SystemSoundID sound_id,void *user_data){
//    //销毁系统音效
//    AudioServicesDisposeSystemSoundID(sound_id);
//}
//
//// log NSSet with UTF8
//// if not ,log will be \Uxxx
//- (NSString *)logDic:(NSDictionary *)dic {
//    if (![dic count]) {
//        return nil;
//    }
//    NSString *tempStr1 =
//    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
//                                                 withString:@"\\U"];
//    NSString *tempStr2 =
//    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
//    NSString *tempStr3 =
//    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
//    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
//    NSString *str =
//    [NSPropertyListSerialization propertyListFromData:tempData
//                                     mutabilityOption:NSPropertyListImmutable
//                                               format:NULL
//                                     errorDescription:NULL];
//    return str;
//}
//
//- (void)serviceError:(NSNotification *)notification {
//    NSDictionary *userInfo = [notification userInfo];
//    NSString *error = [userInfo valueForKey:@"error"];
//    NSLog(@"%@", error);
//}



@end
