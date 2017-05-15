//
//  HTTPTool.h
//  TabBarCommon(分栏公用)
//
//  Created by Code on 15/6/29.
//  Copyright (c) 2015年 com.sk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef void (^successBlock)(id json);
typedef void (^failureBlock)(NSError *error);

@interface HTTPTool : NSObject
/**
 *  get请求
 *
 *  @param baseUrl 地址前缀
 *  @param url     请求地址
 *  @param params  请求参数
 *  @param success 请求成功的回调
 *  @param failure 请求失败的回调
 */
+(void)getWithBaseUrl:(NSString *)baseUrl url:(NSString *)url params:(NSMutableDictionary *)params success:(successBlock)success failure:(failureBlock)failure;

/**
 *  get请求
 *
 *  @param url     请求地址
 *  @param params  请求参数
 *  @param success 请求成功的回调
 *  @param failure 请求失败的回调
 */
+ (void)getWithUrl:(NSString *)url params:(NSMutableDictionary *)params success:(successBlock)success failure:(failureBlock)failure;
/**
 *  post请求
 *  @param baseUrl 请求地址头
 *  @param url     请求地址
 *  @param params  请求参数
 *  @param success 请求成功的回调
 *  @param failure 请求失败的回调
 */
+ (void)postWithBaseUrl:(NSString *)baseUrl url:(NSString *)url params:(NSMutableDictionary *)params  success:(successBlock)success failure:(failureBlock)failure;

/**
 *  post请求
 *
 *  @param url     请求地址
 *  @param params  请求参数
 *  @param success 请求成功的回调
 *  @param failure 请求失败的回调
 */
+ (void)postWithUrl:(NSString *)url params:(NSMutableDictionary *)params  success:(successBlock)success failure:(failureBlock)failure;
/**
 *  post请求
 *
 *  @param url     请求地址
 *  @param params  请求参数
 *  @param fileArr 图片数组
 *  @param success 请求成功的回调
 *  @param failure 请求失败的回调
 */
+ (void)postWithUrl:(NSString *)url params:(NSMutableDictionary *)params fileArray:(NSArray *)fileArr success:(successBlock)success failure:(failureBlock)failure;
/**
 *  post请求
 *
 *  @param url     请求地址
 *  @param params  请求参数
 *  @param image   图片
 *  @param success 请求成功的回调
 *  @param failure 请求失败的回调
 */
+ (void)postWithUrl:(NSString *)url params:(NSMutableDictionary *)params image:(UIImage *)image success:(successBlock)success failure:(failureBlock)failure;
@end
