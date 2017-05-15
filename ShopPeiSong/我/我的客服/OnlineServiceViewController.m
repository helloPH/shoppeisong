//
//  OnlineServiceViewController.m
//  LifeForMM
//
//  Created by HUI on 16/3/29.
//  Copyright © 2016年 时元尚品. All rights reserved.
//

#import "OnlineServiceViewController.h"
#import "Header.h"
#import "feedbackViewController.h"
@interface OnlineServiceViewController ()<UIGestureRecognizerDelegate>

@property(nonatomic,strong)UIWebView *mainWebView;
@property(nonatomic,strong)UIButton *leftButton,*rightButton;
@end

@implementation OnlineServiceViewController
{
    UIImageView *caozuotishiImage;
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBarTintColor:txtColors(4, 196, 153, 1)];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    /*  --- 手势返回 (系统) --- */
    __weak typeof (self) weakSelf = self;
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        self.navigationController.interactivePopGestureRecognizer.delegate = weakSelf;
    }
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.alpha = 0.95;
    //初始化导航栏
    [self initNavigation];
    //获取数据
    [self reloadData];
}

-(UIWebView *)mainWebView
{
    if (!_mainWebView) {
        _mainWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, kDeviceWidth, kDeviceHeight-64)];
        _mainWebView.backgroundColor = [UIColor whiteColor];
        _mainWebView.scalesPageToFit = YES;//自动放缩适应屏幕
        _mainWebView.opaque = NO;
        [self.view addSubview:_mainWebView];
    }
    return _mainWebView;
}

-(UIButton *)leftButton
{
    if (!_leftButton) {
        _leftButton = [BaseCostomer buttonWithFrame:CGRectMake(0, 0, NVbtnWight, NVbtnWight) backGroundColor:[UIColor clearColor] text:@"" image:@"返回按钮"];
        [_leftButton addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftButton;
}
-(UIButton *)rightButton
{
    if (!_rightButton) {
        _rightButton = [BaseCostomer buttonWithFrame:CGRectMake(0, 0, NVbtnWight, NVbtnWight) backGroundColor:[UIColor clearColor] text:@"" image:@"反馈"];
        [_rightButton addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightButton;
}
//-(void)judgeTheFirst
//{
//    if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"isFirstFankui"] integerValue] == 1) {
//        NSString *url = @"images/caozuotishi/fankui.png";
//        NSString * urlPath = [NSString stringWithFormat:@"%@%@",HTTPWeb,url];
//        caozuotishiImage = [[UIImageView alloc]initWithFrame:CGRectMake(0,-10, kDeviceWidth, kDeviceHeight)];
//        caozuotishiImage.alpha = 0.9;
//        caozuotishiImage.userInteractionEnabled = YES;
//        [caozuotishiImage sd_setImageWithURL:[NSURL URLWithString:urlPath]];
//        UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageHidden:)];
//        [caozuotishiImage addGestureRecognizer:imageTap];
//        [self.view addSubview:caozuotishiImage];
//    }
//}

//-(void)imageHidden:(UITapGestureRecognizer *)tap
//{
//    [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"isFirstFankui"];
//    [caozuotishiImage removeFromSuperview];
//}
////初始化导航
-(void)initNavigation
{
    self.navigationItem.title = @"在线客服";
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:MLwordFont_2],NSFontAttributeName,nil]];
    UIBarButtonItem *leftbarBtn = [[UIBarButtonItem alloc]initWithCustomView:self.leftButton];
    self.navigationItem.leftBarButtonItem =leftbarBtn;
    
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.rightButton];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
}
//获取数据
-(void)reloadData
{
    NSString *urlStr = [NSString stringWithFormat:@"%@/MshcShop/zaixiankefu.jsp?userid=%@",HTTPWeb,user_id];
    NSURL *url =[NSURL URLWithString:urlStr];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    [self.mainWebView loadRequest:request];
    
    //    [self judgeTheFirst];
}
//返回按钮 事件
-(void)btnAction:(UIButton *)btn
{
    if (btn == self.leftButton) {
        if (_isOrder) { //在订单页面进入
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        }
        else{//非订单页进去
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }else
    {
        feedbackViewController *vc = [[feedbackViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
@end
