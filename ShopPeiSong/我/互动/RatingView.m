//
//  RatingView.m
//  LifeForMM
//
//  Created by HUI on 15/7/27.
//  Copyright (c) 2015年 时元尚品. All rights reserved.
//

#import "RatingView.h"
#import "Header.h"
@implementation RatingView
-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews
{
    //灰星星
    _gayStartArray = [[NSMutableArray alloc]initWithCapacity:5];
    _grayView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    _grayView.backgroundColor = [UIColor clearColor];
    for (int i = 0; i<5; i++) {
        UIImageView *star = [[UIImageView alloc]initWithFrame:CGRectZero];
        star.backgroundColor = [UIColor clearColor];
        star.image = [UIImage imageNamed:@"未评价"];
        [self addSubview:star];
        [_gayStartArray addObject:star];
    }
    [self addSubview:_grayView];
    //红星星
    _redStartArray = [[NSMutableArray alloc]initWithCapacity:5];
    _redView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    _redView.clipsToBounds = YES;
    [_redView sizeToFit];
    _redView.backgroundColor = [UIColor clearColor];
    for (int j = 0; j<5; j++) {
        UIImageView *redStart = [[UIImageView alloc]initWithFrame:CGRectZero];
        redStart.backgroundColor = [UIColor clearColor];
        redStart.image = [UIImage imageNamed:@"评价"];
        [_redView addSubview:redStart];
        [_redStartArray addObject:redStart];
    }
    [self addSubview:_redView];
}

-(void)setRatingScore:(CGFloat)ratingScore
{
    _ratingScore = ratingScore;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    for (int i = 0; i<5; i++) {
        UIView *gayStart = _gayStartArray[i];
        UIView *redStart = _redStartArray[i];
        gayStart.frame = CGRectMake(35*i*MCscale, 0, 30*MCscale, self.height);
        redStart.frame = CGRectMake(35*i*MCscale, 0, 30*MCscale, self.height);
    }
    CGFloat redWidth  = 15*MCscale;
    if (_ratingScore==0) {
        redWidth = 0;
    }
    else if (_ratingScore>0&&_ratingScore<10*MCscale) {
        redWidth = 15*MCscale;
    }
    else if (_ratingScore <=20*MCscale)
    {
        redWidth = 30*MCscale;
    }
    else if (_ratingScore <=30*MCscale)
    {
        redWidth = 50*MCscale;
    }
    else if (_ratingScore <=40*MCscale)
    {
        redWidth = 65*MCscale;
    }
    else if (_ratingScore <=50*MCscale)
    {
        redWidth = 85*MCscale;
    }
    else if (_ratingScore <=60*MCscale)
    {
        redWidth = 100*MCscale;
    }
    else if (_ratingScore <=70*MCscale)
    {
        redWidth = 120*MCscale;
    }
    else if (_ratingScore <=80*MCscale)
    {
        redWidth = 135*MCscale;
    }
    else if (_ratingScore <=90*MCscale)
    {
        redWidth = 155*MCscale;
    }
    else
        redWidth = 170*MCscale;
    
    _redView.frame = CGRectMake(0, 0, redWidth, self.frame.size.height);
}
@end
