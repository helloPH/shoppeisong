//
//  YanzhengShenfenzhengView.m
//  GoodYeWu
//
//  Created by MIAO on 2017/2/28.
//  Copyright © 2017年 时元尚品. All rights reserved.
//

#import "YanzhengShenfenzhengView.h"

@interface YanzhengShenfenzhengView ()
@property (nonatomic,strong)UITextField *numberTextField;
@property (nonatomic,strong)UIView *lineView;
@property (nonatomic,strong)UIButton *sureBtn;

@end
@implementation YanzhengShenfenzhengView
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

-(UITextField *)numberTextField
{
    if (!_numberTextField) {
        _numberTextField = [BaseCostomer textfieldWithFrame:CGRectZero font:[UIFont systemFontOfSize:MLwordFont_4] textColor:textBlackColor textAlignment:NSTextAlignmentCenter keyboardType:UIKeyboardTypeNumberPad borderStyle:UITextBorderStyleNone placeholder:@"请输入身份证号后六位"];
        _numberTextField.backgroundColor = [UIColor clearColor];
        [self addSubview:_numberTextField];
    }
    return _numberTextField;
}
-(UIView *)lineView
{
    if (!_lineView) {
        _lineView = [BaseCostomer viewWithFrame:CGRectZero backgroundColor:lineColor];
        [self addSubview:_lineView];
    }
    return _lineView;
}
-(UIButton *)sureBtn
{
    if (!_sureBtn) {
        _sureBtn = [BaseCostomer buttonWithFrame:CGRectZero font:[UIFont systemFontOfSize:MLwordFont_2] textColor:[UIColor whiteColor] backGroundColor:redTextColor cornerRadius:3.0 text:@"下一步" image:@""];
        [_sureBtn addTarget:self action:@selector(YanzhengShenfenzhengClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_sureBtn];
    }
    return _sureBtn;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.numberTextField.frame = CGRectMake(20*MCscale,50*MCscale, self.width - 40*MCscale, 35*MCscale);
    self.lineView.frame = CGRectMake(10*MCscale,self.numberTextField.bottom+10*MCscale, self.width -20*MCscale, 1);
    self.sureBtn.frame = CGRectMake(0, 0, 120*MCscale, 40*MCscale);
    _sureBtn.center = CGPointMake(self.width/2.0, self.height-40*MCscale);
}
-(void)YanzhengShenfenzhengClick
{
    MBProgressHUD *Hmud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    Hmud.mode = MBProgressHUDModeIndeterminate;
    Hmud.delegate = self;
    Hmud.labelText = @"请稍等...";
    [Hmud show:YES];
    NSString *passStr = [user_loginPass stringFromMD5];
    NSString *accont = [NSString stringWithFormat:@"%@",user_tel];
    NSString *pass = [NSString stringWithFormat:@"%@%@",accont,passStr];
    NSString *pass_md5 = [pass stringFromMD5];
    NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"yuangong.id":user_id,@"yuangong.chushimima":pass_md5,@"yuangong.shenfenzheng":self.numberTextField.text}];
    [HTTPTool getWithUrl:@"checkZhifuPwd.action" params:pram success:^(id json) {
        NSLog(@"%@",json);
        [Hmud hide:YES];
        if ([[json valueForKey:@"message"]integerValue]==1) {
            //成功
            if ([self.shenfenzhengDelegate respondsToSelector:@selector(YanzhengShenfenzhengViewSuccess)]) {
                [self.shenfenzhengDelegate YanzhengShenfenzhengViewSuccess];
            }
            self.numberTextField.text = @"";
        }
        else if ([[json valueForKey:@"message"]integerValue]==0)
        {
            [self promptMessageWithString:@"参数不能为空"];
        }
        else if ([[json valueForKey:@"message"]integerValue]==2)
        {
            [self promptMessageWithString:@"身份证验证失败"];
        }
    } failure:^(NSError *error) {
        [Hmud hide:YES];
        [self promptMessageWithString:@"网络连接错误"];
    }];
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.numberTextField resignFirstResponder];
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
    sleep(1.5);
}
@end
