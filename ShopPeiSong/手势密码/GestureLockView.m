//
//  GestureLockView.m
//  ManageForMM
//
//  Created by MIAO on 16/9/24.
//  Copyright © 2016年 时元尚品. All rights reserved.
//

#import "GestureLockView.h"
#define SELECT_COLOR [UIColor colorWithRed:0.3 green:0.7 blue:1 alpha:1]
@implementation GestureLockView
{
    NSMutableArray *selectBtnArr;
    CGPoint currentPoint;
    NSString *rightResult;
    NSInteger viewTag;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        selectBtnArr = [NSMutableArray arrayWithCapacity:0];
        self.backgroundColor = [UIColor whiteColor];
        self.layer.shadowRadius = 5.0;
        self.layer.shadowOpacity = 0.5;
        self.alpha = 0.95;
        self.layer.shadowOffset = CGSizeMake(0, 0);
        [self createSelectedBtn];
    }
    return self;
}
-(void)reloDataWithIndex:(NSInteger)index
{
    viewTag = index;
}

-(void)createSelectedBtn
{
    float interval = self.size.width/13;
    float radius = interval*3;
    for (int i = 0; i < 9; i ++) {
        int row = i/3;
        int list = i%3;
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(list*(interval+radius)+interval, row*(interval+radius)+interval, radius, radius)];
        btn.userInteractionEnabled = NO;
        btn.layer.cornerRadius = radius/2.0;
        btn.layer.masksToBounds = YES;
        btn.backgroundColor = [UIColor clearColor];
        [btn setImage:[self drawUnselectImageWithRadius:radius-6] forState:UIControlStateNormal];
        [btn setImage:[self drawSelectImageWithRadius:radius-6] forState:UIControlStateSelected];
        [self addSubview:btn];
        btn.tag = i + 1;
    }
}

//自定义画图
- (void)drawRect:(CGRect)rect
{
    self.layer.cornerRadius = 15.0;
    self.clipsToBounds = YES;
    UIBezierPath *path;
    if (selectBtnArr.count == 0) {
        return;
    }
    path = [UIBezierPath bezierPath];
    path.lineWidth = 6;
    path.lineJoinStyle = kCGLineCapRound;
    path.lineCapStyle = kCGLineCapRound;
    
    if (self.userInteractionEnabled) {
        [[UIColor yellowColor] set];
    }else
    {
        [[UIColor orangeColor] set];
    }
    for (int i = 0; i < selectBtnArr.count; i ++) {
        UIButton *btn = selectBtnArr[i];
        if (i == 0) {
            [path moveToPoint:btn.center];
        }else
        {
            [path addLineToPoint:btn.center];
        }
    }
    [path addLineToPoint:currentPoint];
    [path stroke];
}

//设置密码
- (void)setRigthResult:(NSString *)result
{
    rightResult = result;
    
}

//视图恢复原样
- (void)resetView
{
    for (UIButton *oneSelectBtn in selectBtnArr) {
        oneSelectBtn.selected = NO;
    }
    [selectBtnArr removeAllObjects];
    [self setNeedsDisplay];
}

//输入错误回到原状态
- (void)wrongRevert:(NSArray *)arr
{
    self.userInteractionEnabled = YES;
    for (UIButton *btn in arr) {
        float interval = self.frame.size.width/13;
        float radius = interval*3;
        [btn setImage:[self drawSelectImageWithRadius:radius-6] forState:UIControlStateSelected];
    }
    [self resetView];
}

