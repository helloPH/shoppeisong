//
//  OrdersModel.h
//  ShopPeiSong
//
//  Created by MIAO on 2017/3/10.
//  Copyright © 2017年 时元尚品. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrdersModel : NSObject
@property(nonatomic,strong)NSString *address;//收货地址
@property(nonatomic,strong)NSString *button; //显示按钮（按钮序号3-红色交货 按钮序号4-红色收货 按钮序号5-灰色收货 按钮序号6-红色确认收货）
@property(nonatomic,strong)NSString *caigouchengben;//采购成本(用于管家收货时输入的实	际支付成本金额进行对比,不能大于采购成本，当订单状态为配送中时采购成本默认传0）
@property(nonatomic,strong)NSString *chae; //差额 (值为0时不显示)(值为负数时表示需要给用户退差值为正数时表示用户需要补差 )
@property(nonatomic,strong)NSString *chuliren; //处理人姓名（没有值默认传0）
@property(nonatomic,strong)NSString *danhao;//订单号
@property(nonatomic,strong)NSString *date;//下单时间
@property(nonatomic,strong)NSString *dianpuleixing;//店铺类型(1=片区自营  2=入驻商户 3=委托配送)
@property(nonatomic,strong)NSString *dianpulogo;//店铺logo
@property(nonatomic,strong)NSString *jiaohuodate;//交货时间 (按钮为4,5时默认为0)
@property(nonatomic,strong)NSString *jiedandate;//接单时间
@property(nonatomic,strong)NSString *quhuotime;//取货时间 （值为0时不显示)
@property(nonatomic,strong)NSString *shanghu;//商户名称
@property(nonatomic,strong)NSString *shouhuodate; //收货时间 (按钮为4,5时默认为0)
@property(nonatomic,strong)NSString *type; //订单类型(1采购 2管家)（用于用户点击收货按钮后出发的操作，订单类型为2管家时，点击收货弹出输入采购成本框。当订单状态为配送中时订单类型默认传0 )
@property(nonatomic,strong)NSString *zhifufangshi;// //支付方式 (1=货到付款 2=在线支付 3=余额支付)

@end
