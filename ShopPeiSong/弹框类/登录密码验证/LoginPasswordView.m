//
//  LoginPasswordView.m
//  ManageForMM
//
//  Created by MIAO on 16/9/20.
//  Copyright © 2016年 时元尚品. All rights reserved.
//

#import "LoginPasswordView.h"
#import "Header.h"

@interface LoginPasswordView ()
@property(nonatomic,strong) UIButton * backView;
@property(nonatomic,strong)GestureLockView *gesView;//手势密码
@end
@implementation LoginPasswordView
{
    NSString *passResult;
    NSInteger viewTag;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(newPasswordNot) name:@"newPasswordNot" object:nil];
        self.backgroundColor = txtColors(231, 231, 231, 1);
        self.layer.cornerRadius = 15.0;
        self.layer.shadowRadius = 5.0;
        self.layer.shadowOpacity = 0.5;
        self.alpha = 0.95;
        self.layer.shadowOffset = CGSizeMake(0, 0);
        self.promptLabel.text = @"请输入手势密码";
    }
    return self;
}
-(void)reloadDataWithViewTag:(NSInteger)viewtag
{
    viewTag = viewtag;
    [self.gesView reloDataWithIndex:viewTag];
}
-(GestureLockView *)gesView
{
    if (!_gesView) {
        _gesView = [[GestureLockView alloc]initWithFrame:CGRectMake(10*MCscale, 50*MCscale,self.width-20*MCscale,self.height - 60*MCscale)];
        _gesView.GestureDelegate = self;
        [self addSubview:_gesView];
    }
    return _gesView;
}

-(UILabel *)promptLabel
{
    if (!_promptLabel) {
        _promptLabel = [BaseCostomer labelWithFrame:CGRectMake(self.width/2-75*MCscale, 10*MCscale, 150*MCscale, 30*MCscale) font:[UIFont systemFontOfSize:MLwordFont_4] textColor:mainColor backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentCenter numOfLines:1 text:@""];
        [self addSubview:_promptLabel];
    }
    return _promptLabel;
}
#pragma mark - GestureLockViewDelegate
//原密码为nil调用
- (void)GestureLockSetResult:(NSString *)result gestureView:(GestureLockView *)gestureView
{
    NSLog(@"输入密码：%@",result);
    passResult = result;
    [gestureView setRigthResult:result];
    self.promptLabel.text = @"请确认密码";
}

//密码核对成功调用
- (void)GestureLockPasswordRight:(GestureLockView *)gestureView
{
    self.promptLabel.text = @"密码正确";
    if ([self.loginPassDelegate respondsToSelector:@selector(changeNewPassWordWithString:AndIndex:)]) {
        [self.loginPassDelegate changeNewPassWordWithString:passResult AndIndex:viewTag];
    }
    if (_block) {
        _block(YES);
    }
    
}
//密码核对失败调用
- (void)GestureLockPasswordWrong:(GestureLockView *)gestureView
{
    NSLog(@"密码错误");
    self.promptLabel.text = @"密码错误";
    [self performSelector:@selector(resetLabel) withObject:nil afterDelay:1];
    if (_block) {
        _block(NO);
    }
}
- (void)resetLabel
{
    self.promptLabel.text = @"请输入正确的密码";
}

-(void)newPasswordNot
{
    self.promptLabel.text = @"请输入新密码";
}
-(void)appear{
    _backView = [[UIButton alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [[UIApplication sharedApplication].delegate.window addSubview:_backView];
    [_backView addTarget:self action:@selector(disAppear) forControlEvents:UIControlEventTouchUpInside];
    
    self.frame=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width-40*MCscale, [UIScreen mainScreen].bounds.size.width-40*MCscale);
    self.center=CGPointMake(kDeviceWidth/2, kDeviceHeight/2);
    [_backView addSubview:self];
    
    
    self.gesView.size=CGSizeMake(self.width-20*MCscale, self.height-20*MCscale);
    self.height=self.gesView.bottom+10*MCscale;
    _backView.alpha=0;
    
    self.promptLabel.centerX=self.gesView.centerX;
    [UIView animateWithDuration:0.3 animations:^{
        _backView.alpha=0.95;
    }completion:^(BOOL finished) {
        
    }];
    
    
}
-(void)disAppear{
    [UIView animateWithDuration:0.3 animations:^{
        _backView.alpha=0;
    }completion:^(BOOL finished) {
        [_backView removeFromSuperview];
    }];
}
@end
