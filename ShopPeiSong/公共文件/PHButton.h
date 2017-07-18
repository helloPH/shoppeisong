//
//  PHButton.h
//  ShopPeiSong
//
//  Created by MIAO on 2017/6/12.
//  Copyright © 2017年 妙灵科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PHButton.h"
typedef NS_ENUM(NSUInteger , ImgDirection) {
    imgLeft,
    imgTop,
    imgRight,
    imgBotton
};

typedef void(^Block)();
@interface PHButton : UIButton
@property (nonatomic,assign)ImgDirection imgDirection;

@property (nonatomic,strong)Block block;


-(void)addAction:(Block)block;
- (void)changeTitleLeft;
@end
