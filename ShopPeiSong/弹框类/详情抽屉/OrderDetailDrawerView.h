//
//  OrderDetailDrawerView.h
//  ShopPeiSong
//
//  Created by MIAO on 2017/3/31.
//  Copyright © 2017年 妙灵科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OrderDetailDrawerViewDelegate <NSObject>
-(void)selectedTargetWithIndex:(NSInteger)index;
@end
@interface OrderDetailDrawerView : UIView
@property(nonatomic,strong)id<OrderDetailDrawerViewDelegate>drawerDelegate;
@end
