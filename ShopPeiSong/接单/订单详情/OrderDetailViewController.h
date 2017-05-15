//
//  OrderDetailViewController.h
//  ShopPeiSong
//
//  Created by MIAO on 2017/3/8.
//  Copyright © 2017年 时元尚品. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrdersModel.h"
@interface OrderDetailViewController : UIViewController

@property(nonatomic,strong)OrdersModel *model;
@property(nonatomic,strong)NSString *danhao;
@property(nonatomic,assign)NSInteger viewTag;
//@property(nonatomic,assign)NSInteger viewTag;
@end
