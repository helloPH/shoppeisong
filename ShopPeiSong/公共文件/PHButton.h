//
//  PHButton.h
//  ShopPeiSong
//
//  Created by MIAO on 2017/6/12.
//  Copyright © 2017年 妙灵科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PHButton.h"

typedef void(^Block)();
@interface PHButton : UIButton
@property (nonatomic,strong)Block block;
-(void)addAction:(Block)block;
@end
