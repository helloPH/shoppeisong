//
//  findPasViewController.m
//  LifeForMM
//
//  Created by HUI on 15/11/5.
//  Copyright © 2015年 时元尚品. All rights reserved.
//

#import "findPasViewController.h"
#import "Header.h"
#import "ShouShiMiMaView.h"

#import "MoNiSystemAlert.h"


@interface findPasViewController ()<UIAlertViewDelegate,MBProgressHUDDelegate,UITextFieldDelegate,UIGestureRecognizerDelegate>
{
    
    NSString * newPass;
    UIView *findNumView;//找回密码方式
    UIView *mmsFindView;//短信找回
    UIView *resetPasdView;//重置密码
    NSInteger contTime;
    NSString *userTel,*userEmail,*userDevId;
    NSMutableArray *findWayNameAry;
    NSMutableArray *findWayTagAry;
    NSInteger lastChooseTag;
    UIView *findWayView;//找回方式View
    UILabel *timeLabel;
    NSInteger timeSec;//
    UIView *newPasPopView;//新密码
    UIView *codePopView;// 短信验证码
    UIView *emailSecdPopView;//邮件发送
    NSInteger lastPopTag;
    CGFloat topHeight;
    UIView *mask;//键盘遮罩
    BOOL isTan;
    BOOL isEmail;
}
@property (nonatomic,strong)ShouShiMiMaView * shoushimima;
@end

