//
//  TopUpView.m
//  ShopPeiSong
//
//  Created by MIAO on 2017/5/22.
//  Copyright © 2017年 妙灵科技. All rights reserved.
//

#import "TopUpView.h"
#import "Header.h"
#import "Order.h"
#import <AlipaySDK/AlipaySDK.h>
#import "DataSigner.h"

@interface TopUpView()<UITextFieldDelegate>
@property (nonatomic,strong)UIButton * backView;

@property (nonatomic,strong)UITextField * inputField;
@property (nonatomic,strong)NSString * title;
@property (nonatomic,strong)NSString * body;
@property (nonatomic,assign)float limitMoney;
@end
@implementation TopUpView
-(instancetype)init{
    if (self=[super init]) {
        [self newView];
    }
    return self;
}
-(void)newView{
    _backView = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    [_backView addTarget:self action:@selector(disAppear) forControlEvents:UIControlEventTouchUpInside];
    CGFloat setY = 10*MCscale;
    
    
    self.frame=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width*0.8, 100);
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 15.0;
    self.layer.shadowRadius = 5.0;
    self.layer.shadowOpacity = 0.5;
    self.alpha = 0.95;
    self.layer.shadowOffset = CGSizeMake(0, 0);
    UITextField * inputField = [[UITextField alloc]initWithFrame:CGRectMake(0, setY, 100*MCscale, 30*MCscale)];
    inputField.backgroundColor=lineColor;
    inputField.textColor=redTextColor;
    inputField.centerX=self.width/2;
    inputField.textAlignment=NSTextAlignmentCenter;
    inputField.text=@"50";
    inputField.keyboardType=UIKeyboardTypeNumbersAndPunctuation;
    setY=inputField.bottom;
    
    [self addSubview:inputField];
    inputField.delegate=self;
    _inputField=inputField;
    
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, setY+10*MCscale, self.width, 1)];
    line.centerX=self.width/2;
    line.backgroundColor=lineColor;
    
    setY=line.bottom;
    [self addSubview:line];

    for (int i = 0; i < 3; i ++) {
        UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(0, setY+10*MCscale, self.width, 30*MCscale)];
        [self addSubview:btn];
        
        setY=btn.bottom;
        btn.contentMode=UIViewContentModeScaleAspectFit;
        btn.imageView.contentMode=UIViewContentModeScaleAspectFit;
        
        UIView * line1 = [[UIView alloc]initWithFrame:CGRectMake(10*MCscale, setY+10*MCscale, self.width-20*MCscale, 1)];
        line1.backgroundColor=lineColor;
        
        
        switch (i) {
            case 0:
            {

                [btn setImage:[UIImage imageNamed:@"支付宝"] forState:UIControlStateNormal];
                [self addSubview:line1];
                setY = line1.bottom;
                [btn addTarget:self action:@selector(alipay) forControlEvents:UIControlEventTouchUpInside];
                
            }
                break;
            case 1:
            {
                [btn setImage:[UIImage imageNamed:@"微支付"] forState:UIControlStateNormal];
                [self addSubview:line1];
                setY = line1.bottom;
                [btn addTarget:self action:@selector(wechatPay) forControlEvents:UIControlEventTouchUpInside];
                
            }
                break;
            case 2:
            {
                [btn setTitle:@"更多充值方式" forState:UIControlStateNormal];
                btn.titleLabel.font=[UIFont systemFontOfSize:MLwordFont_5];
                [btn setTitleColor:mainColor forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(morePay) forControlEvents:UIControlEventTouchUpInside];
            }
                break;
            default:
                break;
        }
        
        
    
        
    }
    
    self.height=setY+10*MCscale;
    self.centerY=[UIScreen mainScreen].bounds.size.height/2;
}

-(void)setMoney:(float )money limitMoney:(float)limitMoney title:(NSString *)title body:(NSString *)body canChange:(BOOL)canChange{
    
    _inputField.userInteractionEnabled=canChange;
    _inputField.text = [NSString stringWithFormat:@"%.2f",money];
    _limitMoney=limitMoney;
    _body=body;
    _title=title;
}
-(void)appear{
    [[UIApplication sharedApplication].delegate.window addSubview:_backView];
    [_backView addSubview:self];
    self.center=CGPointMake(_backView.width/2, _backView.height/2);
    _backView.alpha=0;
    [UIView animateWithDuration:0.3 animations:^{
        _backView.alpha=1;
    }];
    
    
}
-(void)disAppear{
    [UIView animateWithDuration:0.3 animations:^{
        _backView.alpha=0;
    }completion:^(BOOL finished) {
        [_backView removeFromSuperview];
        [self removeFromSuperview];
    }];
    
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString * currentString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (![currentString isValidateMoneying]) {
        [MBProgressHUD promptWithString:@"请输入正确的金额"];
        return NO;
    }
    
    
    return YES;
}
#pragma mark -- btnClick
//-(void)alipay{
//    [MBProgressHUD promptWithString:@"正在开发中"];
//}
//支付宝
-(void)alipay
{
    if (![_inputField.text isValidateMoneyed] || [_inputField.text isEmptyString]) {
        [MBProgressHUD promptWithString:@"请输入正确的金额"];
        return;
    };
    if ([_inputField.text floatValue]<_limitMoney) {
        [MBProgressHUD promptWithString:[NSString stringWithFormat:@"最少输入%.2f元!",_limitMoney]];
        return;
    }
    
    
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
            [MBProgressHUD promptWithString:@"获取支付信息失败!请稍后尝试"];
//            [self promptMessageWithString:@"获取支付信息失败!请稍后尝试"];
        }
        
    } failure:^(NSError *error) {
        
    }];
}
#pragma  mark -- 支付宝跳转支付
-(void)payMoney:(NSMutableDictionary *)dic
{
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyMMddHHmmss"];
    NSString *dateTime = [formatter stringFromDate:[NSDate date]];
    int x = arc4random() % 15;
    
    NSString * dan = [NSString stringWithFormat:@"%@%d",dateTime,x];
    
    
    NSString *partner = [dic valueForKey:@"partner"];
    NSString *seller = [dic valueForKey:@"seller_id"];
    NSString *privateKey =[dic valueForKey:@"private_key"];
    NSString *body=_body;

    
//    if (user_Id)
//    {
//        body = [NSString stringWithFormat:@"%@",user_Id];
//    }
//    else{
    
//        body = [NSString stringWithFormat:@"妙店佳商铺端+%@备用金充值",user_tel];
//    }
    
    Order *order = [[Order alloc]init];
    order.partner = partner;
    order.seller = seller;
    order.tradeNO = dan; //订单ID(由商家□自□行制定)
    
    order.productName = _title; //商品标题
    order.productDescription = body; //商品描述
    order.amount = [NSString stringWithFormat:@"%@",self.inputField.text]; //商 品价格
    order.notifyURL = [NSString stringWithFormat:@"%@zhifu.action",HTTPHEADER]; //回调URL
    order.notifyURL = @"http://www.shp360.com/MshcShop/notify_url.jsp";
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
-(void)wechatPay{
    [MBProgressHUD promptWithString:@"正在开发中"];
}
-(void)morePay{
    [MBProgressHUD promptWithString:@"正在开发中"];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
