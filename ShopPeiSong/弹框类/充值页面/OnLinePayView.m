//
//  OnLinePayView.m
//  LifeForMM
//
//  Created by MIAO on 16/5/27.
//  Copyright © 2016年 时元尚品. All rights reserved.
//

#import "OnLinePayView.h"
#import "Header.h"
#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
//#import "orderPingjiaModel.h"
//#import "OrderViewController.h"
@interface OnLinePayView()<UITextFieldDelegate>
@property (nonatomic,strong)UIButton * backView;
@end
@implementation OnLinePayView
{
    NSMutableDictionary *wxPaymessage;
    NSString *leimuName;
    /**
     *  isFrom = 4;
     rechargePopView.isFromSure = 1;
     *
     *  @param instancetype <#instancetype description#>
     *
     *  @return <#return value description#>
     */
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        wxPaymessage = [[NSMutableDictionary alloc]init];
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 15.0;
        self.layer.shadowRadius = 5.0;
        self.layer.shadowOpacity = 0.5;
        self.alpha = 0.95;
        self.layer.shadowOffset = CGSizeMake(0, 0);
        [self createUI];
        //        [[NSNotificationCenter defaultCenter]removeObserver:self];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wxPayResult:) name:@"weixinzhifu" object:nil];
    }
    return self;
}
-(instancetype)init{
    if (self=[super init]) {
        wxPaymessage = [[NSMutableDictionary alloc]init];
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 15.0;
        self.layer.shadowRadius = 5.0;
        self.layer.shadowOpacity = 0.5;
        self.alpha = 0.95;
        self.layer.shadowOffset = CGSizeMake(0, 0);
        [self createUI];
        //        [[NSNotificationCenter defaultCenter]removeObserver:self];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wxPayResult:) name:@"weixinzhifu" object:nil];
    }
    return self;
}

-(void)createUI
{
    //上方视图
    self.moneyView = [[UIView alloc]initWithFrame:CGRectZero];
    [self addSubview:self.moneyView];
    
    self.titleName = [[UILabel alloc]initWithFrame:CGRectZero];
    self.titleName.textColor = redTextColor;
    self.titleName.textAlignment =  NSTextAlignmentCenter;
    self.titleName.font = [UIFont systemFontOfSize:MLwordFont_2];
    [self.moneyView addSubview:self.titleName];
    
    self.promptInformationLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    self.promptInformationLabel.textColor = lineColor;
    self.promptInformationLabel.text = @"绑定验证金额将充值到账户余额";
    self.promptInformationLabel.textAlignment =  NSTextAlignmentCenter;
    self.promptInformationLabel.font = [UIFont systemFontOfSize:MLwordFont_5];
    [self.moneyView addSubview:self.promptInformationLabel];
    
    //充值金额
    self.moneyTextFiled = [[UITextField alloc]initWithFrame:CGRectZero];
    self.moneyTextFiled.backgroundColor = txtColors(241, 241, 241, 1);
    self.moneyTextFiled.textColor = redTextColor;
    self.moneyTextFiled.delegate = self;
    self.moneyTextFiled.font = [UIFont systemFontOfSize:MLwordFont_1];
    self.moneyTextFiled.textAlignment = NSTextAlignmentCenter;
    self.moneyTextFiled.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    self.moneyTextFiled.userInteractionEnabled=NO;
    [self.moneyView addSubview:self.moneyTextFiled];
    
    self.line1 = [[UIView alloc]initWithFrame:CGRectZero];
    self.line1.backgroundColor = lineColor;
    [self addSubview:self.line1];
    
    //支付宝
    self.alipayImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
    self.alipayImageView.userInteractionEnabled = YES;
    self.alipayImageView.image = [UIImage imageNamed:@"支付宝"];
    UITapGestureRecognizer *alipayTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
    alipayTap.view.tag = 2000;
    [self.alipayImageView addGestureRecognizer:alipayTap];
    [self addSubview:self.alipayImageView];
    
    self.line2 = [[UIView alloc]initWithFrame:CGRectZero];
    self.line2.backgroundColor = lineColor;
    [self addSubview:self.line2];
    
    //微信
    self.wChatImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
    self.wChatImageView.userInteractionEnabled = YES;
    self.wChatImageView.image = [UIImage imageNamed:@"微支付"];
    UITapGestureRecognizer *wChatTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
    wChatTap.view.tag = 2001;
    [self.wChatImageView addGestureRecognizer:wChatTap];
    [self addSubview:self.wChatImageView];
    
    self.line3 = [[UIView alloc]initWithFrame:CGRectZero];
    self.line3.backgroundColor = lineColor;
    [self addSubview:self.line3];
    
    //下方视图
    self.moreView = [[UIView alloc]initWithFrame:CGRectZero];
    UITapGestureRecognizer *moreViewTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
    moreViewTap.view.tag = 2002;
    [self.moreView addGestureRecognizer:moreViewTap];
    [self addSubview:self.moreView];
    
    self.yueZhifu = [[UILabel alloc]initWithFrame:CGRectZero];
    self.yueZhifu.textColor = txtColors(25,182,132,1);
    self.yueZhifu.textAlignment =  NSTextAlignmentCenter;
    self.yueZhifu.font = [UIFont boldSystemFontOfSize:MLwordFont_1];
    self.yueZhifu.text = @"账号余额";
    [self.moreView addSubview:self.yueZhifu];
}

