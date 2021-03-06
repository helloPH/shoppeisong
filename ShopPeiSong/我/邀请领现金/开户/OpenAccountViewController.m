//
//  OpenAccountViewController.m
//  GoodYeWu
//
//  Created by MIAO on 16/11/15.
//  Copyright © 2016年 时元尚品. All rights reserved.
//

#import "OpenAccountViewController.h"
#import "ReviewSelectedView.h"
#import "AFNetworking.h"
#import "ModifyKaihufeiView.h"
#import "Header.h"
#import "AutographView.h"
//#import "UpdateTipView.h"
#import "PaymentPasswordView.h"
#import "UseDirectionViewController.h"
#import "GetLocationView.h"
#import "PHMap.h"

@interface OpenAccountViewController ()<MBProgressHUDDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,ModifyKaihufeiViewDelegate,AutographViewDelegate,UITextFieldDelegate,PaymentPasswordViewDelegate>
@end


//method not implement
@implementation OpenAccountViewController
{
    UIView *industryView;
    UILabel *selectedIndustrLabel;
    UIImageView *imageview1;
    
    UIView *protocolView;
    UIImageView *protocolImage;
    UILabel *xieyiLabel;
    
    UIView *signView;
    UILabel *signLabel;
    UIImageView *signImageView;
    
    UIButton *submitBtn;
    UIView *maskView;
    UIView *mask;
    
    BOOL isMap,isAgree,isModify,ISImage;//地图定位,同意协议,修改草稿,选择照片
    
    NSString *hangyeID;

    ModifyKaihufeiView *kaihufeiView;
    UIImagePickerController *imagePicker;
    NSInteger imageViewTag;
    
    NSString *yingyezhizhao;
    NSString *suiwudengjizhen;
    NSString *jigoudaima;
    
    NSMutableArray *selectedImageArray;
    UIImageView *bubbleView;//气泡
    NSString *dianpuID;
    NSString *kaihufei;
    AutographView *autoView;
    
    NSString *latitudeStr,*longitudeStr;
    
//    UpdateTipView *updatePop;//更新提示弹框
    UIView *updateBackgroundView;//更新背景
    NSString *sysLevel,*descripton;//更新等级 更新说明
    NSString *city;
    PaymentPasswordView *passPopView;
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self maskViewDisMiss];
//    [self.mapView viewWillDisappear];

}
-(void)newNavi{
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, NVbtnWight, NVbtnWight);
    [rightButton setImage:[UIImage imageNamed:@"加号按钮"] forState:UIControlStateNormal];
    rightButton.tag = 1002;
    [rightButton addTarget:self action:@selector(tightItemClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
    
    UIButton * leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, NVbtnWight, NVbtnWight)];
    [leftBtn setImage:[UIImage imageNamed:@"返回按钮"] forState:UIControlStateNormal];
    [leftBtn addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    
    self.navigationItem.title=@"邀请注册";
}
- (void)viewDidLoad {
    [super viewDidLoad];
    yingyezhizhao = @"";
    suiwudengjizhen = @"";
    jigoudaima = @"";
    hangyeID = @"";
    dianpuID = @"";
    latitudeStr = @"";
    longitudeStr = @"";
    city = @"";
    isMap = 0;
    [self locationAndUpdateView];
    
    isAgree = 1;
    isModify = 0;
    ISImage = 0;
    selectedImageArray = [NSMutableArray arrayWithObjects:@{},@{},@{},@{}, nil];
   

    [self newNavi];

    [self createUI];
    [self initMaskView];
    [self initMask];
    [self popView];//弹框

    [self showGuideImageWithUrl:@"images/caozuotishi/caogao.png"];
}

-(void)tightItemClick
{
    [UIView animateWithDuration:0.3 animations:^{
        [self.navigationController.view addSubview:bubbleView];
        [self.view addSubview:maskView];
        maskView.alpha = 1;
        bubbleView.alpha = 0.95;
        bubbleView.frame = CGRectMake(kDeviceWidth*3/5.0-10*MCscale, 52, kDeviceWidth*2/5.0, 120*MCscale);
    }];
}
-(void)popView
{
    bubbleView = [[UIImageView alloc]initWithFrame:CGRectMake(kDeviceWidth-20, 50,97*MCscale ,56*MCscale)];
    bubbleView.alpha = 0;
    bubbleView.userInteractionEnabled = YES;
    bubbleView.image = [UIImage imageNamed:@"选择弹框"];
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(22*MCscale, 67*MCscale, kDeviceWidth/3.0-20*MCscale, 1)];
    line.backgroundColor = lineColor;
    [bubbleView addSubview:line];
    
    for (int i=0; i<2; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(22*MCscale, 30*MCscale+i*45*MCscale, kDeviceWidth/3.0-20*MCscale, 30*MCscale);
        btn.tag = 10+i;
        [self customButton:btn];
        [bubbleView addSubview:btn];
    }
}
-(void)customButton:(UIButton *)sender
{
    NSArray *titleArray = @[@"申请",@"提取"];
    NSArray *imageArray = @[@"shenqing",@"shenqing"];
    sender.imageEdgeInsets = UIEdgeInsetsMake(5*MCscale,25*MCscale,5*MCscale,60*MCscale);
    sender.titleEdgeInsets = UIEdgeInsetsMake(3*MCscale,0,3*MCscale, 20*MCscale);
    sender.titleLabel.textAlignment = NSTextAlignmentCenter;
    [sender setTitleColor:textColors forState:UIControlStateNormal];
    NSInteger index = sender.tag - 10;
    sender.backgroundColor = [UIColor clearColor];
    [sender setTitle:titleArray[index] forState:UIControlStateNormal];
    [sender addTarget:self action:@selector(popAction:) forControlEvents:UIControlEventTouchUpInside];
    [sender setImage:[UIImage imageNamed:imageArray[index]] forState:UIControlStateNormal];
    
}
-(void)popAction:(UIButton *)button
{
    if (button.tag == 10) {
        [UIView animateWithDuration:0.3 animations:^{
            maskView.alpha = 0;
            [maskView removeFromSuperview];
            [self.view endEditing:YES];
            bubbleView.alpha = 0;
            [bubbleView removeFromSuperview];
        }];
        
        [UIView animateWithDuration:0.3 animations:^{
            maskView.alpha = 1;
            [self.view addSubview:maskView];
            kaihufeiView.alpha = 0.95;
            [self.view addSubview:kaihufeiView];
        }];
    }else
    {
        [UIView animateWithDuration:0.3 animations:^{
            maskView.alpha = 0;
            [maskView removeFromSuperview];
            [self.view endEditing:YES];
            bubbleView.alpha = 0;
            [bubbleView removeFromSuperview];
        }];
        
        ReviewSelectedView * sele = [ReviewSelectedView new];
        [sele appear];
        [sele reloadDataWithViewTag:6];
        sele.block=^(id data){
            [self selectedCaogaoWithId:[NSString stringWithFormat:@"%@",[data valueForKey:@"dianpuid"]]];
        };
        
    }
}
-(void)createUI
{
    self.view.backgroundColor=backColor;
    
    CGFloat setY = 84*MCscale;;
    UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(0, setY, kDeviceWidth, 100)];
    backView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:backView];
    
    
    CGFloat temY = 10*MCscale;
    NSArray *titleArray = @[@"店铺名",@"行业",@"法人/联系人",@"联系/注册手机号"
//                            ,@"服务电话",@"定位签到点",@"店铺地址"
                            ];
    NSArray *placeHoldArray = @[@"请输入店铺名",@"",@"请输入店主/联系人",@"请输入绑定/注册手机号"
//                                ,@"请输入服务电话",@"",@"请输入店铺地址"
                                ];
    for (int i = 0; i<titleArray.count; i++) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20*MCscale,temY+10*MCscale, 0*MCscale, 30*MCscale)];
        [self customLabel:label AndString:titleArray[i]];
        label.tag = 10000+i;
        label.userInteractionEnabled = YES;
        [backView addSubview:label];
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(10*MCscale, label.bottom +5*MCscale, kDeviceWidth - 20*MCscale, 1)];
        lineView.backgroundColor = lineColor;
        [backView addSubview:lineView];