@implementation findPasViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self.navigationController.navigationBar setBarTintColor:txtColors(4, 196, 153, 1)];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
//    ShouShiMiMaView * ma = [ShouShiMiMaView new];
//
//    ma.passBlock=^(NSString * passWord){
//        
//    };
//    [ma appear];
  
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    __weak typeof (self) weakSelf = self;
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        self.navigationController.interactivePopGestureRecognizer.delegate = weakSelf;
    }
    findWayNameAry = [[NSMutableArray alloc]init];//
    findWayTagAry = [[NSMutableArray alloc]init];
    contTime = 60;
    isEmail = 0;
    timeSec = 120;
    isTan = 0;
    lastChooseTag = 0;
    lastPopTag = -1;
    [self initMask];
    [self initNavigation];//导航栏
    [self initTelView]; //电话输入框
    
}
-(void)initNavigation
{
    self.navigationItem.title = @"重置密码";
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:20],NSFontAttributeName,nil]];
    
    UIButton *leftbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftbutton.frame = CGRectMake(0, 0, NVbtnWight, NVbtnWight);
    [leftbutton setBackgroundImage:[UIImage imageNamed:@"返回按钮"] forState:UIControlStateNormal];
    [leftbutton addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftbarBtn = [[UIBarButtonItem alloc]initWithCustomView:leftbutton];
    self.navigationItem.leftBarButtonItem =leftbarBtn;
}
-(void)btnAction:(UIButton *)btn
{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}
-(void)initMask
{
    mask = [[UIView alloc]initWithFrame:self.view.bounds];
    mask.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [mask addGestureRecognizer:tap];
}
#pragma mark -- 输入框
//第一步用户账号确认
-(void)initTelView
{
    findNumView = [[UIView alloc]initWithFrame:CGRectMake(0, 124*MCscale, kDeviceWidth, 62*MCscale)];
    findNumView.userInteractionEnabled = YES;
    findNumView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:findNumView];
    UIView *telview = [[UIView alloc]initWithFrame:CGRectMake(20*MCscale, 0, 210*MCscale, 40*MCscale)];
    telview.backgroundColor = txtColors(232, 232, 232, 1);
    [findNumView addSubview:telview];
    
    UITextField *telFiled = [[UITextField alloc]initWithFrame:telview.bounds];
    telFiled.placeholder = @"请输入绑定手机号";
    telFiled.keyboardType = UIKeyboardTypeNumberPad;
    telFiled.textAlignment = NSTextAlignmentCenter;
    telFiled.textColor = [UIColor blackColor];
    telFiled.backgroundColor = [UIColor clearColor];
    telFiled.font = [UIFont systemFontOfSize:16];
    telFiled.tag = 101;
    telFiled.delegate = self;
    [telview addSubview:telFiled];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(telview.right+10, 0, 130*MCscale, 40*MCscale);
    btn.backgroundColor = txtColors(248, 53, 74, 1);
    [btn setTitle:@"验证" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:18];
    btn.layer.cornerRadius = 3.0;
    btn.layer.masksToBounds = YES;
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(telSureBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [findNumView addSubview:btn];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, telFiled.bottom+20, kDeviceWidth, 1)];
    line.backgroundColor = lineColor;
    [self.view addSubview:line];
}
-(void)initPopView
{
    [self initCodePopView];
    [self initNewPasPopView];
}
#pragma mark -- btnAction
//确定用户账户
-(void)telSureBtnAction
{
    UITextField *tel = (UITextField *)[self.view viewWithTag:101];
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
                [Request yanZhengShengFenWithDic:pram success:^(id json) {
                    NSString * message = [NSString stringWithFormat:@"%@",[json valueForKey:@"messages"]];
                    message = @"345";
                    
                    if ([message isEqualToString:@"0"]) {//
                        [MBProgressHUD promptWithString:@"验证码已发送至您的手机"];
                    }else{// 发送手机验证码
                        MoNiSystemAlert * alert = [MoNiSystemAlert new];
                        alert.content=message;
                        [alert appear];
                    }
           
                    
                } failure:^(NSError *error) {
                    MoNiSystemAlert * alert = [MoNiSystemAlert new];
                    alert.content=@"验证码获取失败";
                    [alert appear];

                }];
                
                
                userTel = [NSString stringWithFormat:@"%@",[dic valueForKey:@"tel"]];
                userEmail = [NSString stringWithFormat:@"%@",[dic valueForKey:@"email"]];
                userDevId = [NSString stringWithFormat:@"%@",[dic valueForKey:@"shebeiId"]];
                [findWayView removeFromSuperview];
                isTan = 1;
                [self initAryData];
                

            }
        } failure:^(NSError *error) {
            [MBProgressHUD stop];
            
            [self promptMessageWithString:@"网络连接错误"];
        }];
    }
}
-(void)initAryData
{
    [findWayNameAry removeAllObjects];
//    if ([userDevId isEmptyString]) {
//        [findWayNameAry addObject:@"系统找回"];
//        [findWayTagAry addObject:@"1"];
//    }
//    if (![userEmail isEmptyString]) {
//        [findWayNameAry addObject:@"邮箱找回"];
//        [findWayTagAry addObject:@"2"];
//    }
//    if(![userTel isEmptyString]){
        [findWayNameAry addObject:@"短信找回"];
        [findWayTagAry addObject:@"3"];
//    }
    [self dismPopView];
    [self initfindWayView];
    if (findWayNameAry.count == 1) {
        topHeight = 236*MCscale;
    }
    else if (findWayNameAry.count == 2){
        topHeight = 287*MCscale;
    }
    if (findWayNameAry.count == 3) {
        topHeight = 338*MCscale;
    }
    [self initPopView];
}

//找回方式
-(void)initfindWayView
{
    findWayView = [[UIView alloc]initWithFrame:CGRectMake(0, 185*MCscale, kDeviceWidth, 152*MCscale)];
    findNumView.backgroundColor = [UIColor whiteColor];
    if (findWayNameAry.count == 1) {
        findWayView.frame = CGRectMake(0, 185*MCscale, kDeviceWidth, 51*MCscale);
    }
    else if (findWayNameAry.count == 2){
        findWayView.frame = CGRectMake(0, 185*MCscale, kDeviceWidth, 102*MCscale);
    }
    else if (findWayNameAry.count == 3){
        findWayView.frame = CGRectMake(0, 185*MCscale, kDeviceWidth, 153*MCscale);
    }
    findWayView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:findWayView];
    for (int i = 0; i<findWayNameAry.count; i++) {
        UIView *chooseView = [[UIView alloc]initWithFrame:CGRectMake(0, 50*i*MCscale, kDeviceWidth, 40*MCscale)];
        chooseView.backgroundColor = [UIColor clearColor];
        chooseView.tag = [findWayTagAry[i] integerValue];
        chooseView.userInteractionEnabled = YES;
        [findWayView addSubview:chooseView];
        
        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(findWayTapAction:)];
        [chooseView addGestureRecognizer:tap];
        if (i==0) {
            UIView *topLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 1)];
            topLine.backgroundColor = lineColor;
            [chooseView addSubview:topLine];
        }
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(30*MCscale, 10*MCscale, 100*MCscale, 30*MCscale)];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentLeft;
        label.textColor = txtColors(253, 42, 59, 1);
        label.font = [UIFont systemFontOfSize:MLwordFont_2];
