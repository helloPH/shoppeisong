//
//  TGCenterLineLabel.m
//  团购
//
//  Created by app24 on 14-7-28.
//  Copyright (c) 2014年 app24. All rights reserved.
//


// ***************划线——————————————————————————————

#import "TGCenterLineLabel.h"

@implementation TGCenterLineLabel

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    // 1.获得上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    // 2.设置颜色
    [self.textColor setStroke];
    
    // 3.画线
    CGFloat y = rect.size.height * 0.4;
    CGContextMoveToPoint(ctx, -2, y);
    CGFloat endX = [self.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.font,NSFontAttributeName, nil]].width;
    CGContextAddLineToPoint(ctx, endX+5, y);
    
    // 4.渲染
    CGContextStrokePath(ctx);
}

@end