//        temY = lineView.bottom;
        
        
        
        
        if (i == 0 ||i == 2 ||i == 3 ||i == 4||i == 6) {
            UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(label.right,label.top, kDeviceWidth - 40*MCscale - 140*MCscale, 30*MCscale)];
//            [self custom:textField AndString:placeHoldArray[i]];
        
            textField.placeholder = placeHoldArray[i];
//            textField.textAlignment = NSTextAlignment;
            textField.font = [UIFont systemFontOfSize:MLwordFont_4];
            textField.textColor = textColors;
            textField.delegate = self;
            textField.returnKeyType = UIReturnKeyDone;
            textField.backgroundColor = [UIColor clearColor];
            [backView addSubview:textField];
            
            
            if (i == 3 || i== 4) {
                textField.keyboardType = UIKeyboardTypePhonePad;
            }
            textField.tag = 11000+i;
        }
        else if (i == 1)
        {
//            UILabel *industrLabel = [self.view viewWithTag:10001];
            industryView = [[UIView alloc]initWithFrame:CGRectMake(label.right ,label.top, kDeviceWidth - label.right*2, 30*MCscale)];
            industryView.backgroundColor = [UIColor clearColor];
            [backView addSubview:industryView];
            
            UITapGestureRecognizer *industryTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewTapClick:)];
            [industryView addGestureRecognizer:industryTap];
            
            selectedIndustrLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,industryView.width - 15*MCscale,30*MCscale)];
            [self customLabel:selectedIndustrLabel AndString:@"请选择行业类别"];
//            selectedIndustrLabel.textAlignment = NSTextAlignment;
            [industryView addSubview:selectedIndustrLabel];
            
            imageview1 = [[UIImageView alloc]initWithFrame:CGRectMake(industryView.width - 15*MCscale, 5*MCscale, 15*MCscale,20*MCscale)];
            imageview1.right=industryView.width;
            imageview1.image = [UIImage imageNamed:@"right_jian_icon"];
            [industryView addSubview:imageview1];

        }
        else
        {
            [self getLocationData];
        }
        temY = lineView.bottom;
    }
    
    
    backView.height = temY;
    setY = backView.bottom;
    
    
    setY = [self selectedImageDataWithSetY:setY+20*MCscale].bottom;  //  图片
    
    setY =  [self setSaveButtonDataWithSetY:setY+20*MCscale].bottom; //  签名和保存按钮
    
    setY =  [self setProtocolDataWithSetY:setY].bottom;              //  协议
}
#pragma mark 选择行业
-(void)selectedHangyeType
{
    UILabel *industrLabel = [self.view viewWithTag:10001];
    industryView = [[UIView alloc]initWithFrame:CGRectMake(industrLabel.right ,industrLabel.top, kDeviceWidth - 180*MCscale, 30*MCscale)];
    industryView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:industryView];
    
    UITapGestureRecognizer *industryTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewTapClick:)];
    [industryView addGestureRecognizer:industryTap];
    
    selectedIndustrLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,industryView.width - 15*MCscale,30*MCscale)];
    [self customLabel:selectedIndustrLabel AndString:@"请选择行业类别"];
    selectedIndustrLabel.textAlignment = NSTextAlignmentRight;
    [industryView addSubview:selectedIndustrLabel];
    
    imageview1 = [[UIImageView alloc]initWithFrame:CGRectMake(industryView.width - 15*MCscale, 5*MCscale, 15*MCscale,20*MCscale)];
    imageview1.image = [UIImage imageNamed:@"right_jian_icon"];
    [industryView addSubview:imageview1];
}

