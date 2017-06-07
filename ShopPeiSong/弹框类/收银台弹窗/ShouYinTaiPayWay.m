//
//  SelectPayWay.m
//  ShopPeiSong
//
//  Created by MIAO on 2017/5/3.
//  Copyright © 2017年 妙灵科技. All rights reserved.
//

#import "ShouYinTaiPayWay.h"
#import "LoginPasswordView.h"

@interface ShouYinTaiPayWay()<UITextFieldDelegate>
@property (nonatomic,strong)NSDictionary * dataDic;

@property (nonatomic,assign)NSInteger whatForPay;

@property (nonatomic,strong)UIButton * backView;

@property (nonatomic,assign)NSInteger btnIndex;
@end

@implementation ShouYinTaiPayWay
-(instancetype)init{
    if (self=[super init]) {
        self.frame=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width-80*MCscale, 100);
        [self initData];
        [self newView];

    }
    return self;
}

-(void)initData{
    _dataDic = [NSDictionary dictionary];
    _whatForPay=0;
}
-(void)reshData{
    NSDictionary * pram = @{@"danhao":_danhao};
    
    [Request getShouYinTaiTanChuangInfoWithDic:pram success:^(id json) {
        NSString * message = [NSString stringWithFormat:@"%@",[json valueForKey:@"message"]];
        if ([message isEqualToString:@"1"]) {
            _dataDic = (NSDictionary *)json;
            NSLog(@"订单信息:---%@",_dataDic);

            [self reshView];
        }else{
            [MBProgressHUD promptWithString:@"无可显示信息"];
        }
    } failure:^(NSError *error) {
    }];
    
}
-(void)reshView{
    /**
     *  收款金额 输入框的赋值
     */
    UITextField * inputField = [self viewWithTag:110];// 顶部显示金额输入框
    
    NSString * shishou = [NSString stringWithFormat:@"%@",_dataDic[@"shishou"]];
    inputField.text = shishou;
    
    NSString * change = [NSString stringWithFormat:@"%@",_dataDic[@"change"]];
    inputField.userInteractionEnabled = [change isEqualToString:@"1"];
    inputField.enabled = [change isEqualToString:@"1"];

    UIButton * xiaofeiBtn = [self viewWithTag:30];// 消费中按钮
    NSString * xiaofeizhong = [NSString stringWithFormat:@"%@",_dataDic[@"xiaofeizhong"]];
    xiaofeiBtn.userInteractionEnabled=[xiaofeizhong isEqualToString:@"0"];
    xiaofeiBtn.selected=[xiaofeizhong isEqualToString:@"1"];

    /**
     *  取消订单的赋值
     */
    // 是否正在消费中
    UIButton * cancelBtn = [self viewWithTag:31];// 取消订单按钮
    
    
    /**
     *  付款方式的赋值
     */
    
    UIButton * payBtn = [self viewWithTag:100];// 收款方式按钮
    
    NSString * zhifuF = [NSString stringWithFormat:@"%@",_dataDic[@"zhifufangshi"]];
    NSString * payTitle;
    
    if([zhifuF isEqualToString:@"0"]){//未支付
        [payBtn.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        payTitle = @"";
//        payBtn.userInteractionEnabled=NO;
        // // 显示全部的付款方式
        
        CGFloat zeroY = 0;
        NSArray * title = @[@"   现金收款",@"       妙支付",@"   微信收款",@"支付宝收款"];
        for (int i = 0; i < title.count; i ++) {
            CGFloat zeroW = payBtn.width;
            CGFloat zeroH = payBtn.height;
            CGFloat zeroX = 0 ;

            UIButton * zeroBtn = [[UIButton alloc]initWithFrame:CGRectMake(zeroX, zeroY, zeroW, zeroH)];
            [payBtn addSubview:zeroBtn];
            [zeroBtn setImage:[UIImage imageNamed:@"选择"] forState:UIControlStateNormal];
            [zeroBtn setImage:[UIImage imageNamed:@"选中"] forState:UIControlStateSelected];
            [zeroBtn setTitle:title[i] forState:UIControlStateNormal];
            [zeroBtn setTitleColor:textBlackColor forState:UIControlStateNormal];
            zeroBtn.titleLabel.font=[UIFont systemFontOfSize:MLwordFont_4];
            zeroY=zeroBtn.bottom+20*MCscale;
            zeroBtn.tag=300+i;
            zeroBtn.imageView.contentMode=UIViewContentModeScaleAspectFit;
            [zeroBtn addTarget:self action:@selector(payByZeroPayBtn:) forControlEvents:UIControlEventTouchUpInside];
            
            UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, zeroBtn.bottom+10*MCscale, zeroBtn.width, 1)];
            line.backgroundColor=lineColor;
            [payBtn addSubview:line];
            
        }
        payBtn.height=zeroY;
    }

    if ([zhifuF isEqualToString:@"1"]) {//货到付款
        payTitle = @"    货到付款";
    }
    
    if([zhifuF isEqualToString:@"7"]){//现金收款
        payTitle = @"    现金收款";
    }
    if([zhifuF isEqualToString:@"3"]){//妙支付
        payTitle = @"    妙支付收款";
    }
    if([zhifuF isEqualToString:@"4"]){//微信支付
        payTitle = @"    微信收款";
    }
    if([zhifuF isEqualToString:@"5"]){//支付宝支付
        payTitle = @"    支付宝收款";
    }
    
    
    [payBtn setTitle:payTitle forState:UIControlStateNormal];
    self.height=payBtn.bottom+20*MCscale;
    self.center=CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2);
    
}
-(void)newView{
    _backView = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    [_backView addTarget:self action:@selector(disAppear) forControlEvents:UIControlEventTouchUpInside];
    _backView.alpha=0;
    [[UIApplication sharedApplication].delegate.window addSubview:_backView];
    
    [_backView addSubview:self];
    self.backgroundColor=[UIColor whiteColor];
    self.frame=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width-80, 100);
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 15.0;
    self.layer.shadowOpacity = 0.5;
    self.layer.shadowOffset = CGSizeMake(0, 0);
    CGFloat setY = 20*MCscale;
    self.center=CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2);
    

    NSArray * titleArr = @[@"实收:12.00",@"",@""];
    for (int i = 0; i < titleArr.count; i ++) {
        CGFloat btnX =  20*MCscale;
        CGFloat btnY =  setY;
        CGFloat btnW =  self.width-40*MCscale;
        CGFloat btnH =  40*MCscale;
        
        UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(btnX, btnY, btnW, btnH)];
        [btn setTitle:titleArr[i] forState:UIControlStateNormal];
        [self addSubview:btn];
  
        
        if (i == 0) {
            UITextField * inputText = [[UITextField alloc]initWithFrame:btn.frame];
            inputText.backgroundColor=lineColor;
            inputText.font=[UIFont systemFontOfSize:MLwordFont_4];
            [btn removeFromSuperview];
            [self addSubview:inputText];
            setY = inputText.bottom+10*MCscale;
            inputText.tag=110;
            inputText.textAlignment=NSTextAlignmentCenter;
            inputText.delegate=self;
            inputText.keyboardType=UIKeyboardTypeNumbersAndPunctuation;
        }else if (i == 1){
            btn.height=60*MCscale;
            setY=btn.bottom;
            
            for (int j = 0; j < 2; j ++) {
                
                
                UIButton *selBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 120, 20)];
                [btn addSubview:selBtn];
                selBtn.tag=30+j;
                [selBtn setImage:[UIImage imageNamed:@"选择"] forState:UIControlStateNormal];
                [selBtn setImage:[UIImage imageNamed:@"选中"] forState:UIControlStateSelected];
                [selBtn setTitleColor:textBlackColor forState:UIControlStateNormal];
                selBtn.imageView.contentMode=UIViewContentModeScaleAspectFit;
                if (j == 0) {
                    [selBtn setTitle:@"消费中" forState:UIControlStateNormal];
                    [selBtn addTarget:self action:@selector(leftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                }else{
                    [selBtn setTitle:@"取消订单" forState:UIControlStateNormal];
                    selBtn.right = btn.width;
                    [selBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                }
                selBtn.centerY=btn.height/2;
            }
            
            
            UIImageView * line = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, btn.width, 1)];
            line.backgroundColor=lineColor;
            line.bottom=btn.height;
            [btn addSubview:line];
        }else{
            [btn setImage:[UIImage imageNamed:@"选择"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"选中"] forState:UIControlStateSelected];
            btn.imageView.contentMode=UIViewContentModeScaleAspectFit;
            btn.height=20*MCscale;
            [btn setTitleColor:textBlackColor forState:UIControlStateNormal];
            btn.top =setY+10*MCscale;
            UIImageView * line = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, btn.width, 1)];
            btn.tag=100+i-2;
            line.backgroundColor=lineColor;
            line.bottom=btn.height+10*MCscale;
            [btn addSubview:line];
            [btn addTarget:self action:@selector(payBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        }
            setY=btn.bottom+10*MCscale;
        
    }
    self.height=setY+20*MCscale;

  
    
}
#pragma mark -- 按钮的点击事件
/**
 *   收款方式
 *
 *  @param sender 收款方式的点击事件
 */
