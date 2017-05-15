//
//  BalanceRecordModel.h
//  ShopPeiSong
//
//  Created by MIAO on 2017/3/24.
//  Copyright © 2017年 时元尚品. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BalanceRecordModel : NSObject

@property(nonatomic,strong)NSString *cunru;//存入
@property(nonatomic,strong)NSString *daofu;//到付
@property(nonatomic,strong)NSString *date;//时间
@property(nonatomic,strong)NSString *yue;//余额
@property(nonatomic,strong)NSString *zhichu;//支出
@end