#pragma mark - Touch
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *oneTouch = [touches anyObject];
    CGPoint point = [oneTouch locationInView:self];
    for (UIButton *oneBtn in self.subviews){
        if (CGRectContainsPoint(oneBtn.frame, point)){
            oneBtn.selected = YES;
            if (![selectBtnArr containsObject:oneBtn]) {
                [selectBtnArr addObject:oneBtn];
            }
        }
    }
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *oneTouch = [touches anyObject];
    CGPoint point = [oneTouch locationInView:self];
    currentPoint = point;
    for (UIButton *oneBtn in self.subviews) {
        if (CGRectContainsPoint(oneBtn.frame, point)) {
            oneBtn.selected = YES;
            if (![selectBtnArr containsObject:oneBtn]) {
                [selectBtnArr addObject:oneBtn];
            }
        }
    }
    [self setNeedsDisplay];
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    //获取结果
    NSMutableString *result = [[NSMutableString alloc]initWithCapacity:0];
    for (int i = 0; i < selectBtnArr.count; i ++) {
        UIButton *btn = (UIButton *)selectBtnArr[i];
        [result appendFormat:@"%d",(int)btn.tag];
    }
    
    NSLog(@"result======%@",result);
    UIButton *lastBtn = [selectBtnArr lastObject];
    currentPoint = lastBtn.center;
    
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"isFirstLogin"]integerValue] == 1) {
        //首次登录
        NSString *passStr = [result stringFromMD5];
        NSString *accont = [NSString stringWithFormat:@"%@",user_tel];
        NSString *pass = [NSString stringWithFormat:@"%@%@",accont,passStr];
        NSString *pass_md5 = [pass stringFromMD5];
        NSString * userid = [NSString stringWithFormat:@"%@",user_Id];
        
        
        
        NSMutableDictionary *pram = [NSMutableDictionary dictionaryWithDictionary:@{@"yuangong.id":userid,@"yuangong.chushimima":pass_md5}];
        NSLog(@"%@",pram);
        MBProgressHUD *mHud = [MBProgressHUD showHUDAddedTo:self animated:YES];
        mHud.mode = MBProgressHUDModeIndeterminate;
        mHud.delegate = self;
        mHud.labelText = @"请稍等...";
        [mHud show:YES];
        
        [HTTPTool getWithUrl:@"checkLogin.action" params:pram success:^(id json) {
            [mHud hide:YES];
            NSLog(@"json  %@",json);
            if ([[json valueForKey:@"message"]integerValue]== 2) {
                [self promptMessageWithString:@"请输入正确的手势密码"];
                if ([self.GestureDelegate respondsToSelector:@selector(GestureLockPasswordWrong:)]) {
                    [self.GestureDelegate GestureLockPasswordWrong:self];
                }
                for (UIButton *btn in selectBtnArr) {
                    float interval = self.frame.size.width/13;
                    float radius = interval*3;
                    [btn setImage:[self drawWrongImageWithRadius:radius-6] forState:UIControlStateSelected];
                }
                [self performSelector:@selector(wrongRevert:) withObject:[NSArray arrayWithArray:selectBtnArr] afterDelay:1];
                self.userInteractionEnabled = NO;
                [self setNeedsDisplay];
            }
            else if ([[json valueForKey:@"message"]integerValue] == 0)
            {
                [self promptMessageWithString:@"参数不能为空"];
                [self resetView];
            }
            else
            {
                [[NSUserDefaults standardUserDefaults] setValue:@"2" forKey:@"isFirstLogin"];
                [[NSUserDefaults standardUserDefaults] setValue:result forKey:@"loginPass"];
                if ([self.GestureDelegate respondsToSelector:@selector(GestureLockPasswordRight:)]) {
                    [self.GestureDelegate GestureLockPasswordRight:self];
                }
                [self resetView];
            }
        } failure:^(NSError *error) {
            [mHud hide:YES];
            [self promptMessageWithString:@"网络连接错误"];
        }];
    }
    else
    {
        
        NSLog(@"user_loginPass%@ rightResult %@",user_loginPass,rightResult);
        
        //结果与正确密码比较
        
        if (user_loginPass) {
            [self yanzhengPasswordWithString:result];
        }
        else
        {
            if (![rightResult isEqualToString:@""]) {
                if ([rightResult isEqualToString:result]) {//密码正确
                    [self.GestureDelegate GestureLockPasswordRight:self];
                    [self resetView];
                }else
                {//密码错误
                    [self.GestureDelegate GestureLockPasswordWrong:self];
                    for (UIButton *btn in selectBtnArr) {
                        float interval = self.frame.size.width/13;
                        float radius = interval*3;
                        [btn setImage:[self drawWrongImageWithRadius:radius-6] forState:UIControlStateSelected];
                    }
                    [self performSelector:@selector(wrongRevert:) withObject:[NSArray arrayWithArray:selectBtnArr] afterDelay:1];
                    self.userInteractionEnabled = NO;
                    [self setNeedsDisplay];
                }
            }else
            {//无密码设置密码
                [self.GestureDelegate GestureLockSetResult:result gestureView:self];
                [self resetView];
            }
        }
    }
}
#pragma mark 验证登录密码
-(void)yanzhengPasswordWithString:(NSString *)string
{
    MBProgressHUD *mHud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    mHud.mode = MBProgressHUDModeIndeterminate;
    mHud.delegate = self;
    mHud.labelText = @"请稍等...";
    [mHud show:YES];
    
    NSString *passStr = [string stringFromMD5];
    NSString *accont = [NSString stringWithFormat:@"%@",user_tel];
    NSString *pass = [NSString stringWithFormat:@"%@%@",accont,passStr];
    NSString *pass_md5 = [pass stringFromMD5];
    NSString *urlStr;
    NSMutableDictionary *pram = [NSMutableDictionary dictionaryWithDictionary:@{@"yuangong.id":user_id,@"yuangong.chushimima":pass_md5}];
    NSLog(@"%@",pram);
    if (viewTag == 0 || viewTag == 1) {
        urlStr = @"checkLogin.action";
    }
    else if (viewTag == 2||viewTag == 5)
    {
        urlStr = @"updateShebei.action";
    }
    [HTTPTool getWithUrl:urlStr params:pram success:^(id json) {
        [mHud hide:YES];
        NSLog(@"登录密码验证 %@",json);
        if ([[json valueForKey:@"message"]integerValue]== 2) {
            [self promptMessageWithString:@"请输入正确的手势密码"];
            if ([self.GestureDelegate respondsToSelector:@selector(GestureLockPasswordWrong:)]) {
                [self.GestureDelegate GestureLockPasswordWrong:self];
            }
            for (UIButton *btn in selectBtnArr) {
                float interval = self.frame.size.width/13;
                float radius = interval*3;
                [btn setImage:[self drawWrongImageWithRadius:radius-6] forState:UIControlStateSelected];
            }
            [self performSelector:@selector(wrongRevert:) withObject:[NSArray arrayWithArray:selectBtnArr] afterDelay:1];
            self.userInteractionEnabled = NO;
            [self setNeedsDisplay];
        }
        else if ([[json valueForKey:@"message"]integerValue] == 0)
        {
            [self promptMessageWithString:@"参数不能为空"];
        }
        else
        {
            [[NSUserDefaults standardUserDefaults] setValue:@"2" forKey:@"isFirstLogin"];
            if (viewTag == 0) {
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"loginPass"];
                NSLog(@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"loginPass"]);
                rightResult = @"";
                NSNotification *newPasswordNot = [NSNotification notificationWithName:@"newPasswordNot" object:nil];
                [[NSNotificationCenter defaultCenter] postNotification:newPasswordNot];
                [[NSNotificationCenter defaultCenter]removeObserver:self name:@"newPasswordNot" object:nil];
                [self resetView];
            }
            else
            {
                [[NSUserDefaults standardUserDefaults] setValue:string forKey:@"loginPass"];
                if ([self.GestureDelegate respondsToSelector:@selector(GestureLockPasswordRight:)]) {
                    [self.GestureDelegate GestureLockPasswordRight:self];
                }
                [self resetView];
            }
        }
    } failure:^(NSError *error) {
        [mHud hide:YES];
        [self promptMessageWithString:@"网络连接错误"];
    }];
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    
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
-(void)promptMessageWithString:(NSString *)string
{
    MBProgressHUD *mHud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    mHud.labelText = string;
    mHud.mode = MBProgressHUDModeText;
    [mHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
}
-(void)myTask
{
    sleep(1);
}

@end

