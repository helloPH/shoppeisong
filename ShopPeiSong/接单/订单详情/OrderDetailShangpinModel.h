//
//  OrderDetailShangpinModel.h
//  ShopPeiSong
//
//  Created by MIAO on 2017/3/23.
//  Copyright © 2017年 时元尚品. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderDetailShangpinModel : UIView
@property(nonatomic,strong)NSString *shopid;//商品id
@property(nonatomic,strong)NSString *shopimg;//商品图片
@property(nonatomic,strong)NSString *shopname;//商品名
@property(nonatomic,strong)NSString *shuliang;//数量
@property(nonatomic,strong)NSString *total_money;//钱数
@property(nonatomic,strong)NSString *xianjia;//现价
@property(nonatomic,strong)NSString *xinghao;//型号
@property(nonatomic,strong)NSString *yanse;//颜色
@property(nonatomic,strong)NSString *fujiafei_money;//附加费钱数
@property(nonatomic,strong)NSString *fujiafeishop;//附加费名称
@property(nonatomic,strong)NSString *jiage;//价格

@end
