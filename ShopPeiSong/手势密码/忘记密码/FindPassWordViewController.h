//
//  FindPassWordViewController.h
//  ShopPeiSong
//
//  Created by MIAO on 2017/6/28.
//  Copyright © 2017年 妙灵科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YanButton.h"

@interface FindPassWordViewController : UIViewController
@property (nonatomic,strong)void (^backPhone)(NSString * tel);
@property (nonatomic,strong)void (^popBack)();
@property (nonatomic,strong)NSString * beforeTel;

@property (nonatomic,strong)NSTimer * timer;
@end
