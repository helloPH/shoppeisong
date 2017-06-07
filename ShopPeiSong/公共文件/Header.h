//
//  Header.h
//  ManageForMM
//
//  Created by MIAO on 16/9/20.
//  Copyright © 2016年 时元尚品. All rights reserved.
//

#ifndef Header_h
#define Header_h


#endif /* Header_h */


#import <UIKit/UIKit.h>
#import "UIViewExt.h"
#import "MBProgressHUD.h"
#import "HTTPTool.h"
#import "BaseCostomer.h"
#import "NSString+MD5Addition.h"
#import "Request.h"
#import "tool/NSString+Helper.h"
//#import <CoreLocation/CoreLocation.h>
//#import <ShareSDK/ShareSDK.h>
//#import <ShareSDKConnector/ShareSDKConnector.h>
////微信SDK头文件
#import "WXApi.h"
////腾讯开放平台（对应QQ和QQ空间）SDK头文件
//#import <TencentOpenAPI/TencentOAuth.h>
//#import <TencentOpenAPI/QQApiInterface.h>
//#import "APOpenAPIObject.h"
//#import "APOpenAPI.h"
////微信SDK头文件
//#import "WXApi.h"
//
////新浪微博SDK头文件
//#import "WeiboSDK.h"
////新浪微博SDK需要在项目Build Settings中的Other Linker Flags添加"-ObjC"
//
////人人SDK头文件
//#import <RennSDK/RennSDK.h>
//
#import "UIImageView+WebCache.h"
#import "SDWebImageManager.h"
#import "MJRefresh.h"
#import "Masonry.h"
#import <Foundation/Foundation.h>
//#import <AlipaySDK/AlipaySDK.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件
#import <BaiduMapAPI_Map/BMKMapView.h>//只引入所需的单个头文件
#define user_id [[NSUserDefaults standardUserDefaults]valueForKey:@"user_ID"]//用户ID
#define user_shebeiId [[UIDevice currentDevice].identifierForVendor UUIDString]//设备ID
#define user_canshu  [[NSUserDefaults standardUserDefaults]valueForKey:@"canshu"]//公司名
#define user_chengshi  [[NSUserDefaults standardUserDefaults]valueForKey:@"chengshi"]//公司名
#define user_name  [[NSUserDefaults standardUserDefaults]valueForKey:@"name"]//公司名
#define user_zhiwu  [[NSUserDefaults standardUserDefaults]valueForKey:@"zhiwu"]//公司名

#define user_kaihufei [[NSUserDefaults standardUserDefaults]valueForKey:@"kaihufeiyong"]//开户费
#define shipin [[NSUserDefaults standardUserDefaults]valueForKey:@"shipin"]//视频是否下载过
#define user_dianpulogo [[NSUserDefaults standardUserDefaults]valueForKey:@"dianpulogo"]//店铺lodo
#define user_show [[NSUserDefaults standardUserDefaults]valueForKey:@"show"]//员工身份



//登录分享内容
#define set_LoginShareContent(loginShareContent) [[NSUserDefaults standardUserDefaults] setValue:loginShareContent forKey:@"loginShareContent"]//登录时的分享内容
#define loginShareContent [[NSUserDefaults standardUserDefaults]valueForKey:@"loginShareContent"]//登录时的分享内容


//店铺名字名字
#define set_DianPuName(shequname) [[NSUserDefaults standardUserDefaults] setValue:shequname forKey:@"dianpuname"]//店铺名字
#define dianPuName [[NSUserDefaults standardUserDefaults]valueForKey:@"dianpuname"]//店铺名字





#define set_LoginPass(loginPass) [[NSUserDefaults standardUserDefaults] setValue:loginPass forKey:@"loginPass"]//用户登录密码
#define user_loginPass [[NSUserDefaults standardUserDefaults]valueForKey:@"loginPass"]//用户登录密码

#define user_tel [[NSUserDefaults standardUserDefaults]valueForKey:@"user_tel"]//用户手机号
#define set_User_Tel(user_Tel) [[NSUserDefaults standardUserDefaults] setValue:user_Tel forKey:@"user_tel"]//用户手机号


//收银台权限
#define set_User_ShouYingTaiQX(shouyintaiquanxian)  [[NSUserDefaults standardUserDefaults] setBool:shouyintaiquanxian forKey:@"shouyintaiquanxian"]
#define user_ShouYingTaiQX  [[NSUserDefaults standardUserDefaults]boolForKey:@"shouyintaiquanxian"]

//免密支付
#define set_MianMiPay(mianMiPay)  [[NSUserDefaults standardUserDefaults] setBool:mianMiPay forKey:@"mianMiPay"]
#define mianMiPay  [[NSUserDefaults standardUserDefaults]boolForKey:@"mianMiPay"]

//是否已经登录
#define set_IsLogin(isLogin)  [[NSUserDefaults standardUserDefaults] setBool:isLogin forKey:@"user_IsLogin"]
#define isLogin  [[NSUserDefaults standardUserDefaults]boolForKey:@"user_IsLogin"]

//用户id
#define user_Id [[NSUserDefaults standardUserDefaults] valueForKey:@"user_ID"]
#define set_User_Id(userid) [[NSUserDefaults standardUserDefaults] setValue:userid forKey:@"user_ID"]

//店铺id
#define set_User_dianpuID(dianpuid) [[NSUserDefaults standardUserDefaults] setValue:dianpuid forKey:@"dianpuID"]
#define user_dianpuID [[NSUserDefaults standardUserDefaults]valueForKey:@"dianpuID"]//店铺ID

