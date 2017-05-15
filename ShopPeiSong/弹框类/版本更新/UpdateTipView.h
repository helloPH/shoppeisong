//
//  UpdateTipView.h
//  LifeForMM
//
//  Created by HUI on 16/3/17.
//  Copyright © 2016年 时元尚品. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UpdateTipView;
@protocol updateTipDelegate <NSObject>

@optional
-(void)updateTip:(UpdateTipView *)updateView tapIndex:(NSInteger)index;

@end
@interface UpdateTipView : UIView
@property (nonatomic,retain)UITextView *txtView;//更新内容
@property (nonatomic,retain)UIButton *updateBtn;//更新btn
@property (nonatomic,retain)UIButton *rejectBtn;//拒绝更新btn
@property (nonatomic,weak)id<updateTipDelegate>delegate;
@end
