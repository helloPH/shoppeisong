//
//  Request.m
//  ShopPeiSong
//
//  Created by MIAO on 2017/4/28.
//  Copyright © 2017年 妙灵科技. All rights reserved.
//

#import "Request.h"
#import "MBProgressHUD.h"
#import "Header.h"
#import "AFNetworking.h"
@implementation Request
#pragma  mark -- 首页
/*
 *增值应用扫码支付
 */
+(void)payBySaomaWithDic:(NSDictionary *)dic success:(successBlock)success failure:(failureBlock)failure{
    NSString * url = @"AddYingyng.action";
    [MBProgressHUD start];
    [HTTPTool getWithBaseUrl:HTTPImage url:url params:[NSMutableDictionary dictionary] success:^(id json) {
        [MBProgressHUD stop];
        success(json);
    } failure:^(NSError *error) {
        [MBProgressHUD stop];
        [MBProgressHUD promptWithString:@"网络请求失败"];
        failure(error);
    }];
    
    
}
/*
 *PC端扫码登录
 */
+(void)pcLoginWithScanWithDic:(NSDictionary *)dic success:(successBlock)success failure:(failureBlock)failure{
    NSString * url = @"UpdateLoginInfo.action";
    [MBProgressHUD start];
    [HTTPTool getWithBaseUrl:HTTPImage url:url params:[NSMutableDictionary dictionaryWithDictionary:dic] success:^(id json) {
        [MBProgressHUD stop];
        success(json);
    } failure:^(NSError *error) {
        [MBProgressHUD stop];
        //        [MBProgressHUD promptWithString:@"网络请求失败"];
        failure(error);
    }];
}
/*
 *获取收银台弹窗信息
 */
+(void)getShouYinTaiTanChuangInfoWithDic:(NSDictionary *)dic success:(successBlock)success failure:(failureBlock)failure{
    NSString * url = @"shouyintai.action";
    [MBProgressHUD start];
    [HTTPTool getWithBaseUrl:HTTPHEADER url:url params:[NSMutableDictionary dictionaryWithDictionary:dic] success:^(id json) {
        [MBProgressHUD stop];
        success(json);
    } failure:^(NSError *error) {
        [MBProgressHUD stop];
        //        [MBProgressHUD promptWithString:@"网络请求失败"];
        failure(error);
    }];
}
/*
 *点击消费中按钮
 */
+(void)checkXiaoFeiZhognWithDic:(NSDictionary *)dic success:(successBlock)success failure:(failureBlock)failure{
    NSString * url = @"xiaofeizhong.action";
    [MBProgressHUD start];
    [HTTPTool getWithBaseUrl:HTTPHEADER url:url params:[NSMutableDictionary dictionaryWithDictionary:dic] success:^(id json) {
        [MBProgressHUD stop];
        success(json);
    } failure:^(NSError *error) {
        [MBProgressHUD stop];
        [MBProgressHUD promptWithString:@"网络请求失败"];
        failure(error);
    }];
}
/*
 *取消订单
 */
+(void)cancelShouYinTaiOrderWithDic:(NSDictionary *)dic success:(successBlock)success failure:(failureBlock)failure{
    NSString * url = @"cancleDingdan.action";
    [MBProgressHUD start];
    [HTTPTool getWithBaseUrl:HTTPHEADER url:url params:[NSMutableDictionary dictionaryWithDictionary:dic] success:^(id json) {
        [MBProgressHUD stop];
        success(json);
    } failure:^(NSError *error) {
        [MBProgressHUD stop];
        [MBProgressHUD promptWithString:@"网络请求失败"];
        failure(error);
    }];
}
/*
 *收款
 */
+(void)shouYinTaiShouKuanWithDic:(NSDictionary *)dic success:(successBlock)success failure:(failureBlock)failure{
    NSString * url = @"shouyintaiShoukuan.action";
    [MBProgressHUD start];
    [HTTPTool getWithBaseUrl:HTTPHEADER url:url params:[NSMutableDictionary dictionaryWithDictionary:dic] success:^(id json) {
        [MBProgressHUD stop];
        success(json);
    } failure:^(NSError *error) {
        [MBProgressHUD stop];
        [MBProgressHUD promptWithString:@"网络请求失败"];
        failure(error);
    }];

}
/*
 *结束收银台
 */
