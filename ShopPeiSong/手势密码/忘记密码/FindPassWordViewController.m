//
//  FindPassWordViewController.m
//  ShopPeiSong
//
//  Created by MIAO on 2017/6/28.
//  Copyright © 2017年 妙灵科技. All rights reserved.
//

#import "FindPassWordViewController.h"
#import "Header.h"
#import "MoNiSystemAlert.h"

#import "ShouShiMiMaView.h"
#import "YanButton.h"

@interface FindPassWordViewController ()<UITextFieldDelegate>
@property (nonatomic,strong)NSString * nPW;


@property (nonatomic,strong)UITextField * phoneTF;

@property (nonatomic,strong)YanButton * yanBtn;


@property (nonatomic,strong)UITextField * yanTF;

@property (nonatomic,strong)UIButton    * yanSureBtn;

@end

@implementation FindPassWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self newNavi];
    [self newView];
    [self reshView];
    
    // Do any additional setup after loading the view.
}
-(void)newNavi{
    UIButton * leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, NVbtnWight, NVbtnWight)];
    [leftBtn setImage:[UIImage imageNamed:@"返回按钮"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    
    self.navigationItem.title=@"重置密码";
    
    
}
-(void)dismiss{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{}];
}
-(void)reshView{
    _yanBtn.hidden=YES;
    _yanTF.hidden=YES;
    _yanSureBtn.hidden=YES;
}
-(void)newView{
    self.view.backgroundColor=[UIColor whiteColor];
    
    CGFloat setY = 100*MCscale;
    
    UITextField *telFiled = [[UITextField alloc]initWithFrame:CGRectMake(20*MCscale, setY, 210*MCscale, 40*MCscale)];
    
    telFiled.placeholder = @"请输入绑定手机号";
    telFiled.keyboardType = UIKeyboardTypeNumberPad;
    telFiled.textAlignment = NSTextAlignmentCenter;
    telFiled.textColor = [UIColor blackColor];
    telFiled.backgroundColor =lineColor;
    telFiled.font = [UIFont systemFontOfSize:16];
    telFiled.delegate = self;
    [self.view addSubview:telFiled];
    _phoneTF = telFiled;
    if (_beforeTel && [_beforeTel isValidateMobile]) {
        _phoneTF.text = _beforeTel;
    }
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(telFiled.right+10, telFiled.top, 130*MCscale, 40*MCscale);
    btn.backgroundColor = txtColors(248, 53, 74, 1);
    [btn setTitle:@"验证" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:18];
    btn.layer.cornerRadius = 3.0;
    btn.layer.masksToBounds = YES;
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(yanzhengtel) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    
    setY = btn.bottom;
    

    _yanBtn = [YanButton insButtonWithFrame:CGRectMake(20*MCscale, setY + 30, self.view.width-40*MCscale, 30*MCscale) title:@"验证码" time:180];
    [_yanBtn setTitleColor:redTextColor forState:UIControlStateNormal];
    [self.view addSubview:_yanBtn];
    setY = _yanBtn.bottom;
    
    
    _yanTF = [[UITextField alloc]initWithFrame:CGRectMake(20*MCscale, setY+20, self.view.width-40, 40*MCscale)];
    _yanTF.placeholder = @"请输入验证码";
    _yanTF.keyboardType = UIKeyboardTypeNumberPad;
    _yanTF.textAlignment = NSTextAlignmentCenter;
    _yanTF.textColor = [UIColor blackColor];
    _yanTF.backgroundColor = lineColor;
    _yanTF.font = [UIFont systemFontOfSize:16];
    _yanTF.delegate = self;
    [self.view addSubview:_yanTF];
    setY  = _yanTF.bottom;
    
    _yanSureBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, setY+20*MCscale, 100, 30)];
    _yanSureBtn.centerX=_yanTF.centerX;
    _yanSureBtn.backgroundColor = txtColors(248, 53, 74, 1);
    [_yanSureBtn setTitle:@"确定" forState:UIControlStateNormal];
    _yanSureBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    _yanSureBtn.layer.cornerRadius = 3.0;
    _yanSureBtn.layer.masksToBounds = YES;
    [_yanSureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_yanSureBtn addTarget:self action:@selector(yanSureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_yanSureBtn];
}
-(void)yanzhengtel{
    UITextField *tel = _phoneTF;
    BOOL isMatch = [BaseCostomer panduanPhoneNumberWithString:tel.text];
    if(!isMatch){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"错误提示" message:@"您输入的手机号码不正确!请重新输入" preferredStyle:1];
        UIAlertAction *suerAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alert addAction:suerAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else{
        NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"yuangong.tel":tel.text}];
        
        
        
        [MBProgressHUD start];
        [HTTPTool getWithUrl:@"back.action" params:pram success:^(id json) {
            [MBProgressHUD stop];
            
            
            NSDictionary *dic = (NSDictionary *)json;
            if ([dic valueForKey:@"massage"]) {
                if([[dic valueForKey:@"massage"]intValue]==1){
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"错误提示" message:@"您输入的手机未注册!请重新输入" preferredStyle:1];
                    UIAlertAction *suerAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    }];
                    [alert addAction:suerAction];
                    [self presentViewController:alert animated:YES completion:nil];
                }
                else{
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"错误提示" message:@"您输入的手机号码不正确!请重新输入" preferredStyle:1];
                    UIAlertAction *suerAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    }];
                    [alert addAction:suerAction];
                    [self presentViewController:alert animated:YES completion:nil];
                }
            }
            else{
                
                
      
                NSDictionary * pram = @{@"canshu":@"2",// 1 用户 2 员工
                                        @"tel":tel.text,
                                        @"content":user_shebeiId};
                
                [self yanZhengShengFenWithDic:pram success:^(id json) {
                    
                            _yanBtn.hidden=NO;
                            [_yanBtn startTimer];
                            _yanTF.hidden=NO;
                            _yanSureBtn.hidden=NO;
                    if ([json isEqualToString:@"0"]) {
                    }else{
                        MoNiSystemAlert * alert = [MoNiSystemAlert new];
                        alert.content=[NSString stringWithFormat:@"%@",json];
                        [alert appear];
                    }
                } failure:^(NSError *error) {
                    
                }];
            

            
            }
        } failure:^(NSError *error) {
            [MBProgressHUD stop];
            
            [MBProgressHUD promptWithString:@"网络连接错误"];
 
        }];
    }
}
-(void)yanSureBtnClick:(UIButton *)sender{
    UITextField *mes = _yanTF;
    NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"yuangong.tel":_phoneTF.text,@"code":mes.text}];
    

    [MBProgressHUD start];
    [HTTPTool getWithUrl:@"backlongin.action" params:pram success:^(id json) {
        [MBProgressHUD stop];
        
        NSDictionary *dic = (NSDictionary *)json;
        if([[dic valueForKey:@"massage"]intValue]==3){
            [self shurumima];
        }
        else{
            [MBProgressHUD promptWithString:@"验证码有误"];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD stop];
        [MBProgressHUD promptWithString:@"网络连接错误"];
    }];

}
-(void)shurumima{
    __block  NSString * setPassWord;
    __block NSInteger count = 0;
    
    ShouShiMiMaView * shoushimima;

    shoushimima= [ShouShiMiMaView new];
    [shoushimima setTitle:@"请输入密码"];
    [shoushimima appear];
    __block ShouShiMiMaView * weakMima = shoushimima;
    __block FindPassWordViewController * weakSelf = self;
    
    shoushimima.passBlock=^(NSString *password){
        if (count == 0) { // 第一次划手势后进行判断
            if (password.length>=3) {// 密码位数合格
                setPassWord=password;
            }else{// 不合格
                [MBProgressHUD promptWithString:@"请至少连接3个点"];
                [weakMima setTitle:@"请输入密码"];
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
                _nPW = setPassWord;
                [weakSelf changeNewPasSure:^(BOOL isSuccess) {
                   [weakMima disAppear];
                }];
            }else{
                [MBProgressHUD promptWithString:@"两次输入不一致"];
                count=1;
            }
        }
    };
    
}
//新密码 修改
-(void)changeNewPasSure:(void(^)(BOOL isSuccess))block
{

        NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"yuangong.tel":_phoneTF.text,@"yuangong.chushimima":_nPW}];
        
        [Request findMiMaWithDic:pram Success:^(id json) {
            NSDictionary *dic = (NSDictionary *)json;
            if ([[dic valueForKey:@"massage"]intValue]==1) {

                NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
            
                [def setValue:_nPW forKey:@"loginPass"];
                [MBProgressHUD promptWithString:@"密码重置成功"];
                if (_backPhone) {
                    _backPhone(self.phoneTF.text);
                }
                [self.navigationController dismissViewControllerAnimated:YES completion:^{
                    
                }];
                
            }
            else{
                [MBProgressHUD promptWithString:@"密码重置失败!请稍后重试"];
                
            }
            
        } failure:^(NSError *error) {
            
        }];
        
}


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString * newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    return newString.length<=11;

}

