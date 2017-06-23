//
//  InvitationViewController.m
//  ShopPeiSong
//
//  Created by MIAO on 2017/3/10.
//  Copyright © 2017年 时元尚品. All rights reserved.
//

#import "InvitationViewController.h"
#import "OpenAccountViewController.h"
#import "Header.h"
#import "SuperNavigationView.h"

@interface InvitationViewController ()<UIGestureRecognizerDelegate>
@property (nonatomic,strong)SuperNavigationView * navi;

@property(nonatomic,strong)UIImageView *yaoqingImageView;
@property(nonatomic,strong)UIButton *leftButton,*invitationBtn;

@end

@implementation InvitationViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden=YES;
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden=NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    __weak typeof (self) weakSelf = self;
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        self.navigationController.interactivePopGestureRecognizer.delegate = weakSelf;
    }
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavigationItem];

    
    NSString *imageStr = [NSString stringWithFormat:@"%@images/xitong/kaihu.png",HTTPHEADER];
    NSURL *url = [NSURL URLWithString:imageStr];
    [self.yaoqingImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@""] options:SDWebImageRefreshCached];
    [self.view addSubview:self.invitationBtn];
}

-(UIImageView *)yaoqingImageView
{
    if (!_yaoqingImageView) {
        _yaoqingImageView = [BaseCostomer imageViewWithFrame:CGRectMake(0, 0 , kDeviceWidth, kDeviceHeight  - 50*MCscale) backGroundColor:[UIColor clearColor] image:@""];
        [self.view addSubview:_yaoqingImageView];
        [self.view bringSubviewToFront:_navi];
        
        
    }
    return _yaoqingImageView;
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

-(UIButton *)invitationBtn
{
    if (!_invitationBtn) {
        _invitationBtn = [BaseCostomer buttonWithFrame:CGRectMake(0, self.yaoqingImageView.bottom, kDeviceWidth, 50*MCscale) font:[UIFont systemFontOfSize:MLwordFont_2] textColor:[UIColor whiteColor] backGroundColor:naviBarTintColor cornerRadius:0 text:@"邀请注册" image:@""];
        [_invitationBtn addTarget:self action:@selector(invitationBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _invitationBtn;
}
-(void)setNavigationItem
{
    
    _navi = [SuperNavigationView new];
    [_navi.leftBtn setBackgroundImage:[UIImage imageNamed:@"返回按钮"] forState:UIControlStateNormal];
    [self.view addSubview:_navi];
    
    __weak InvitationViewController * weakSelf = self;
    _navi.block=^(NSInteger index){
        if (index==0) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    };
//    [self.navigationItem setTitle:@"邀请领现金"];
//    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:MLwordFont_2],NSFontAttributeName, nil]];
//    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:self.leftButton];
//    self.navigationItem.leftBarButtonItem = leftItem;
}

-(void)invitationBtnClick
{
//开户
    if ([user_dianpu_banben isEqualToString:@"0"] || [user_dianpu_banben isEqualToString:@"1"]) {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"" message:@"商铺权限暂不能为好友注册" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    OpenAccountViewController *openAccountVC = [[OpenAccountViewController alloc]init];
    openAccountVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:openAccountVC animated:YES];
}
-(void)btnAction:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
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


