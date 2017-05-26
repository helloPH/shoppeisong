//
//  RegistrationView.m
//  ManageForMM
//
//  Created by MIAO on 16/9/24.
//  Copyright © 2016年 时元尚品. All rights reserved.
//

#import "RegistrationView.h"
#import "NSString+MD5Addition.h"
#import "FenXiangWithLoginAfter.h"


@interface RegistrationView()<MBProgressHUDDelegate,UITextFieldDelegate>
@property (nonatomic,strong)UILabel * naviView;

@property (nonatomic,strong)UIButton * openBtn;
@property (nonatomic,strong)UIButton *registraBtn;//注册按钮
@property (nonatomic,strong)NSMutableArray *yingyongArr ;//应用数组
@property (nonatomic,strong)UILabel *dianpuNameLabel,*nameLabel;//店铺名,姓名
@property (nonatomic,strong)UIView *line1,*line2,*line3,*line4;

@end
@implementation RegistrationView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
//        self.layer.cornerRadius = 15.0;
//        self.layer.shadowRadius = 5.0;
//        self.layer.shadowOpacity = 0.5;
//        self.alpha = 0.95;
//        self.layer.shadowOffset = CGSizeMake(0, 0);
    }
    return self;
}
-(UILabel *)naviView{
    if (!_naviView) {
        _naviView = [BaseCostomer labelWithFrame:CGRectZero font:[UIFont systemFontOfSize:MLwordFont_4] textColor:textBlackColor text:@""];
        
      
        _naviView.textAlignment=NSTextAlignmentCenter;
        _naviView.backgroundColor=naviBarTintColor;
        [self addSubview:_naviView];
        
        
        
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        label.text=@"登录";
        label.font=[UIFont systemFontOfSize:MLwordFont_3];
        label.textColor=[UIColor blackColor];
        label.backgroundColor=[UIColor clearColor];
        [_naviView addSubview:label];
        [label sizeToFit];
        label.center=CGPointMake(_naviView.width/2, _naviView.height/2);
        
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_naviView);
            make.centerY.mas_equalTo(_naviView).offset(10*MCscale);
            make.width.mas_equalTo(40*MCscale);
            make.height.mas_equalTo(20*MCscale);
            
        }];

    }
    return _naviView;
}
#pragma mark 公司名
-(UILabel *)dianpuNameLabel
{
    if (_dianpuNameLabel == nil) {
        _dianpuNameLabel = [BaseCostomer labelWithFrame:CGRectZero font:[UIFont systemFontOfSize:MLwordFont_5] textColor:redTextColor backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentCenter numOfLines:1 text:@""];
        _dianpuNameLabel.hidden = YES;
        [self addSubview:_dianpuNameLabel];
    
    }
    return _dianpuNameLabel;
}
-(UIView *)line1
{
    if (!_line1) {
        _line1 = [BaseCostomer viewWithFrame:CGRectZero backgroundColor:lineColor];
        _line1.hidden = YES;
        [self addSubview:_line1];
    }
    return _line1;
}
-(UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [BaseCostomer labelWithFrame:CGRectZero font:[UIFont systemFontOfSize:MLwordFont_5] textColor:redTextColor backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentCenter numOfLines:1 text:@""];
        _nameLabel.hidden = YES;
        [self addSubview:_nameLabel];
    }
    return _nameLabel;
}

