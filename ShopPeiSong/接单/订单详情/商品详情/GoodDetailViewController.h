//
//  GoodDetailViewController.h
//  LifeForMM
//
//  Created by MIAO on 16/11/9.
//  Copyright © 2016年 时元尚品. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShangpinModel.h"
@interface GoodDetailViewController : UIViewController
@property(nonatomic,copy)NSString *goodId;//商品id
@property(nonatomic,copy)NSString *dianpuId;//店铺id
@property(nonatomic,copy)NSString *goodtag;//标签图片url
@property(nonatomic,copy)NSString *zhuangtai;//商品状态

@property(nonatomic,assign)NSInteger ViewTag; //


@property (nonatomic,strong)void (^block)(NSMutableArray * hasGoodArr);
@property(nonatomic,strong)NSMutableArray * hasGoodArray;


@end
