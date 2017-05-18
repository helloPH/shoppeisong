//
//  SecurityViewController.m
//  ShopPeiSong
//
//  Created by MIAO on 2017/3/8.
//  Copyright © 2017年 时元尚品. All rights reserved.
//

#import "SecurityViewController.h"
#import "SecurityCell.h"
#import "LoginPasswordView.h"
#import "ChangePhoneNumber.h"
#import "SetPaymentPasswordView.h"
#import "YanzhengShenfenzhengView.h"
#import "ChangeImageView.h"
#import "SelectedTixingTimeView.h"
#import "Header.h"
#import "GestureViewController.h"

@interface SecurityViewController ()<UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource,LoginPasswordViewDelegate,MBProgressHUDDelegate,ChangePhoneNumberDelegate,SetPaymentPasswordViewDelegate,YanzhengShenfenzhengViewDelegate,ChangeImageViewDelegate,SecurityCellDelegate>
@property(nonatomic,strong)UITableView *mainTableView;
@property(nonatomic,strong)UIButton *leftButton;
@property(nonatomic,strong)UIView *maskView;
@property(nonatomic,strong)LoginPasswordView *passView;
@property(nonatomic,strong)ChangePhoneNumber *changPhoneNextPop;//改变手机号下一步
@property(nonatomic,strong)SetPaymentPasswordView *nextPayPas;//支付密码下一步
@property(nonatomic,strong)YanzhengShenfenzhengView *shenfenzhengView;
@property(nonatomic,strong)ChangeImageView *changeImage;
@property(nonatomic,strong)SelectedTixingTimeView *selectedTimeView;
@property(nonatomic,strong)UIButton * outLoginBtn;

@end
@implementation SecurityViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    __weak typeof (self) weakSelf = self;
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        self.navigationController.interactivePopGestureRecognizer.delegate = weakSelf;
    }
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.mainTableView];
    [self setNavigationItem];
    
    [self newVeiw];
}
-(void)newVeiw{
#pragma mark 退出登录
    _outLoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _outLoginBtn.frame = CGRectMake(10*MCscale, self.mainTableView.bottom+20*MCscale, kDeviceWidth-20*MCscale, 50*MCscale);
    _outLoginBtn.backgroundColor = txtColors(249, 54, 73, 1);
    _outLoginBtn.layer.masksToBounds = YES;
    _outLoginBtn.layer.cornerRadius = 5.0;
    [_outLoginBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    _outLoginBtn.titleLabel.font = [UIFont systemFontOfSize:MLwordFont_2];
    [_outLoginBtn addTarget:self action:@selector(goOutLogin) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_outLoginBtn];
    
}
-(void)goOutLogin{
    

    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"确定退出登录" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cleAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"user_ID"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"user_tel"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"name"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"user_tel"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"loginPass"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"touxiangImage"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"bumen"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"zhiwu"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"status"];
        
        GestureViewController * ges = [GestureViewController new];
        [self presentViewController:ges animated:YES completion:^{
            
        }];
        
        
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    
    [alert addAction:cleAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
    
}
#pragma mark 设置导航栏
-(UIButton *)leftButton
{
    if (!_leftButton) {
        _leftButton = [BaseCostomer buttonWithFrame:CGRectMake(0, 0, NVbtnWight, NVbtnWight) backGroundColor:[UIColor clearColor] text:@"" image:@"返回按钮"];
        [_leftButton addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftButton;
}
-(void)setNavigationItem
{
    [self.navigationItem setTitle:@"安全设置"];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:MLwordFont_2],NSFontAttributeName, nil]];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:self.leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
}
-(UITableView *)mainTableView
{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,64*MCscale,kDeviceWidth, 420*MCscale) style:UITableViewStylePlain];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.separatorStyle = UITableViewCellSelectionStyleNone;
        _mainTableView.scrollEnabled=NO;
    }
    return _mainTableView;
}

-(UIView *)maskView
{
    if (!_maskView) {
        _maskView = [[UIView alloc]initWithFrame:self.view.bounds];
        _maskView.alpha = 1;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(maskDisMiss)];
        [_maskView addGestureRecognizer:tap];
    }
    return _maskView;
}
-(LoginPasswordView *)passView
{
    if (!_passView) {
        _passView = [[LoginPasswordView alloc]initWithFrame:CGRectMake(40*MCscale, 100*MCscale, kDeviceWidth - 80*MCscale, 320*MCscale)];;
        _passView.loginPassDelegate = self;
    }
    return _passView;
}