#pragma mark 定位坐标
-(void)getLocationData
{
    NSArray *locaArray = @[@"当前位置",@"地图定位"];
    UITextField *telTextField = [self.view viewWithTag:11004];
    for (int i = 0; i<2; i++) {
        UIView *locationView = [[UIView alloc]initWithFrame:CGRectMake(100*MCscale*i +170*MCscale,telTextField.bottom +10*MCscale, 80*MCscale, 30*MCscale)];
        locationView.tag = 12000+i;
        locationView.backgroundColor = [UIColor clearColor];
        UITapGestureRecognizer *locationTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewTapClick:)];
        [locationView addGestureRecognizer:locationTap];
        [self.view addSubview:locationView];
        
        UIImageView *locationImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 8*MCscale, 15*MCscale, 15*MCscale)];
        locationImage.tag = 13000+i;
        locationImage.backgroundColor = [UIColor clearColor];
        locationImage.userInteractionEnabled = YES;
        [locationView addSubview:locationImage];
        if (i == 0) {
            locationImage.image = [UIImage imageNamed:@"选中"];
        }
        else
        {
            locationImage.image = [UIImage imageNamed:@"选择"];
        }
        
        UILabel *locationLabel = [[UILabel alloc]initWithFrame:CGRectMake(locationImage.right + 5*MCscale,5*MCscale, locationView.width - 17*MCscale, 20*MCscale)];
        [self customLabel:locationLabel AndString:locaArray[i]];
        locationLabel.font = [UIFont systemFontOfSize:MLwordFont_7];
        locationLabel.userInteractionEnabled = YES;
        [locationView addSubview:locationLabel];
    }
}
#pragma mark 选择照片
-(UIView *)selectedImageDataWithSetY:(CGFloat )setY
{
//    UITextField *addressTextField = [self.view viewWithTag:11006];
    UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(0, setY, kDeviceWidth, 100)];
    backView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:backView];
    
    CGFloat temY = 20*MCscale;
    
    
    CGFloat imageWidth = (kDeviceWidth - 60*MCscale)/3;
    NSArray *imageArray = @[@"yingyezhizhao",@"shenfenzheng",@"yinghangka"];
    for (int i = 0; i<3; i++) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((imageWidth +10*MCscale)*i+20*MCscale , temY, imageWidth, imageWidth)];
        imageView .backgroundColor = [UIColor clearColor];
        imageView.image = [UIImage imageNamed:imageArray[i]];
        imageView.userInteractionEnabled = YES;
        imageView.tag = 1000+i;
        [backView addSubview:imageView];
        
        UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageTapClick:)];
        [imageView addGestureRecognizer:imageTap];
        backView.height = imageView.bottom+20*MCscale;
    }
    

    return backView;
}

#pragma mark 开户协议
-(UIView *)setProtocolDataWithSetY:(CGFloat)setY
{
    
    
//    UIImageView *imageView = [self.view viewWithTag:1000];
    UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(0, setY, kDeviceWidth, 100)];
    backView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:backView];
    
    CGFloat temY = 0 ;
    
    protocolView = [[UIView alloc]initWithFrame:CGRectMake(20*MCscale,temY +5*MCscale, kDeviceWidth - 40*MCscale, 30*MCscale)];
    protocolView.backgroundColor = [UIColor clearColor];
//    UITapGestureRecognizer *protocoTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewTapClick:)];
//    [protocolView addGestureRecognizer:protocoTap];
    [backView addSubview:protocolView];
    
    protocolImage = [[UIImageView alloc]initWithFrame:CGRectMake(5*MCscale, 7*MCscale, 15*MCscale, 15*MCscale)];
    protocolImage.backgroundColor = [UIColor clearColor];
//    protocolImage.image = [UIImage imageNamed:@"选中"];
//    protocolImage.userInteractionEnabled = YES;
    [protocolView addSubview:protocolImage];
    
    UILabel *protocolLabel = [[UILabel alloc]initWithFrame:CGRectMake(protocolImage.right + 5*MCscale,5*MCscale,100, 20*MCscale)];
    [self customLabel:protocolLabel AndString:@"我已阅读并同意"];
    protocolLabel.font = [UIFont systemFontOfSize:MLwordFont_7];
    [protocolView addSubview:protocolLabel];
    
    xieyiLabel = [[UILabel alloc]initWithFrame:CGRectMake(protocolLabel.right,5*MCscale,89*MCscale, 20*MCscale)];
    [self customLabel:xieyiLabel AndString:@"系统使用协议"];
    xieyiLabel.textColor = mainColor;
    xieyiLabel.font = [UIFont systemFontOfSize:MLwordFont_7];
    xieyiLabel.userInteractionEnabled = YES;
    [protocolView addSubview:xieyiLabel];
    
    UITapGestureRecognizer *xieyiTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewTapClick:)];
    [xieyiLabel addGestureRecognizer:xieyiTap];
    
    UIView *xieyiView = [[UIView alloc]initWithFrame:CGRectMake(xieyiLabel.left, xieyiLabel.bottom, xieyiLabel.width, 1)];
    xieyiView.backgroundColor = mainColor;
    [protocolView addSubview:xieyiView];
    protocolView.width=xieyiLabel.right;
    protocolView.centerX = backView.width/2;
    
    backView.height = protocolView.bottom;
    backView.height = self.view.bottom-setY;
    protocolView.bottom=backView.height-10*MCscale;
    return backView;
    
}
#pragma mark 乙方签名及提交按钮
-(UIView *)setSaveButtonDataWithSetY:(CGFloat)setY
{
    CGFloat temY = 20*MCscale;
    
    UIView * backView  = [[UIView alloc]initWithFrame:CGRectMake(0, setY, kDeviceWidth, 100)];
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
    
    
    
//    signView = [[UIView alloc]initWithFrame:CGRectMake(20*MCscale, temY, kDeviceWidth - 40*MCscale, 40*MCscale)];
//    signView.backgroundColor = [UIColor clearColor];
//    [backView addSubview:signView];
//    UITapGestureRecognizer *signViewTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(signViewTapClick:)];
//    [signView addGestureRecognizer:signViewTap];
//    
//    signLabel = [[UILabel alloc]initWithFrame:CGRectMake(5*MCscale, 5*MCscale, 100*MCscale, 30*MCscale)];
//    signLabel.textColor = redTextColor;
//    signLabel.font = [UIFont systemFontOfSize:MLwordFont_2];
//    signLabel.text = @"乙方签名:";
//    [signView addSubview:signLabel];
//    
//    signImageView = [[UIImageView alloc]initWithFrame:CGRectMake(signLabel.right +5*MCscale,0,80*MCscale,40*MCscale)];
//    signImageView.backgroundColor = [UIColor clearColor];
//    [signView addSubview:signImageView];
//    temY = signView.bottom;
    
    
#pragma mark 提交按钮
    submitBtn = [[UIButton alloc]initWithFrame:CGRectMake(20*MCscale, temY, kDeviceWidth - 40*MCscale, 40*MCscale)];
    [submitBtn setTitle:@"创建开户" forState:UIControlStateNormal];
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    submitBtn.titleLabel.font = [UIFont boldSystemFontOfSize:MLwordFont_2];
    submitBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    submitBtn.layer.cornerRadius = 5;
    submitBtn.layer.masksToBounds = YES;
    submitBtn.backgroundColor = redTextColor;
    [submitBtn addTarget:self action:@selector(submitBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:submitBtn];
    
    temY  = submitBtn.bottom;
    backView.height = temY;
    
    
    return backView;
}
-(void)initMaskView
{
    maskView = [[UIView alloc]initWithFrame:self.view.bounds];
    maskView.backgroundColor = [UIColor clearColor];
    maskView.alpha = 0;

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(maskViewDisMiss)];
    [maskView addGestureRecognizer:tap];
    
    //支付密码
    passPopView = [[PaymentPasswordView alloc]initWithFrame:CGRectMake(kDeviceWidth/20.0, 180*MCscale, kDeviceWidth*9/10.0, 360*MCscale)];
    passPopView.paymentPasswordDelegate = self;
    passPopView.alpha = 0;
    
    
    kaihufeiView = [[ModifyKaihufeiView alloc]initWithFrame:CGRectMake(60*MCscale, 180*MCscale, kDeviceWidth - 120*MCscale, 170*MCscale)];
    kaihufeiView.modefyDelegate = self;
    
    autoView = [[AutographView alloc]initWithFrame:CGRectMake(60*MCscale, 200*MCscale, kDeviceWidth - 120*MCscale, 200*MCscale)];
}
-(void)initMask
{
    mask = [[UIView alloc]initWithFrame:self.view.bounds];
    mask.backgroundColor = txtColors(83,83,83,0.5);
    mask.alpha = 0;
    autoView = [[AutographView alloc]initWithFrame:CGRectMake(30*MCscale, 200*MCscale, kDeviceWidth - 60*MCscale, 200*MCscale)];
    autoView.autoDelegate = self;
}
#pragma mark 手动签名
-(void)signViewTapClick:(UITapGestureRecognizer *)tap
{
    if (tap.view  == signView) {
        if (isAgree) {
            //签名
            [UIView animateWithDuration:0.3 animations:^{
                mask.alpha = 1;
                [self.view addSubview:mask];
                autoView.alpha = 1;
                [self.view addSubview:autoView];
            }];
        }
        else
        {
            [self promptMessageWithString:@"请阅读并同意开户协议"];
        }
    }
}

