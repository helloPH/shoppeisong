//
//  LatexView.m
//  九宫格
//
//  Created by alive on 16/8/15.
//  Copyright © 2016年 alive. All rights reserved.
//

#import "LatexView.h"
#define SELECT_COLOR [UIColor colorWithRed:0.3 green:0.7 blue:1 alpha:1]

@interface LatexView()

@property(nonatomic,strong)NSMutableArray *btnArra;
@property(nonatomic,assign)CGPoint currentPoint;

@end

@implementation LatexView

-(NSMutableArray *)btnArra
{
    if (_btnArra == nil) {
        _btnArra =[NSMutableArray array];
    }
    return _btnArra;
}


-(instancetype)initWithFrame:(CGRect)frame
{
    self =[super initWithFrame:frame];
    if (self) {
        for (int i = 0; i<9; i++) {
            UIButton * btn=[UIButton buttonWithType:UIButtonTypeCustom];
            btn.userInteractionEnabled = NO;
            [btn setTitle:[NSString stringWithFormat:@"%d",i+1] forState:UIControlStateNormal];
            
            CGFloat width=74;
            [btn setImage:[self drawUnselectImageWithRadius:width-6] forState:UIControlStateNormal];
            [btn setImage:[self drawSelectImageWithRadius:width-6] forState:UIControlStateSelected];
            [btn setBackgroundImage:[self drawWrongImageWithRadius:width -6] forState:UIControlStateSelected];
       
            [btn setBackgroundImage:[self drawWrongImageWithRadius:width - 6] forState:UIControlStateDisabled];
            [self addSubview:btn];
            
            CGFloat height=74;
            CGFloat Margin=(self.frame.size.width-3*width)/4;
            //  遍历设置9个button的frame
            [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                //    通过tag设置按钮的索引标识
                obj.tag=idx+50;
                int row=(int)idx/3;
                int col=idx%3;
                obj.frame=CGRectMake(col*(Margin + width)+Margin, row*(Margin +height)+Margin, width, height);
            }];
        }

    }
    return self;
}
-(CGPoint)pointWithTouch:(NSSet *)touches
{
    //拿到触摸的点
    UITouch *touch =[touches anyObject];
    CGPoint point =[touch locationInView:touch.view];
    
    return point;
}
-(UIButton *)buttonWithPoint:(CGPoint )point
{
    //根据触摸的点拿到相应的按钮
    for (UIButton *btn in self.subviews) {
        //
        if (CGRectContainsPoint(btn.frame, point)) {
            return btn;
        }
    }
    return nil;
}