-(ChangePhoneNumber *)changPhoneNextPop
{
    if (!_changPhoneNextPop) {
        _changPhoneNextPop = [[ChangePhoneNumber alloc]initWithFrame:CGRectMake(kDeviceWidth/20.0, 180*MCscale, kDeviceWidth*9/10.0, 232*MCscale)];
        _changPhoneNextPop.changeDelegate = self;
        _changPhoneNextPop.alpha = 0;
    }
    return _changPhoneNextPop;
}
-(YanzhengShenfenzhengView *)shenfenzhengView
{
    if (!_shenfenzhengView) {
        _shenfenzhengView = [[YanzhengShenfenzhengView alloc]initWithFrame:CGRectMake(kDeviceWidth/20.0, 180*MCscale, kDeviceWidth*9/10.0, 200*MCscale)];
        _shenfenzhengView.shenfenzhengDelegate = self;
    }
    return _shenfenzhengView;
}

-(SetPaymentPasswordView *)nextPayPas
{
    if (!_nextPayPas) {
        _nextPayPas  = [[SetPaymentPasswordView alloc] initWithFrame:CGRectMake(kDeviceWidth/20.0, 180*MCscale, kDeviceWidth*9/10.0, 232*MCscale)];
        _nextPayPas.setPaymentDelegate = self;
        _nextPayPas.alpha = 0;
    }
    return _nextPayPas;
}

-(ChangeImageView *)changeImage
{
    if (!_changeImage) {
        _changeImage = [[ChangeImageView alloc]initWithFrame:CGRectMake(50*MCscale,230*MCscale, kDeviceWidth-100*MCscale,150*MCscale)];
        _changeImage.changeImageDelegate = self;
    }
    return _changeImage;
}

-(SelectedTixingTimeView *)selectedTimeView
{
    if (!_selectedTimeView) {
        _selectedTimeView = [[SelectedTixingTimeView alloc]initWithFrame:CGRectMake(30*MCscale, 230*MCscale, kDeviceWidth - 60*MCscale,130*MCscale)];
    }
    return _selectedTimeView;
}

#pragma mark UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    SecurityCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[SecurityCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.securityDelegate = self;
    [cell reloadDataWithIndexpath:indexPath];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0 || indexPath.row == 1|| indexPath.row == 2|| indexPath.row == 6) {
        [UIView animateWithDuration:0.3 animations:^{
            self.maskView.alpha = 1;
            [self.view addSubview:self.maskView];
            self.passView.alpha = 0.95;
            [self.view addSubview:self.passView];
            [self.passView reloadDataWithViewTag:indexPath.row];
            [self.passView bringSubviewToFront:self.view];
        }];
    }
    else if (indexPath.row == 5)
    {
        [UIView animateWithDuration:0.3 animations:^{
            self.maskView.alpha = 1;
            [self.view addSubview:self.maskView];
            self.changeImage.alpha = 0.95;
            [self.view addSubview:self.changeImage];
        }];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60*MCscale;
}

#pragma mark LoginPasswoordViewDelegate
-(void)changeNewPassWordWithString:(NSString *)newPass AndIndex:(NSInteger)index
{
    [self maskDisMiss];
    if (index == 0)//修改登录密码
    {
        [self changeLoginPasswordWithPass:newPass];
    }
    else if (index == 1) {//提现密码
        [UIView animateWithDuration:0.3 animations:^{
            self.maskView.alpha = 1;
            [self.view addSubview:self.maskView];
            self.shenfenzhengView.alpha = 0.95;
            [self.view addSubview:self.shenfenzhengView];
        }];
        
    }
    else if (index == 2)//更换绑定设备
    {// 更换设备
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"user_ID"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"user_tel"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"name"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"user_tel"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"loginPass"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"touxiangImage"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"bumen"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"zhiwu"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"status"];
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"更换绑定设备成功,将退出系统" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cleAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        exit(0);
        }];
        [alert addAction:cleAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else{
        [UIView animateWithDuration:0.3 animations:^{
            self.maskView.alpha = 1;
            [self.view addSubview:self.maskView];
            self.changPhoneNextPop.alpha = 0.95;
            [self.view addSubview:self.changPhoneNextPop];
        }];
    }
}