#pragma mark AutographViewDelegate(签名)
-(void)setImageWithIndex:(NSInteger)index WithDict:(NSDictionary *)dict
{
    NSLog(@"dddddddddd%@",dict);
    if (index == 0) {
        NSData *imageData = UIImageJPEGRepresentation(dict[@"image"], 0.9);
        if (![dict isEqual:@{}]) {
//            submitBtn.enabled = YES;
//            submitBtn.backgroundColor = txtColors(250, 54, 71, 1);
            signImageView.image = [UIImage imageWithData:imageData];
            NSDictionary *dict111 = @{@"imageName":@"qianming.png",@"image":dict[@"image"]};
            [selectedImageArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                if ([obj isEqual:@{}]) {
                    if ([dict111[@"imageName"] isEqualToString:@"qianming.png"]) {
                        *stop = YES;
                        if (*stop == YES)
                        {
                            [selectedImageArray replaceObjectAtIndex:3 withObject:dict111];
                        }
                    }
                }
                else
                {
                    if ([dict111[@"imageName"] isEqualToString:@"qianming.png"]) {
                        *stop = YES;
                        if (*stop == YES)
                        {
                            [selectedImageArray replaceObjectAtIndex:3 withObject:dict111];
                        }
                    }
                }
            }];
            NSLog(@"selectedImageArray%@",selectedImageArray);
        }
        else
        {
//            submitBtn.enabled = NO;
//            submitBtn.backgroundColor = txtColors(213, 213, 213, 1);
        }
        [UIView animateWithDuration:0.3 animations:^{
            mask.alpha = 0;
            [mask removeFromSuperview];
            [self.view endEditing:YES];
            autoView.alpha = 0;
            [autoView removeFromSuperview];
        }];
    }
    else if (index == 2)
    {
        [UIView animateWithDuration:0.3 animations:^{
            mask.alpha = 0;
            [mask removeFromSuperview];
            [self.view endEditing:YES];
            autoView.alpha = 0;
            [autoView removeFromSuperview];
        }];
    }
}
#pragma mark 上传照片
-(void)imageTapClick:(UITapGestureRecognizer *)tap
{
    imageViewTag = tap.view.tag;
    if (imageViewTag == 1000) {
        yingyezhizhao = @"yingyezhizhao.png";
    }
    else if (imageViewTag == 1001)
    {
        suiwudengjizhen = @"shenfenzheng.png";
    }
    else
    {
        jigoudaima = @"yinhangka.png";
    }
    if (imagePicker == nil) {
        imagePicker = [[UIImagePickerController alloc]init];
    }
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    UIAlertController  *alert = [UIAlertController alertControllerWithTitle:nil message:@"选择图片路径" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancalAction = [UIAlertAction actionWithTitle:@"从相册选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }];
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"照相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }];
    UIAlertAction *cleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:cancalAction];
    [alert addAction:otherAction];
    [alert addAction:cleAction];
    
    UIPopoverPresentationController *popover =alert.popoverPresentationController;
    popover.sourceView = tap.view;
    popover.sourceRect = tap.view.bounds;
    popover.permittedArrowDirections=UIPopoverArrowDirectionAny;
    
    [self presentViewController:alert animated:YES completion:nil];
}



#pragma mark 草稿详情
-(void)selectedCaogaoWithId:(NSString *)ID
{
    MBProgressHUD *mbHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    mbHud.delegate = self;
    mbHud.mode = MBProgressHUDModeIndeterminate;
    mbHud.labelText = @"请稍后...";
    [mbHud show:YES];
    
    NSMutableDictionary *pram =[NSMutableDictionary dictionaryWithDictionary:@{@"dianpu.id":ID}];
    
    [HTTPTool getWithUrl:@"kaihucaogao.action" params:pram success:^(id json) {
        [mbHud hide:YES];
        NSLog(@"草稿详情%@",json);
        
        UITextField *storyNameTextField = [self.view viewWithTag:11000];
        UITextField *nameTextField = [self.view viewWithTag:11002];
        UITextField *phoneTextField = [self.view viewWithTag:11003];
        UITextField *telTextField = [self.view viewWithTag:11004];
        UITextField *addressTextField = [self.view viewWithTag:11006];
        
        NSDictionary *dict = [json valueForKey:@"kaihuinfo"];
        storyNameTextField.text = dict[@"dianpuname"];
        selectedIndustrLabel.text = dict[@"hangye"];
        nameTextField .text = dict[@"lianxiren"];
        phoneTextField.text = dict[@"shoujihao"];
        telTextField.text = dict[@"fuwudianhua"];
        addressTextField.text = dict[@"dingweidizhi"];
        hangyeID = dict[@"hangyeid"];
        latitudeStr = [NSString stringWithFormat:@"%@",dict[@"X"]];
        longitudeStr = [NSString stringWithFormat:@"%@",dict[@"Y"]];
        //普通态
        UIView *locationView = [self.view viewWithTag:12000];
        UIImageView *locationImage = [locationView viewWithTag:13000];
        
        UIView *mapView = [self.view viewWithTag:12001];
        UIImageView *mapImage = [mapView viewWithTag:13001];
        
        if ([dict[@"dingweileixing"]integerValue]== 0) {
            locationImage.image = [UIImage imageNamed:@"选中"];
            mapImage.image = [UIImage imageNamed:@"选择"];
            isMap = 0;
        }
        else
        {
            locationImage.image = [UIImage imageNamed:@"选择"];
            mapImage.image = [UIImage imageNamed:@"选中"];
            isMap = 1;
        }
        NSArray *imageUrl = @[[NSString stringWithFormat:@"%@",dict[@"yingyezhizhao"]],[NSString stringWithFormat:@"%@",dict[@"shenfenzheng"]],[NSString stringWithFormat:@"%@",dict[@"yinhangka"]]];
        
        NSArray *imageArray = @[@"yingyezhizhao",@"shenfenzheng",@"yinghangka"];
        for (int i = 0; i<imageArray.count; i++) {
            UIImageView *image = (UIImageView *)[self.view viewWithTag:(1000+i)];
            [image sd_setImageWithURL:[NSURL URLWithString:imageUrl[i]] placeholderImage:[UIImage imageNamed:imageArray[i]] options:SDWebImageRefreshCached];
        }
        dianpuID = ID;
        kaihufei = dict[@"money"];
        isModify = 1;
        ISImage = 0;
        
        signImageView.image = [UIImage imageNamed:@""];
//        submitBtn.enabled = NO;
//        submitBtn.backgroundColor = txtColors(213, 213, 213, 1);
        
        NSNotification *qingchuSign = [NSNotification notificationWithName:@"qingchuSignClick" object:nil];
        [[NSNotificationCenter defaultCenter]postNotification:qingchuSign];
        [[NSNotificationCenter defaultCenter]removeObserver:self];
    } failure:^(NSError *error) {
        [mbHud hide:YES];
        [self promptMessageWithString:@"网络连接错误1"];
    }];
    [self maskViewDisMiss];
}


#pragma mark ModifyKaihufeiViewDelegate
-(void)modifyKaihufeiWithString:(NSString *)string
{
    if (isModify){
        [self ModifyKaihuWithShenhe:@"2" AndMoney:string];
    }
    else
    {

        [self FabuKaihuWithShenhe:@"2" AndMoney:string];
    }
    
    [self maskViewDisMiss];
}
-(void)submitBtnClick
{
    NSMutableDictionary *pram =[NSMutableDictionary dictionaryWithDictionary:@{@"yuangong.id":user_id}];
    [HTTPTool  postWithUrl:@"zhiyuanYue.action" params:pram success:^(id json) {
        NSLog(@"开户%@",json);
//        [self PaymentSuccess];
//        return ;
        
        if ([[json valueForKey:@"flag"]integerValue] == 1) {
            if ([[json valueForKey:@"message"]integerValue] == 1) {
                [UIView animateWithDuration:0.3 animations:^{
                    maskView.alpha = 1;
                    [self .view addSubview:maskView];
                    passPopView.alpha = 0.95;
                    [self.view addSubview:passPopView];

                }];
            }
            else if([[json valueForKey:@"message"]integerValue] == 2)
            {
                [self promptMessageWithString:@"开户金额不足,请充值"];
            }
            else
            {
                [self promptMessageWithString:@"无此账户"];
            }
        }
        else
        {
            [self promptMessageWithString:@"没有设置支付密码,请前往安全设置中进行设置"];
        }
    } failure:^(NSError *error) {
        [self promptMessageWithString:@"网络连接错误2"];
    }];
}
#pragma mark 发布开户
-(void)FabuKaihuWithShenhe:(NSString *)shenhe AndMoney:(NSString *)money
{
    UITextField *storyNameTextField = [self.view viewWithTag:11000];
    UITextField *nameTextField = [self.view viewWithTag:11002];
    UITextField *phoneTextField = [self.view viewWithTag:11003];

    if ([storyNameTextField.text isEqualToString:@""]
        ||[selectedIndustrLabel.text isEqualToString:@"请选择行业类别"]
        ||[nameTextField.text isEqualToString:@""]
        ||[phoneTextField.text isEqualToString:@""]
        

        ){
        [self promptMessageWithString:@"请完善信息后重试"];
    }
    else
    {
        
        NSDictionary * imageDic = selectedImageArray[2];
        UIImage * image  = imageDic[@"image"];
        if (!image || ![image isKindOfClass:[UIImage class]]) {
            [MBProgressHUD promptWithString:@"请上传资质证书"];
            return;
        }

        if([phoneTextField.text isValidateMobile]){
            NSMutableDictionary *pram =[NSMutableDictionary dictionaryWithDictionary:@{@"dianpu.yidongtel":phoneTextField.text}];
            [HTTPTool  postWithUrl:@"kaihuCheck.action" params:pram success:^(id json) {
                NSLog(@"开户%@",json);
                if ([[json valueForKey:@"message"]integerValue] == 1) {
                    [self promptMessageWithString:@"该手机号已开户,请重新填写"];
                }
                else
                {
                    [MBProgressHUD start];
                    NSMutableDictionary *pram =[NSMutableDictionary dictionaryWithDictionary:@{@"dianpu.dianpuname":storyNameTextField.text,
                                                   @"dianpu.suozaihangyi":hangyeID,
//                                                   @"dianpu.dianpuleixing":[NSString stringWithFormat:@"%d",isMap],
//                                                   @"dianpu.x":longitudeStr,
//                                                   @"dianpu.y":latitudeStr,
                                                   @"dianpu.lianxiren":nameTextField.text,
                                                   @"dianpu.yidongtel":phoneTextField.text,
//                                                   @"dianpu.kefurexian":telTextField.text,
//                                                   @"dianpu.dingweidizhi":addressTextField.text,
                                                   @"dianpu.yingyezhizhao":yingyezhizhao,
                                                   @"dianpu.suiwudengjizhen":suiwudengjizhen,
                                                   @"dianpu.jigoudaima":jigoudaima,
                                                   @"dianpu.shenhe":shenhe,
                                                   @"zhiyuanid":user_id,
                                                   @"money":money,
//                                                   @"dianpu.shifoukaitonghoutai":city
                                                 }];
                    [HTTPTool  postWithUrl:@"kaihu.action" params:pram success:^(id json) {
                        [MBProgressHUD stop];
                        NSLog(@"开户%@",json);
                        if ([[json valueForKey:@"message"]integerValue] == 1) {
                            dianpuID = [NSString stringWithFormat:@"%@",[json valueForKey:@"dianpuid"]];
                            
                            if (ISImage) {
                                [self upLoadImages];
                            }
                            else
                            {
                                MBProgressHUD *mbHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                                mbHud.mode = MBProgressHUDModeCustomView;
                                mbHud.labelText = @"开户成功";
                                mbHud.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"37x-Checkmark"]];
                                [mbHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
                                
                                [self clernDataForKaihu];
                                
                                NSNotification *qingchuSign = [NSNotification notificationWithName:@"qingchuSignClick" object:nil];
                                [[NSNotificationCenter defaultCenter]postNotification:qingchuSign];
                                [[NSNotificationCenter defaultCenter]removeObserver:self];
                            }
                        }
                        else
                        {
                            [self promptMessageWithString:@"请将开户信息填写完整后重试"];
                        }
                    } failure:^(NSError *error) {
                        [MBProgressHUD stop];
                        [self promptMessageWithString:@"网络连接错误3"];
                    }];
                }
            } failure:^(NSError *error) {
                [self promptMessageWithString:@"网络连接错误4"];
            }];
        }
        else
        {
            [self promptMessageWithString:@"请填写正确的手机号码"];
        }
    }
}

