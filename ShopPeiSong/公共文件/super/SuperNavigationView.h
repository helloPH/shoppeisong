//
//  SuperNavigationView.h
//  ShopPeiSong
//
//  Created by MIAO on 2017/6/19.
//  Copyright © 2017年 妙灵科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SuperNavigationView : UIView
@property (nonatomic,strong)UIButton * leftBtn;
@property (nonatomic,strong)UIButton * rightBtn;
@property (nonatomic,strong)UIButton * titleView;

@property (nonatomic,strong)void (^block)(NSInteger index);
@property (nonatomic,strong)void(^backBlock)();
@end
