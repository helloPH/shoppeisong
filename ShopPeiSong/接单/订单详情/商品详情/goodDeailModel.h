//
//  goodDeailModel.h
//  LifeForMM
//
//  Created by HUI on 15/8/20.
//  Copyright (c) 2015年 时元尚品. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface goodDeailModel : NSObject

@property(nonatomic,copy)NSString *caigoujia;// 采购价
@property(nonatomic,strong)NSString *canpinpic;// 图片
@property(nonatomic,retain)NSString *fujiafei;// 附加费
@property(nonatomic,copy)NSString *shangpinid;//商品id
@property(nonatomic,copy)NSString *shangpinname;//商品名
@property(nonatomic,copy)NSString *xianjia;//现价
@property(nonatomic,copy)NSString *yuanjia;//原价


@property(nonatomic,strong)NSArray *kexuanmoney;
// 搭档
@property(nonatomic,copy)NSArray *guanxishangpin;//搭档 id
@property(nonatomic,retain)NSArray  *guanlianpic;//搭档 图片
@property(nonatomic,retain)NSArray *shangpinjianjie;//搭档 简介
@property(nonatomic,strong)NSArray *shopcaigoujia;//搭档 采购价
@property(nonatomic,strong)NSArray *shopfujiafei;//搭档 附加费
@property(nonatomic,strong)NSArray *shopname;//搭档 名字
@property(nonatomic,strong)NSArray *shopxianjia;//搭档 现价

// 可选
@property(nonatomic,retain)NSArray *kexuanyanse;//可选颜色
@property(nonatomic,retain)NSArray *kexuanyansepic;//可选图片
@property(nonatomic,copy)NSArray *xinghao;//型号





@end