//开始触摸
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    [self setStatus:lockBtnTypeNoSelected];
    
    //拿到触摸的点
    CGPoint point =[self pointWithTouch:touches];
    self.currentPoint=point;
    //根据触摸的点拿到相应的按钮
    UIButton *btn =[self buttonWithPoint:point];
    if (btn && btn.selected == NO) {
        btn.selected = YES;
        [self.btnArra addObject:btn];//往数组或者字典中添加数组的时候要判断是否存在
    }
}
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //拿到触摸的点
    CGPoint point =[self pointWithTouch:touches];
    //根据触摸的点拿到相应的按钮
    UIButton *btn =[self buttonWithPoint:point];
    if (btn && btn.selected == NO) {
        btn.selected = YES;
        [self.btnArra addObject:btn];//往数组或者字典中添加数组的时候要判断是否存在
    }else{
        self.currentPoint = point;
    }
    [self setNeedsDisplay];
  
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.currentPoint=((UIButton *)(self.btnArra.lastObject)).center;
    NSMutableString *path =[NSMutableString string];
    for (UIButton *btn in self.btnArra) {
        [path appendFormat:@"%ld",(long)btn.tag+1-50];
    }


    if (_block) {
        _block(path);
    }
    if (_passWord==nil || [_passWord isEqualToString:@""]) {
        [self setStatus:lockBtnTypeNoSelected];
    }else if (![_passWord isEqualToString:path]){
        [self setStatus:lockBtnTypeWrong];
    }else{
        [self setStatus:lockBtnTypeNoSelected];
    }
 
}
-(void)setStatus:(LockBtnType)lockBtnType{
    //遍历按钮
    if (lockBtnType == lockBtnTypeNoSelected) {
        for (int i = 0 ; i < 9; i ++) {
            
            UIButton * btn = [self viewWithTag:i+50];
            if ([btn isKindOfClass:[UIButton class]]) {
                [btn setEnabled:YES];
                [btn setSelected:NO];
            }
        }
    }else{
        for (int i =0; i<self.btnArra.count; i++) {
            UIButton *btn =self.btnArra[i];
            [btn setSelected:NO];
            [btn setEnabled:YES];
            if (lockBtnType == lockBtnTypeSelected) {// 选中
                [btn setSelected:YES];
            }else{// 手势错误
                [btn setEnabled:NO];
            }
        }
    }
    // 清空数组
    if (lockBtnType != lockBtnTypeWrong) {
        [self.btnArra removeAllObjects];
    }
    
    // 刷新
    [self setNeedsDisplay];
}
#pragma mark ---绘图
-(void)drawRect:(CGRect)rect
{
    if (self.btnArra.count == 0) {
        
        return;
    }
    UIBezierPath *path =[UIBezierPath bezierPath];
    path.lineWidth = 6;
    path.lineJoinStyle = kCGLineJoinRound;
    
    UIColor * currentColor;
    if (((UIButton *)(self.btnArra[0])).enabled) {// 普通选中
        currentColor = [UIColor colorWithRed:32/255.0 green:210/255.0 blue:254/255.0 alpha:0.5];
    }else{// 错误
        currentColor = [UIColor orangeColor];
    }
    [currentColor set];
    //遍历按钮
    for (int i =0; i<self.btnArra.count; i++) {
        UIButton *btn =self.btnArra[i];
        if (i  == 0) {//设置起点
            [path moveToPoint:btn.center];
        }else{
            [path addLineToPoint:btn.center];
        }
    }
    [path addLineToPoint:self.currentPoint];
    [path stroke];
}
#pragma mark - CGContext使用
//画未选中点图片
- (UIImage *)drawUnselectImageWithRadius:(float)radius
{
    UIGraphicsBeginImageContext(CGSizeMake(radius+6, radius+6));
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextAddEllipseInRect(context, CGRectMake(3, 3, radius, radius));
    [[UIColor lightGrayColor] setStroke];
    CGContextSetLineWidth(context, 5);
    
    CGContextDrawPath(context, kCGPathStroke);
    
    UIImage *unselectImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return unselectImage;
}

//画选中点图片
- (UIImage *)drawSelectImageWithRadius:(float)radius
{
    UIGraphicsBeginImageContext(CGSizeMake(radius+6, radius+6));
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, 5);
    
    CGContextAddEllipseInRect(context, CGRectMake(3+radius*5/12, 3+radius*5/12, radius/6, radius/6));
    
    UIColor *selectColor = SELECT_COLOR;
    
    [selectColor set];
    
    CGContextDrawPath(context, kCGPathFillStroke);
    
    CGContextAddEllipseInRect(context, CGRectMake(3, 3, radius, radius));
    
    [selectColor setStroke];
    
    CGContextDrawPath(context, kCGPathStroke);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

//画错误图片
- (UIImage *)drawWrongImageWithRadius:(float)radius
{
    UIGraphicsBeginImageContext(CGSizeMake(radius+6, radius+6));
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, 5);
    
    CGContextAddEllipseInRect(context, CGRectMake(3+radius*5/12, 3+radius*5/12, radius/6, radius/6));
    
    UIColor *selectColor = [UIColor orangeColor];
    
    [selectColor set];
    
    CGContextDrawPath(context, kCGPathFillStroke);
    
    CGContextAddEllipseInRect(context, CGRectMake(3, 3, radius, radius));
    
    [selectColor setStroke];
    
    CGContextDrawPath(context, kCGPathStroke);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

@end