+(void)endShouYinTaiWithDic:(NSDictionary *)dic success:(successBlock)success failure:(failureBlock)failure{
    NSString * url = @"yijieshu.action";
    [MBProgressHUD start];
    [HTTPTool getWithBaseUrl:HTTPHEADER url:url params:[NSMutableDictionary dictionaryWithDictionary:dic] success:^(id json) {
        [MBProgressHUD stop];
        success(json);
    } failure:^(NSError *error) {
        [MBProgressHUD stop];
        [MBProgressHUD promptWithString:@"网络请求失败"];
        failure(error);
    }];
    
}
#pragma mark -- 订单界面
/*
 *获取 已接订单列表
 */
+(void)getYiJieOrderListWithDic:(NSDictionary *)dic success:(successBlock)success failure:(failureBlock)failure{
    NSString * url = @"getDingdan.action";
    [MBProgressHUD start];
    [HTTPTool postWithUrl:url params:[NSMutableDictionary dictionaryWithDictionary:dic] success:^(id json){
        [MBProgressHUD stop];
        success(json);
    } failure:^(NSError *error) {
        [MBProgressHUD stop];
        [MBProgressHUD promptWithString:@"网络请求失败"];
        failure(error);
    }];
}
+(void)getOrderInfoWithDic:(NSDictionary *)dic success:(successBlock)success failure:(failureBlock)failure{
    NSString * url = @"dingdanInfo.action";
    [MBProgressHUD start];
    [HTTPTool getWithUrl:url params:[NSMutableDictionary dictionaryWithDictionary:dic] success:^(id json){
        [MBProgressHUD stop];
        success(json);
    } failure:^(NSError *error) {
        [MBProgressHUD stop];
        [MBProgressHUD promptWithString:@"服务器请求失败"];
        failure(error);
    }];
}
/*
 *保存 订单修改
 */
+(void)saveOrderEditWithDic:(NSDictionary *)dic success:(successBlock)success failure:(failureBlock)failure{
    NSString * url = @"saveDingdan.action";
    [MBProgressHUD start];
    [HTTPTool postWithUrl:url params:[NSMutableDictionary dictionaryWithDictionary:dic] success:^(id json){
        [MBProgressHUD stop];
        success(json);
    } failure:^(NSError *error) {
        [MBProgressHUD stop];
        [MBProgressHUD promptWithString:@"网络请求失败"];
        failure(error);
    }];
    
    
    
    
}

#pragma mark --- 个人中心
/*
 *判断手机号是否开户
 */
+(void)judgePhoneWithDic:(NSDictionary *)dic success:(successBlock)success failure:(failureBlock)failure{
    NSString * url = @"kaihuCheck.action";
    [MBProgressHUD start];
    [HTTPTool postWithUrl:url params:[NSMutableDictionary dictionaryWithDictionary:dic] success:^(id json){
        [MBProgressHUD stop];
        success(json);
    } failure:^(NSError *error) {
        [MBProgressHUD stop];
        [MBProgressHUD promptWithString:@"服务器请求失败"];
        failure(error);
    }];
}
/*
 *免费开户
 */
+(void)openAccountFreeWithDic:(NSDictionary *)dic success:(successBlock)success failure:(failureBlock)failure{
    NSString * url = @"kaihuMianfei.action";
    [MBProgressHUD start];
    [HTTPTool postWithUrl:url params:[NSMutableDictionary dictionaryWithDictionary:dic] success:^(id json){
        [MBProgressHUD stop];
        success(json);
    } failure:^(NSError *error) {
        [MBProgressHUD stop];
        [MBProgressHUD promptWithString:@"服务器请求失败"];
        failure(error);
    }];
    
}
/*
 *获取个人中心信息
 */
+(void)getPersonInfoWithDic:(NSDictionary *)dic success:(successBlock)success failure:(failureBlock)failure{
    NSString * url = @"personalCenter.action";
    [MBProgressHUD start];
    [HTTPTool postWithUrl:url params:[NSMutableDictionary dictionaryWithDictionary:dic] success:^(id json){
        [MBProgressHUD stop];
        success(json);
    } failure:^(NSError *error) {
        [MBProgressHUD stop];
        [MBProgressHUD promptWithString:@"服务器请求失败"];
        failure(error);
    }];
}
+(void)getYanMaWithDic:(NSDictionary *)dic success:(successBlock)success failure:(failureBlock)failure{
    NSString * url = @"fansongyangzhengma.action";
    [MBProgressHUD start];
    [HTTPTool postWithUrl:url params:[NSMutableDictionary dictionaryWithDictionary:dic] success:^(id json) {
        [MBProgressHUD stop];
        success(json);
    } failure:^(NSError *error) {
        [MBProgressHUD stop];
        [MBProgressHUD promptWithString:@"网络请求失败"];
        failure(error);
    }];
    
    
}
/*
 *获取分享内容
 */
