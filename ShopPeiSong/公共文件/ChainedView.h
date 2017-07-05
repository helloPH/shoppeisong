//
//  ChainedView.h
//  ShopPeiSong
//
//  Created by MIAO on 2017/6/30.
//  Copyright © 2017年 妙灵科技. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ChainedView : UIView
@property(nonatomic, readonly) ChainedView *(^backGroundColor)(UIColor * backGroundColor);
@property(nonatomic, readonly) ChainedView *(^frame)(CGRect rect);


@end
