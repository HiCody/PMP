//
//  AppDelegate.m
//  PMP
//
//  Created by mac on 15/11/30.
//  Copyright © 2015年 mac. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "PMPHomeViewController.h"
#import "BaseNavigationController.h"
#import "AccountModel.h"
#import <Bugly/CrashReporter.h>
#import "APService.h"
#import "BCPMPHomeViewController.h"
@interface AppDelegate (){
    NSDictionary *message;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window=[[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    
    //JPush推送
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
    // ios8之后可以自定义category
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories
        [APService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                       UIUserNotificationTypeSound |
                                                       UIUserNotificationTypeAlert)
                                           categories:nil];
    } else {
#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_8_0
        // ios8之前 categories 必须为nil
        [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                       UIRemoteNotificationTypeSound |
                                                       UIRemoteNotificationTypeAlert)
                                           categories:nil];
#endif
    }
#else
    // categories 必须为nil
    [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                   UIRemoteNotificationTypeSound |
                                                   UIRemoteNotificationTypeAlert)
                                       categories:nil];
#endif      // Required
    [APService setupWithOption:launchOptions];

    /*---------------------------------------------------------------------------------------*/
    
    // 初始化Bugly SDK，开启崩溃捕获上报功能及卡顿监听上报
    [[CrashReporter sharedInstance] installWithAppId:BUGLY_APP_ID];
    // ------
    // 注意: 在调试SDK的捕获上报功能时，请注意以下内容:
    // 1. Xcode断开编译器，否则Xcode编译器会拦截应用错误信号，让应用进程挂起，方便开发者调试定位问题。此时，SDK无法顺利进行崩溃的错误上报
    // 2. 请关闭项目存在第三方捕获工具，否则会相互产生影响。因为崩溃捕获的机制一致，系统只会保持一个注册的崩溃处理函数
    // ------
    
    /*---------------------------------------------------------------------------------------*/
    [UIApplication sharedApplication].applicationIconBadgeNumber=0.0;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginStateChange:)
                                                 name:KNOTIFICATION_LOGINCHANGE
                                               object:nil];
    message = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (launchOptions != nil) {
        NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if (userInfo != nil) {
            self.userInfo  =userInfo;
        }
        NSLog(@"remote notification:%@",userInfo);
    }
   
    [self loginStateChange:nil];
   // [self LoginIn];
    
    return YES;
}

- (void)LoginIn{
    
    PMPHomeViewController *pmpHomeVC=[[PMPHomeViewController alloc] init];
   // BCPMPHomeViewController *pmpHomeVC=[[BCPMPHomeViewController alloc] init];
    
    BaseNavigationController *navi = [[BaseNavigationController alloc] initWithRootViewController:pmpHomeVC];

    self.window.rootViewController=navi;

}

- (void)signOut{
    
    LoginViewController *loginVC=[[LoginViewController alloc] init];
    
    self.window.rootViewController  = loginVC;

}


#pragma mark - private
//登陆状态改变
-(void)loginStateChange:(NSNotification *)notification
{
    
    BOOL loginSuccess = [notification.object boolValue];
    
    if (loginSuccess) {//登陆成功加载主窗口控制器
  
        [self LoginIn];
        
        
    }else{//登陆失败加载登陆页面控制器
        AccountModel *account = [AccountModel shareAccount];
        [account loadAccountFromSanbox];
        
        LoginViewController *loginVC  = [[LoginViewController alloc] init];
        if (account.passWord&&account.userName) {
            
             [loginVC requestLoginWithName:account.userName pwd:account.passWord];
             self.window.rootViewController = loginVC;
            
        }else{
            
           [self signOut];
            
        }
        
    }
    
    
    
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    [UIColor colorWithRed:0.0 / 255
                    green:122.0 / 255
                     blue:255.0 / 255
                    alpha:1];
    NSLog(@"%@", [NSString stringWithFormat:@"Device Token: %@", deviceToken]);
    [APService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application
didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
- (void)application:(UIApplication *)application
didRegisterUserNotificationSettings:
(UIUserNotificationSettings *)notificationSettings {
}

// Called when your app has been activated by the user selecting an action from
// a local notification.
// A nil action identifier indicates the default action.
// You should call the completion handler as soon as you've finished handling
// the action.
- (void)application:(UIApplication *)application
handleActionWithIdentifier:(NSString *)identifier
forLocalNotification:(UILocalNotification *)notification
  completionHandler:(void (^)())completionHandler {
}

// Called when your app has been activated by the user selecting an action from
// a remote notification.
// A nil action identifier indicates the default action.
// You should call the completion handler as soon as you've finished handling
// the action.
- (void)application:(UIApplication *)application
handleActionWithIdentifier:(NSString *)identifier
forRemoteNotification:(NSDictionary *)userInfo
  completionHandler:(void (^)())completionHandler {
}
#endif

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [APService handleRemoteNotification:userInfo];
      [[NSNotificationCenter defaultCenter] postNotificationName:kCheckInformationRefresh object:@YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:kRemoteNotification object:userInfo];
     [[NSNotificationCenter defaultCenter] postNotificationName:@"MessageCenter" object:nil];
    
    NSLog(@"收到通知:%@", [self logDic:userInfo]);
    
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:
(void (^)(UIBackgroundFetchResult))completionHandler {
    [APService handleRemoteNotification:userInfo];
    NSLog(@"收到通知:%@", [self logDic:userInfo]);
    [[NSNotificationCenter defaultCenter] postNotificationName:kRemoteNotification object:userInfo];
      [[NSNotificationCenter defaultCenter] postNotificationName:kCheckInformationRefresh object:@YES];
       [[NSNotificationCenter defaultCenter] postNotificationName:@"MessageCenter" object:nil];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application
didReceiveLocalNotification:(UILocalNotification *)notification {
    [APService showLocalNotificationAtFront:notification identifierKey:nil];
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
@end