+(void)getFenXiangContentWithDic:(NSDictionary *)dic success:(successBlock)success failure:(failureBlock)failure{
    [MBProgressHUD start];
    [HTTPTool  getWithBaseUrl:@"http://www.shp360.com/MshcShop/" url:@"fenxiangFriends.action" params:[NSMutableDictionary dictionaryWithDictionary:dic] success:^(id json) {
        [MBProgressHUD stop];
        success(json);
    } failure:^(NSError *error) {
        [MBProgressHUD stop];
        [MBProgressHUD promptWithString:@"网络连接错误"];
        failure(error);
    }];
}
/*
 *余额是否足够
 */
+(void)getMoneyIsEnoughWithDic:(NSDictionary *)dic success:(successBlock)success failure:(failureBlock)failure{
    [MBProgressHUD start];
    [HTTPTool  getWithBaseUrl:HTTPImage url:@"enoughMoney.action" params:[NSMutableDictionary dictionaryWithDictionary:dic] success:^(id json) {
        [MBProgressHUD stop];
        success(json);
    } failure:^(NSError *error) {
        [MBProgressHUD stop];
        [MBProgressHUD promptWithString:@"网络连接错误"];
        failure(error);
    }];
}
#pragma mark --- 登录注册
/*
 *登录
 */
+(void)loginWithDic:(NSDictionary *)dic Success:(successBlock)success failure:(failureBlock)failure{
    [MBProgressHUD start];
    [HTTPTool  getWithBaseUrl:HTTPHEADER url:@"yuangongLogin.action" params:[NSMutableDictionary dictionaryWithDictionary:dic] success:^(id json) {
        [MBProgressHUD stop];
        
        
        NSString * message = [NSString stringWithFormat:@"%@",[json valueForKey:@"message"]];
        switch ([message integerValue]) {
            case 0:
                [MBProgressHUD promptWithString:@"无此员工信息"];
                break;
            case 1://登录成功
            {
                        set_User_Id([json valueForKey:@"yuangongid"]);
                         success(json);
            }
                break;
            case 2:
                [MBProgressHUD promptWithString:@"密码有误"];
                break;
            case 3:
                [MBProgressHUD promptWithString:@"员工身份无效"];
                break;
            default:
                break;
        }
        
        

        
        
    } failure:^(NSError *error) {
        [MBProgressHUD stop];
        //        [MBProgressHUD promptWithString:@"网络连接错误"];
        failure(error);
    }];
}
/*
 *验证设备
 */
+(void)yanZhengSheBeiSuccess:(successBlock)success failure:(failureBlock)failure{
    [MBProgressHUD start];
    [HTTPTool  getWithBaseUrl:HTTPHEADER url:@"checkShebei.action" params:[NSMutableDictionary dictionaryWithDictionary:@{@"yuangong.shebeishenfen":user_shebeiId}] success:^(id json) {
        [MBProgressHUD stop];
        success(json);
    } failure:^(NSError *error) {
        [MBProgressHUD stop];
        //        [MBProgressHUD promptWithString:@"网络连接错误"];
        failure(error);
    }];
}
/*
 *验证登录密码
 */
+(void)yanZhengLoginPassSuccess:(successBlock)success failure:(failureBlock)failure{
    [MBProgressHUD start];
    [HTTPTool  getWithBaseUrl:HTTPHEADER url:@"checkLogin.action" params:[NSMutableDictionary dictionaryWithDictionary:@{@"yuangong.shebeishenfen":user_shebeiId}] success:^(id json) {
        [MBProgressHUD stop];
        NSString * message = [NSString stringWithFormat:@"%@",[json valueForKey:@"message"]];
        switch ([message integerValue]) {
            case 0:
                [MBProgressHUD promptWithString:@"参数有空"];
                break;
            case 1:
                 success(json);
                break;
            case 2:
                [MBProgressHUD promptWithString:@"密码验证失败"];
                break;
                
            default:
                break;
        }
        
        

    } failure:^(NSError *error) {
        [MBProgressHUD stop];
        //        [MBProgressHUD promptWithString:@"网络连接错误"];
        failure(error);
    }];
   
}
/*
 *开户升级版  选择开户版本
 */