#pragma mark  评价
-(void)reloadDataFromDanhao:(NSString *)danhao AndMoney:(NSString *)money AndBody:(NSString *)body AndLeiming:(NSString *)leimu
{
    self.danhao = danhao;
    self.payMoney = money;
    self.body = body;
    self.titleName.text = [NSString stringWithFormat:@"%@管家%@元",leimu,self.payMoney];
    leimuName = leimu;
}
#pragma mark  验证
-(void)reloadDataForVerification
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyMMddHHmmss"];
    NSString *dateTime = [formatter stringFromDate:[NSDate date]];
    self.danhao = [NSString stringWithFormat:@"%@",dateTime];
    self.payMoney = self.moneyTextFiled.text;
    NSString *suffix;
    if (self.isFrom == 2) {
        suffix = @"充值";
    }
    else if (self.isFrom == 3)
    {
        suffix = @"验证";
    }
    else if (self.isFrom == 4)
    {
        suffix = @"商户开户";
    }
    self.body = [NSString stringWithFormat:@"妙店佳+%@%@",user_tel,suffix];
}

-(void)tapClick:(UITapGestureRecognizer *)tap
{
    if (tap.self.view == self.alipayImageView ) {
        if (self.isFrom == 2 || self.isFrom == 4) {
            [self reloadDataForVerification];
            if (self.isFromSure == 1) {
                float inputNum = [self.moneyTextFiled.text floatValue];
                if (inputNum < [self.shouldMoney floatValue]) {
                    [self promptMessageWithString:@"输入金额不足!请重新输入"];
                }
                else{
                    self.payMoney = self.moneyTextFiled.text;
                    [self AlipayPay];
                }
            }
            else
            {
                if (self.payMoney.doubleValue >=50) {
                    [self AlipayPay];
                }
                else
                {
                    [self promptMessageWithString:@"输入金额不能低于50"];
                }
            }
        }
        else if (self.isFrom == 3)
        {
            [self reloadDataForVerification];
            if (self.payMoney.doubleValue ==0){
                [self promptMessageWithString:@"请输入金额"];
            }
            else
            {
                [self AlipayPay];
            }
        }
        else
        {
            [self AlipayPay];
            NSNotification *wchatPayClick = [NSNotification notificationWithName:@"wchatPayClick" object:nil];
            [[NSNotificationCenter defaultCenter] postNotification:wchatPayClick];
            [[NSNotificationCenter defaultCenter]removeObserver:self name:@"wchatPayClick" object:nil];
        }
    }
    else if (tap.self.view == self.wChatImageView)
    {
        [self promptMessageWithString:@"该功能正在努力开发中"];
        return;
        /*
        if (self.isFrom == 2 || self.isFrom == 4) {
            [self reloadDataForVerification];
            if (self.isFromSure == 1) {
                float inputNum = [self.moneyTextFiled.text floatValue];
                if (inputNum < [self.shouldMoney floatValue]) {
                    [self promptMessageWithString:@"输入金额不足!请重新输入"];
                }
                else{
                    self.payMoney = self.moneyTextFiled.text;
                    [self wxPay];
                }
            }
            else
            {
                if (self.payMoney.doubleValue >=50) {
                    [self wxPay];
                    
                }else
                {
                    [self promptMessageWithString:@"输入金额不能低于50"];
                }
            }
        }
        else if (self.isFrom == 3)
        {
            [self reloadDataForVerification];
            if (self.payMoney.doubleValue ==0)
            {
                [self promptMessageWithString:@"请输入金额"];
            }else
            {
                [self wxPay];
            }
        }
        else
        {
            [self wxPay];
            NSNotification *wchatPayClick = [NSNotification notificationWithName:@"wchatPayClick" object:nil];
            [[NSNotificationCenter defaultCenter] postNotification:wchatPayClick];
            [[NSNotificationCenter defaultCenter]removeObserver:self name:@"wchatPayClick" object:nil];
        }
        */
    }
    else
    {
        if ([self.onLinePayDelegate respondsToSelector:@selector(PaymentPasswordViewWithDanhao:AndLeimu:AndMoney:)]) {
            [self.onLinePayDelegate  PaymentPasswordViewWithDanhao:self.danhao AndLeimu:leimuName AndMoney:self.payMoney];
        }
    }
    NSNotification *onLinePayViewHidden = [NSNotification notificationWithName:@"onLinePayViewHidden" object:nil];
    [[NSNotificationCenter defaultCenter] postNotification:onLinePayViewHidden];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"onLinePayViewHidden" object:nil];
}
//支付宝
-(void)AlipayPay
{
    NSMutableDictionary *privateDic = [[NSMutableDictionary alloc]init];
    [Request getZhiFuBaoInfoSuccess:^(id json) {
        if(json){
            [privateDic setValue:[json valueForKey:@"out_trade_no"] forKey:@"out_trade_no"];//单号
            [privateDic setValue:[json valueForKey:@"partner"] forKey:@"partner"];//appid
            [privateDic setValue:[json valueForKey:@"private_key"] forKey:@"private_key"];//私钥
            [privateDic setValue:[json valueForKey:@"seller_id"] forKey:@"seller_id"];//支付宝单号
            [self payMoney:privateDic];
        }
        else{
            [self promptMessageWithString:@"获取支付信息失败!请稍后尝试"];
        }

    } failure:^(NSError *error) {
        
    }];
}
#pragma  mark -- 支付宝跳转支付
-(void)payMoney:(NSMutableDictionary *)dic
{
    NSString *partner = [dic valueForKey:@"partner"];
    NSString *seller = [dic valueForKey:@"seller_id"];
    NSString *privateKey =[dic valueForKey:@"private_key"];
    NSString *body;
//    NSUserDefaults *sdf = [NSUserDefaults standardUserDefaults];
//    if ([sdf integerForKey:@"isLogin"]==1)
//    {
//        body = [NSString stringWithFormat:@"%@",user_id];
//    }
//    else{
//        body = [NSString stringWithFormat:@"%@",userSheBei_id];
//    }
    body = @"0";
    
    Order *order = [[Order alloc]init];
    order.partner = partner;
    order.seller = seller;
    order.tradeNO = self.danhao; //订单ID(由商家□自□行制定)
    
    order.productName = self.body; //商品标题
    order.productDescription = body; //商品描述
    order.amount = [NSString stringWithFormat:@"%@",self.payMoney]; //商 品价格
    order.notifyURL = [NSString stringWithFormat:@"%@notify_url.jsp",HTTPHEADER]; //回调URL
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    
    NSString *orderSpec = [order description];
    NSString *appScheme = @"aliMiaoShangpu";
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",orderSpec, signedString, @"RSA"];
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSString *payState = [resultDic valueForKey:@"resultStatus"];
            if ([payState isEqualToString:@"9000"]) {
                if (_payBlock) {
                    _payBlock(YES);
                }
            }
            else{
                if (_payBlock) {
                    _payBlock(NO);
                }
            }
        }];
    }
}

