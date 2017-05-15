//
//  ShangpinMessagesModel.h
//  ShopPeiSong
//
//  Created by MIAO on 2017/3/21.
//  Copyright © 2017年 时元尚品. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShangpinMessagesModel : NSObject
@property(nonatomic,strong)NSString *shangpinid;//商品id
@property(nonatomic,strong)NSString *mingcheng;//商品名称
@property(nonatomic,strong)NSString *xianjia;//现价
@property(nonatomic,strong)NSString *status;//状态 (1上架 0下架)
@end
