//
//  SelectPayWay.h
//  ShopPeiSong
//
//  Created by MIAO on 2017/5/3.
//  Copyright © 2017年 妙灵科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Header.h"

@interface ShouYinTaiPayWay : UIView
@property (nonatomic,strong)void (^block)();
@property (nonatomic,strong)NSString * danhao;
-(void)appear;
-(void)disAppear;
@end