#pragma mark 修改开户
-(void)ModifyKaihuWithShenhe:(NSString *)shenhe AndMoney:(NSString *)money
{
    UITextField *storyNameTextField = [self.view viewWithTag:11000];// 
    UITextField *nameTextField = [self.view viewWithTag:11002];
    UITextField *phoneTextField = [self.view viewWithTag:11003];
//    UITextField *telTextField = [self.view viewWithTag:11004];
//    UITextField *addressTextField = [self.view viewWithTag:11006];
    if ([storyNameTextField.text isEqualToString:@""]
        ||[selectedIndustrLabel.text isEqualToString:@"请选择行业类别"]
        ||[nameTextField.text isEqualToString:@""]
        ||[phoneTextField.text isEqualToString:@""]
//        ||[telTextField.text isEqualToString:@""]
//        ||[addressTextField.text isEqualToString:@""]
//        ||[longitudeStr isEqualToString:@""]
//        ||[latitudeStr isEqualToString:@""]
        ){
        [self promptMessageWithString:@"请完善信息后重试"];
    }
    else
    {

        if([phoneTextField.text isValidateMobile]){
            NSMutableDictionary *pram =[NSMutableDictionary dictionaryWithDictionary:@{@"dianpu.yidongtel":phoneTextField.text}];
            [HTTPTool  postWithUrl:@"kaihuCheck.action" params:pram success:^(id json) {
                NSLog(@"验证手机号%@",json);
                
                if ([[json valueForKey:@"message"]integerValue] == 1) {
                    [self promptMessageWithString:@"该手机号已开户,请重新填写"];
                }
                else
                {
                    [MBProgressHUD start];

                    NSMutableDictionary *pram =[NSMutableDictionary dictionaryWithDictionary:
                                               @{
                                                 @"dianpu.id":dianpuID,
                                                 @"dianpu.dianpuname":storyNameTextField.text,
                                                 @"dianpu.suozaihangyi":hangyeID,
//                                                 @"dianpu.dianpuleixing":[NSString stringWithFormat:@"%d",isMap],
//                                                 @"dianpu.x":latitudeStr,
//                                                 @"dianpu.y":longitudeStr,
                                                 @"dianpu.lianxiren":nameTextField.text,
                                                 @"dianpu.yidongtel":phoneTextField.text,
//                                                 @"dianpu.kefurexian":telTextField.text,
//                                                 @"dianpu.dingweidizhi":addressTextField.text,
                                                 @"dianpu.yingyezhizhao":yingyezhizhao,
                                                 @"dianpu.suiwudengjizhen":suiwudengjizhen,
                                                 @"dianpu.jigoudaima":jigoudaima,
                                                 @"dianpu.shenhe":shenhe,
                                                 @"zhiyuanid":user_id,
                                                 @"money":money
                                                 }
                                                ];
                    
                    [HTTPTool postWithUrl:@"updateKaihuCaogao.action" params:pram success:^(id json) {
                        [MBProgressHUD stop];
                        NSLog(@"修改开户%@",json);
                        if ([[json valueForKey:@"message"]integerValue] == 1) {
                            if (ISImage) {
                                [self upLoadImages];
                            }
                            else
                            {
                                [self clernDataForKaihu];
                                MBProgressHUD *mbHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                                mbHud.mode = MBProgressHUDModeCustomView;
                                mbHud.labelText = @"开户成功";
                                mbHud.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"37x-Checkmark"]];
                                [mbHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
                                NSNotification *qingchuSign = [NSNotification notificationWithName:@"qingchuSignClick" object:nil];
                                [[NSNotificationCenter defaultCenter]postNotification:qingchuSign];
                                [[NSNotificationCenter defaultCenter]removeObserver:self];
                            }
                        }
                        else if ([[json valueForKey:@"message"]integerValue] ==2)
                        {
                            [self promptMessageWithString:@" 修改草稿信息失败"];
                        }
                        else
                        {
                            [self promptMessageWithString:@"请将开户信息填写完整后重试"];
                        }
                    } failure:^(NSError *error){
                        [MBProgressHUD stop];
                        [self promptMessageWithString:@"网络连接错误5"];
                    }];
                }
            } failure:^(NSError *error) {
                [self promptMessageWithString:@"网络连接错误6"];
            }];
        }
        else
        {
            [self promptMessageWithString:@"请填写正确的手机号码"];
        }
    }
}


