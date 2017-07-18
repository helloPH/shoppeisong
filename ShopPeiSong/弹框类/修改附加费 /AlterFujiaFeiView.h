//
//  AlterFujiaFeiView.h
//  ShopPeiSong
//
//  Created by MIAO on 2017/7/10.
//  Copyright © 2017年 妙灵科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlterFujiaFeiView : UIView
@property (nonatomic,strong)void (^block)(NSString * string);

-(void)appear;
-(void)disAppear;
@end