//        label.text = findWayNameAry[i];
        [chooseView addSubview:label];
        
        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(kDeviceWidth-45*MCscale, 15*MCscale, 22*MCscale, 22*MCscale)];
        image.image = [UIImage imageNamed:@"选择"];
        image.tag = 1102;
        image.backgroundColor = [UIColor clearColor];
        [chooseView addSubview:image];
        
        
        timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(label.right +10*MCscale, 15*MCscale, 150*MCscale, 20*MCscale)];
        timeLabel.backgroundColor = lineColor;
        timeLabel.hidden = YES;
        timeLabel.textAlignment = NSTextAlignmentCenter;
        timeLabel.textColor = txtColors(253, 42, 59, 1);
        timeLabel.font = [UIFont systemFontOfSize:MLwordFont_7];
        [chooseView addSubview:timeLabel];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(20, 49*MCscale, kDeviceWidth-40*MCscale, 1)];
        line.backgroundColor = lineColor;
        if (i<findWayNameAry.count-1) {
            [chooseView addSubview:line];
        }
        if (i == 2) {
            [self findWayTapAction:tap];
        }
    }
    UIView *lines = [[UIView alloc]initWithFrame:CGRectMake(0, findWayView.height-1, kDeviceWidth, 1)];
    lines.backgroundColor = lineColor;
    [findWayView addSubview:lines];
}
-(void)findWayTapAction:(UITapGestureRecognizer *)tap
{
    for (int i = 0; i<findWayNameAry.count; i++) {
        UIView *chooseView =[findWayView viewWithTag:[findWayTagAry[i] integerValue]];
        chooseView.userInteractionEnabled = NO;
    }
    
    NSInteger tapTag = tap.view.tag;
    if (lastChooseTag != 0) {
        UIView *lastView = [findWayView viewWithTag:lastChooseTag];
        UIImageView *lasImg = [lastView viewWithTag:1102];
        lasImg.image = [UIImage imageNamed:@"选择"];
    }
    UIView *newView = [findWayView viewWithTag:tapTag];
    UIImageView *newImg = [newView viewWithTag:1102];
    newImg.image = [UIImage imageNamed:@"选中"];
    lastChooseTag = tapTag;
    if (tapTag == 1) {
        timeSec = 120;
        timeLabel.hidden = YES;
        [self systemFindAction];
    }
    else if (tapTag == 2){
        [self sendEmailAccess];
    }
    else{
        [self timImngAction];
        [self messageFindAction];
    }
}

