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
#import "PHPush.h"
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
#import "PHMap.h"

#import "PHJavaScriptHelper.h"
#import "IQKeyboardManager.h"

#import "GuideViewController.h"

@interface AppDelegate ()
@property (nonatomic,assign)UIBackgroundTaskIdentifier bgTask;
@end

@implementation AppDelegate

-(void)initData{
    
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
//    　　//控制点击背景是否收起键盘
    manager.shouldResignOnTouchOutside = YES;
//    　　//控制键盘上的工具条文字颜色是否用户自定义。
//    manager.shouldToolbarUsesTextFieldTintColor = YES;
//    　　//控制是否显示键盘上的工具条。
//    manager.enableAutoToolbar = NO;
    
    
    
    if (!push_SystemValue) {
       set_Push_SystemValue(@"0");
    }

//    set_User_IsMianMiLogin(NO);
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self initData];
    [self beginBgTask];
    
    
    if(![[NSUserDefaults standardUserDefaults] valueForKey:@"isFirstShoushi"]){
        [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"isFirstShoushi"];
    }
    if(![[NSUserDefaults standardUserDefaults] valueForKey:@"isFirstDingdanDetil"]){
        [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"isFirstDingdanDetil"];
    }
    [self switchRootController];
    
//    UINavigationController * navi = [[UINavigationController alloc]initWithRootViewController:[LoginViewController new]];
//    self.window.rootViewController = navi;
//    
    
    /*微支付*/
//    [WXApi registerApp:@"wx34d8cb6d9fda6306"];
    [[PHMapHelper new]configBaiduMap];
    [self configShareSdk];
    [self beginBgTask];
    
    return YES;
}
-(void)switchRootController{
    GuideViewController * guide = [GuideViewController new];
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = guide;
    [self.window makeKeyAndVisible];
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
                            @(SSDKPlatformTypeWechat),
//                            @(SSDKPlatformTypeMail),
//                            @(SSDKPlatformTypeSMS),
                         

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
                 [appInfo SSDKSetupWeChatByAppId:@"wx34d8cb6d9fda6306"
                          appSecret:@"b59d82e254d344bc015e262b677bbd20"];
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
    [self beginBgTask];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    
//    [self initPushTimer];
    
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//    [self initPushTimer];
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
#pragma mark -- tuisong
-(void)endBgTask{
    if (_bgTask) {
        UIApplication *app = [UIApplication sharedApplication];
        [app endBackgroundTask:_bgTask];
    }
}
- (void)beginBgTask{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];

    if (!banben_IsAfter) {
        return;
    }
    
   
    int timeinter=60;
    __block int weakTimeInter = timeinter;
    
//    if (!pushTimeInter || pushTimeInter == 0 ) {
//        [self endBgTask];
//        return;
//    }
    
    
    
    NSLog(@"### -->backgroundinghandler");
    UIApplication *app = [UIApplication sharedApplication];

    [sharePush registWithBlock:^(NSData *token, NSError *error) {
        
    }];

    
    _bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        __block UIBackgroundTaskIdentifier weakBgTask =_bgTask;
        dispatch_async(dispatch_get_main_queue(),^{
            if( weakBgTask != UIBackgroundTaskInvalid){
                weakBgTask = UIBackgroundTaskInvalid;
            }
        });
        NSLog(@"====任务完成了。。。。。。。。。。。。。。。===>");
        [app endBackgroundTask:weakBgTask];
    }];

    
    // Start the long-running task
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        while (true) {
            if (!banben_IsAfter) {
                break;
            }
            
            NSString * urString = [NSString stringWithFormat:@"%@GuanjiaInfo.jsp?%@",HTTPImage,user_Id];
            NSURL * url = [NSURL URLWithString:urString];
            NSString * htmlString = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
            
            PHJavaScriptHelper * jshelper = [PHJavaScriptHelper new];
            jshelper.htmlString = htmlString;
            NSArray * arrar =  [jshelper getInfoS];

            
            NSLog(@"推送的数据解析-------:%@",arrar);
            for (NSDictionary * dic in arrar) {
               NSString * value = [NSString stringWithFormat:@"%@",dic[@"value"]];
               NSString * Id = [NSString stringWithFormat:@"%@",dic[@"id"]];
                
                if (![value isEmptyString] && ![value isEqualToString:@"0"]) {
                    
                    NSString * title;
                    switch ([Id integerValue]) {
                        case 1:
                            title = @"欢迎使用妙店佳商铺";
                            if ([value isEqualToString:@"0"]) {
                                if (isZaiGang) {
                                        NSLog(@"进入推送2");
                                        Id = @"2";
                                }else{
                                    Id = @"0";
                                }
                            }else{
                                if ([value isEqualToString:push_SystemValue]) {
                                    if (isZaiGang) {
                                        NSLog(@"进入推送2");
                                        Id = @"2";
                                    }
                                    else{
                                        Id = @"0";
                                    }
                                }
                            }
                            break;
                        case 2:
                            title = @"员工";
                            break;
                        case 3:
                            break;
                        default:
                            break;
                    }
                    if ([Id integerValue]==1) {//系统
                        set_Push_SystemValue(value);
                        [sharePush localPushWithTitle:title body:@"点击进入详情"  time:0 sound:nil pram:dic];
                    }else if ([Id integerValue]==2){
                        if ([value isEqualToString:@"0"]) {// pc端地图接口
                            
                        }else{// 进入推送3
                            
                        }
                    }else if([Id integerValue]==1){//新订单
                        if (user_id) {
                            weakTimeInter = (int)pushTimeInter;
                            title = [NSString stringWithFormat:@"%@ %@",dianPuName,user_name];
                            value = @"用户新订单提醒";
                            [sharePush localPushWithTitle:title body:value  time:0 sound:@"dingdantixng.mp3" pram:dic];
                            //          dingdantixng.mp3
                        }
                    }
                }
            }
            sleep(timeinter);
        }
        
    });
}
@end
