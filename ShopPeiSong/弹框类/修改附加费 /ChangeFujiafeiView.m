
//
//  ChangeFujiafeiView.m
//  ShopPeiSong
//
//  Created by MIAO on 2017/4/12.
//  Copyright © 2017年 妙灵科技. All rights reserved.
//

#import "ChangeFujiafeiView.h"
#import "Header.h"
@interface ChangeFujiafeiView ()<UITextFieldDelegate,MBProgressHUDDelegate>

@property(nonatomic,strong)UIView *line1;
@property(nonatomic,strong)UIButton *saveBtn;
@property(nonatomic,assign)NSInteger ViewIndex;
@end
@implementation ChangeFujiafeiView

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

-(UITextField *)moneyTextField
{
    if (!_moneyTextField) {
        _moneyTextField = [BaseCostomer textfieldWithFrame:CGRectZero font:[UIFont systemFontOfSize:MLwordFont_4] textColor:textColors textAlignment:1 keyboardType:UIKeyboardTypeNumbersAndPunctuation borderStyle:0 placeholder:@""];
        _moneyTextField.delegate = self;
        _moneyTextField.returnKeyType = UIReturnKeyDone;
        [self addSubview:_moneyTextField];
    }
    return _moneyTextField;
}

-(UIView *)line1
{
    if (!_line1) {
        _line1 = [BaseCostomer viewWithFrame:CGRectZero backgroundColor:lineColor];
        [self addSubview:_line1];
    }
    return _line1;
}

-(UIButton *)saveBtn
{
    if (!_saveBtn) {
        _saveBtn = [BaseCostomer buttonWithFrame:CGRectZero font:[UIFont systemFontOfSize:MLwordFont_4] textColor:[UIColor whiteColor] backGroundColor:redTextColor cornerRadius:3.0 text:@"保存" image:@""];
        [_saveBtn addTarget:self action:@selector(saveBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_saveBtn];
    }
    return _saveBtn;
}
-(void)getFujiafeiMoney:(NSString *)fujiafeiMoney AndViewTag:(NSInteger)viewTag
{
    self.ViewIndex = viewTag;
    self.moneyTextField.placeholder = fujiafeiMoney;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.moneyTextField.frame = CGRectMake(20*MCscale,20*MCscale, self.width-40*MCscale, 40*MCscale);
    self.line1.frame = CGRectMake(10*MCscale, self.moneyTextField.bottom, self.width - 20*MCscale, 1);
    self.saveBtn.frame = CGRectMake(self.width/2.0-50*MCscale,self.height - 45*MCscale, 100*MCscale, 30*MCscale);
}

-(void)saveBtnClick
{
    if (self.ViewIndex == 1) {
        if ([self.changeFujiaDelegate respondsToSelector:@selector(changeFujiafeiSuccessWithMoney:AndIndex:)]) {
            [self.changeFujiaDelegate changeFujiafeiSuccessWithMoney:self.moneyTextField.text AndIndex:0];
        }
    }
    else
    {
        if ([self.moneyTextField.text isEqualToString:@""]) {
            [self promptMessageWithString:@"输入金额不能为空"];
        }
        else if (self.buchaMoney < [self.moneyTextField.text floatValue]) {
            [self promptMessageWithString:@"输入的金额不符合退款金额"];
        }
        else
        {
            MBProgressHUD *mHud = [MBProgressHUD showHUDAddedTo:self animated:YES];
            mHud.mode = MBProgressHUDModeIndeterminate;
            mHud.delegate = self;
            mHud.labelText = @"请稍等...";
            [mHud show:YES];
            NSMutableDictionary *pram = [NSMutableDictionary dictionaryWithDictionary:@{@"danhao":self.danhaoStr,@"yuangongid":user_id,@"chae":self.moneyTextField.text}];
            [HTTPTool getWithUrl:@"chae.action" params:pram success:^(id json){
                NSLog(@"补差额%@",json);
                [mHud hide:YES];
                if ([self.changeFujiaDelegate respondsToSelector:@selector(changeFujiafeiSuccessWithMoney:AndIndex:)]) {
                    [self.changeFujiaDelegate changeFujiafeiSuccessWithMoney:self.moneyTextField.text AndIndex:[[json valueForKey:@"message"] integerValue]];
                }
            } failure:^(NSError *error) {
                [mHud hide:YES];
                [self promptMessageWithString:@"网络连接错误"];
            }];
        }
    }
    self.moneyTextField.text = @"";
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

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.moneyTextField resignFirstResponder];
    return YES;
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.moneyTextField resignFirstResponder];
}
@end
