//
//  FreeOpenView.m
//  ShopPeiSong
//
//  Created by MIAO on 2017/5/8.
//  Copyright © 2017年 妙灵科技. All rights reserved.
//

#import "FreeOpenView.h"
#import "Header.h"
#import "YanButton.h"
#import "AutographView.h"
#import "ReviewSelectedView.h"
#import "AFHTTPRequestOperationManager.h"
#import "GestureViewController.h"
#import "UseDirectionViewController.h"
#import "PaymentPasswordView.h"
//#import "PHPay.h"
#import "OnLinePayView.h"

@interface FreeOpenView()
@property (nonatomic,strong)NSDictionary * dataDic;

@property (nonatomic,strong)UIScrollView * mainScrollView;


@property (nonatomic,strong)UIView * industryView;
@property (nonatomic,strong)NSDictionary * hangYeDic;


@property (nonatomic,strong)UIImageView * signImageView;

@property (nonatomic,assign)BOOL isAgree;

@property (nonatomic,strong)UIButton * submitBtn;
@end
@implementation FreeOpenView
-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self initData];
        [self newView];
        [self reshData];
    }
    return self;
}
-(void)initData{
    _hangYeDic = @{};
    _isAgree=YES;
}
-(void)reshData{
}
-(void)reshView{

}
-(void)newView{
    self.backgroundColor=[UIColor whiteColor];
    _mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    [self addSubview:_mainScrollView];
    CGFloat setY = 0;
 
    
    

     NSArray *   titleArray = @[@"店铺名",@"行业",@"法人/联系人",@"联系/注册手机号",@""];
     NSArray *   placeHoldArray = @[@"请输入店铺名",@"请选择行业",@"请输入法人/联系人",@"请输入联系/注册手机号",@"请输入验证码"];


    for (int i = 0; i<titleArray.count; i++) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20*MCscale,40*MCscale*i+0, 140*MCscale, 30*MCscale)];
        label.text=titleArray[i];
        label.textColor=textColors;
        label.tag = 10000+i;
        label.userInteractionEnabled = YES;
        [_mainScrollView addSubview:label];
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(10*MCscale, label.bottom +5*MCscale, kDeviceWidth - 20*MCscale, 1)];
        lineView.backgroundColor = lineColor;
        [_mainScrollView addSubview:lineView];
        

        UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(label.right,label.top, kDeviceWidth - 40*MCscale - 140*MCscale, 30*MCscale)];
        textField.placeholder=placeHoldArray[i];
        [_mainScrollView addSubview:textField];
        if (i == 1) {
            textField.text=placeHoldArray[i];
            textField.textAlignment=NSTextAlignmentRight;
            textField.rightView= [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"right_jian_icon"]];
            textField.rightViewMode=UITextFieldViewModeAlways;

            textField.rightView.size=CGSizeMake(30, 30);
            textField.userInteractionEnabled=YES;
            
            UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, textField.width, textField.height)];
            [textField addSubview:btn];
            [btn addTarget:self action:@selector(selectHangYeClick:) forControlEvents:UIControlEventTouchUpInside];
        }
                textField.tag = 11000+i;
        
        if (i == 3 || i== 4) {
            textField.keyboardType = UIKeyboardTypePhonePad;
            if (i == 3) {
//                [textField setValue:@11 forKey:@"limit"];
            }
            
            if (i == 4) {
                YanButton  * yanBtn= [YanButton insButtonWithFrame:CGRectMake(0, 0, 100, 30) title:@"发送验证码" time:120];
                yanBtn.tag=2100;
                [_mainScrollView addSubview:yanBtn];
                [yanBtn addTarget:self action:@selector(yanBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                yanBtn.right=kDeviceWidth-20;
                yanBtn.centerY=textField.centerY;
                [yanBtn setBackgroundColor:redTextColor];
                
                textField.right=yanBtn.left-10*MCscale;
                
                
            }
   
        }
        
        
  
        setY=lineView.bottom;
    }


    
    /**
     *   签名
     */
    
    UIView * signV ;
    signV = [[UIView alloc]initWithFrame:CGRectMake(20*MCscale, setY+10*MCscale, kDeviceWidth - 40*MCscale, 40*MCscale)];
    signV.backgroundColor = [UIColor clearColor];
    [_mainScrollView addSubview:signV];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(signTap:)];
    [signV addGestureRecognizer:tap];
    
    
    UILabel * signLabel = [[UILabel alloc]initWithFrame:CGRectMake(5*MCscale, 5*MCscale, 100*MCscale, 30*MCscale)];
    signLabel.textColor = redTextColor;
    signLabel.font = [UIFont systemFontOfSize:MLwordFont_2];
    signLabel.text = @"签名:";
    [signV addSubview:signLabel];
    
    _signImageView = [[UIImageView alloc]initWithFrame:CGRectMake(signLabel.right +5*MCscale,0,80*MCscale,40*MCscale)];
    _signImageView.backgroundColor = [UIColor clearColor];
    [signV addSubview:_signImageView];
  
    
    setY =signV.bottom;
    /**
     *  提交按钮
     */
    UIButton * submit ;
    submit = [[UIButton alloc]initWithFrame:CGRectMake(20*MCscale,setY+20*MCscale, kDeviceWidth-40, 40*MCscale)];
    _submitBtn=submit;
    [submit setTitle:@"创建开户" forState:UIControlStateNormal];
    [submit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    submit.titleLabel.font = [UIFont boldSystemFontOfSize:MLwordFont_2];
    submit.titleLabel.textAlignment = NSTextAlignmentCenter;
    submit.layer.cornerRadius = 5;
    submit.layer.masksToBounds = YES;
    submit.backgroundColor = txtColors(213, 213, 213, 1);
    submit.enabled = NO;
    [_mainScrollView addSubview:submit];
    setY = submit.bottom;
        [submit addTarget:self action:@selector(submitClick:) forControlEvents:UIControlEventTouchUpInside];

      

    
    /**
     *  开户协议
     */
    
    //    UIImageView *imageView = [self.view viewWithTag:1000];
    UIView * proView = [[UIView alloc]initWithFrame:CGRectMake(20*MCscale,setY, kDeviceWidth - 40*MCscale, 30*MCscale)];
    proView.backgroundColor = [UIColor clearColor];
    [_mainScrollView addSubview:proView];
    
    
    UIButton * protocolBtn = [[UIButton alloc]initWithFrame:CGRectMake(5*MCscale, 5*MCscale, 135*MCscale, 20*MCscale)];
    protocolBtn.imageView.contentMode=UIViewContentModeScaleAspectFit;
    [protocolBtn setImage:[UIImage imageNamed:@"选中"] forState:UIControlStateSelected];
    [protocolBtn setImage:[UIImage imageNamed:@"选择"] forState:UIControlStateNormal];
    [protocolBtn setTitle:@"我已阅读并同意" forState:UIControlStateNormal];
    [protocolBtn setTitleColor:textBlackColor forState:UIControlStateNormal];
    protocolBtn.titleLabel.font=[UIFont systemFontOfSize:MLwordFont_7];
    [proView addSubview:protocolBtn];
    protocolBtn.selected=_isAgree;
    [protocolBtn addTarget:self action:@selector(changeIsAgree:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    UILabel * xieyiLabel = [[UILabel alloc]initWithFrame:CGRectMake(protocolBtn.right,5*MCscale,188*MCscale, 20*MCscale)];
    xieyiLabel.text=@"《妙店佳系统使用协议》";
    xieyiLabel.textColor = txtColors(78, 194, 151, 1);
    xieyiLabel.font = [UIFont systemFontOfSize:MLwordFont_7];
    xieyiLabel.userInteractionEnabled = YES;
    [proView addSubview:xieyiLabel];
    UITapGestureRecognizer *xieyiTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(xieyiBtnClick:)];
    [xieyiLabel addGestureRecognizer:xieyiTap];
    [xieyiLabel sizeToFit];
    
    UIView *xieyiView = [[UIView alloc]initWithFrame:CGRectMake(xieyiLabel.left, xieyiLabel.bottom, xieyiLabel.width, 1)];
    xieyiView.backgroundColor = txtColors(78, 194, 151, 1);
    [proView addSubview:xieyiView];
    xieyiView.width=xieyiLabel.width;
    
    setY = proView.bottom;
    

    _mainScrollView.contentSize=CGSizeMake(kDeviceWidth, setY+20*MCscale);
}



#pragma mark -- 按钮事件
/**
 *   签名的点击事件
 *
 *  @param tap 签名的点击事件
 */
-(void)signTap:(UITapGestureRecognizer *)tap{
    
    if (_isAgree) {
        //签名
        AutographView * autogra = [[AutographView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
        [autogra appear];
        autogra.Block=^(NSInteger index,NSDictionary * dict){
            if (index == 0) {
                NSData *imageData = UIImageJPEGRepresentation(dict[@"image"], 0.9);
                if (![dict isEqual:@{}]) {
                    _submitBtn.enabled = YES;
                    _submitBtn.backgroundColor = txtColors(250, 54, 71, 1);
                    _signImageView.image = [UIImage imageWithData:imageData];
                    //                        NSDictionary *dict111 = @{@"imageName":@"qianming.png",@"image":dict[@"image"]};
                    
                }
                else
                {
                    _signImageView.image=[UIImage new];
                    _submitBtn.enabled = NO;
                    _submitBtn.backgroundColor = txtColors(213, 213, 213, 1);
                }
                
            }
            else if (index == 2)
            {
                
            }
            
        };
        
        
    }
    else
    {
        [MBProgressHUD promptWithString:@"请阅读并同意开户协议"];
        
    }
}
/**
 *
 *  提交按钮的点击事件
 *  @param sender 提交按钮的点击事件
 */
-(void)submitClick:(UIButton *)sender{
    
    UITextField * dianPu=[_mainScrollView viewWithTag:11000];
    UILabel * hangYe=[_mainScrollView viewWithTag:11001];
    UITextField * person=[_mainScrollView viewWithTag:11002];
    UITextField * phone =[_mainScrollView viewWithTag:11003];
    UITextField * code  =[_mainScrollView viewWithTag:11004];
    if ([dianPu.text isEmptyString] ||
        [person.text isEmptyString] ||
        [phone.text  isEmptyString] ||
        [code.text   isEmptyString]) {
        [MBProgressHUD promptWithString:@"请完整填写以上内容"];
        return;
    }
    
    if ([hangYe.text isEqualToString:@"请选择行业"]) {
        [MBProgressHUD promptWithString:@"请选择行业"];
        return;
    }

    NSDictionary * dic = @{@"dianpu.dianpuname":dianPu.text,
                           @"dianpu.suozaihangyi":[NSString stringWithFormat:@"%@",_hangYeDic[@"id"]],
                           @"dianpu.lianxiren":person.text,
                           @"dianpu.yidongtel":phone.text,
                           @"code":code.text};
    [Request openAccountFreeWithDic:dic success:^(id json) {
        NSString * message = [NSString stringWithFormat:@"%@",[json valueForKey:@"message"]];
        
        if ([message isEqualToString:@"1"]) {
            
            NSString * dianpuid = [NSString stringWithFormat:@"%@",json[@"dianpuid"]];
            [self upLoadImagesWithDianPuId:dianpuid];
            _dataDic = (NSDictionary *)json;
            [self login];
            
        }else if([message isEqualToString:@"0"]){
            [MBProgressHUD promptWithString:@"参数有空请检查"];
        }else{
            [MBProgressHUD promptWithString:@"验证码有误"];
        }
    } failure:^(NSError *error) {
        
    }];
}
-(void)login{
    
    
    
    UITextField * phone =[_mainScrollView viewWithTag:11003];
    NSString * loginPass = [NSString stringWithFormat:@"%@",_dataDic[@"password"]];
    NSString * dianpuid = [NSString stringWithFormat:@"%@",_dataDic[@"dianpuid"]];

    
    set_User_Tel(phone.text);
    set_User_dianpuID(dianpuid);
    set_LoginPass(loginPass);

    [self clearData];
    
    /**
     *  登录功能暂未实现   用以下功能代替
     */
    if (self.controller.successBlock) {
        self.controller.successBlock(YES);
    }
    [self.controller dismissViewControllerAnimated:YES completion:^{
    }];
    [self.controller.navigationController popViewControllerAnimated:YES];
    return;
//    NSDictionary * dic = _dataDic;
//    
//    NSString * dianpuID = [NSString stringWithFormat:@"%@",dic[@"dianpuid"]];
//    NSString * loginPass =  [NSString stringWithFormat:@"%@",dic[@"password"]];
//    UITextField * phone =[_mainScrollView viewWithTag:11003];
//    
//    
//    NSDictionary * pram = @{@"yuangong.shebeishenfen":user_shebeiId,
//                            @"yuangong.chushimima":loginPass,
//                            @"yuangong.tel":phone.text};
//    [Request loginWithDic:pram Success:^(id json) {
//        
//        [Request yanZhengLoginPassSuccess:^(id json) {
//            
//            
//            
//            set_IsLogin(YES);
//            set_User_dianpuID(dianpuID);
//            set_LoginPass(loginPass);
//            set_User_Tel(phone.text);
//            set_User_IsMianMiLogin(YES);
//            
//            NSLog(@"%@%@%@",dianpuID,loginPass,phone.text);
//            GestureViewController * ges = [GestureViewController new];
//            [self.controller.navigationController pushViewController:ges animated:YES];
//        } failure:^(NSError *error) {
//            
//        }];
//        
//        
//    } failure:^(NSError *error) {
//        
//        
//        
//    }];
}

/**
 *  验证码的点击事件
 *
 *  @param sender 验证码
 */
-(void)yanBtnClick:(YanButton *)sender{
    UITextField * tel = [_mainScrollView viewWithTag:11003];
    if (![tel.text isValidateMobile]) {
        [MBProgressHUD promptWithString:@"请输入有效的手机号"];
        return;
    }
    NSDictionary * dic = @{@"dianpu.yidongtel":tel.text};
    [Request judgePhoneWithDic:dic success:^(id json) {
        NSString * message = [NSString stringWithFormat:@"%@",[json valueForKey:@"message"]];
        if ([message isEqualToString:@"0"]) {
            sender.code=@"   ";
            [Request getYanMaWithDic:@{@"dianpu.yidongtel":tel.text} success:^(id json) {
                sender.code= [json valueForKey:@"code"];
                NSLog(@"----验证码:%@",sender.code);
                [sender startTimer];
            } failure:^(NSError *error) {
                sender.code=@"   ";
            }];
        }else{
            [MBProgressHUD promptWithString:@"该手机号已经开过户"];
        }
    } failure:^(NSError *error) {
        
    }];

}
/**
 *  是否同意协议
 *
 *  @param sender 是否同意协议的点击事件
 */
-(void)changeIsAgree:(UIButton *)sender{
    _isAgree=!_isAgree;
    sender.selected=_isAgree;
}

/**
 *  选择行业
 */
-(void)selectHangYeClick:(UIButton *)sender
{
    
    
    ReviewSelectedView * sele = [ReviewSelectedView new];
    [sele appear];
    [sele reloadDataWithViewTag:7];
    sele.block=^(id data){
        _hangYeDic = (NSDictionary *)data;
        ((UITextField *)(sender.superview)).text=[NSString stringWithFormat:@"%@",_hangYeDic[@"name"]];
        ((UITextField *)(sender.superview)).rightView=nil;
        NSLog(@"%@",data);
    };
    
}


/**
 *  上传图片
 */
-(void)upLoadImagesWithDianPuId:(NSString * )ID{
        UIImage *image = _signImageView.image;

        NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"dianpuid":[NSString stringWithFormat:@"%@",ID]}];
        AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
        //网络延时设置15秒
        manger.requestSerializer.timeoutInterval = 15;
        NSString *url = @"fileuploadDianpuInfo.action";
        NSString * urlPath = [NSString stringWithFormat:@"%@%@",HTTPImage,url];
        [manger POST:urlPath parameters:pram constructingBodyWithBlock:^(id<AFMultipartFormData> formData){
            NSData *imageData = UIImageJPEGRepresentation(image, 0.9);
            NSString *fileName = [NSString stringWithFormat:@"%@",@"qianming"];
            [formData appendPartWithFileData:imageData name:@"file" fileName:fileName mimeType:@"image/jpeg"];
        }success:^(AFHTTPRequestOperation *operation, id responseObject) {
             [MBProgressHUD promptWithString:@"开户成功"];      
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        }];
    
}
-(void)xieyiBtnClick:(UIButton *)sender{
    UseDirectionViewController *agr = [[UseDirectionViewController alloc]init];
//    if (isModify) {
//        agr.pageUrl = [NSString stringWithFormat:@"%@/useXieyi.action?dianpuid=%@",HTTPImage,dianpuID];
//    }
//    else
//    {
        agr.pageUrl = [NSString stringWithFormat:@"%@shiyongxieyiMianfei.jsp",HTTPImage];
//    }
    agr.titStr = @"妙店佳系统使用协议";
    agr.hidesBottomBarWhenPushed = YES;
    UIBarButtonItem *bar=[[UIBarButtonItem alloc]init];
    bar.image = [UIImage imageNamed:@"返回"];
    agr.navigationItem.backBarButtonItem=bar;
    [self.controller.navigationController pushViewController:agr animated:YES];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
/**
 *  清空数据
 */
-(void)clearData{
    UITextField * dianPu=[_mainScrollView viewWithTag:11000];
    UITextField * person=[_mainScrollView viewWithTag:11002];
    UITextField * phone =[_mainScrollView viewWithTag:11003];
    UITextField * code  =[_mainScrollView viewWithTag:11004];
    dianPu.text=@"";
    person.text=@"";
    phone.text=@"";
    code.text=@"";
}

@end
