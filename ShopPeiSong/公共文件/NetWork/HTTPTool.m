//
//  HTTPTool.m
//  TabBarCommon(分栏公用)
//
//  Created by Code on 15/6/29.
//  Copyright (c) 2015年 com.sk. All rights reserved.
//

#import "HTTPTool.h"
#import "AFNetworking.h"
#import "Header.h"

#define outTimes 20
@implementation HTTPTool
+(void)getWithBaseUrl:(NSString *)baseUrl url:(NSString *)url params:(NSMutableDictionary *)params success:(successBlock)success failure:(failureBlock)failure{
    // 1.获取AFN的请求管理者
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    //网络延时设置15秒
    manger.requestSerializer.timeoutInterval = outTimes;
    NSString * urlPath = [NSString stringWithFormat:@"%@%@",baseUrl,url];
    // 3.发送请求
    [manger GET:urlPath parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];

    
    
}
+ (void)getWithUrl:(NSString *)url params:(NSMutableDictionary *)params success:(successBlock)success failure:(failureBlock)failure
{
    // 1.获取AFN的请求管理者
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    //网络延时设置15秒
    manger.requestSerializer.timeoutInterval = outTimes;
    NSString * urlPath = [NSString stringWithFormat:@"%@%@",HTTPHEADER,url];
    // 3.发送请求
    [manger POST:urlPath parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}
+ (void)postWithBaseUrl:(NSString *)baseUrl url:(NSString *)url params:(NSMutableDictionary *)params  success:(successBlock)success failure:(failureBlock)failure{
    // 1.获取AFN的请求管理者
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    //网络延时设置15秒
    manger.requestSerializer.timeoutInterval = outTimes;
    manger.responseSerializer = [AFJSONResponseSerializer serializer];
    NSString * urlPath = [NSString stringWithFormat:@"%@%@",baseUrl,url];
    // 3.发送请求
    [manger POST:urlPath parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    
    
}
+ (void)postWithUrl:(NSString *)url params:(NSMutableDictionary *)params success:(successBlock)success failure:(failureBlock)failure
{
    // 1.获取AFN的请求管理者
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    //网络延时设置15秒
    manger.requestSerializer.timeoutInterval = outTimes;
    manger.responseSerializer = [AFJSONResponseSerializer serializer];
    NSString * urlPath = [NSString stringWithFormat:@"%@%@",HTTPHEADER,url];
    // 3.发送请求
    [manger POST:urlPath parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}
+ (void)postWithUrl:(NSString *)url params:(NSMutableDictionary *)params fileArray:(NSArray *)fileArr success:(successBlock)success failure:(failureBlock)failure
{
    // 1.获取AFN的请求管理者
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    //网络延时设置15秒
    manger.requestSerializer.timeoutInterval = outTimes;
    NSString * urlPath = [NSString stringWithFormat:@"%@%@",HTTPHEADER,url];
    [manger POST:urlPath
      parameters:params
constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
     {
         for (int i=0; i<fileArr.count; i++) {
             NSData *imageData = UIImageJPEGRepresentation(fileArr[i], 0.9);
             [formData appendPartWithFileData:imageData name:[NSString stringWithFormat:@"file%d",i+1] fileName:[NSString stringWithFormat:@"file%d",i+1] mimeType:@"image/jpeg"];
         }
     }
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             if (success) {
                 success(responseObject);
             }
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             if (failure) {
                 failure(error);
             }
         }];
}
+ (void)postWithUrl:(NSString *)url params:(NSMutableDictionary *)params image:(UIImage *)image success:(successBlock)success failure:(failureBlock)failure
{
    // 1.获取AFN的请求管理者
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    //网络延时设置15秒
    manger.requestSerializer.timeoutInterval = outTimes;
    NSString * urlPath = [NSString stringWithFormat:@"%@%@",HTTPImage,url];
    
    [manger POST:urlPath parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData){
         NSData *imageData = UIImageJPEGRepresentation(image, 0.9);
         NSString *fileName = [NSString stringWithFormat:@"%@.png",user_id];
         [formData appendPartWithFileData:imageData name:@"file" fileName:fileName mimeType:@"image/jpeg"];
     }
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             if (success) {
                 success(responseObject);
             }
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             if (failure) {
                 failure(error);
             }
         }];
}
@end
