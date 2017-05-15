//
//  CancalOrderView.m
//  ShopPeiSong
//
//  Created by MIAO on 2017/4/13.
//  Copyright © 2017年 妙灵科技. All rights reserved.
//

#import "CancalOrderView.h"
#import "Header.h"

@interface CancalOrderView ()<UITextFieldDelegate,MBProgressHUDDelegate>
@property(nonatomic,strong)UIView *line1;
@property(nonatomic,strong)UIButton *saveBtn;
@end
@implementation CancalOrderView
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

-(UITextField *)RecordTextField
{
    if (!_RecordTextField) {
        _RecordTextField = [BaseCostomer textfieldWithFrame:CGRectZero font:[UIFont systemFontOfSize:MLwordFont_4] textColor:textColors textAlignment:1 keyboardType:0 borderStyle:0 placeholder:@"请输入取消原因"];
        _RecordTextField.delegate = self;
        _RecordTextField.returnKeyType = UIReturnKeyDone;
        [self addSubview:_RecordTextField];
    }
    return _RecordTextField;
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
        _saveBtn = [BaseCostomer buttonWithFrame:CGRectZero font:[UIFont systemFontOfSize:MLwordFont_4] textColor:redTextColor backGroundColor:[UIColor whiteColor] cornerRadius:3.0 text:@"取消订单申请" image:@""];
        [_saveBtn addTarget:self action:@selector(saveBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_saveBtn];
    }
    return _saveBtn;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.RecordTextField.frame = CGRectMake(20*MCscale,20*MCscale, self.width-40*MCscale, 40*MCscale);
    self.line1.frame = CGRectMake(10*MCscale, self.RecordTextField.bottom, self.width - 20*MCscale, 1);
    self.saveBtn.frame = CGRectMake(20*MCscale,self.height - 45*MCscale,self.width - 40*MCscale, 30*MCscale);
}
-(void)saveBtnClick
{
    if ([self.RecordTextField.text isEqualToString:@""]) {
        [self promptMessageWithString:@"输入金额不能为空"];
    }
    else
    {
        MBProgressHUD *mHud = [MBProgressHUD showHUDAddedTo:self animated:YES];
        mHud.mode = MBProgressHUDModeIndeterminate;
        mHud.delegate = self;
        mHud.labelText = @"请稍等...";
        [mHud show:YES];
        NSMutableDictionary *pram = [NSMutableDictionary dictionaryWithDictionary:@{@"danhao":self.danhaoStr,@"quxiaoyuanyin":self.RecordTextField.text}];
        [HTTPTool getWithUrl:@"quxiaoShenhe.action" params:pram success:^(id json){
            NSLog(@"取消订单%@",json);
            [mHud hide:YES];
            if ([self.cancalDelegate respondsToSelector:@selector(cancalOrderSuccessWithIndex:)]) {
                [self.cancalDelegate cancalOrderSuccessWithIndex:[[json valueForKey:@"message"] integerValue]];
            }
        } failure:^(NSError *error) {
            [mHud hide:YES];
            [self promptMessageWithString:@"网络连接错误"];
        }];
    }
    self.RecordTextField.text = @"";
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
    [self.RecordTextField resignFirstResponder];
    return YES;
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.RecordTextField resignFirstResponder];
}
@end


