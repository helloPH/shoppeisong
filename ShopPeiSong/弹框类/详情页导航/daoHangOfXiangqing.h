//
//  daoHangOfXiangqing.h
//  ShopPeiSong
//
//  Created by MIAO on 2017/4/27.
//  Copyright © 2017年 妙灵科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface daoHangOfXiangqing : UIView
@property (nonatomic,strong)NSString * qiLongi;
@property (nonatomic,strong)NSString * qiLati;
@property (nonatomic,strong)NSString * zhongLongi;
@property (nonatomic,strong)NSString * zhongLati;

@property (nonatomic,strong)void (^block)();
@end
