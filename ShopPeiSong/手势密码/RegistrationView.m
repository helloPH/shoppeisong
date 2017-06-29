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
#import "ShouShiMiMaView.h"
#import "findPasViewController.h"
#import "PHAlertView.h"
#import "PHMap.h"
#import "PHButton.h"

#import "ChangeAccountView.h"
#import "OpenAccViewController.h"
#import "FindPassWordViewController.h"

@interface RegistrationView()<MBProgressHUDDelegate,UITextFieldDelegate>
@property (nonatomic,strong)NSMutableDictionary * dataDic;

@property (nonatomic,strong)UILabel * naviView;
@property (nonatomic,strong)UIImageView * headImg;
@property (nonatomic,strong)UIButton * openBtn;
@property (nonatomic,strong)UIButton *registraBtn;//注册按钮
@property (nonatomic,strong)NSMutableArray *yingyongArr ;//应用数组
@property (nonatomic,strong)UILabel *dianpuNameLabel,*nameLabel;//店铺名,姓名
@property (nonatomic,strong)UIView *line1,*line2,*line3,*line4;
@property (nonatomic,strong)UIButton * findPass;

@property (nonatomic,strong)PHMapHelper * mapHelper;

@property (nonatomic,strong)PHButton * moreBtn;
@end
@implementation RegistrationView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
         [self initData];
        self.backgroundColor = [UIColor whiteColor];
        
        NSString * account = [self getAccount];
        if (account) {
            self.accountTextfield.text=account;
            [self getUserInfoWithPhone:self.accountTextfield.text];
        }
        
    }
    return self;
}
-(void)initData{
    _dataDic = [NSMutableDictionary dictionary];
}
-(UILabel *)naviView{
    if (!_naviView) {
        _naviView = [BaseCostomer labelWithFrame:CGRectZero font:[UIFont systemFontOfSize:MLwordFont_4] textColor:textBlackColor text:@""];
        _naviView.hidden=YES;
      
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
#pragma mark 店铺logo
-(UIImageView *)headImg{
    if (!_headImg) {
        _headImg = [[UIImageView alloc]init];
        _headImg.hidden=YES;
        [self addSubview:_headImg];
    }
    return _headImg;
}
#pragma mark 公司名
-(UILabel *)dianpuNameLabel
{
    if (_dianpuNameLabel == nil) {
        _dianpuNameLabel = [BaseCostomer labelWithFrame:CGRectZero font:[UIFont systemFontOfSize:MLwordFont_5] textColor:textBlackColor backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentCenter numOfLines:1 text:@""];
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
        _nameLabel = [BaseCostomer labelWithFrame:CGRectZero font:[UIFont systemFontOfSize:MLwordFont_5] textColor:textBlackColor backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentCenter numOfLines:1 text:@""];
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
        _accountTextfield = [BaseCostomer textfieldWithFrame:CGRectZero font:[UIFont systemFontOfSize:MLwordFont_1] textColor:textColors textAlignment:NSTextAlignmentCenter keyboardType:UIKeyboardTypeNumberPad borderStyle:UITextBorderStyleNone placeholder:@"请输入登录手机号"];
        _accountTextfield.delegate = self;
        [self addSubview:self.accountTextfield];
        
        _accountTextfield.clearButtonMode=UITextFieldViewModeAlways;
//        _accountTextfield.leftView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"输入账号"]];
//        _accountTextfield.leftView.width=_accountTextfield.leftView.height=25*MCscale;
//        _accountTextfield.leftViewMode=UITextFieldViewModeAlways;
        
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
        _passWordTextfield = [BaseCostomer textfieldWithFrame:CGRectZero font:[UIFont systemFontOfSize:MLwordFont_1] textColor:textColors textAlignment:NSTextAlignmentCenter keyboardType:UIKeyboardTypeNumberPad borderStyle:UITextBorderStyleNone placeholder:@"请输入密码"];
        _passWordTextfield.delegate = self;
        [self addSubview:self.passWordTextfield];

        
        _passWordTextfield.secureTextEntry=YES;
//        _passWordTextfield.leftView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"输入密码"]];
//        _passWordTextfield.leftView.width=_passWordTextfield.leftView.height=25*MCscale;
//        _passWordTextfield.leftViewMode=UITextFieldViewModeAlways;
        _passWordTextfield.hidden=YES;
    }
    return _passWordTextfield;
}
-(UIView *)line4
{
    if (!_line4) {
        _line4 = [BaseCostomer viewWithFrame:CGRectZero backgroundColor:lineColor];
        [self addSubview:self.line4];
        _line4.hidden=YES;
    }
    return _line4;
}
-(UIButton *)findPass{
    if (!_findPass) {
        _findPass = [BaseCostomer buttonWithFrame:CGRectZero backGroundColor:nil text:@"忘记密码" image:nil];
        _findPass.hidden=YES;
        [_findPass setTitleColor:mainColor forState:UIControlStateNormal];
        [_findPass addTarget:self.controller action:@selector(forgetBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_findPass];
    }
    return _findPass;
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
        _openBtn.hidden=YES;
        [_openBtn addTarget:self action:@selector(openClick:) forControlEvents:UIControlEventTouchUpInside];
        
        set_Banben_IsAfter(NO);
        if (!banben_IsAfter) {
            [self reshBanbenBlock:^(BOOL isAfter) {
//                _openBtn.hidden=!isAfter;
            }];
        }
        [self addSubview:_openBtn];
    }
    return _openBtn;
}
-(PHButton *)moreBtn{
    if (!_moreBtn) {
        _moreBtn = [PHButton new];
        [_moreBtn setTitle:@"更多" forState:UIControlStateNormal];
        [_moreBtn setTitleColor:textBlackColor forState:UIControlStateNormal];
        _moreBtn.titleLabel.font=[UIFont systemFontOfSize:MLwordFont_4];
        [self addSubview:_moreBtn];
        
        __block RegistrationView * weakSelf = self;
        [_moreBtn addAction:^{
            
        }];
        _moreBtn.block=^(){
            [weakSelf showShell];
        };
    }
    return _moreBtn;
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
    
    [self.headImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.openBtn.mas_bottom).offset(20*MCscale);
        
        make.centerX.equalTo(self);
        make.width.equalTo(@(90*MCscale));
        make.height.equalTo(@(90*MCscale));
    }];
    
    
    
    [self.dianpuNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headImg.mas_bottom).offset(10*MCscale);
        make.left.equalTo(self).offset(20*MCscale);
        make.right.equalTo(self).offset(-20*MCscale);
        make.height.equalTo(@(25*MCscale));
    }];
    
    [self.line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(30*MCscale);
        make.right.equalTo(self).offset(-30*MCscale);
        make.top.equalTo(self.dianpuNameLabel.mas_bottom).offset(0);
        make.height.equalTo(@(0*MCscale));
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.line1.mas_bottom).offset(0*MCscale);
        make.left.equalTo(self).offset(20*MCscale);
        make.right.equalTo(self).offset(-20*MCscale);
        make.height.equalTo(@(25*MCscale));
    }];
    
    [self.line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(30*MCscale);
        make.right.equalTo(self).offset(-30*MCscale);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(0);
        make.height.equalTo(@(0*MCscale));
    }];
    
    [self.accountTextfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.line2.mas_bottom).offset(50*MCscale);
        make.left.equalTo(self).offset(60*MCscale);
        make.right.equalTo(self).offset(-60*MCscale);
        make.height.equalTo(@(30*MCscale));
    }];
    
    [self.line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(60*MCscale);
        make.right.equalTo(self).offset(-60*MCscale);
        make.top.equalTo(self.accountTextfield.mas_bottom).offset(5*MCscale);
        make.height.equalTo(@(1*MCscale));
    }];
    
    [self.passWordTextfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.line3.mas_bottom).offset(20*MCscale);
        make.left.equalTo(self).offset(60*MCscale);
        make.right.equalTo(self).offset(-60*MCscale);
        make.height.equalTo(@(30*MCscale));
    }];

    [self.line4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.passWordTextfield.mas_bottom).offset(5*MCscale);
        make.left.equalTo(self).offset(60*MCscale);
        make.right.equalTo(self).offset(-60*MCscale);
        make.height.equalTo(@(1*MCscale));
    }];
    [self.findPass mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.line4.mas_bottom).offset(5*MCscale);
        make.right.equalTo(self.line4.mas_right).offset(0);
        make.height.equalTo(@(20*MCscale));
        make.width.equalTo(@(100*MCscale));
    }];
    
    [self.registraBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.line4.mas_bottom).offset(40*MCscale);
        make.left.equalTo(self).offset(20*MCscale);
        make.right.equalTo(self).offset(-20*MCscale);
        make.height.equalTo(@(40*MCscale));
    }];
    
    [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(100));
        make.height.equalTo(@(20));
        make.bottom.equalTo(self).offset(-20);
        make.centerX.equalTo(self.registraBtn.mas_centerX);
    }];
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == self.passWordTextfield) {
        
        
    }
}
-(void)getUserInfoWithPhone:(NSString *)phone{
    BOOL isMatch = [BaseCostomer panduanPhoneNumberWithString:phone];
    if(!isMatch){
        [self promptMessageWithString:@"您输入的手机号码不正确!请重新输入"];
    }
    else{
        [MBProgressHUD start];
        NSMutableDictionary *pram = [NSMutableDictionary dictionaryWithDictionary:@{@"tel":phone}];
        [HTTPTool getWithUrl:@"getYuangongInfo.action" params:pram success:^(id json) {
            [MBProgressHUD stop];
            NSLog(@"json%@",json);
            
            
            if ([[json valueForKey:@"message"]integerValue] == 0) {
                [self promptMessageWithString:@"无此员工信息"];
            }
            else if ([[json valueForKey:@"message"]integerValue] == 1)
            {
                if (_dataDic) {
                    [_dataDic removeAllObjects];
                }
                [_dataDic addEntriesFromDictionary:[NSDictionary dictionaryWithDictionary:(NSDictionary *)json]];
                self.dianpuNameLabel.hidden = NO;
                self.line1.hidden = NO;
                self.nameLabel.hidden = NO;
                self.line2.hidden = NO;
                
                
                BOOL hasMima;
                hasMima= [[NSString stringWithFormat:@"%@",[json valueForKey:@"pwd"]] isEqualToString:@"1"];// 判断该账号是否设置密码
            
         
                if (hasMima) {
                    self.headImg.hidden=NO;
                    self.passWordTextfield.hidden=NO;
                    self.line4.hidden=NO;
            
                }else{
                    self.headImg.hidden=YES;
                    self.passWordTextfield.hidden=YES;
                    self.line4.hidden=YES;
              
//                    self.findPass.hidden = YES;
                    [self shezhimima];
                }
                
                NSString * headLink = [NSString stringWithFormat:@"%@",[json valueForKey:@"image"]];

                [self.headImg sd_setImageWithURL:[NSURL URLWithString:headLink] placeholderImage:[UIImage imageNamed:@""] options:SDWebImageRefreshCached];
                
                
                
                self.dianpuNameLabel.text = [json valueForKey:@"dianpuname"];
                self.nameLabel.text =[NSString stringWithFormat:@"%@     %@",[json valueForKey:@"bumen"],[json valueForKey:@"name"]];
                
                NSString * bumen = [NSString stringWithFormat:@"%@",[json valueForKey:@"bumen"]];
                
                
                set_DianPuName(self.dianpuNameLabel.text);
                [[NSUserDefaults standardUserDefaults] setValue:[json valueForKey:@"name"] forKey:@"name"];
                [[NSUserDefaults standardUserDefaults] setValue:[json valueForKey:@"zhiwu"] forKey:@"zhiwu"];
                set_User_BuMen(bumen);
                [[NSUserDefaults standardUserDefaults] setValue:[json valueForKey:@"status"] forKey:@"status"];
            }
        } failure:^(NSError *error) {
            [MBProgressHUD stop];
            [MBProgressHUD promptWithString:@"网络连接失败"];
        }];
        
    }

}
-(void)shezhimima{
    [self endEditing:YES];
    
    __block  NSString * setPassWord;
    __block NSInteger count = 0;
    
    ShouShiMiMaView* shoushimima= [ShouShiMiMaView new];
    [shoushimima setTitle:@"请设置初始密码"];
    [shoushimima appear];
    [shoushimima.backView removeTarget:shoushimima action:@selector(disAppear) forControlEvents:UIControlEventTouchUpInside];
    __block ShouShiMiMaView * weakMima = shoushimima;
    __block RegistrationView * weakSelf = self;
    
    shoushimima.passBlock=^(NSString *password){
        if (count == 0) { // 第一次划手势后进行判断
            if (password.length>=3) {// 密码位数合格
                setPassWord=password;
            }else{// 不合格
                [MBProgressHUD promptWithString:@"请至少连接3个点"];
                [weakMima setTitle:@"请设置初始密码"];
                weakMima.passWord=nil;
                count = 0;
                return ;
            }
        }
        count ++;
        if (count==1) {// 密码 首次设置成功
            [weakMima setTitle:@"请再次输入密码"];
            weakMima.passWord=setPassWord;
        }
        if (count==2) {// 密码 二次输入
            if ([setPassWord isEqualToString:password]) {/// 密码输入正确
                //                        [MBProgressHUD promptWithString:@"密码设置成功"];
                [weakMima disAppear];//
                
                [weakSelf findMimaWithPhone:weakSelf.accountTextfield.text password:setPassWord];
//                newPass = setPassWord;
//                [weakSelf changeNewPasSure:^(BOOL isSuccess) {
//                    //                    [weakMima disAppear];
//                }];
            }else{
                [MBProgressHUD promptWithString:@"两次输入不一致"];
                count=1;
            }
        }
    };
}
-(void)findMimaWithPhone:(NSString *)phone password:(NSString *)password{
    NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"yuangong.tel":phone,@"yuangong.chushimima":password}];
  
    [Request findMiMaWithDic:pram Success:^(id json) {
        if ([[NSString stringWithFormat:@"%@",[json valueForKey:@"massage"]] isEqualToString:@"1"]) {
            [MBProgressHUD promptWithString:@"密码重置成功"];
            set_User_Tel(phone);
            set_LoginPass(password);
            
            if ([user_BuMen isEqualToString:@"管理"]) {
                self.controller.willUpdateLocation=YES;
            }else{
                self.controller.willUpdateLocation=NO;
            }
            
           
            
            PHAlertView * alert = [[PHAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"登录密码设置，商铺管理后台登录密码为“%@”。",user_loginPass] delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
            [alert show];
            alert.block=^(NSInteger index){
                
                [self.controller  surePersonState];
                [self mianMiLogin];
                
            };
            
      
            
        }
    } failure:^(NSError *error) {
    

    }];
}
-(void)registraBtnClick:(UIButton *)button
{
    [self.accountTextfield resignFirstResponder];
    [self.passWordTextfield resignFirstResponder];
    
    
    if (!self.accountTextfield.text || self.accountTextfield.text.length==0) {
        [MBProgressHUD promptWithString:@"请输入手机号"];
        return;
    }
    
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
            [self saveAccount:self.accountTextfield.text];
            
            set_User_Tel(self.accountTextfield.text);
            set_User_Id([json valueForKey:@"yuangongid"]);
            
            NSLog(@"%@",json);            
            NSString * shouyinTaiQX = [NSString stringWithFormat:@"%@",[json valueForKey:@"shouyintai"]];
       
            set_User_ShouYingTaiQX([shouyinTaiQX isEqualToString:@"1"]);
            NSLog(@"收银台   %@",user_ShouYingTaiQX?@"YES":@"NO");
            
            
            NSString * shareContent = [NSString stringWithFormat:@"%@",[json valueForKey:@"kaihufenxiang"]];
            
            set_LoginShareContent(shareContent);
            set_LoginPass(self.passWordTextfield.text);
            
            
            if ([self.registraDeleagte respondsToSelector:@selector(completeRegistration)]) {
                [self.registraDeleagte completeRegistration];
                [self.controller mianmilogin];// 手势密码的 自动点击事件
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
        NSString * newString = [textField.text stringByReplacingCharactersInRange:range withString:string];

        
      
        if (newString.length <= 11){
            if (newString.length<11) {// 手机号输入不完整
                self.passWordTextfield.hidden=YES;
                self.line4.hidden=YES;
                self.dianpuNameLabel.hidden = YES;
                self.line1.hidden = YES;
                self.nameLabel.hidden = YES;
                self.line2.hidden = YES;
       
                self.findPass.hidden=YES;
                self.headImg.hidden=YES;
            }else{//
                [self getUserInfoWithPhone:newString];
            }
            
            return YES;
        }
        else
            
            return NO;
    }
    return YES;
}
-(BOOL)textFieldShouldClear:(UITextField *)textField{
    self.passWordTextfield.hidden=YES;
    self.line4.hidden=YES;
    self.dianpuNameLabel.hidden = YES;
    self.line1.hidden = YES;
    self.nameLabel.hidden = YES;
    self.line2.hidden = YES;
  
    self.findPass.hidden=YES;
    self.headImg.hidden=YES;
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
-(void)mianMiLogin{//  登录界面的 自动输入密码
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
-(void)reshBanbenBlock:(void(^)(BOOL isAfter))block{
    [Request getAppStatusSuccess:^(id json) {
        NSString * status = [NSString stringWithFormat:@"%@",json];
        if ([status isEqualToString:@"0"] || [status isEqualToString:@"1"]) {
            set_Banben_IsAfter(YES);
            block(YES);
            return ;
        }
        set_Banben_IsAfter(NO);
        block(NO);
    } failure:^(NSError *error) {
        set_Banben_IsAfter(NO);
        block(NO);
    }];
}

-(void)showShell{
    __block RegistrationView * weakSelf = self;
    
    
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    
    UIAlertAction * action1 = [UIAlertAction actionWithTitle:@"更换账号" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSMutableArray * accounts = local_Accounts;
        if (!accounts || ![accounts isKindOfClass:[NSMutableArray class]]) {
            [MBProgressHUD promptWithString:@"应用还未登陆过任何账号"];
            return ;
        }
       
      
      ChangeAccountView * change = [[ChangeAccountView alloc]init];
        __block ChangeAccountView * weakChange = change;
        change.block=^(NSString * account){
            [weakChange disAppear];
            
            weakSelf.accountTextfield.text=account;
            [weakSelf getUserInfoWithPhone:weakSelf.accountTextfield.text];
        };
      [change appear];
    }];
    UIAlertAction * action2 = [UIAlertAction actionWithTitle:@"注册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        
        OpenAccViewController * openAcc = [OpenAccViewController new];
        UINavigationController * openNavi = [[UINavigationController alloc]initWithRootViewController:openAcc];
        [openNavi.navigationBar setBarTintColor:naviBarTintColor];
        [self.controller presentViewController:openNavi animated:YES completion:^{
        }];
        openAcc.successBlock=^(BOOL isLoginSuc){///开户成功 的 回调
        
        };

        
        
        
    }];
    UIAlertAction * action3 = [UIAlertAction actionWithTitle:@"忘记密码" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UIButton * btn = [UIButton new];
        btn.tag=100;
        [self.controller forgetBtnClick:btn];
        
        
    }];
    UIAlertAction * action4 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];

    
    [alert addAction:action1];
    [alert addAction:action2];
    [alert addAction:action3];
    [alert addAction:action4];

    [self.controller presentViewController:alert animated:YES completion:^{
        
    }];
}
-(NSString *)getAccount{
     NSMutableArray * accounts = local_Accounts;
    if (accounts && [accounts isKindOfClass:[NSMutableArray class]] && [accounts count]>0) {
        NSString * account = [accounts lastObject];
        if ([account isKindOfClass:[NSString class]] && [account isValidateMobile]) {
            return account;
        }
    }
    return nil;
}
-(void)saveAccount:(NSString *)account{
    
    NSMutableArray * accounts = [NSMutableArray arrayWithArray:local_Accounts];
    
    if (!accounts || ![accounts isKindOfClass:[NSMutableArray class]]) {
        accounts = [NSMutableArray array];
    }
    if (![accounts containsObject:account]) {
        [accounts addObject:account];
        if ([accounts count]>4) {
            [accounts removeObjectAtIndex:0];
        }
    }else{
        [accounts removeObject:account];
        [accounts addObject:account];
    }
    set_Local_Accounts(accounts);
}
@end