//定时器
-(void)timImngAction
{
    NSString *title = [NSString stringWithFormat:@"%lds后可再次发送",(long)timeSec];
    if (timeSec>=0) {
        timeSec--;
        [self performSelector:@selector(timImngAction) withObject:self afterDelay:1];
        timeLabel.hidden = NO;
        timeLabel.text = title;
    }
    else{
        timeSec = 120;
        for (int i = 0; i<findWayNameAry.count; i++) {
            UIView *chooseView =[findWayView viewWithTag:[findWayTagAry[i] integerValue]];
            chooseView.userInteractionEnabled = YES;
        }
        timeLabel.hidden = YES;
    }
}
//短信 系统找回密码 重置新密码
-(void)initNewPasPopView
{
    
    
    
    
    newPasPopView = [[UIView alloc]initWithFrame:CGRectMake(0, topHeight, kDeviceWidth, 180*MCscale)];
    newPasPopView.backgroundColor = [UIColor whiteColor];
    newPasPopView.tag = 110;
    UITextField *newPasFilde = [[UITextField alloc]initWithFrame:CGRectMake(30*MCscale, 10*MCscale, kDeviceWidth-60*MCscale, 40*MCscale)];
    newPasFilde.backgroundColor = [UIColor clearColor];
    newPasFilde.tag = 1001;
    newPasFilde.delegate = self;
    newPasFilde.placeholder = @"请输入新密码";
    [newPasFilde setSecureTextEntry:YES];
    newPasFilde.font = [UIFont systemFontOfSize:MLwordFont_2];
    newPasFilde.textAlignment = NSTextAlignmentCenter;
    [newPasPopView addSubview:newPasFilde];
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(30*MCscale, newPasFilde.bottom+5*MCscale, kDeviceWidth-60*MCscale, 1)];
    line1.backgroundColor = lineColor;
    [newPasPopView addSubview:line1];
    
    UITextField *agnNewPasFiled = [[UITextField alloc]initWithFrame:CGRectMake(30*MCscale, line1.bottom+10*MCscale, kDeviceWidth-60*MCscale, 40*MCscale)];
    agnNewPasFiled.backgroundColor = [UIColor clearColor];
    agnNewPasFiled.tag = 1002;
    agnNewPasFiled.delegate = self;
    agnNewPasFiled.placeholder = @"确认新密码";
    [agnNewPasFiled setSecureTextEntry:YES];
    agnNewPasFiled.font = [UIFont systemFontOfSize:MLwordFont_2];
    agnNewPasFiled.textAlignment = NSTextAlignmentCenter;
    [newPasPopView addSubview:agnNewPasFiled];
    
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(30*MCscale, agnNewPasFiled.bottom+5*MCscale, kDeviceWidth-60*MCscale, 1)];
    line2.backgroundColor = lineColor;
    [newPasPopView addSubview:line2];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 120*MCscale, 40*MCscale);
    btn.backgroundColor = txtColors(248, 53, 74, 1);
    [btn setTitle:@"保存" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:18];
    btn.layer.cornerRadius = 3.0;
    btn.layer.masksToBounds = YES;
    btn.center = CGPointMake(kDeviceWidth/2.0, line2.bottom+40*MCscale);
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [btn addTarget:self action:@selector(changeNewPasSure) forControlEvents:UIControlEventTouchUpInside];
    [newPasPopView addSubview:btn];
}
//短信验证码
-(void)initCodePopView
{
    codePopView = [[UIView alloc]initWithFrame:CGRectMake(0, topHeight, kDeviceWidth, 150*MCscale)];
    codePopView.backgroundColor = [UIColor whiteColor];
    codePopView.tag = 111;
    UIView *codView = [[UIView alloc]initWithFrame:CGRectMake(60*MCscale, 40*MCscale, kDeviceWidth-120*MCscale, 40*MCscale)];
    codView.backgroundColor = txtColors(232, 232, 232, 1);
    [codePopView addSubview:codView];
    UITextField *telFiled = [[UITextField alloc]initWithFrame:codView.bounds];
    telFiled.placeholder = @"请输验证码";
    telFiled.keyboardType = UIKeyboardTypeNumberPad;
    telFiled.textAlignment = NSTextAlignmentCenter;
    telFiled.textColor = [UIColor blackColor];
    telFiled.backgroundColor = [UIColor clearColor];
    telFiled.layer.shadowOffset = CGSizeMake(0, 0);
    telFiled.font = [UIFont systemFontOfSize:16];
    telFiled.tag = 101;
    telFiled.delegate = self;
    [codView addSubview:telFiled];
    
    UIButton *surBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    surBtn.frame = CGRectMake(0, 0, 120*MCscale, 40*MCscale);
    surBtn.backgroundColor = txtColors(248, 53, 74, 1);
    [surBtn setTitle:@"确定" forState:UIControlStateNormal];
    surBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    surBtn.layer.cornerRadius = 3.0;
    surBtn.layer.masksToBounds = YES;
    surBtn.center = CGPointMake(kDeviceWidth/2.0, codView.bottom+40*MCscale);
    [surBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [surBtn addTarget:self action:@selector(messageEnsure) forControlEvents:UIControlEventTouchUpInside];
    [codePopView addSubview:surBtn];
}

//发送邮件
-(void)emailSendSuccess:(NSString *)message
{
    emailSecdPopView = [[UIView alloc]initWithFrame:CGRectMake(0, topHeight, kDeviceWidth, 60*MCscale)];
    emailSecdPopView.backgroundColor = [UIColor whiteColor];
    emailSecdPopView.tag = 112;
    [self.view addSubview:emailSecdPopView];
    UILabel *labe = [[UILabel alloc]initWithFrame:CGRectMake(0, 10*MCscale, kDeviceWidth, 40)];
    labe.backgroundColor =[UIColor clearColor];
    labe.tag = 11021;
    labe.textColor = [UIColor blackColor];
    labe.textAlignment = NSTextAlignmentCenter;
    labe.font = [UIFont systemFontOfSize:MLwordFont_2];
    labe.text = message;
    [emailSecdPopView addSubview:labe];
}
#pragma mark -- 选择不同修改方式
-(void)systemFindAction
{
    [self dismPopView];
    [UIView animateWithDuration:0.3 animations:^{
        lastPopTag = 110;
        [self.view addSubview:newPasPopView];
    }];
}
-(void)messageFindAction
{
    NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"yuangong.tel":userTel}];
    [HTTPTool getWithUrl:@"backCode.action" params:pram success:^(id json) {
        NSDictionary *dic = (NSDictionary *)json;
        if ([[dic valueForKey:@"massage"]intValue]==1) {
            [self dismPopView];
            [UIView animateWithDuration:0.3 animations:^{
                lastPopTag = 111;
                [self.view addSubview:codePopView];
            }];
        }
        else{
            [self promptMessageWithString:@"验证码发送失败!请稍后重试"];
        }
    } failure:^(NSError *error) {
        [self promptMessageWithString:@"网络连接错误"];
    }];
}
#pragma mark -- 接口事件处理
//新密码 修改
-(void)changeNewPasSure:(void(^)(BOOL isSuccess))block
{
    UITextField *onePas = (UITextField *)[newPasPopView viewWithTag:1001];
    UITextField *secPas = (UITextField *)[newPasPopView viewWithTag:1002];
    if ([onePas.text isEqualToString:secPas.text]) {
        NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"yuangong.tel":userTel,@"yuangong.chushimima":newPass}];
        
        [Request findMiMaWithDic:pram Success:^(id json) {
            NSDictionary *dic = (NSDictionary *)json;
            if ([[dic valueForKey:@"massage"]intValue]==1) {
                for (int i = 0; i<findWayNameAry.count; i++) {
                    UIView *chooseView =[findWayView viewWithTag:[findWayTagAry[i] integerValue]];
                    chooseView.userInteractionEnabled = YES;
                }
                NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
                //                [def setInteger:2 forKey:@"isLogin"];
                [def setValue:onePas.text forKey:@"loginPass"];
                MBProgressHUD *mbHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                mbHud.mode = MBProgressHUDModeCustomView;
                mbHud.labelText = @"密码重置成功";
                mbHud.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"37x-Checkmark"]];
                [mbHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
                
                
                [_shoushimima disAppear];
                [self.navigationController dismissViewControllerAnimated:YES completion:^{
                }];
                
            }
            else{
                [MBProgressHUD promptWithString:@"密码重置失败!请稍后重试"];
             
            }

        } failure:^(NSError *error) {
            
        }];
  
        