-(void)payBtnClick:(UIButton *)sender{
    NSString * zhifuF = [NSString stringWithFormat:@"%@",_dataDic[@"zhifufangshi"]];
    UITextField * inputField = [self viewWithTag:110];
    float money = [[NSString stringWithFormat:@"%@",_dataDic[@"shishou"]] floatValue];
    float currentMoney = [inputField.text floatValue];

    if (![inputField.text isValidateMoneyed]) {
        [MBProgressHUD promptWithString:@"请输入正确的金额"];
        return;
    }
    
    
    if ((!mianMiPay && ([zhifuF isEqualToString:@"1"] ||[zhifuF isEqualToString:@"7"]))||// 不免密 但是 现金支付
        (!mianMiPay && (money != currentMoney))// 不免密 但是金额改变 都要输入密码
       )  {
        

        LoginPasswordView * loginPass = [LoginPasswordView new];
        [loginPass appear];
        [loginPass reloadDataWithViewTag:1];
        __block LoginPasswordView * weakPass = loginPass;
        loginPass.block=^(BOOL isRight){// 密码回调
            if (isRight) {// 输入正确
                [weakPass disAppear];
                [self shoukuan];
            }
        };
        return;
    }
    if (mianMiPay && money != currentMoney) {// 免密支付 但是 金额被改变
        LoginPasswordView * loginPass = [LoginPasswordView new];
        [loginPass appear];
        [loginPass reloadDataWithViewTag:1];
        __block LoginPasswordView * weakPass = loginPass;
        loginPass.block=^(BOOL isRight){// 密码回调
            if (isRight) {// 输入正确
                [weakPass disAppear];
                [self shoukuan];
            }
        };
        return;
    }
    
    [self shoukuan];
}
-(void)shoukuan{
    UITextField * inputField = [self viewWithTag:110];
    
    NSString * zhifuFangshi = [NSString stringWithFormat:@"%@",_dataDic[@"zhifufangshi"]];
    
    
    if ([zhifuFangshi isEqualToString:@"0"]) {
        switch (_btnIndex) {
            case 0:
                zhifuFangshi=@"7";
                break;
            case 1:
                zhifuFangshi=@"3";
                break;
            case 2:
                zhifuFangshi=@"4";
                break;
            case 3:
                zhifuFangshi=@"5";
                break;
            default:
                break;
        }
    }
    
    
    NSDictionary * pram = @{@"yuangong.id":user_Id,
                            @"danhao":_danhao,
                            @"shifujine":inputField.text,
                            @"zhifufangshi":zhifuFangshi};
    [Request shouYinTaiShouKuanWithDic:pram success:^(id json) {
        NSString * message = [NSString stringWithFormat:@"%@",[json valueForKey:@"message"]];
        if ([message isEqualToString:@"1"]) {
            UIButton * cancelBtn = [self viewWithTag:31];// 取消订单按钮
            [cancelBtn setTitle:@"已结束" forState:UIControlStateNormal];
            cancelBtn.imageView.image=[UIImage new];
            [cancelBtn removeTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [cancelBtn addTarget:self action:@selector(jieshuDingdan:) forControlEvents:UIControlEventTouchUpInside];
            
            UIButton * payBtn;
            if ([[NSString stringWithFormat:@"%@",_dataDic[@"zhifufangshi"]] isEqualToString:@"0"]) {
                payBtn = [self viewWithTag:300+_btnIndex];
            }else{
                payBtn = [self viewWithTag:100];
            }
              payBtn.selected=YES;

        }
    } failure:^(NSError *error) {
        
    }];
 
}
/**
 *消费中的 按钮
 *
 *  @param sender 消费中的 按钮 点击事件
 */
-(void)leftBtnClick:(UIButton *)sender{
    NSString * xiaofeizhong = [NSString stringWithFormat:@"%@",_dataDic[@"xiaofeizhong"]];
    if ([xiaofeizhong isEqualToString:@"1"]) {
        return;
    }
    
    NSDictionary * pram = @{@"yuangong.id":user_Id,
                            @"danhao":_danhao};
    [Request checkXiaoFeiZhognWithDic:pram success:^(id json) {
        NSString * message = [NSString stringWithFormat:@"%@",[json valueForKey:@"message"]];
        if ([message isEqualToString:@"1"]) {
            [self reshData];
            [self disAppear];
        }
    } failure:^(NSError *error) {
        
    }];
}
/**
 *取消订单的 按钮
 *
 *  @param sender 取消订单的 按钮 点击事件
 */
-(void)rightBtnClick:(UIButton *)sender{
    NSDictionary * pram = @{@"yuangong.id":user_Id,
                            @"danhao":_danhao};
    [Request cancelShouYinTaiOrderWithDic:pram success:^(id json) {
        NSString * message = [NSString stringWithFormat:@"%@",[json valueForKey:@"message"]];
        if ([message isEqualToString:@"1"]) {// 取消成功
            [self disAppear];
            if (_block) {
                _block();
            }
        }else{
            [MBProgressHUD promptWithString:@"取消失败"];
        }
    } failure:^(NSError *error) {
    }];
}

-(void)appear{
  
    self.centerX=[UIScreen mainScreen].bounds.size.width/2;
    self.centerY=[UIScreen mainScreen].bounds.size.height/2;

     [self reshData];
    [UIView animateWithDuration:0.3 animations:^{
        _backView.alpha=0.95;
    } completion:^(BOOL finished) {
        
    }];
}
-(void)disAppear{
    
    __weak ShouYinTaiPayWay * weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        _backView.alpha=0;
    }completion:^(BOOL finished) {
        [_backView removeFromSuperview];
        _backView = nil;
        
        [weakSelf removeFromSuperview];
    }];
}
-(void)jieshuDingdan:(UIButton *)sender{
    NSDictionary * pram =@{@"yuangong.id":user_Id,
                           @"danhao":_danhao};
    [Request endShouYinTaiWithDic:pram success:^(id json) {
        NSString * message = [NSString stringWithFormat:@"%@",[json valueForKey:@"message"]];
        if ([message isEqualToString:@"1"]) {
            [self disAppear];
            if (_block) {
                _block();
            }
            return ;
        }
        [MBProgressHUD promptWithString:@"操作失败"];
    } failure:^(NSError *error) {
        
    }];
 
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString * currentString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if ([currentString isValidateMoneying]) {
        return YES;
    }else{
        [MBProgressHUD promptWithString:@"请输入正确的金额"];
        return NO;
    }
    
}