-(void)yanZhengShengFenWithDic:(NSDictionary *)dic success:(successBlock)success failure:(failureBlock)failure{
    [Request yanZhengShengFenWithDic:dic success:^(id json) {
        NSString * message = [NSString stringWithFormat:@"%@",[json valueForKey:@"messages"]];
        
        if ([message isEqualToString:@"0"]) {//
            NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"yuangong.tel":_phoneTF.text}];
            [HTTPTool getWithUrl:@"backCode.action" params:pram success:^(id json) {
                NSDictionary *dic = (NSDictionary *)json;
                if ([[dic valueForKey:@"massage"]intValue]==1) {
                    success(@"0");// 短信
                }
                else{

                    failure(nil);
                
                }
            } failure:^(NSError *error) {
                failure(error);
            }];
        }else{// 发送手机验证码
            success(message);// 本地
            
//            MoNiSystemAlert * alert = [MoNiSystemAlert new];
//            alert.content=message;
//            [alert appear];
        }
//        _yanBtn.hidden=NO;
//        [_yanBtn startTimer];
//        _yanTF.hidden=NO;
//        _yanSureBtn.hidden=NO;
//        
        
    } failure:^(NSError *error) {
        failure(error);
//        MoNiSystemAlert * alert = [MoNiSystemAlert new];
//        //                    alert.content=message;
//        [alert appear];
        
    }];


}


@end