//        [HTTPTool getWithUrl:@"backtelPassword.action" params:pram success:^(id json) {
//                   } failure:^(NSError *error) {
//            [self promptMessageWithString:@"网络连接错误"];
//        }];
    }
    else{
        [self promptMessageWithString:@"两次密码不一致!请重新输入"];
    }
}
-(void)sendEmailAccess
{
    MBProgressHUD *mbHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    mbHud.mode = MBProgressHUDModeIndeterminate;
    mbHud.labelText = @"正在发送邮件,请稍候...";
    mbHud.delegate = self;
    [mbHud show:YES];
    NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"tel":userTel}];
    [HTTPTool getWithUrl:@"changePwdByEmail.action" params:pram success:^(id json) {
        [self dismPopView];
        [mbHud hide:YES];
        if([[json valueForKey:@"message"] integerValue]==1){
            for (int i = 0; i<findWayNameAry.count; i++) {
                UIView *chooseView =[findWayView viewWithTag:[findWayTagAry[i] integerValue]];
                chooseView.userInteractionEnabled = YES;
            }
            [self emailSendSuccess:@"修改连接已发送到绑定邮箱!注意查收"];
        }
        else{
            [self emailSendSuccess:@"邮件发送失败!请稍后重试"];
        }
        lastPopTag = 112;
    } failure:^(NSError *error) {
        [self promptMessageWithString:@"网络连接错误"];
    }];
}
//验证码确定
-(void)messageEnsure
{
    UITextField *mes = (UITextField *)[codePopView viewWithTag:101];
    NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"yuangong.tel":userTel,@"code":mes.text}];
    
    [MBProgressHUD start];
    [HTTPTool getWithUrl:@"backlongin.action" params:pram success:^(id json) {
        [MBProgressHUD stop];
        
        NSDictionary *dic = (NSDictionary *)json;
        if([[dic valueForKey:@"massage"]intValue]==3){
            [self shurumima];
        }
        else{
            [self promptMessageWithString:@"验证码有误"];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD stop];
        [self promptMessageWithString:@"网络连接错误"];
    }];
}

