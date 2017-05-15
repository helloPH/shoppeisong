//
//  getBalanceViewController.m
//  LifeForMM
//
//  Created by 时元尚品 on 15/7/24.
//  Copyright (c) 2015年 时元尚品. All rights reserved.
//
#import "getBalanceViewController.h"
#import "Header.h"
@interface getBalanceViewController ()<UITextFieldDelegate>
@property(nonatomic,strong)UITextField *numTextfiled;
@property(nonatomic,strong)UILabel *useMoney,*moneyNum,*zhanghaoLabel,*accountLabel,*titleLabel1,*titleLabel2,*titleLabel3;
@property(nonatomic,strong)UIButton *submitBtn;
@property(nonatomic,strong)UIView *zhanghaoView,*lineView;
@property(nonatomic,strong)UIImageView *selectImage;
@property(nonatomic,strong)NSString *tixianMoney;
@end

@implementation getBalanceViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBarTintColor:txtColors(4, 196, 153, 1)];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"余额提现";
    [self relodData];
}

-(NSString *)tixianMoney
{
    if (!_tixianMoney) {
        _tixianMoney = @"";
    }
    return _tixianMoney;
}

-(UIImageView *)selectImage
{
    if (!_selectImage) {
        _selectImage = [BaseCostomer imageViewWithFrame:CGRectMake(25*MCscale, 94*MCscale,25*MCscale,30*MCscale) backGroundColor:[UIColor clearColor] image:@"dengpao_icon"];
        [self.view addSubview:_selectImage];
    }
    return _selectImage;
}

-(UILabel *)titleLabel1
{
    if (!_titleLabel1) {
        _titleLabel1 = [BaseCostomer labelWithFrame:CGRectMake(self.selectImage.right + 5*MCscale,100*MCscale,180*MCscale,16*MCscale) font:[UIFont systemFontOfSize:MLwordFont_5] textColor:[UIColor blackColor] text:@"3-10个工作日内到达指定账户"];
        [self.view addSubview:_titleLabel1];
    }
    return _titleLabel1;
}
-(UILabel *)titleLabel2
{
    if (!_titleLabel2) {
        _titleLabel2 = [BaseCostomer labelWithFrame:CGRectMake(self.selectImage.right,self.titleLabel1.bottom-5*MCscale,kDeviceWidth - 75*MCscale,60*MCscale) font:[UIFont systemFontOfSize:MLwordFont_8] textColor:textColors backgroundColor:[UIColor clearColor] textAlignment:0 numOfLines:0 text:@"银行处理可能有延迟，具体以账户的到账时间为准。提现时也会对应多笔到账"];
        [self.view addSubview:_titleLabel2];
    }
    return _titleLabel2;
}
-(UILabel *)useMoney
{
    if (!_useMoney) {
        _useMoney = [BaseCostomer labelWithFrame:CGRectMake(20*MCscale,self.titleLabel2.bottom+50*MCscale,110*MCscale, 20*MCscale) font:[UIFont systemFontOfSize:MLwordFont_2] textColor:lineColor text:@"可提现金额:"];
        [self.view addSubview:_useMoney];
    }
    return _useMoney;
}

-(UILabel *)moneyNum
{
    if (!_moneyNum) {
        _moneyNum = [BaseCostomer labelWithFrame:CGRectMake(self.useMoney.right, self.useMoney.top,kDeviceWidth-150*MCscale , 20*MCscale) font:[UIFont systemFontOfSize:MLwordFont_2] textColor:redTextColor text:@""];
        [self.view addSubview:_moneyNum];
    }
    return _moneyNum;
}

