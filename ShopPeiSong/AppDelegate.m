//
//  AppDelegate.m
//  ShopPeiSong
//
//  Created by MIAO on 2017/3/6.
//  Copyright © 2017年 时元尚品. All rights reserved.
//

#import "AppDelegate.h"
#import "CustomerTabbatViewController.h"
#import "GestureViewController.h"
#import "Header.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
//微信SDK头文件
#import "WXApi.h"
//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

//#import "APOpenAPI.h"
//微信SDK头文件
#import "WXApi.h"

#import "PHPush.h"

//新浪微博SDK头文件
#import "WeiboSDK.h"
//新浪微博SDK需要在项目Build Settings中的Other Linker Flags添加"-ObjC"


#import "PHPay.h"
@interface AppDelegate ()

@end

@implementation AppDelegate
{
    BMKMapManager* _mapManager;
}
-(void)initData{
//    set_User_IsMianMiLogin(NO);
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    if(![[NSUserDefaults standardUserDefaults] valueForKey:@"isFirstShoushi"]){
        [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"isFirstShoushi"];
    }
    if(![[NSUserDefaults standardUserDefaults] valueForKey:@"isFirstDingdanDetil"]){
        [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"isFirstDingdanDetil"];
    }
    GestureViewController *gestureVC = [[GestureViewController alloc]init];
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = gestureVC;
    [self.window makeKeyAndVisible];
    
//    UINavigationController * navi = [[UINavigationController alloc]initWithRootViewController:[LoginViewController new]];
//    self.window.rootViewController = navi;
//    
    
    /*微支付*/
//    [WXApi registerApp:@"wx34d8cb6d9fda6306"];
    [self configBaiduMap];
    [self configShareSdk];

    
    return YES;
}
-(void)configBaiduMap{
    // 要使用百度地图，请先启动BaiduMapManager
    _mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [_mapManager start:@"1GnHQkt3rczn0Y3NYyIwp2hwlkZExXT8"  generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
}
-(void)configShareSdk{
    /**
     *  设置ShareSDK的appKey，如果尚未在ShareSDK官网注册过App，请移步到http://mob.com/login 登录后台进行应用注册
     *  在将生成的AppKey传入到此方法中。
     *  方法中的第二个第三个参数为需要连接社交平台SDK时触发，
     *  在此事件中写入连接代码。第四个参数则为配置本地社交平台时触发，根据返回的平台类型来配置平台信息。
     *  如果您使用的时服务端托管平台信息时，第二、四项参数可以传入nil，第三项参数则根据服务端托管平台来决定要连接的社交SDK。
     */
    

 
    [ShareSDK registerApp:@"1a5460bdf0b6c"
     
          activePlatforms:@[
//                            @(SSDKPlatformTypeSinaWeibo),
//                            @(SSDKPlatformTypeQQ),
//                            @(SSDKPlatformTypeWechat),
                            @(SSDKPlatformTypeMail),
                            @(SSDKPlatformTypeSMS),

                            ]
                 onImport:^(SSDKPlatformType platformType)
     {
         
      
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
             case SSDKPlatformTypeQQ:
                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                 break;
             case SSDKPlatformTypeSinaWeibo:
                 [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                 break;
             default:
                 break;
         }
     }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeSinaWeibo:
                 //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                 [appInfo SSDKSetupSinaWeiboByAppKey:@"568898243"
                                           appSecret:@"38a4f8204cc784f81f9f0daaf31e02e3"
                                         redirectUri:@"http://www.sharesdk.cn"
                                            authType:SSDKAuthTypeBoth];
                 break;
             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:@"wxc5607fe641cd382f"
                                       appSecret:@"499e397e84f2a8ca772b185e6bc614f3"];
                 break;
             case SSDKPlatformTypeQQ:
                 [appInfo SSDKSetupQQByAppId:@"1106006922"
                                      appKey:@"XqiHURUGG4GG5J1b"
                                    authType:SSDKAuthTypeBoth];
                 break;
             case SSDKPlatformTypeRenren:
                 [appInfo        SSDKSetupRenRenByAppId:@"226427"
                                                 appKey:@"fc5b8aed373c4c27a05b712acba0f8c3"
                                              secretKey:@"f29df781abdd4f49beca5a2194676ca4"
                                               authType:SSDKAuthTypeBoth];
                 break;
             default:
                 break;
         }
     }];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark -- 打开url的代理方法
-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options{
    if(sharePay.block){
        sharePay.block(url);
    }
    return YES;
}
-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    if (sharePay.block) {
        sharePay.block(url);
    }
    return YES;
}


#pragma mark -- 推送 的 方法
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    if (sharePush.registBlock) {
        sharePush.registBlock(deviceToken,nil);
    }
}
-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    if (sharePush.registBlock) {
        sharePush.registBlock(nil,error);
    }
}
-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    if (sharePush.localBlock) {
        sharePush.localBlock([notification valueForKey:@"userInfo"]);
    }
}
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    if (sharePush.remoteBlock) {
        sharePush.remoteBlock(userInfo);
    }
}


@end
