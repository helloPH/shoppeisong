//
//  YanZhengMaViewController.h
//  ShopPeiSong
//
//  Created by MIAO on 2017/6/26.
//  Copyright © 2017年 妙灵科技. All rights reserved.
//

#import "SuperViewController.h"

@interface YanZhengMaViewController : SuperViewController


@property (nonatomic,strong)NSString * phone;
@property (nonatomic,strong)void (^block)(NSString * yanzhengma);

-(void)clear;
@end