-(void)shurumima{
    __block  NSString * setPassWord;
    __block NSInteger count = 0;
    
    
    if (_shoushimima) {
        [_shoushimima disAppear];
        _shoushimima = nil;
    }
    
    _shoushimima= [ShouShiMiMaView new];
    [_shoushimima setTitle:@"请输入密码"];
    [_shoushimima appear];
    __block ShouShiMiMaView * weakMima = _shoushimima;
    __block findPasViewController * weakSelf = self;
    
    _shoushimima.passBlock=^(NSString *password){
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
                newPass = setPassWord;
                [weakSelf changeNewPasSure:^(BOOL isSuccess) {
//                    [weakMima disAppear];
                }];
            }else{
                [MBProgressHUD promptWithString:@"两次输入不一致"];
                count=1;
            }
        }
    };

}

//移除上次弹框
-(void)dismPopView
{
    if (lastPopTag !=-1) {
        UIView *poView = [self.view viewWithTag:lastPopTag];
        [UIView animateWithDuration:0.3 animations:^{
            [poView removeFromSuperview];
        }];
    }
}
-(void)promptMessageWithString:(NSString *)string
{
    MBProgressHUD *mHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    mHud.labelText = string;
    mHud.mode = MBProgressHUDModeText;
    [mHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
}
- (void)myTask {
    // Do something usefull in here instead of sleeping ...
    sleep(1.5);
//    [self dismissViewControllerAnimated:YES completion:^{
//    }];
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.tag == 101) {
        isTan = 0;
    }
    else{
        isTan = 1;
    }
}
//键盘弹出
-(void)keyboardWillShow:(NSNotification *)notifaction
{
    if (isTan) {
        NSDictionary *userInfo = [notifaction userInfo];
        NSValue *userValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
        CGRect keyboardRect = [userValue CGRectValue];
        UIView *poView = [self.view viewWithTag:lastPopTag];
        CGRect fram = poView.frame;
        CGRect findVfram = findWayView.frame;
        CGRect findMunfram = findNumView.frame;
        fram.origin.y = keyboardRect.origin.y-fram.size.height;
        findVfram.origin.y = fram.origin.y-findVfram.size.height;
        findMunfram.origin.y = findVfram.origin.y - findMunfram.size.height;
        poView.frame = fram;
        findWayView.frame = findVfram;
        findNumView.frame = findMunfram;
    }
    [self.view addSubview:mask];
}
//键盘隐藏
-(void)keyboardWillHide:(NSNotification *)notifaction
{
    if (isTan) {
        UIView *poView = [self.view viewWithTag:lastPopTag];
        CGRect fram = poView.frame;
        CGRect findVfram = findWayView.frame;
        CGRect findMunfram = findNumView.frame;
        findMunfram.origin.y = 124*MCscale;
        findVfram.origin.y = 185*MCscale;
        fram.origin.y = topHeight;
        findWayView.frame = findVfram;
        findNumView.frame = findMunfram;
        poView.frame = fram;
    }
    [mask removeFromSuperview];
}
-(void)tapAction:(UITapGestureRecognizer *)tap
{
    [self.view endEditing:YES];
}

@end