#pragma mark 清空数据
-(void)clernDataForKaihu
{
    UITextField *storyNameTextField = [self.view viewWithTag:11000];
    UITextField *nameTextField = [self.view viewWithTag:11002];
    UITextField *phoneTextField = [self.view viewWithTag:11003];
    UITextField *telTextField = [self.view viewWithTag:11004];
    UITextField *addressTextField = [self.view viewWithTag:11006];
    
    nameTextField.text = @"";
    storyNameTextField.text = @"";
    phoneTextField.text = @"";
    telTextField.text = @"";
    addressTextField.text = @"";
    selectedIndustrLabel.text = @"请选择行业类别";
    UIView *locationView = [self.view viewWithTag:12000];
    UIImageView *locationImage = [locationView viewWithTag:13000];
    UIView *mapView = [self.view viewWithTag:12001];
    UIImageView *mapImage = [mapView viewWithTag:13001];
    locationImage.image = [UIImage imageNamed:@"选中"];
    mapImage.image = [UIImage imageNamed:@"选择"];
    isMap = 0;
    isModify = 0;
    ISImage = 0;
    hangyeID = @"";
    latitudeStr = @"";
    longitudeStr = @"";
    city = @"";
    signImageView.image = [UIImage imageNamed:@""];
//    submitBtn.enabled = NO;
//    submitBtn.backgroundColor = txtColors(213, 213, 213, 1);
    
    NSArray *imageArray = @[@"yingyezhizhao",@"shenfenzheng",@"yinghangka"];
    for (int i = 0; i<imageArray.count; i++) {
        UIImageView *image = (UIImageView *)[self.view viewWithTag:(1000+i)];
        image.image = [UIImage imageNamed:imageArray[i]];
    }
    [selectedImageArray replaceObjectAtIndex:0 withObject:@{}];
    [selectedImageArray replaceObjectAtIndex:1 withObject:@{}];
    [selectedImageArray replaceObjectAtIndex:2 withObject:@{}];
    [selectedImageArray replaceObjectAtIndex:3 withObject:@{}];
}

