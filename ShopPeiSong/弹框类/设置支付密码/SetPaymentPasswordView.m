//
//  SetPaymentPasswordView.m
//  LifeForMM
//
//  Created by MIAO on 16/6/16.
//  Copyright © 2016年 时元尚品. All rights reserved.
//

#import "SetPaymentPasswordView.h"

@interface SetPaymentPasswordView ()
@property(nonatomic,strong)UIButton *sureBtn;
@end
@implementation SetPaymentPasswordView
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
        [self createUI];
    }
    return self;
}

-(UIButton *)sureBtn
{
    if (!_sureBtn) {
        _sureBtn = [BaseCostomer buttonWithFrame:CGRectZero font:[UIFont systemFontOfSize:MLwordFont_2] textColor:[UIColor whiteColor] backGroundColor:redTextColor cornerRadius:3.0 text:@"保存" image:@""];
        [_sureBtn addTarget:self action:@selector(sureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_sureBtn];
    }
    return _sureBtn;
}
-(void)createUI
{
    NSArray *array = @[@"设置6位数字支付密码",@"确认支付密码"];
    for (int i=0; i<2; i++) {
        UITextField *textfiled = [BaseCostomer textfieldWithFrame:CGRectMake(10*MCscale, 20*MCscale+60*i*MCscale, self.width-20*MCscale, 40*MCscale) font:[UIFont systemFontOfSize:MLwordFont_2] textColor:textBlackColor textAlignment:NSTextAlignmentCenter keyboardType:UIKeyboardTypeNumberPad borderStyle:0 placeholder:array[i]];
        [textfiled setSecureTextEntry:YES];
        textfiled.backgroundColor = [UIColor clearColor];
        textfiled.tag = i+1;
        textfiled.delegate = self;
        [self addSubview:textfiled];
        UIView *line = [BaseCostomer viewWithFrame:CGRectMake(10*MCscale, textfiled.bottom+5*MCscale, self.width-20*MCscale, 1) backgroundColor:lineColor];
        [self addSubview:line];
    }
}

-(void)getTextFieldPlaceholderWithArray:(NSArray *)array
{
    UITextField *newfile = (UITextField *)[self viewWithTag:1];
    newfile.placeholder = array[0];
    UITextField *newfileAgn = (UITextField *)[self viewWithTag:2];
    newfileAgn.placeholder = array[1];
}

-(void)sureBtnClick:(UIButton *)btn
{
    UITextField *newfile = (UITextField *)[self viewWithTag:1];
    UITextField *newfileAgn = (UITextField *)[self viewWithTag:2];
    MBProgressHUD *Hmud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    Hmud.mode = MBProgressHUDModeIndeterminate;
    Hmud.delegate = self;
    Hmud.labelText = @"请稍等...";
    [Hmud show:YES];
    
    if ([newfile.text isEqualToString:newfileAgn.text]) {
        if (newfile.text.length == 6) {
            NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"yuangong.id":user_id,@"yuangong.gonghao":newfile.text}];
            [HTTPTool getWithUrl:@"updateZhiFuPwd.action" params:pram success:^(id json) {
                [Hmud hide:YES];
                NSLog(@"支付密码%@",json);
                
                if ([[json valueForKey:@"message"] integerValue] == 1) {
                    if ([self.setPaymentDelegate respondsToSelector:@selector(SetPaymentPasswordSuccessWithIndex:)]) {
                        [self.setPaymentDelegate SetPaymentPasswordSuccessWithIndex:[[json valueForKey:@"message"] integerValue]];
                        newfile.text = @"";
                        newfileAgn.text = @"";
                    }
                }else{
                    if ([self.setPaymentDelegate respondsToSelector:@selector(SetPaymentPasswordSuccessWithIndex:)]) {
                        [self.setPaymentDelegate SetPaymentPasswordSuccessWithIndex:[[json valueForKey:@"message"] integerValue]];
                    }
                }
            } failure:^(NSError *error) {
                [Hmud hide:YES];
                [self promptMessageWithString:@"网络连接错误"];
            }];
        }
        else{
            [Hmud hide:YES];
            [self promptMessageWithString:@"请输入6位长度密码"];
        }
    }
    else{
        [Hmud hide:YES];
        [self promptMessageWithString:@"两次密码不一致"];
    }
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

-(void)layoutSubviews
{
    self.sureBtn.frame = CGRectMake(0, 0, 120*MCscale, 40*MCscale);
    self.sureBtn.center = CGPointMake(self.width/2.0, self.height-40*MCscale);
}

@end
