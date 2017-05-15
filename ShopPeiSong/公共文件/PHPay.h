//
//  PHPay.h
//  ShopPeiSong
//
//  Created by MIAO on 2017/5/10.
//  Copyright © 2017年 妙灵科技. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface PHPay : NSObject
#define sharePay [PHPay share]
@property (nonatomic,strong)void(^block)(NSURL * url);
+(instancetype)share;
+(void)tearDown;
- (void)pay:(NSDictionary  *)dic success:(void(^)(NSDictionary * resultDic))block;
@end