#pragma mark 上传图片
-(void)upLoadImages
{
    NSLog(@"selectedImageArrayselectedImageArray%@",selectedImageArray);
    
    for (NSDictionary *dict in selectedImageArray) {
        NSLog(@"dictdict%@",dict);
        UIImage *image = dict[@"image"];
        NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"dianpuid":[NSString stringWithFormat:@"%@",dianpuID]}];
        
        AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
        //网络延时设置15秒
        manger.requestSerializer.timeoutInterval = 15;
        NSString *url = @"fileuploadDianpuInfo.action";
        NSString * urlPath = [NSString stringWithFormat:@"%@%@",HTTPImage,url];
        [manger POST:urlPath parameters:pram constructingBodyWithBlock:^(id<AFMultipartFormData> formData){
            if (![dict isEqual:@{}]) {
                NSData *imageData = UIImageJPEGRepresentation(image, 0.9);
                NSString *fileName = [NSString stringWithFormat:@"%@",dict[@"imageName"]];
                [formData appendPartWithFileData:imageData name:@"file" fileName:fileName mimeType:@"image/jpeg"];
            }
        }success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self clernDataForKaihu];
            NSNotification *qingchuSign = [NSNotification notificationWithName:@"qingchuSignClick" object:nil];
            [[NSNotificationCenter defaultCenter]postNotification:qingchuSign];
            [[NSNotificationCenter defaultCenter]removeObserver:self];
            MBProgressHUD *mbHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            mbHud.mode = MBProgressHUDModeCustomView;
            mbHud.labelText = @"开户成功";
            mbHud.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"37x-Checkmark"]];
            [mbHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        }];
    }
}
#pragma  mark  PaymentPasswordViewDelegate
-(void)PaymentSuccess
{
    [UIView animateWithDuration:0.3 animations:^{
        maskView.alpha = 0;
        [maskView removeFromSuperview];
        [self setEditing:YES];
        passPopView.alpha = 0;
        [passPopView removeFromSuperview];
    }];
    
    if (isModify) {//  提取出来的 数据
        [self ModifyKaihuWithShenhe:@"0" AndMoney:kaihufei];
    }
    else
    {             //   填写的数据
        set_User_Kaihufei(@"1365");
        [self FabuKaihuWithShenhe:@"0" AndMoney:[NSString stringWithFormat:@"%@",user_kaihufei]];
    }
}
#pragma mark UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    [picker dismissViewControllerAnimated:YES completion:^{
        UIImageView *imageView = [self.view viewWithTag:imageViewTag];
        imageView.image = image;
        ISImage = 1;
        NSString *imageName;
        if (imageViewTag == 1000) {
            imageName = @"yingyezhizhao.png";
        }
        else if (imageViewTag == 1001)
        {
            imageName = @"shenfenzheng.png";
        }
        else
        {
            imageName = @"yinhangka.png";
        }
        NSDictionary *dict = @{@"imageName":imageName,@"image":image};
        [selectedImageArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([obj isEqual:@{}]) {
                if ([dict[@"imageName"] isEqualToString:@"yingyezhizhao.png"]) {
                    *stop = YES;
                    if (*stop == YES)
                    {
                        [selectedImageArray replaceObjectAtIndex:0 withObject:dict];
                    }
                }
                else if([dict[@"imageName"] isEqualToString:@"shenfenzheng.png"])
                {
                    *stop = YES;
                    if (*stop == YES)
                    {
                        [selectedImageArray replaceObjectAtIndex:1 withObject:dict];
                    }
                }
                else if([dict[@"imageName"] isEqualToString:@"yinhangka.png"])
                {
                    *stop = YES;
                    if (*stop == YES)
                    {
                        [selectedImageArray replaceObjectAtIndex:2 withObject:dict];
                    }
                }
            }
            else
            {
                if ([dict[@"imageName"] isEqualToString:@"yingyezhizhao.png"]) {
                    *stop = YES;
                    if (*stop == YES)
                    {
                        [selectedImageArray replaceObjectAtIndex:0 withObject:dict];
                    }
                }
                else if([dict[@"imageName"] isEqualToString:@"shenfenzheng.png"])
                {
                    *stop = YES;
                    if (*stop == YES)
                    {
                        [selectedImageArray replaceObjectAtIndex:1 withObject:dict];
                    }
                }
                else if([dict[@"imageName"] isEqualToString:@"yinhangka.png"])
                {
                    *stop = YES;
                    if (*stop == YES)
                    {
                        [selectedImageArray replaceObjectAtIndex:2 withObject:dict];
                    }
                }
            }
        }];
        NSLog(@"%@selectedImageArray",selectedImageArray);
    }];
}
-(void)viewTapClick:(UITapGestureRecognizer *)tap
{
    UIView *locationView = [self.view viewWithTag:12000];
    UIImageView *locationImage = [locationView viewWithTag:13000];
    
    UIView *mapView = [self.view viewWithTag:12001];
    UIImageView *mapImage = [mapView viewWithTag:13001];
    
    if(tap.view == industryView)
    {
        
        ReviewSelectedView * sele = [ReviewSelectedView new];
        [sele appear];
        [sele reloadDataWithViewTag:7];
        sele.block=^(id data){
            selectedIndustrLabel.text = [NSString stringWithFormat:@"%@",[data valueForKey:@"name"]];
            hangyeID = [NSString stringWithFormat:@"%@",[data valueForKey:@"id"]];
        };
        
    }
    else if (tap.view == locationView)
    {
        locationImage.image = [UIImage imageNamed:@"选中"];
        mapImage.image = [UIImage imageNamed:@"选择"];
        isMap = 0;
        [self locationAndUpdateView];
    }
    else if (tap.view == mapView)
    {
        locationImage.image = [UIImage imageNamed:@"选择"];
        mapImage.image = [UIImage imageNamed:@"选中"];
        isMap = 1;
        
        
        GetLocationView * location = [GetLocationView new];
        PHMapHelper * helper = [PHMapHelper new];
        
        [location appear];
        location.block=^(double  latitude,double longitude){
            latitudeStr=[NSString stringWithFormat:@"%f",latitude];
            longitudeStr = [NSString stringWithFormat:@"%f",longitude];
                 [helper regeoWithLocation:CLLocationCoordinate2DMake(latitude, longitude) block:^(BMKReverseGeoCodeResult *result, BMKSearchErrorCode error) {
                     if (error) {
                         [MBProgressHUD promptWithString:@"地理编码失败"];
                         return ;
                     }
                     city = result.addressDetail.city;
                 }];
        };
 
    }
    else if (tap.view ==  protocolView)
    {
        isAgree = !isAgree;
        if (isAgree) {
            protocolImage.image = [UIImage imageNamed:@"选中"];
        }
        else{
            protocolImage.image = [UIImage imageNamed:@"选择"];
        }
    }
    else if (tap.view == xieyiLabel)
    {
        UseDirectionViewController *agr = [[UseDirectionViewController alloc]init];
        if (isModify) {
            agr.pageUrl = [NSString stringWithFormat:@"%@/useXieyi.action?dianpuid=%@",HTTPImage,dianpuID];
        }
        else
        {
            agr.pageUrl = [NSString stringWithFormat:@"%@shiyongxieyi.jsp",HTTPWeb];
        }
        agr.titStr = @"系统使用协议";
        agr.hidesBottomBarWhenPushed = YES;
        UIBarButtonItem *bar=[[UIBarButtonItem alloc]init];
        bar.title=@"";
        //            bar.image = [UIImage imageNamed:@"返回"];
        self.navigationItem.backBarButtonItem=bar;
        [self.navigationController pushViewController:agr animated:YES];
    }
}