-(void)payByZeroPayBtn:(UIButton *)sender{
    _btnIndex = sender.tag-300;
    
    NSString * zhifuF = [NSString stringWithFormat:@"%@",_dataDic[@"zhifufangshi"]];
    UITextField * inputField = [self viewWithTag:110];
    float money = [[NSString stringWithFormat:@"%@",_dataDic[@"shishou"]] floatValue];
    float currentMoney = [inputField.text floatValue];
    
    if (![inputField.text isValidateMoneyed]) {
        [MBProgressHUD promptWithString:@"请输入正确的金额"];
        return;
    }
    
    
    if ((!mianMiPay && ([zhifuF isEqualToString:@"1"] ||_btnIndex == 0))||// 不免密 但是 现金支付
        (!mianMiPay && (money != currentMoney))// 不免密 但是金额改变 都要输入密码
        )  {
        
        
        LoginPasswordView * loginPass = [LoginPasswordView new];
        [loginPass appear];
        [loginPass reloadDataWithViewTag:1];
        __block LoginPasswordView * weakPass = loginPass;
        loginPass.block=^(BOOL isRight){// 密码回调
            if (isRight) {// 输入正确
                [weakPass disAppear];
                [self shoukuan];
            }
        };
        return;
    }
    if (mianMiPay && money != currentMoney) {// 免密支付 但是 金额被改变
        LoginPasswordView * loginPass = [LoginPasswordView new];
        [loginPass appear];
        [loginPass reloadDataWithViewTag:1];
        __block LoginPasswordView * weakPass = loginPass;
        loginPass.block=^(BOOL isRight){// 密码回调
            if (isRight) {// 输入正确
                [weakPass disAppear];
                [self shoukuan];
            }
        };
        return;
    }
    
    [self shoukuan];
    
}

@end
