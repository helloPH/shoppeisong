//
//  ChangePhoneNumber.m
//  LifeForMM
//
//  Created by MIAO on 16/6/20.
//  Copyright © 2016年 时元尚品. All rights reserved.
//

#import "ChangePhoneNumber.h"

@interface ChangePhoneNumber ()

@property(nonatomic,strong)UIButton *sendCode,*sureBtn;//验证码按钮,提交按钮
@property(nonatomic,strong)UITextField *telNumber,*codeFiled;//手机号,验证码
@property(nonatomic,strong)UIImageView *phoneImage,*codeImage;//
@property(nonatomic,strong)UIView *line1,*line2;//
@property(nonatomic,assign)NSInteger timeSec;//倒计时
@end
@implementation ChangePhoneNumber

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 15.0;
        self.layer.shadowRadius = 5.0;
        self.layer.shadowOpacity = 0.5;
        self.alpha = 0.95;
        self.layer.shadowOffset = CGSizeMake(0, 0);
        
    }
    return self;
}

-(NSInteger)timeSec
{
    if (!_timeSec) {
        _timeSec = 60;
    }
    return _timeSec;
}
-(UIImageView *)phoneImage
{
    if (!_phoneImage) {
        _phoneImage = [BaseCostomer imageViewWithFrame:CGRectZero backGroundColor:[UIColor clearColor] image:@"输入手机号"];
        [self addSubview:_phoneImage];
    }
    return _phoneImage;
}
-(UITextField *)telNumber
{
    if (!_telNumber) {
        _telNumber = [BaseCostomer textfieldWithFrame:CGRectZero font:[UIFont systemFontOfSize:MLwordFont_11] textColor:textBlackColor textAlignment:0 keyboardType:UIKeyboardTypeNumberPad borderStyle:0 placeholder:@"请输入登录手机号"];
        _telNumber.backgroundColor = [UIColor clearColor];
        _telNumber.delegate  = self;
        [self addSubview:_telNumber];
    }
    return _telNumber;
}

