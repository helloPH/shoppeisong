//
//  GestureViewController.m
//  ManageForMM
//
//  Created by MIAO on 16/9/23.
//  Copyright © 2016年 时元尚品. All rights reserved.
//

#import "GestureViewController.h"
#import "CustomerTabbatViewController.h"
#import "GestureLockView.h"
#import "RegistrationView.h"
#import "Header.h"
//#import "findPasViewController.h"
#import "OpenAccountViewController.h"
#import "OpenAccViewController.h"
#import "PHAlertView.h"
#import "PHMap.H"
#import "FindPassWordViewController.h"

@interface GestureViewController ()<GestureLockDelegate,MBProgressHUDDelegate,RegistrationViewDelegate>
@property (strong, nonatomic) UILabel *label;
@property (strong, nonatomic) NSString *passResult;
@property (strong, nonatomic) UIButton *forgetBtn;
@property (strong, nonatomic) GestureLockView *gesView;//手势密码
@property (strong, nonatomic) RegistrationView *registraView;//注册
@property (strong, nonatomic) UIImageView *backImge;



@property (nonatomic,strong)PHMapHelper * mapHelper;
@end
@implementation GestureViewController
- (void)viewDidLoad {
    [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"isFirstLogin"];
    [super viewDidLoad];
    self.view.backgroundColor = txtColors(231, 231, 231, 1);
    [self surePersonState];


}
-(void)mianmilogin{
    [self surePersonState];
    
    [self.gesView loginWithPassWord:user_loginPass];
}

-(GestureLockView *)gesView
{
    if (!_gesView) {
        _gesView = [[GestureLockView alloc]initWithFrame:CGRectMake(20*MCscale, 200*MCscale, kDeviceWidth-40*MCscale, kDeviceWidth-40*MCscale)];
        _gesView.GestureDelegate = self;
        [self.view addSubview:_gesView];

    }
    return _gesView;
}

-(RegistrationView *)registraView
{
    if (!_registraView) {
        _registraView = [[RegistrationView alloc]initWithFrame:CGRectZero];
        _registraView.registraDeleagte = self;
        _registraView.controller=self;
        
        __block GestureViewController * weakSelf = self;
        _registraView.openBlock=^(){// 登录界面的 开户按钮 回调
            OpenAccViewController * openAcc = [OpenAccViewController new];
            UINavigationController * openNavi = [[UINavigationController alloc]initWithRootViewController:openAcc];
            [openNavi.navigationBar setBarTintColor:naviBarTintColor];
            [weakSelf presentViewController:openNavi animated:YES completion:^{
            }];
            
            openAcc.successBlock=^(BOOL isLoginSuc){///开户成功 的 回调
//                PHAlertView * alertview = [[PHAlertView alloc]initWithTitle:@"提示" message:@"商铺开户成功，请输入手机号并设置初始登录密码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                [alertview show];
                
//                [weakSelf.registraView mianMiLogin];
            };
        };
        [self.view addSubview:_registraView];
        
        [_registraView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.view.mas_centerY);
            make.left.equalTo(self.view).offset(0*MCscale);
            make.right.equalTo(self.view).offset(0*MCscale);
            make.height.equalTo(@(kDeviceHeight));
            
        }];

    }
    return _registraView;
}

-(UIImageView *)backImge
{
    if (!_backImge) {
        _backImge  = [BaseCostomer imageViewWithFrame:CGRectZero backGroundColor:[UIColor clearColor] cornerRadius:35*MCscale userInteractionEnabled:NO image:@""];
        _backImge.hidden=YES;
        NSString *imageUrl =   [[NSUserDefaults standardUserDefaults]valueForKey:@"touxiangImage"];
        [_backImge sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"yonghutouxiang"] options:SDWebImageRefreshCached];
        [self.view addSubview:_backImge];
        [self.backImge mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(70*MCscale);
            make.centerX.equalTo(self.view.mas_centerX);
            make.size.equalTo(@(70*MCscale));
        }];
    }
    return _backImge;
}

-(void)surePersonState
{
    if (user_Id) {
        [Request yanZhengSheBeiSuccess:^(id json) {
            NSString * message = [NSString stringWithFormat:@"%@",[json valueForKey:@"message"]];
            switch ([message integerValue]) {
                case 0:
                    [self denglujiemian];
                    break;
                case 1:
                {
                    set_User_Id([json valueForKey:@"yuangongid"]);
                    set_DianPuName([json valueForKey:@"shequname"]);
                    set_User_dianpuID([json valueForKey:@"shequid"]);
                    
                    if (_willUpdateLocation) {
                        [self updateLocation];
                    }
                    self.registraView.hidden = YES;
                    self.label.hidden = NO;
                    self.label.text = @"请输入手势密码";
//                    self.backImge.hidden = NO;
                    self.gesView.hidden = NO;
                    self.forgetBtn.hidden = NO;
                }
                    break;
                case 2:
                    [MBProgressHUD promptWithString:@"参数为空"];
                    break;
                    
                default:
                    break;
            }
  
        } failure:^(NSError *error) {
            
        }];

    }else{
        [self denglujiemian];
    }
    

}
-(void)denglujiemian{
    [UIView animateWithDuration:0.3 animations:^{
        self.registraView.alpha = 0.95;
        self.registraView.hidden = NO;
        self.gesView.hidden = YES;
        self.forgetBtn.hidden = YES;
//        self.backImge.hidden = YES;
        self.label.hidden = YES;
    } completion:^(BOOL finished) {
        //            self.view.backgroundColor=[UIColor whiteColor];
    }];
}

