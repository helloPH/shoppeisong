//
//  Request.h
//  ShopPeiSong
//
//  Created by MIAO on 2017/4/28.
//  Copyright © 2017年 妙灵科技. All rights reserved.
//  新的 网络请求类

#import <Foundation/Foundation.h>
#import "HTTPTool.h"
@interface Request : NSObject
#pragma  mark -- 首页
/*
 *增值应用扫码支付
 */
+(void)payBySaomaWithDic:(NSDictionary *)dic success:(successBlock)success failure:(failureBlock)failure;

/*
 *PC端扫码登录
 */
+(void)pcLoginWithScanWithDic:(NSDictionary *)dic success:(successBlock)success failure:(failureBlock)failure;
/*
 *获取收银台弹窗信息
 */
+(void)getShouYinTaiTanChuangInfoWithDic:(NSDictionary *)dic success:(successBlock)success failure:(failureBlock)failure;
/*
 *点击消费中按钮
 */
+(void)checkXiaoFeiZhognWithDic:(NSDictionary *)dic success:(successBlock)success failure:(failureBlock)failure;
/*
 *取消订单
 */
+(void)cancelShouYinTaiOrderWithDic:(NSDictionary *)dic success:(successBlock)success failure:(failureBlock)failure;
/*
 *收款
 */
+(void)shouYinTaiShouKuanWithDic:(NSDictionary *)dic success:(successBlock)success failure:(failureBlock)failure;
/*
 *结束收银台
 */
+(void)endShouYinTaiWithDic:(NSDictionary *)dic success:(successBlock)success failure:(failureBlock)failure;
#pragma mark -- 订单界面
/*
 *获取 已接订单
 */
+(void)getYiJieOrderListWithDic:(NSDictionary *)dic success:(successBlock)success failure:(failureBlock)failure;
/*
 *订单详情
 */
+(void)getOrderInfoWithDic:(NSDictionary *)dic success:(successBlock)success failure:(failureBlock)failure;
/*
 *保存 订单修改
 */
+(void)saveOrderEditWithDic:(NSDictionary *)dic success:(successBlock)success failure:(failureBlock)failure;
/*
 *取消配送费
 */
+(void)cancelOrderPeiSongFeiWithDic:(NSDictionary *)dic success:(successBlock)success failure:(failureBlock)failure;
/*
 * 修改配送费
 */
+(void)alterOrderPeiSongFeiWithDic:(NSDictionary *)dic success:(successBlock)success failure:(failureBlock)failure;
/*
 * 获取商品详情
 */
+(void)getGoodsInfoWithDic:(NSDictionary *)dic success:(successBlock)success failure:(failureBlock)failure;
#pragma mark --- 个人中心
/*
 *判断手机号是否开户
 */
+(void)judgePhoneWithDic:(NSDictionary *)dic success:(successBlock)success failure:(failureBlock)failure;
/*
 *免费开户
 */
+(void)openAccountFreeWithDic:(NSDictionary *)dic success:(successBlock)success failure:(failureBlock)failure;
/*
 *获取验证码
 */
+(void)getYanMaWithDic:(NSDictionary *)dic success:(successBlock)success failure:(failureBlock)failure;
/*
 *获取分享内容
 */
+(void)getFenXiangContentWithDic:(NSDictionary *)dic success:(successBlock)success failure:(failureBlock)failure;
/*
 *获取个人中心信息
 */
+(void)getPersonInfoWithDic:(NSDictionary *)dic success:(successBlock)success failure:(failureBlock)failure;
/*
 *余额是否足够
 */
+(void)getMoneyIsEnoughWithDic:(NSDictionary *)dic success:(successBlock)success failure:(failureBlock)failure;
/*
 *获取服务有效期
 */
+(void)getFuWuYouXiaoQiWithDic:(NSDictionary *)dic success:(successBlock)success failure:(failureBlock)failure;
/*
 *获取服务时间 列表
 */
+(void)getFuWuDateListWithDic:(NSDictionary *)dic success:(successBlock)success failure:(failureBlock)failure;
/*
 *店铺续费
 */
+(void)dianPuXuFeiWithDic:(NSDictionary *)dic success:(successBlock)success failure:(failureBlock)failure;

#pragma mark --- 登录注册
/*
 *登录
 */
+(void)loginWithDic:(NSDictionary *)dic Success:(successBlock)success failure:(failureBlock)failure;
/*
 *验证设备
 */
+(void)yanZhengSheBeiSuccess:(successBlock)success failure:(failureBlock)failure;
/*
 *验证登录密码
 */
+(void)yanZhengLoginPassSuccess:(successBlock)success failure:(failureBlock)failure;
/*
 *开户升级版  选择开户版本
 */
+(void)chooseKaiShengBanbenWithDic:(NSDictionary *)dic success:(successBlock)success failure:(failureBlock)failure;
/*
 *开户升级版  选择开户版本
 */
+(void)kaiHuShengBanWithDic:(NSDictionary *)dic success:(successBlock)success failure:(failureBlock)failure;
/*
 *升级完整版  进入时获取已有的数据
 */
+(void)getShengJiWanInfoBanWithDic:(NSDictionary *)dic success:(successBlock)success failure:(failureBlock)failure;
/*
 *升级完整版  获取费用
 */
+(void)getShengJiWanFeiYongWithDic:(NSDictionary *)dic success:(successBlock)success failure:(failureBlock)failure;
/*
 *升级完整版
 */
+(void)shengJiWanZhengBanWithDic:(NSDictionary *)dic success:(successBlock)success failure:(failureBlock)failure;
/*
 * 获取支付宝 参数
 */
+(void)getZhiFuBaoInfoSuccess:(successBlock)success failure:(failureBlock)failure;
/*
 * 获取版本信息
 */
+(void)getAppStatusSuccess:(successBlock)success failure:(failureBlock)failure;
/*
 *获取开户立减分享内容
 */
+(void)getKaihuLiLianContentSuccess:(successBlock)success failure:(failureBlock)failure;
/*
 * 分享 开户立减内容成功
 */
+(void)successFenxiangKaihuLiLianContentSuccess:(successBlock)success failure:(failureBlock)failure;
@end

