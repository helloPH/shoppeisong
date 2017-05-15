//
//  BalanceModel.h
//  ShopPeiSong
//
//  Created by MIAO on 2017/3/24.
//  Copyright © 2017年 时元尚品. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BalanceModel : NSObject
@property(nonatomic,strong)NSString *danhao;//单号
@property(nonatomic,strong)NSString *date;//时间
@property(nonatomic,strong)NSString *jine;//金额
@property(nonatomic,strong)NSString *leimu;//类目
@property(nonatomic,strong)NSString *shuoming;//金额状态 （1= 显示’冻’ ，2=’限’ ，0不显示）
@property(nonatomic,strong)NSString *status;//金额状态 （1= 显示’冻’ ，2=’限’ ，0不显示）
@property(nonatomic,strong)NSString *type;//收支类型 （1=显示“+”、0=显示“-”）
@property(nonatomic,strong)NSString *yue;//余额
@property(nonatomic,strong)NSString *zhangdanid;//id

@end

