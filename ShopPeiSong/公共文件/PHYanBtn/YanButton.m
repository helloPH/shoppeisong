//
//  YanButton.m
//  PHPackAge
//
//  Created by wdx on 2017/1/11.
//  Copyright © 2017年 wdx. All rights reserved.
//

#import "YanButton.h"
@interface YanButton ()
@property (nonatomic,assign)NSUInteger totalTime;
@property (nonatomic,strong)NSString * titleYan;
@property (nonatomic,strong)NSTimer * timer;
@property (nonatomic,assign)NSInteger realTime;
@end
@implementation YanButton
+(YanButton *)insButtonWithFrame:(CGRect )frame title:(NSString *)title  time:(NSInteger)time{
    YanButton * button=[[YanButton alloc]initWithFrame:frame];
    button.titleYan=title;
    button.totalTime=time;
    button.realTime=time;
    
    [button setTitle:title forState:UIControlStateNormal];
    return button;
}
-(NSString *)titleYan{
    if (!_titleYan) {
    return @"获取验证码";
    }
    return _titleYan;
}

-(void)startTimer{
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerEnent:) userInfo:nil repeats:YES];
    NSString * value=[NSString stringWithFormat:@"%ld",(long)_realTime];
    [self setTitle:value forState:UIControlStateNormal];
    self.userInteractionEnabled=NO;
}
-(void)timerEnent:(NSTimer *)timer{
    _realTime--;
    if (_realTime >= 0) {
        NSString * value=[NSString stringWithFormat:@"%ld",(long)_realTime];
        [self setTitle:value forState:UIControlStateNormal];
    }else{
           [self endTimer];
    }
}
-(void)endTimer{
    _realTime=_totalTime;
    self.userInteractionEnabled=YES;
    [self setTitle:_titleYan forState:UIControlStateNormal];
    [_timer invalidate];
    _timer=nil;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
