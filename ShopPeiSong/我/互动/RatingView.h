//
//  RatingView.h
//  LifeForMM
//
//  Created by HUI on 15/7/27.
//  Copyright (c) 2015年 时元尚品. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RatingView : UIView
{
    @private
    NSMutableArray *_gayStartArray;//存放灰星星
    NSMutableArray *_redStartArray;//存放红星星
}
@property(nonatomic,retain)UIView *grayView;//灰星星
@property(nonatomic,retain)UIView *redView;//红星星
@property(nonatomic,assign)CGFloat ratingScore;//评分
@end
