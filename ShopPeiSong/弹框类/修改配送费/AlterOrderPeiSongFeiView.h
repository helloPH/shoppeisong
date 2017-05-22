//
//  AlterOrderPeiSongFeiView.h
//  ShopPeiSong
//
//  Created by MIAO on 2017/5/21.
//  Copyright © 2017年 妙灵科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlterOrderPeiSongFeiView : UIView
@property (nonatomic,strong)NSString * danhao;
@property (nonatomic,strong)void (^block)();
-(void)appear;
-(void)disAppear;
@end