-(void)updateLocation{
    _mapHelper = [PHMapHelper new];
    [_mapHelper configBaiduMap];
    [_mapHelper locationStartLocation:^{
        
    } locationing:^(BMKUserLocation *location, NSError *error) {
        [_mapHelper regeoWithLocation:CLLocationCoordinate2DMake(location.location.coordinate.latitude, location.location.coordinate.longitude) block:^(BMKReverseGeoCodeResult *result, BMKSearchErrorCode error) {
            if (error) {
                [MBProgressHUD promptWithString:@"地理编码失败"];
                return ;
            }
            NSDictionary * pram = @{@"dianpu.id":user_dianpuID,
                                    @"dianpu.x":[NSString stringWithFormat:@"%f",location.location.coordinate.longitude],
                                    @"dianpu.y":[NSString stringWithFormat:@"%f",location.location.coordinate.latitude],
                                    @"code":result.addressDetail.city};
            [Request updateLocationWithDic:pram Success:^(id json) {
            } failure:^(NSError *error) {
            }];
        }];
        
        

        [_mapHelper endLocation];
    } stopLocation:^{
        
    }];
    
    
}

- (void)resetLabel
{
    self.label.text = @"请输入正确的密码";
}

#pragma mark - GestureLockViewDelegate
//原密码为nil调用
- (void)GestureLockSetResult:(NSString *)result gestureView:(GestureLockView *)gestureView
{
    NSLog(@"输入密码：%@",result);
    _passResult = result;
    [gestureView setRigthResult:result];
    //    self.label.text = @"请确认密码";
}

//密码核对成功调用
- (void)GestureLockPasswordRight:(GestureLockView *)gestureView
{
    NSLog(@"密码正确");
    self.label.text = @"密码正确";
    
    
    
    [self addMainViewController];
}
-(void)addMainViewController
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    CustomerTabbatViewController *main = [[CustomerTabbatViewController  alloc]init];
    self.view.window.rootViewController = main;
}

//密码核对失败调用
- (void)GestureLockPasswordWrong:(GestureLockView *)gestureView
{
    NSLog(@"密码错误");
    self.label.text = @"密码错误";
    [self performSelector:@selector(resetLabel) withObject:nil afterDelay:1];
}
-(UILabel *)label
{
    if (!_label) {
        _label = [BaseCostomer labelWithFrame:CGRectZero font:[UIFont systemFontOfSize:MLwordFont_4] textColor:mainColor backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentCenter numOfLines:1 text:@"请输入手势密码"];
        [self.view addSubview:_label];
        [_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.backImge.mas_bottom).offset(10*MCscale);
            make.left.equalTo(self.view).offset(0);
            make.right.equalTo(self.view).offset(0);
            make.height.equalTo(@(30*MCscale));
        }];
    }
    return _label;
}

#pragma mark 忘记密码按钮
-(UIButton *)forgetBtn
{
    if (!_forgetBtn) {
        _forgetBtn = [BaseCostomer buttonWithFrame:CGRectZero font:[UIFont systemFontOfSize:MLwordFont_4] textColor:mainColor backGroundColor:[UIColor clearColor] cornerRadius:0 text:@"忘记密码" image:@""];
        [_forgetBtn addTarget:self action:@selector(forgetBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_forgetBtn];
        [_forgetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.gesView.mas_bottom).offset(10*MCscale);
            make.right.equalTo(self.view.mas_right).offset(-20*MCscale);
            make.width.equalTo(@(80*MCscale));
            make.height.equalTo(@(30*MCscale));
        }];
    }
    return _forgetBtn;
}

#pragma mark 忘记密码
-(void)forgetBtnClick:(UIButton *)button
{
//    findPasViewController *findPasVC = [[findPasViewController alloc]init];
    FindPassWordViewController * findPasVC = [FindPassWordViewController new];
    if (button.tag==100) {
        findPasVC.beforeTel=self.registraView.accountTextfield.text;
        findPasVC.backPhone=^(NSString *tel){
            self.registraView.accountTextfield.text=tel;
        };
    }
    
    
    findPasVC.hidesBottomBarWhenPushed = YES;
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:findPasVC];
    UINavigationBar *bar = navi.navigationBar;
    bar.translucent = YES;
    [bar setBarTintColor:naviBarTintColor];
    bar.tintColor = [UIColor whiteColor];
    [bar setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:17],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self presentViewController:navi animated:YES completion:^{
        //code;
    }];
}

#pragma mark RegistrationViewDelegate
-(void)completeRegistration
{

    [self surePersonState];
    
    
//    [UIView animateWithDuration:0.3 animations:^{
//        self.registraView.alpha = 0;
//        [self.view endEditing:YES];
//        [self.registraView removeFromSuperview];
//        self.gesView.hidden = NO;
//        self.label.hidden = NO;
//        self.forgetBtn.hidden = NO;
//        self.backImge.hidden = NO;
//    }];
//    self.label.text = @"请输入手势密码";
//    [self showGuideImageWithUrl:@"images/caozuotishi/shoushi.png"];

//    [self judgeTheFirst];
}




-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.registraView.accountTextfield resignFirstResponder];
    [self.registraView.passWordTextfield resignFirstResponder];
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
    sleep(1);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
