//
//  CancalOrderView.h
//  ShopPeiSong
//
//  Created by MIAO on 2017/4/13.
//  Copyright © 2017年 妙灵科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CancalOrderViewDelegate <NSObject>

-(void)cancalOrderSuccessWithIndex:(NSInteger)index;

@end
@interface CancalOrderView : UIView

@property(nonatomic,strong)id<CancalOrderViewDelegate>cancalDelegate;
@property(nonatomic,strong)UITextField *RecordTextField;
@property(nonatomic,strong)NSString *danhaoStr;

@end