//微信
-(void)wxPay
{
    if (wxPaymessage.count == 0) {
        NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"total_fee":self.payMoney,@"shequid":@"8",@"body":self.body,@"userid":user_id?user_id:@"0"}];
        
 
        [HTTPTool postWithBaseUrl:@"http://www.shp360.com/MshcShop/" url:@"weixingfangwen.action" params:pram success:^(id json) {
            NSLog(@"%@",json);
            [wxPaymessage setValue:[json valueForKey:@"dingdanhao"] forKey:@"dingdanhao"];
            [wxPaymessage setValue:[json valueForKey:@"noncestr"] forKey:@"noncestr"];
            [wxPaymessage setValue:[json valueForKey:@"package"] forKey:@"package"];
            [wxPaymessage setValue:[json valueForKey:@"partnerid"] forKey:@"partnerid"];
            [wxPaymessage setValue:[json valueForKey:@"prepayid"] forKey:@"prepayid"];
            [wxPaymessage setValue:[json valueForKey:@"sign"] forKey:@"sign"];
            [wxPaymessage setValue:[json valueForKey:@"timestamp"] forKey:@"timestamp"];
            [self wzf:wxPaymessage];
            NSLog(@"wxPaymessage的顶顶顶顶顶大 === %@",wxPaymessage);
        } failure:^(NSError *error) {
            [self promptMessageWithString:@"网络连接错误"];
        }];
    }
    else
        [self wzf:wxPaymessage];
}
-(void)wzf:(NSDictionary *)dic
{
    //============================================================
    // V3&V4支付流程实现
    // 注意:参数配置请查看服务器端Demo
    // 更新时间：2015年11月20日
    //============================================================
    if(dic != nil){
        NSMutableString *retcode = [dic objectForKey:@"retcode"];
        if (retcode.intValue == 0){
            NSMutableString *stamp  = [dic objectForKey:@"timestamp"];
            //调起微信支付
            PayReq* req             = [[PayReq alloc] init];
            req.partnerId           = [dic objectForKey:@"partnerid"];
            req.prepayId            = [dic objectForKey:@"prepayid"];
            req.nonceStr            = [dic objectForKey:@"noncestr"];
            req.timeStamp           = stamp.intValue;
            req.package             = [dic objectForKey:@"package"];
            req.sign                = [dic objectForKey:@"sign"];
            BOOL  fag = [WXApi sendReq:req];
            NSLog(@"%@",fag?@"YES":@"NO");
        }else{
            NSLog(@"retmsg%@",[dic objectForKey:@"retmsg"]);
        }
    }
}
-(void)wxPayResult:(NSNotification *)notifaction
{
    if (wxPaymessage) {
        PayResp *resp = notifaction.object;
        NSLog(@"resp.errCode===%d",resp.errCode);
        
        if (resp.errCode == WXSuccess) {
            //支付成功
            if (self.isFrom == 4)
            {
                NSNotification *RechargSuccess = [NSNotification notificationWithName:@"RechargSuccess" object:nil];
                [[NSNotificationCenter defaultCenter] postNotification:RechargSuccess];
                [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RechargSuccess" object:nil];
            }
            else
            {
                NSNotification *PaymentSuccess = [NSNotification notificationWithName:@"PaymentSuccess" object:nil];
                [[NSNotificationCenter defaultCenter] postNotification:PaymentSuccess];
                [[NSNotificationCenter defaultCenter] removeObserver:self name:@"PaymentSuccess" object:nil];
            }
        }
        else{
            NSNotification *PaymentFailure = [NSNotification notificationWithName:@"PaymentFailure" object:nil];
            [[NSNotificationCenter defaultCenter] postNotification:PaymentFailure];
            
            [[NSNotificationCenter defaultCenter] removeObserver:self name:@"PaymentFailure" object:nil];
        }
        [wxPaymessage removeAllObjects];
    }
    [wxPaymessage removeAllObjects];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    if (self.isFrom == 1) {//支付
        self.alipayImageView.frame = CGRectMake(0, 0, 179*MCscale, 50*MCscale);
        self.alipayImageView.center = CGPointMake(self.width/2,40*MCscale);
        self.line2.frame = CGRectMake(5*MCscale, self.alipayImageView.bottom + 5*MCscale, self.width - 10*MCscale, 1);
        self.wChatImageView.frame = CGRectMake(0, 0, 179*MCscale, 50*MCscale);
        self.wChatImageView.center = CGPointMake(self.width/2, self.line2.bottom + 30*MCscale);
    }
    else if (self.isFrom == 2 || self.isFrom == 4)//充值
    {
        self.moneyView.frame = CGRectMake(0, 0, self.width, 60*MCscale);
        self.moneyTextFiled.frame = CGRectMake(0, 0, 100*MCscale, 35*MCscale);
        self.moneyTextFiled.center = CGPointMake(self.width/2,30*MCscale);
        self.line1.frame = CGRectMake(0, self.moneyView.bottom +1 , self.width, 1);
        self.alipayImageView.frame = CGRectMake(0, 0, 179*MCscale, 50*MCscale);
        self.alipayImageView.center = CGPointMake(self.width/2, self.line1.bottom + 30*MCscale);
        self.line2.frame = CGRectMake(5*MCscale, self.alipayImageView.bottom + 5*MCscale, self.width - 10*MCscale, 1);
        self.wChatImageView.frame = CGRectMake(0, 0, 179*MCscale, 50*MCscale);
        self.wChatImageView.center = CGPointMake(self.width/2, self.line2.bottom + 30*MCscale);
        self.line3.frame = CGRectMake(5*MCscale, self.wChatImageView.bottom + 5*MCscale, self.width - 10*MCscale, 1);
        self.moreView.frame = CGRectMake(0, self.line3.bottom + 5*MCscale, self.width, self.height- 200*MCscale);
        self.yueZhifu.font = [UIFont systemFontOfSize:MLwordFont_4];
        self.yueZhifu.frame = CGRectMake(0, 0, self.width, 40*MCscale);
    }
    else if (self.isFrom == 3)//验证
    {
        self.moneyView.frame = CGRectMake(0, 0, self.width, 60*MCscale);
        self.promptInformationLabel.frame = CGRectMake(0, 0, self.width - 60*MCscale, 15);
        self.promptInformationLabel.center = CGPointMake(self.width/2, 18*MCscale);
        self.moneyTextFiled.frame = CGRectMake(0, 0, self.width-90*MCscale, 30*MCscale);
        self.moneyTextFiled.center = CGPointMake(self.width/2,40*MCscale);
        self.line1.frame = CGRectMake(0, self.moneyView.bottom +1 , self.width, 1);
        self.alipayImageView.frame = CGRectMake(0, 0, 179*MCscale, 50*MCscale);
        self.alipayImageView.center = CGPointMake(self.width/2, self.line1.bottom + 30*MCscale);
        self.line2.frame = CGRectMake(5*MCscale, self.alipayImageView.bottom + 5*MCscale, self.width - 10*MCscale, 1);
        self.wChatImageView.frame = CGRectMake(0, 0, 179*MCscale, 50*MCscale);
        self.wChatImageView.center = CGPointMake(self.width/2, self.line2.bottom + 30*MCscale);
        self.line3.frame = CGRectMake(5*MCscale, self.wChatImageView.bottom + 5*MCscale, self.width - 10*MCscale, 1);
        self.moreView.frame = CGRectMake(0, self.line3.bottom + 5*MCscale, self.width, self.height- 200*MCscale);
        self.yueZhifu.frame = CGRectMake(0, 0, self.width, 40*MCscale);
    }
    else{//评价
        self.moneyView.frame = CGRectMake(0, 0, self.width, 60*MCscale);
        self.titleName.frame = CGRectMake(0, 0, self.width, 30*MCscale);
        self.titleName.center = self.moneyView.center;
        self.line1.frame = CGRectMake(0, self.moneyView.bottom +1 , self.width, 1);
        self.alipayImageView.frame = CGRectMake(0, 0, 179*MCscale, 50*MCscale);
        self.alipayImageView.center = CGPointMake(self.width/2, self.line1.bottom + 30*MCscale);
        self.line2.frame = CGRectMake(5*MCscale, self.alipayImageView.bottom + 5*MCscale, self.width - 10*MCscale, 1);
        self.wChatImageView.frame = CGRectMake(0, 0, 179*MCscale, 50*MCscale);
        self.wChatImageView.center = CGPointMake(self.width/2, self.line2.bottom + 30*MCscale);
        self.line3.frame = CGRectMake(5*MCscale, self.wChatImageView.bottom + 5*MCscale, self.width - 10*MCscale, 1);
        self.moreView.frame = CGRectMake(0, self.line3.bottom + 5*MCscale, self.width, self.height- 200*MCscale);
        self.yueZhifu.frame = CGRectMake(0, 0, self.width, 40*MCscale);
        self.moneyTextFiled.frame=self.titleName.frame;
        self.moneyTextFiled.text=self.payMoney;
    }
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
#pragma mark UITextfiledDelegate

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    textField.placeholder = @"";
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.moneyTextFiled resignFirstResponder];
}


