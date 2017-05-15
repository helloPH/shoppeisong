//
//  KeQiangDiandanModel.h
//  ShopPeiSong
//
//  Created by MIAO on 2017/3/9.
//  Copyright © 2017年 时元尚品. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeQiangDiandanModel : NSObject
@property(nonatomic,strong)NSString *dianpulogo; //店铺logo
@property(nonatomic,strong)NSString *danhao;//订单号
@property(nonatomic,strong)NSString *time;//时间
@property(nonatomic,strong)NSString *shanghu;//商户名称
@property(nonatomic,strong)NSString *shouhuodizhi;//收货地址
@property(nonatomic,strong)NSString *shifoukeqiang; //是否可抢单[ 1可抢--按钮序号为1(红色抢单按钮) 2不可抢--按钮序号为2(灰色抢单按钮)]
@property(nonatomic,strong)NSString *biaoji;//订单标记 （0常规订单无标记 1 标记为采购正在配货）
@property(nonatomic,strong)NSString *status;//是否是新订单（0 , 1=新订单 2=老订单）
@property(nonatomic,strong)NSString *peisongfangshi;
@end
