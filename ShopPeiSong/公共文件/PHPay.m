//
//  PHPay.m
//  ShopPeiSong
//
//  Created by MIAO on 2017/5/10.
//  Copyright © 2017年 妙灵科技. All rights reserved.
//

#import "PHPay.h"
#import "Order.h"
#import "RSADataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
#import "Request.h"
#import "Header.h"

#define SCHEME @"aliMiaoShangpu"



static dispatch_once_t once;
static PHPay * pay;

@implementation PHPay
+(instancetype)share{
    dispatch_once(&once, ^{
        pay = [PHPay new];
        [pay initData];
    });
    return pay;
}
+(void)tearDown{
    pay=nil;
    once=0;
}
-(void)initData{
    self.block=^(NSURL * url){
        if ([url.host isEqualToString:@"safepay"]) {
//             支付跳转支付宝钱包进行支付，处理支付结果
            [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
                NSLog(@"result = %@",resultDic);
            }];
            
            // 授权跳转支付宝钱包进行支付，处理支付结果
            [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
                NSLog(@"result = %@",resultDic);
                // 解析 auth code
                NSString *result = resultDic[@"result"];
                NSString *authCode = nil;
                if (result.length>0) {
                    NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                    for (NSString *subResult in resultArr) {
                        if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                            authCode = [subResult substringFromIndex:10];
                            break;
                        }
                    }
                }
                NSLog(@"授权结果 authCode = %@", authCode?:@"");
            }];
        }
    };
    
}


-(void)pay:(NSDictionary *)dic success:(void (^)(NSDictionary *))block{
    }

- (NSString *)generateTradeNO
{
    static int kNumber = 15;
    
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand((unsigned)time(0));
    for (int i = 0; i < kNumber; i++)
    {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
}


@end

