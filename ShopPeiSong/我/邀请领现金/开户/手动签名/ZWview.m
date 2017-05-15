//
//  ZWview.m
//  画板demo
//
//  Created by yuxin on 15/8/23.
//  Copyright (c) 2015年 yuxin. All rights reserved.
//

#import "ZWview.h"

@interface ZWview()

@property(nonatomic,strong)NSMutableArray * paths;

@end
@implementation ZWview
-(NSMutableArray *)paths
{
    if (_paths == nil) {
        _paths = [NSMutableArray array];
    }
    return _paths;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch * touch = [touches anyObject];
    CGPoint strat = [touch locationInView:touch.view];
    UIBezierPath * path = [UIBezierPath bezierPath];
    [path moveToPoint:strat];
    [self.paths addObject:path];
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch * touch = [touches anyObject];
    CGPoint move = [touch locationInView:touch.view];
    UIBezierPath * curentPath = [self.paths lastObject];
    [curentPath addLineToPoint:move];
    [self setNeedsDisplay];
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    UITouch * touch = [touches anyObject];
    CGPoint end = [touch locationInView:touch.view];
    UIBezierPath * curentPath = [self.paths lastObject];
    [curentPath addLineToPoint:end];
    [self setNeedsDisplay];
    NSNotification *SignNoti = [NSNotification notificationWithName:@"SignNoti" object:nil userInfo:@{@"index":[NSString stringWithFormat:@"%ld",self.paths.count]}];
    [[NSNotificationCenter defaultCenter] postNotification:SignNoti];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touchesCancelled");
}

-(void)drawRect:(CGRect)rect
{
    //    UIBezierPath * path = [UIBezierPath bezierPath];
    //    [path setLineWidth:5];
    //    [path setLineJoinStyle:kCGLineJoinRound];
    //    [path moveToPoint:CGPointMake(20, 20)];
    //    [path addLineToPoint:CGPointMake(100, 100)];
    //    [path addLineToPoint:CGPointMake(200, 200)];
    //    [path stroke];
    for (UIBezierPath * path in self.paths) {
        [path stroke];
        [path setLineWidth:3];
    }
}
-(void)qingpingView
{
    [self.paths removeAllObjects];
    [self setNeedsDisplay];
    NSNotification *SignNoti = [NSNotification notificationWithName:@"SignNoti" object:nil userInfo:@{@"index":[NSString stringWithFormat:@"%ld",self.paths.count]}];
    [[NSNotificationCenter defaultCenter] postNotification:SignNoti];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
//-(void)huituiView
//{
//    [self.paths removeLastObject];
//    [self setNeedsDisplay];
//
//}
@end