#pragma mark -- 后天改进
-(void)setMoney:(NSString *)money{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyMMddHHmmss"];
    NSString *dateTime = [formatter stringFromDate:[NSDate date]];
    int x = arc4random() % 15;
    
    NSString * dan = [NSString stringWithFormat:@"%@%d",dateTime,x];
  
//    self.moneyTextFiled.frame=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width*2/3.0, 20);
//    self.centerX=self.width/2;
//    self.moneyTextFiled.backgroundColor=[UIColor redColor];
//    

    
    
    
    self.danhao = dan;
    self.payMoney = money;
    self.body = @"1";
    self.titleName.text = [NSString stringWithFormat:@"请支付%@元",self.payMoney];
}
-(void)appear{
    _backView = [[UIButton alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [[UIApplication sharedApplication].delegate.window addSubview:_backView];
    [_backView addTarget:self action:@selector(disAppear) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.frame=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width*2/3.0, [UIScreen mainScreen].bounds.size.width*2/3.0);
    [_backView addSubview:self];
    _backView.alpha=0;
    self.center=CGPointMake(_backView.width/2, _backView.height/2);
    [UIView animateWithDuration:0.3 animations:^{
        _backView.alpha=1;
    }];
    
    
}
-(void)disAppear{
    if (_backView) {
        
        [UIView animateWithDuration:0.3 animations:^{
            _backView.alpha=0;
        }completion:^(BOOL finished) {
            [_backView removeFromSuperview];
            _backView= nil;
        }];
    }

    
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSString * endString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSLog(@"%.2f",[endString floatValue]);
    self.payMoney=endString;
 
//    NSLog(@"%@",endString);
    
   
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    
    
}
@end