-(UIView *)line2
{
    if (!_line2) {
        _line2 = [BaseCostomer viewWithFrame:CGRectZero backgroundColor:lineColor];
        _line2.hidden=YES;
        [self addSubview:self.line2];
    }
    return _line2;
}
#pragma mark 手机号
-(UITextField *)accountTextfield
{
    if (_accountTextfield == nil) {
        _accountTextfield = [BaseCostomer textfieldWithFrame:CGRectZero font:[UIFont systemFontOfSize:MLwordFont_2] textColor:textColors textAlignment:NSTextAlignmentLeft keyboardType:UIKeyboardTypeNumberPad borderStyle:UITextBorderStyleNone placeholder:@"请输入登录手机号"];
        _accountTextfield.delegate = self;
        [self addSubview:self.accountTextfield];
        
        _accountTextfield.clearButtonMode=UITextFieldViewModeAlways;
        _accountTextfield.leftView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"输入账号"]];
        _accountTextfield.leftView.width=_accountTextfield.leftView.height=25*MCscale;
        _accountTextfield.leftViewMode=UITextFieldViewModeAlways;
        
    }
    return _accountTextfield;
}
-(UIView *)line3
{
    if (!_line3) {
        _line3 = [BaseCostomer viewWithFrame:CGRectZero backgroundColor:lineColor];
        [self addSubview:self.line3];
    }
    return _line3;
}
#pragma mark 密码
-(UITextField *)passWordTextfield
{
    if (_passWordTextfield == nil) {
        //密码
        _passWordTextfield = [BaseCostomer textfieldWithFrame:CGRectZero font:[UIFont systemFontOfSize:MLwordFont_2] textColor:textColors textAlignment:NSTextAlignmentLeft keyboardType:UIKeyboardTypeNumberPad borderStyle:UITextBorderStyleNone placeholder:@"请输入密码"];
        _passWordTextfield.delegate = self;
        [self addSubview:self.passWordTextfield];

        
        _passWordTextfield.secureTextEntry=YES;
        _passWordTextfield.leftView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"输入密码"]];
        _passWordTextfield.leftView.width=_passWordTextfield.leftView.height=25*MCscale;
        _passWordTextfield.leftViewMode=UITextFieldViewModeAlways;
    }
    return _passWordTextfield;
}
-(UIView *)line4
{
    if (!_line4) {
        _line4 = [BaseCostomer viewWithFrame:CGRectZero backgroundColor:lineColor];
        [self addSubview:self.line4];
    }
    return _line4;
}