// before and after
#define banben_IsAfter [[NSUserDefaults standardUserDefaults]boolForKey:@"banBen_isAfter"]
#define set_Banben_IsAfter(isAfter) [[NSUserDefaults standardUserDefaults] setBool:isAfter forKey:@"banBen_isAfter"]





// 是否免密登录
#define user_IsMianMiLogin [[NSUserDefaults standardUserDefaults]boolForKey:@"user_IsMianMiLogin"]//员工身份
#define set_User_IsMianMiLogin(isMianMi) [[NSUserDefaults standardUserDefaults] setBool:isMianMi forKey:@"user_IsMianMiLogin"]

//   部门职务
#define user_BuMen [[NSUserDefaults standardUserDefaults] valueForKey:@"bumen"]
#define set_User_BuMen(bumen) [[NSUserDefaults standardUserDefaults] setValue:bumen forKey:@"bumen"]


//是否在岗
#define set_IsZaiGang(zaigang)  [[NSUserDefaults standardUserDefaults] setBool:zaigang forKey:@"iszaigang"]
#define isZaiGang  [[NSUserDefaults standardUserDefaults]boolForKey:@"iszaigang"]


// 系统推送 保存上次的推送值
#define push_SystemValue [[NSUserDefaults standardUserDefaults] valueForKey:@"pushsystemvalue"]
#define set_Push_SystemValue(pushsystemvalue) [[NSUserDefaults standardUserDefaults] setValue:pushsystemvalue forKey:@"pushsystemvalue"]

// 推送提醒时间
#define pushTimeInter [[NSUserDefaults standardUserDefaults] integerForKey:@"pushTimerInter"]
#define set_PushTimeInter(timeInter) [[NSUserDefaults standardUserDefaults] setInteger:timeInter forKey:@"pushTimerInter"]


#define user_PATH [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) firstObject] stringByAppendingPathComponent:@"yingyongArrayXML.xml"]

#define stor_url @"https://itunes.apple.com/cn/app/miao-dian-jia-pei-song/id1163948137?mt=8"




#define HTTPHEADER @"http://www.shp360.com/MshcShopGuanjia/"
#define HTTPImage @"http://www.shp360.com/Store/"
#define HTTPWeb @"http://www.shp360.com/"


//#define HTTPHEADER @"http://192.168.1.250:8080/MshcShopGuanjia/"
//#define HTTPImage @"http://192.168.1.250:8080/Store/"
//#define HTTPWeb @"http://192.168.1.250:8080/"




#ifdef DEBUG
#define NSLog(format, ...) printf("[%s] %s [第%d行] %s\n", __TIME__, __FUNCTION__, __LINE__, [[NSString stringWithFormat:format, ## __VA_ARGS__] UTF8String]);
#else
#define NSLog(format, ...)
#endif

#define iPhone (([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)?(YES):(NO))
//屏幕大小
#define kDeviceHeight [UIScreen mainScreen].bounds.size.height
#define kDeviceWidth [UIScreen mainScreen].bounds.size.width
#define IPHONE_5 ((kDeviceHeight < 667.0)? (YES):(NO))
#define IPHONE_6 ((kDeviceHeight == 667.0)? (YES):(NO))
#define IPHONE_Plus ((kDeviceHeight > 667.0)? (YES):(NO))

//字体大小
#define MLwordFont_14 (iPhone?(IPHONE_5 ? 26 : 30):(32))
#define MLwordFont_1  (iPhone?(IPHONE_5 ? 22 : 25):(27))
#define MLwordFont_11 (iPhone?(IPHONE_5 ? 19 : 22):(24))
#define MLwordFont_15 (iPhone?(IPHONE_5 ? 19 : 21):(23))
#define MLwordFont_2  (iPhone?(IPHONE_5 ? 18 : 20):(22))
#define MLwordFont_3  (iPhone?(IPHONE_5 ? 17 : 19):(21))
#define MLwordFont_4  (iPhone?(IPHONE_5 ? 16 : 18):(20))
#define MLwordFont_12 (iPhone?(IPHONE_5 ? 15 : 17):(19))
#define MLwordFont_5  (iPhone?(IPHONE_5 ? 14 : 16):(18))
#define MLwordFont_6  (iPhone?(IPHONE_5 ? 13 : 15):(17))
#define MLwordFont_7  (iPhone?(IPHONE_5 ? 12 : 14):(16))
#define MLwordFont_8  (iPhone?(IPHONE_5 ? 12 : 13):(15))
#define MLwordFont_9  (iPhone?(IPHONE_5 ? 11 : 12):(14))
#define MLwordFont_10 (iPhone?(IPHONE_5 ? 10 : 11):(13))
#define MLwordFont_13 (iPhone?(IPHONE_5 ? 9 : 10):(12))

//导航栏
#define NVbtnWight (iPhone?(IPHONE_5 ? 22 : 25):(26)) //导航栏按钮大小
#define SEtxtfiledWidth (iPhone?(IPHONE_5 ? 200 : 240):(280)) //搜索框长度
#define MCscale (iPhone?(IPHONE_5 ? 0.85 : 1):(1.25))

//颜色
#define mainColor  [UIColor colorWithRed:4/255.0 green:196/255.0 blue:153/255.0 alpha:1]
#define naviBarTintColor  [UIColor colorWithRed:4/255.0 green:196/255.0 blue:153/255.0 alpha:1]




#define txtColors(r,g,b,alp) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:alp]
#define textColors txtColors(109.0,109.0,109.0,1)
#define placeHolderColor txtColors(194, 195, 196, 1)  //占位符字体颜色
#define textBlackColor txtColors(72, 73, 74, 0.9)
#define lineColor txtColors(74, 75, 76, 0.2) //画线的颜色
#define redTextColor txtColors(237, 58, 76, 1) //红色字体颜色