-(UIView *)lineView
{
    if (!_lineView) {
        _lineView = [BaseCostomer viewWithFrame:CGRectMake(0, self.moneyNum.bottom+20*MCscale, kDeviceWidth, 1) backgroundColor:lineColor];
        [self.view addSubview:_lineView];
    }
    return _lineView;
}
-(UITextField *)numTextfiled
{
    if (!_numTextfiled) {
        _numTextfiled = [BaseCostomer textfieldWithFrame:CGRectMake(kDeviceWidth/2-80*MCscale, self.lineView.bottom + 50*MCscale, 160*MCscale,40*MCscale) font:[UIFont boldSystemFontOfSize:MLwordFont_2] textColor:textColors textAlignment:1 keyboardType:UIKeyboardTypeNumberPad borderStyle:0 placeholder:@"请输入提现金额"];
        _numTextfiled.backgroundColor = txtColors(236, 237, 239, 1);
        [self.view addSubview:_numTextfiled];
    }
    return _numTextfiled;
}
-(UILabel *)zhanghaoLabel
{
    if (!_zhanghaoLabel) {
        _zhanghaoLabel = [BaseCostomer labelWithFrame:CGRectMake(50*MCscale, 0,kDeviceWidth-100*MCscale ,35*MCscale) font:[UIFont systemFontOfSize:MLwordFont_4] textColor:textColors text:@""];
        [self.zhanghaoView addSubview:_zhanghaoLabel];
        
    }
    return _zhanghaoLabel;
}
-(UILabel *)accountLabel
{
    if (!_accountLabel) {
        _accountLabel = [BaseCostomer labelWithFrame:CGRectMake(50*MCscale,self.zhanghaoLabel.bottom,kDeviceWidth-100*MCscale , 35*MCscale) font:[UIFont systemFontOfSize:MLwordFont_4] textColor:textColors text:@""];
        [self.zhanghaoView addSubview:_accountLabel];
    }
    return _accountLabel;
}
-(UIView *)zhanghaoView
{
    if (!_zhanghaoView) {
        _zhanghaoView = [BaseCostomer viewWithFrame:CGRectMake(0, self.numTextfiled.bottom + 30*MCscale, kDeviceWidth, 70*MCscale) backgroundColor:txtColors(236, 236, 236, 1)];
        [self.view addSubview:_zhanghaoView];
        [self.view addSubview:self.titleLabel3];
    }
    return _zhanghaoView;
}
-(UIButton *)submitBtn
{
    if (!_submitBtn) {
        _submitBtn = [BaseCostomer buttonWithFrame:CGRectMake(20*MCscale,self.zhanghaoView.bottom + 30*MCscale, kDeviceWidth-40*MCscale, 48*MCscale) font:[UIFont boldSystemFontOfSize:MLwordFont_2] textColor:[UIColor whiteColor] backGroundColor:txtColors(249, 54, 73, 1) cornerRadius:5.0 text:@"确认提现" image:@""];
        [_submitBtn addTarget:self action:@selector(submitBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_submitBtn];
    }
    return _submitBtn;
}
-(UILabel *)titleLabel3
{
    if (!_titleLabel3) {
        _titleLabel3 = [BaseCostomer labelWithFrame:CGRectMake(10*MCscale,self.submitBtn.bottom+10*MCscale,kDeviceWidth-20*MCscale , 20*MCscale) font:[UIFont systemFontOfSize:MLwordFont_4] textColor:txtColors(203, 203, 203, 1) backgroundColor:[UIColor clearColor] textAlignment:1 numOfLines:1 text:@"每日可提现一次"];
    }
    return _titleLabel3;
}
//获取余额
-(void)relodData
{
    NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"yuangong.id":user_id}];
    [HTTPTool getWithUrl:@"enterTixian.action" params:pram success:^(id json) {
        NSLog(@"余额提现%@",json);
        
        if ([[json valueForKey:@"message"]integerValue] == 1) {
            [self promptMessageWithString:@"参数不能为空"];
        }
        else if ([[json valueForKey:@"message"]integerValue] == 2)
        {
            [self promptMessageWithString:@"无此账户"];
        }
        else
        {
            CGFloat yue = [[json valueForKey:@"ketixianjine"] floatValue];
            self.tixianMoney = [NSString stringWithFormat:@"%.2f",yue];
            self.moneyNum.text = [NSString stringWithFormat:@"%@元",self.tixianMoney];
            self.zhanghaoLabel.text = [NSString stringWithFormat:@"渠道:%@",[json valueForKey:@"qudao"]];
            self.accountLabel.text = [NSString stringWithFormat:@"账户:%@",[json valueForKey:@"zhanghu"]];
        }
    } failure:^(NSError *error) {
        [self promptMessageWithString:@"网络连接错误"];
    }];
}
-(void)submitBtnAction:(UIButton *)button
{
    NSString *textFiledValue = self.numTextfiled.text;
    if (([textFiledValue floatValue] <=[self.tixianMoney floatValue]) && [textFiledValue floatValue] >0) {
        NSMutableDictionary *pram= [[NSMutableDictionary alloc]initWithDictionary:@{@"yuangong.id":user_id,@"tixianjine":textFiledValue}];
        [HTTPTool postWithUrl:@"yueTixian.action" params:pram success:^(id json) {
            NSLog(@"余额提现%@",json);
            NSString *message = [NSString stringWithFormat:@"%@",[json valueForKey:@"message"]];
            if([message isEqualToString:@"1"]){
                [self.navigationController popViewControllerAnimated:YES];
                MBProgressHUD *mbHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                mbHud.mode = MBProgressHUDModeCustomView;
                mbHud.labelText = @"提现成功";
                mbHud.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"37x-Checkmark"]];
                [mbHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
                self.tixianMoney =[NSString stringWithFormat:@"%.2f",[self.tixianMoney floatValue] - [textFiledValue floatValue]];
                UILabel *lb = [self.view viewWithTag:1101];
                lb.text = self.tixianMoney;
                self.numTextfiled.text = @"";
            }
            else if ([message isEqualToString:@"3"]){
                [self promptMessageWithString:@"参数不能为空"];
            }
            else if ([message isEqualToString:@"4"]){
                [self promptMessageWithString:@"无此员工信息"];
            }
        } failure:^(NSError *error) {
            [self promptMessageWithString:@"网络连接错误"];
        }];
    }
    else
    {
        [self promptMessageWithString:@"您输入的有误,请重新输入"];
    }
}

-(void)promptMessageWithString:(NSString *)string
{
    MBProgressHUD *mHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    mHud.labelText = string;
    mHud.mode = MBProgressHUDModeText;
    [mHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
}
-(void)myTask
{
    sleep(1.5);
}
#pragma mark 键盘弹出与隐藏
//键盘弹出
-(void)keyboardWillShow:(NSNotification *)notifaction
{
    //    [self.view addSubview:maskView];
}
//键盘隐藏
-(void)keyboardWillHide:(NSNotification *)notifaction
{
    //    [maskView removeFromSuperview];
}
#pragma mark UITextFiledDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    textField.placeholder = @"";
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    textField.placeholder = @"请输入提现金额";
}

@end