-(NSMutableArray *)yingyongArr
{
    if (_yingyongArr == nil) {
        _yingyongArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _yingyongArr;
}
-(UIButton *)openBtn{
    if (!_openBtn) {
       _openBtn = [BaseCostomer buttonWithFrame:CGRectZero font:[UIFont boldSystemFontOfSize:MLwordFont_3] textColor:[UIColor blackColor] backGroundColor:[UIColor clearColor] cornerRadius:0 text:@"注册" image:@""];
        [_openBtn addTarget:self action:@selector(openClick:) forControlEvents:UIControlEventTouchUpInside];
        
        if (!banben_IsAfter) {
            [self reshBanben];
        }
        [self addSubview:_openBtn];
    }
    return _openBtn;
}
-(void)openClick:(UIButton *)sender{
    if (_openBlock) {
        _openBlock();
    }
}
#pragma mark 注册按钮
-(UIButton *)registraBtn
{
    if (_registraBtn == nil) {
        _registraBtn = [BaseCostomer buttonWithFrame:CGRectZero font:[UIFont boldSystemFontOfSize:MLwordFont_2] textColor:[UIColor whiteColor] backGroundColor:txtColors(250, 54, 71, 1) cornerRadius:5*MCscale text:@"登录" image:@""];
        [_registraBtn addTarget:self action:@selector(registraBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_registraBtn];
    }
    return _registraBtn;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [self.naviView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(kDeviceWidth);
        make.height.mas_equalTo(69*MCscale);
    }];
    
    [self.openBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(35*MCscale);
        make.right.equalTo(self).offset(-20*MCscale);
        make.width.mas_equalTo(50*MCscale);
        make.height.mas_equalTo(20*MCscale);
    }];
    
    
    [self.dianpuNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.openBtn.mas_bottom).offset(100*MCscale);
        make.left.equalTo(self).offset(20*MCscale);
        make.right.equalTo(self).offset(-20*MCscale);
        make.height.equalTo(@(30*MCscale));
    }];
    
    [self.line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(30*MCscale);
        make.right.equalTo(self).offset(-30*MCscale);
        make.top.equalTo(self.dianpuNameLabel.mas_bottom).offset(0);
        make.height.equalTo(@(1*MCscale));
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.line1.mas_bottom).offset(10*MCscale);
        make.left.equalTo(self).offset(20*MCscale);
        make.right.equalTo(self).offset(-20*MCscale);
        make.height.equalTo(@(30*MCscale));
    }];
    
    [self.line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(30*MCscale);
        make.right.equalTo(self).offset(-30*MCscale);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(0);
        make.height.equalTo(@(1*MCscale));
    }];
    
    [self.accountTextfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.line2.mas_bottom).offset(30*MCscale);
        make.left.equalTo(self).offset(20*MCscale);
        make.right.equalTo(self).offset(-20*MCscale);
        make.height.equalTo(@(30*MCscale));
    }];
    
    [self.line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(30*MCscale);
        make.right.equalTo(self).offset(-30*MCscale);
        make.top.equalTo(self.accountTextfield.mas_bottom).offset(5*MCscale);
        make.height.equalTo(@(1*MCscale));
    }];
    
    [self.passWordTextfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.line3.mas_bottom).offset(20*MCscale);
        make.left.equalTo(self).offset(20*MCscale);
        make.right.equalTo(self).offset(-20*MCscale);
        make.height.equalTo(@(30*MCscale));
    }];

    [self.line4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.passWordTextfield.mas_bottom).offset(5*MCscale);
        make.left.equalTo(self).offset(30*MCscale);
        make.right.equalTo(self).offset(-30*MCscale);
        make.height.equalTo(@(1*MCscale));
    }];
    
    [self.registraBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.line4.mas_bottom).offset(60*MCscale);
        make.left.equalTo(self).offset(20*MCscale);
        make.right.equalTo(self).offset(-20*MCscale);
        make.height.equalTo(@(40*MCscale));
    }];
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == self.passWordTextfield) {
        BOOL isMatch = [BaseCostomer panduanPhoneNumberWithString:self.accountTextfield.text];
        if(!isMatch){
            [self promptMessageWithString:@"您输入的手机号码不正确!请重新输入"];
        }
        else{
            NSMutableDictionary *pram = [NSMutableDictionary dictionaryWithDictionary:@{@"tel":self.accountTextfield.text}];
            [HTTPTool getWithUrl:@"getYuangongInfo.action" params:pram success:^(id json) {
                NSLog(@"json%@",json);
                if ([[json valueForKey:@"message"]integerValue] == 0) {
                    [self promptMessageWithString:@"无此员工信息"];
                }
                else if ([[json valueForKey:@"message"]integerValue] == 1)
                {
                    self.dianpuNameLabel.hidden = NO;
                    self.line1.hidden = NO;
                    self.nameLabel.hidden = NO;
                    self.line2.hidden = NO;
                    
                    self.dianpuNameLabel.text = [json valueForKey:@"dianpuname"];
                    self.nameLabel.text =[NSString stringWithFormat:@"%@ %@ %@",[json valueForKey:@"bumen"],[json valueForKey:@"zhiwu"],[json valueForKey:@"name"]];
                    
                    NSString * bumen = [NSString stringWithFormat:@"%@",[json valueForKey:@"bumen"]];
                    
        
                    set_DianPuName(self.dianpuNameLabel.text);
                    [[NSUserDefaults standardUserDefaults] setValue:[json valueForKey:@"name"] forKey:@"name"];
                    [[NSUserDefaults standardUserDefaults] setValue:[json valueForKey:@"zhiwu"] forKey:@"zhiwu"];
                     set_User_BuMen(bumen);
                    [[NSUserDefaults standardUserDefaults] setValue:[json valueForKey:@"status"] forKey:@"status"];
                }
            } failure:^(NSError *error) {
            }];
        }
    }
}
-(void)registraBtnClick:(UIButton *)button
{
    
    
    
    BOOL isMatch = [BaseCostomer phoneNumberJiamiWithString:self.accountTextfield.text];
    if(!isMatch){
        [self promptMessageWithString:@"您输入的手机号码不正确!请重新输入"];
    }
    else{
        
        
        NSString *passStr = [self.passWordTextfield.text stringFromMD5];
        NSString *accont = [NSString stringWithFormat:@"%@",self.accountTextfield.text];
        NSString *pa = [NSString stringWithFormat:@"%@%@",accont,passStr];
        
        NSString *passString = [pa stringFromMD5];
        NSMutableDictionary *pram = [[NSMutableDictionary alloc]init];
        [pram setObject:self.accountTextfield.text forKey:@"yuangong.tel"];
        [pram setObject:user_shebeiId forKey:@"yuangong.shebeishenfen"];
        [pram setObject:passString forKey:@"yuangong.chushimima"];
        
        [Request loginWithDic:pram Success:^(id json) {
            
        
            set_User_Tel(self.accountTextfield.text);
            set_User_Id([json valueForKey:@"yuangongid"]);
            
            NSLog(@"%@",json);            
            NSString * shouyinTaiQX = [NSString stringWithFormat:@"%@",[json valueForKey:@"shouyintai"]];
       
            set_User_ShouYingTaiQX([shouyinTaiQX isEqualToString:@"1"]);
            NSLog(@"收银台   %@",user_ShouYingTaiQX?@"YES":@"NO");
            
            if ([button isEqual:_registraBtn]) {
                NSString * shareContent = [NSString stringWithFormat:@"%@",[json valueForKey:@"kaihufenxiang"]];
                set_LoginShareContent(shareContent);
            }

            
            if ([self.registraDeleagte respondsToSelector:@selector(completeRegistration)]) {
                [self.registraDeleagte completeRegistration];
            }
        } failure:^(NSError *error) {
            [MBProgressHUD promptWithString:@"网络连接失败"];
            
        }];
        
        

    }
}
//键盘收回
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.accountTextfield resignFirstResponder];
    [self.passWordTextfield resignFirstResponder];
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField == self.accountTextfield){
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
-(void)myTask
{
    sleep(2);
}
#pragma mark  -- 免密登录
-(void)mianMiLogin{
    _accountTextfield.text=user_tel;
    _passWordTextfield.text=user_loginPass;
    
    
    NSMutableDictionary *pram = [NSMutableDictionary dictionaryWithDictionary:@{@"tel":self.accountTextfield.text}];
    [HTTPTool getWithUrl:@"getYuangongInfo.action" params:pram success:^(id json) {
        NSLog(@"json%@",json);
        if ([[json valueForKey:@"message"]integerValue] == 0) {
            [self promptMessageWithString:@"无此员工信息"];
        }
        else if ([[json valueForKey:@"message"]integerValue] == 1)
        {
            self.dianpuNameLabel.hidden = NO;
            self.line1.hidden = NO;
            self.nameLabel.hidden = NO;
            self.line2.hidden = NO;
            
            self.dianpuNameLabel.text = [json valueForKey:@"dianpuname"];
            self.nameLabel.text =[NSString stringWithFormat:@"%@ %@ %@",[json valueForKey:@"bumen"],[json valueForKey:@"zhiwu"],[json valueForKey:@"name"]];
            set_DianPuName(self.dianpuNameLabel.text);
            [[NSUserDefaults standardUserDefaults] setValue:[json valueForKey:@"name"] forKey:@"name"];
            [[NSUserDefaults standardUserDefaults] setValue:[json valueForKey:@"zhiwu"] forKey:@"zhiwu"];
            [[NSUserDefaults standardUserDefaults] setValue:[json valueForKey:@"bumen"] forKey:@"bumen"];
            [[NSUserDefaults standardUserDefaults] setValue:[json valueForKey:@"status"] forKey:@"status"];
            
            [self registraBtnClick:[UIButton new]];
        }
    } failure:^(NSError *error) {
    }];

    
    
}
-(void)reshBanben{
    [Request getAppStatusSuccess:^(id json) {
        NSString * status = [NSString stringWithFormat:@"%@",json];
        if ([status isEqualToString:@"1"]) {
            set_Banben_IsAfter(YES);
            return ;
        }
        set_Banben_IsAfter(NO);
    } failure:^(NSError *error) {
        set_Banben_IsAfter(NO);
    }];
}
@end