#pragma mark 验证身份证成功
-(void)YanzhengShenfenzhengViewSuccess
{
    [UIView animateWithDuration:0.3 animations:^{
        self.maskView.alpha = 0;
        [self.maskView removeFromSuperview];
        [self.view endEditing:YES];
        self.shenfenzhengView.alpha = 0;
        [self.shenfenzhengView removeFromSuperview];
    }];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.maskView.alpha =1;
        [self.view addSubview:self.maskView];
        self.nextPayPas.alpha = 0.95;
        [self.view addSubview:self.nextPayPas];
    }];
}
#pragma mark 设置支付密码
-(void)SetPaymentPasswordSuccessWithIndex:(NSInteger)index
{
    if (index == 1) {
        MBProgressHUD *mbHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        mbHud.mode = MBProgressHUDModeCustomView;
        mbHud.labelText = @"支付密码修改成功";
        mbHud.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"37x-Checkmark"]];
        [mbHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];        [self maskDisMiss];
    }
    else
    {
        [self promptMessageWithString:@"修改失败!请稍后再试"];
    }
}
#pragma mark 更换手机号
-(void)ChangePhoneNumberWithString:(NSString *)string AndIndex:(NSInteger)index
{
    if (index == 5) {
        [self maskDisMiss];
        MBProgressHUD *mbHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        mbHud.mode = MBProgressHUDModeCustomView;
        mbHud.labelText = @"手机号更换成功";
        mbHud.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"37x-Checkmark"]];
        [mbHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
        [[NSUserDefaults standardUserDefaults] setObject:string forKey:@"user_tel"];
        NSDictionary *dict = @{@"tel":string};
        NSNotification *changePhoneNumberNoti = [NSNotification notificationWithName:@"changePhoneNumberNoti" object:nil userInfo:dict];
        [[NSNotificationCenter defaultCenter]postNotification:changePhoneNumberNoti];
        [[NSNotificationCenter defaultCenter]removeObserver:self name:@"changePhoneNumberNoti" object:nil];
        [self.mainTableView reloadData];
    }
    else if (index == 3)
    {
        //验证码有误
        [self promptMessageWithString:@"验证码有误"];
    }
    else
    {
        //更改失败请重试
        [self promptMessageWithString:@"操作失败请稍后重试"];
    }
}
#pragma mark 修改登录密码
-(void)changeLoginPasswordWithPass:(NSString *)string
{
    MBProgressHUD *mbHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    mbHud.mode = MBProgressHUDModeIndeterminate;
    mbHud.delegate = self;
    mbHud.labelText = @"请稍等...";
    [mbHud show:YES];
    
    NSMutableDictionary *pram = [NSMutableDictionary dictionaryWithDictionary:@{@"yuangong.id":user_id,@"yuangong.chushimima":string}];
    NSLog(@"asdfsadfdsadfs %@",pram);
    [HTTPTool getWithUrl:@"updatePwd.action" params:pram success:^(id json) {
        [mbHud hide:YES];
        NSLog(@"json %@",json);
        if ([[json valueForKey:@"message"]integerValue] == 1) {
            MBProgressHUD *mbHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            mbHud.mode = MBProgressHUDModeCustomView;
            mbHud.labelText = @"登录密码修改成功";
            mbHud.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"37x-Checkmark"]];
            [mbHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
            [[NSUserDefaults standardUserDefaults] setValue:@"2" forKey:@"isFirstLogin"];
            [[NSUserDefaults standardUserDefaults] setValue:string forKey:@"loginPass"];
            
            NSLog(@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"loginPass"]);
            
        }
    } failure:^(NSError *error) {
        [self promptMessageWithString:@"网络连接错误"];
    }];
}
#pragma mark 更换店铺图片(ChangeImageViewDelegate)
-(void)changeImageWithIndex:(NSInteger)index
{
    [self maskDisMiss];
    if (index == 1) {
        MBProgressHUD *mbHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        mbHud.mode = MBProgressHUDModeCustomView;
        mbHud.labelText = @"店铺图片下载成功";
        mbHud.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"37x-Checkmark"]];
        [mbHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    }
    else if (index == 2)
    {
        [self promptMessageWithString:@"参数不能为空"];
    }
    else if(index == 3)
    {
        [self promptMessageWithString:@"当前社区无店铺信息"];
    }
}

#pragma mark 选择提醒时间(SecutifiCellDelegate)
-(void)selectedTixingTime
{
    [UIView animateWithDuration:0.3 animations:^{
        self.maskView.alpha = 1;
        [self.view addSubview:self.maskView];
        self.selectedTimeView.alpha = 0.95;
        [self.view addSubview:self.selectedTimeView];
    }];
}
//隐藏遮罩
-(void)maskDisMiss
{
    [UIView animateWithDuration:0.3 animations:^{
        self.maskView.alpha = 0;
        [self.maskView removeFromSuperview];
        self.passView.alpha = 0;
        [self.view endEditing:YES];
        [self.passView removeFromSuperview];
        self.passView.promptLabel.text = @"请输入手势密码";
        self.changPhoneNextPop.alpha = 0;
        [self.changPhoneNextPop removeFromSuperview];
        self.nextPayPas.alpha = 0;
        [self.nextPayPas removeFromSuperview];
        self.shenfenzhengView.alpha = 0;
        [self.shenfenzhengView removeFromSuperview];
        self.changeImage.alpha = 0;
        [self.changeImage removeFromSuperview];
        self.selectedTimeView.alpha = 0;
        [self.selectedTimeView removeFromSuperview];
    }];
}
-(void)btnAction:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end