-(UIButton *)sendCode
{
    if (!_sendCode) {
        _sendCode = [BaseCostomer buttonWithFrame:CGRectZero font:[UIFont systemFontOfSize:MLwordFont_2] textColor:[UIColor whiteColor] backGroundColor:txtColors(248, 53, 74, 1) cornerRadius:3.0 text:@"发送验证码" image:@""];
        [_sendCode addTarget:self action:@selector(ChangePhoneNumberCkick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_sendCode];
    }
    return _sendCode;
}
-(UIView *)line1
{
    if (!_line1) {
        _line1 = [BaseCostomer viewWithFrame:CGRectZero backgroundColor:lineColor];
        [self addSubview:_line1];
    }
    return _line1;
}
-(UIImageView *)codeImage
{
    if (!_codeImage) {
        _codeImage = [BaseCostomer imageViewWithFrame:CGRectZero backGroundColor:[UIColor clearColor] image:@"输入验证码"];
        [self addSubview:_codeImage];
    }
    return _codeImage;
}
-(UITextField *)codeFiled
{
    if (!_codeFiled) {
        _codeFiled = [BaseCostomer textfieldWithFrame:CGRectZero font:[UIFont systemFontOfSize:MLwordFont_11] textColor:textBlackColor textAlignment:0 keyboardType:UIKeyboardTypeNumberPad borderStyle:0 placeholder:@"请输入短信验证码"];
        [self addSubview:_codeFiled];
    }
    return _codeFiled;
}
-(UIView *)line2
{
    if (!_line2) {
        _line2 = [BaseCostomer viewWithFrame:CGRectZero backgroundColor:lineColor];
        [self addSubview:_line2];
    }
    return _line2;
}
-(UIButton *)sureBtn
{
    if (!_sureBtn) {
        _sureBtn = [BaseCostomer buttonWithFrame:CGRectZero font:[UIFont systemFontOfSize:MLwordFont_2] textColor:[UIColor whiteColor] backGroundColor:redTextColor cornerRadius:3.0 text:@"确认绑定" image:@""];
        [_sureBtn addTarget:self action:@selector(ChangePhoneNumberCkick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_sureBtn];
    }
    return _sureBtn;
}

-(void)layoutSubviews
{
    self.phoneImage.frame = CGRectMake(15*MCscale, 40*MCscale, 22*MCscale, 22*MCscale),
    self.telNumber.frame = CGRectMake(self.phoneImage.right,35*MCscale, 180*MCscale, 35*MCscale);
    self.sendCode.frame = CGRectMake(self.telNumber.right+2, 35*MCscale, self.width-self.telNumber.width-40*MCscale, 40*MCscale);
    self.line1.frame = CGRectMake(15*MCscale,self.telNumber.bottom+10, self.telNumber.width+20*MCscale, 1);
    self.codeImage.frame = CGRectMake(17*MCscale, self.line1.bottom+23*MCscale, 20*MCscale, 22*MCscale);
    self.codeFiled.frame = CGRectMake(self.codeImage.right+2,self.line1.bottom+20*MCscale, 180*MCscale, 30*MCscale);
    self.line2.frame = CGRectMake(15*MCscale, self.codeFiled.bottom+10*MCscale, self.width-30*MCscale, 1);
    self.sureBtn.frame = CGRectMake(0, 0, 120*MCscale, 40*MCscale);
    self.sureBtn.center = CGPointMake(self.width/2.0, self.height-40*MCscale);
}
-(void)ChangePhoneNumberCkick:(UIButton *)btn
{
    if (btn == self.sendCode) {//验证码
        BOOL isMatch = [BaseCostomer panduanPhoneNumberWithString:self.telNumber.text];
        if(!isMatch){
            [self promptMessageWithString:@"您输入的手机号码不正确!请重新输入"];
        }
        else{
            NSMutableDictionary *jsonDict = [NSMutableDictionary dictionaryWithDictionary:@{@"yuangong.id":user_id,@"tel":self.telNumber.text}];
            [HTTPTool getWithUrl:@"checkBoundNumber.action" params:jsonDict success:^(id json) {
                NSDictionary * dic = (NSDictionary * )json;
                if ([[dic objectForKey:@"message"]intValue]==0) {
                    [self promptMessageWithString:@"该手机号已经注册过"];
                }
                else if ([[dic objectForKey:@"message"]intValue]==1) {
                    [self timImngAction];
                }
            } failure:^(NSError *error) {
                [self promptMessageWithString:@"网络连接错误"];
            }];
        }
    }
    else if(btn == self.sureBtn)//确认更换
    {
        NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"yuangong.id":user_id,@"code":self.codeFiled.text,@"tel":self.telNumber.text}];
        [HTTPTool getWithUrl:@"updateBoundPhone.action" params:pram success:^(id json) {
            NSLog(@"%@",json);
            if ([[json valueForKey:@"message"]integerValue]==4) {
                //成功
                NSString *title = @"发送验证码";
                self.sendCode.titleLabel.font = [UIFont systemFontOfSize:MLwordFont_2];
                [self.sendCode setTitle:title forState:UIControlStateNormal];
                self.sendCode.backgroundColor = txtColors(248, 53, 74, 1);
                [NSObject cancelPreviousPerformRequestsWithTarget:self];
                self.timeSec =60;
                self.sendCode.enabled = YES;
                
                if ([self.changeDelegate respondsToSelector:@selector(ChangePhoneNumberWithString:AndIndex:)]) {
                    [self.changeDelegate ChangePhoneNumberWithString:self.telNumber.text AndIndex:[[json valueForKey:@"message"]integerValue]];
                }
                self.telNumber.text = @"";
                self.codeFiled.text = @"";
            }
            else{
                if ([self.changeDelegate respondsToSelector:@selector(ChangePhoneNumberWithString:AndIndex:)]) {
                    [self.changeDelegate ChangePhoneNumberWithString:self.telNumber.text AndIndex:[[json valueForKey:@"message"]integerValue]];
                }
            }
        } failure:^(NSError *error) {
            [self promptMessageWithString:@"网络连接错误"];
        }];
    }
}
//倒计时
-(void)timImngAction
{
    self.sendCode.backgroundColor = [UIColor grayColor];
    NSString *title = [NSString stringWithFormat:@"%lds后可再次发送",(long)self.timeSec];
    if (self.timeSec>=0) {
        self.timeSec--;
        [self performSelector:@selector(timImngAction) withObject:self afterDelay:1];
        self.sendCode.titleLabel.font = [UIFont systemFontOfSize:MLwordFont_7];
        self.sendCode.enabled = NO;
        [self.sendCode setTitle:title forState:UIControlStateNormal];
    }
    else{
        NSString *title = @"发送验证码";
        self.sendCode.titleLabel.font = [UIFont systemFontOfSize:MLwordFont_2];
        [self.sendCode setTitle:title forState:UIControlStateNormal];
        self.sendCode.backgroundColor = txtColors(248, 53, 74, 1);
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        self.timeSec =60;
        self.sendCode.enabled = YES;
    }
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField == self.telNumber){
        NSInteger leng = textField.text.length;
        NSInteger selectLeng = range.length;
        NSInteger replaceLeng = string.length;
        if (leng - selectLeng + replaceLeng > 11){
            return NO;
        }
        else
            return YES;
    }
    return YES;
}
-(void)promptMessageWithString:(NSString *)string
{
    MBProgressHUD *mHud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    mHud.labelText = string;
    mHud.mode = MBProgressHUDModeText;
    [mHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
}
- (void)myTask {
    // Do something usefull in here instead of sleeping ...
    sleep(1.5);
}
@end