+(void)chooseKaiShengBanbenWithDic:(NSDictionary *)dic success:(successBlock)success failure:(failureBlock)failure{
    [MBProgressHUD start];
    [HTTPTool  getWithBaseUrl:HTTPHEADER url:@"kaihuBanben.action" params:[NSMutableDictionary dictionaryWithDictionary:dic] success:^(id json) {
        [MBProgressHUD stop];
        success(json);
    } failure:^(NSError *error) {
        [MBProgressHUD stop];
        [MBProgressHUD promptWithString:@"网络连接错误"];
        failure(error);
    }];
}
/*
 *开户升级版  选择开户版本
 */
+(void)kaiHuShengBanWithDic:(NSDictionary *)dic success:(successBlock)success failure:(failureBlock)failure{
    [MBProgressHUD start];
    [HTTPTool  postWithBaseUrl:HTTPHEADER url:@"kaihuShengji.action" params:[NSMutableDictionary dictionaryWithDictionary:dic] success:^(id json) {
        [MBProgressHUD stop];
        success(json);
    } failure:^(NSError *error) {
        [MBProgressHUD stop];
        [MBProgressHUD promptWithString:@"网络连接错误"];
        failure(error);
    }];
}
/*
 *升级完整版  进入时获取已有的数据
 */
+(void)getShengJiWanInfoBanWithDic:(NSDictionary *)dic success:(successBlock)success failure:(failureBlock)failure{
    [MBProgressHUD start];
    [HTTPTool  postWithBaseUrl:HTTPHEADER url:@"enterkaihuWanzheng.action" params:[NSMutableDictionary dictionaryWithDictionary:dic] success:^(id json) {
        [MBProgressHUD stop];
        success(json);
    } failure:^(NSError *error) {
        [MBProgressHUD stop];
        [MBProgressHUD promptWithString:@"网络连接错误"];
        failure(error);
    }];
}
/*
 *升级完整版  获取费用
 */
+(void)getShengJiWanFeiYongWithDic:(NSDictionary *)dic success:(successBlock)success failure:(failureBlock)failure{
 
    [HTTPTool  postWithBaseUrl:HTTPHEADER url:@"chooseBanben.action" params:[NSMutableDictionary dictionaryWithDictionary:dic] success:^(id json) {
        [MBProgressHUD stop];
        success(json);
    } failure:^(NSError *error) {
        [MBProgressHUD stop];
        [MBProgressHUD promptWithString:@"网络连接错误"];
        failure(error);
    }];
}
/*
 *升级完整版
 */
+(void)shengJiWanZhengBanWithDic:(NSDictionary *)dic success:(successBlock)success failure:(failureBlock)failure{
    [MBProgressHUD start];
    [HTTPTool  postWithBaseUrl:HTTPHEADER url:@"kaihuWanzheng.action" params:[NSMutableDictionary dictionaryWithDictionary:dic] success:^(id json) {
        [MBProgressHUD stop];
        success(json);
    } failure:^(NSError *error) {
        [MBProgressHUD stop];
        [MBProgressHUD promptWithString:@"网络连接错误"];
        failure(error);
    }];
}
/*
 * 获取支付宝 参数
 */
+(void)getZhiFuBaoInfoSuccess:(successBlock)success failure:(failureBlock)failure{
    [MBProgressHUD start];
    [HTTPTool  postWithBaseUrl:@"http://www.shp360.com/MshcShop/" url:@"zhifu.action" params:[NSMutableDictionary dictionaryWithDictionary:@{}] success:^(id json) {
        [MBProgressHUD stop];
        success(json);
    } failure:^(NSError *error) {
        [MBProgressHUD stop];
        [MBProgressHUD promptWithString:@"网络连接错误"];
        failure(error);
    }];
}
/*
 * 获取版本信息
 */
+(void)getAppStatusSuccess:(successBlock)success failure:(failureBlock)failure{
//    [MBProgressHUD start];
    [HTTPTool  postWithBaseUrl:HTTPHEADER url:@"banbeniosStatus.action" params:[NSMutableDictionary dictionaryWithDictionary:@{@"banbenhao":@"1.5"                                                                                                                        }] success:^(id json) {
//        [MBProgressHUD stop];
        success(json);
    } failure:^(NSError *error) {
//        [MBProgressHUD stop];
//        [MBProgressHUD promptWithString:@"网络连接错误"];
        failure(error);
    }];
}
@end