/**
 *  获取当前位置  并且获取当前城市 并且赋值给属性
 */
-(void)locationAndUpdateView{
    PHMapHelper * helper = [PHMapHelper new];
    [helper locationStartLocation:^{
    } locationing:^(BMKUserLocation *location, NSError *error) {
        latitudeStr = [NSString stringWithFormat:@"%f",location.location.coordinate.latitude];
        longitudeStr = [NSString stringWithFormat:@"%f",location.location.coordinate.longitude];
        
        [helper regeoWithLocation:CLLocationCoordinate2DMake(location.location.coordinate.latitude, location.location.coordinate.longitude) block:^(BMKReverseGeoCodeResult *result, BMKSearchErrorCode error) {
            if (error) {
                [MBProgressHUD promptWithString:@"地理编码失败"];
                return ;
            }
            city = result.addressDetail.city;
        }];
        [helper endLocation];
    } stopLocation:^{
    }];

}

-(void)custom:(UITextField *)textField AndString:(NSString *)string
{
    textField.placeholder = string;
    textField.textAlignment = NSTextAlignmentRight;
    textField.font = [UIFont systemFontOfSize:MLwordFont_4];
    textField.textColor = textColors;
    textField.delegate = self;
    textField.returnKeyType = UIReturnKeyDone;
    textField.backgroundColor = [UIColor clearColor];
    [self.view addSubview:textField];
}
-(void)customLabel:(UILabel *)label AndString:(NSString *)string
{
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:MLwordFont_4];
    label.textColor = textColors;
    label.textAlignment = NSTextAlignmentLeft;
    label.text = string;
}

-(void)maskViewDisMiss
{
    [UIView animateWithDuration:0.3 animations:^{
        maskView.alpha = 0;
        [maskView removeFromSuperview];
        [self.view endEditing:YES];

        bubbleView.alpha = 0;
        [bubbleView removeFromSuperview];
        kaihufeiView.alpha = 0;
        [kaihufeiView removeFromSuperview];

        passPopView.alpha = 0;
        [passPopView removeFromSuperview];
    }];
}


-(void)viewDidAppear:(BOOL)animated
{
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    UITextField *storyNameTextField = [self.view viewWithTag:11000];
    UITextField *nameTextField = [self.view viewWithTag:11002];
    UITextField *phoneTextField = [self.view viewWithTag:11003];
    UITextField *telTextField = [self.view viewWithTag:11004];
    UITextField *addressTextField = [self.view viewWithTag:11006];
    
    [storyNameTextField resignFirstResponder];
    [nameTextField resignFirstResponder];
    [phoneTextField resignFirstResponder];
    [telTextField resignFirstResponder];
    [addressTextField resignFirstResponder];
    return YES;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    UITextField *phoneTextField = [self.view viewWithTag:11003];
    if(textField == phoneTextField){
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

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITextField *storyNameTextField = [self.view viewWithTag:11000];
    UITextField *nameTextField = [self.view viewWithTag:11002];
    UITextField *phoneTextField = [self.view viewWithTag:11003];
    UITextField *telTextField = [self.view viewWithTag:11004];
    UITextField *addressTextField = [self.view viewWithTag:11006];
    
    [storyNameTextField resignFirstResponder];
    [nameTextField resignFirstResponder];
    [phoneTextField resignFirstResponder];
    [telTextField resignFirstResponder];
    [addressTextField resignFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

@end
