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
@interface InvitationViewController ()<UIGestureRecognizerDelegate>

@property(nonatomic,strong)UIImageView *yaoqingImageView;
@property(nonatomic,strong)UIButton *leftButton,*invitationBtn;
@end

@implementation InvitationViewController

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
        _yaoqingImageView = [BaseCostomer imageViewWithFrame:CGRectMake(0, 64 , kDeviceWidth, kDeviceHeight - 64 - 50*MCscale) backGroundColor:[UIColor clearColor] image:@""];
        [self.view addSubview:_yaoqingImageView];
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
        _invitationBtn = [BaseCostomer buttonWithFrame:CGRectMake(0, self.yaoqingImageView.bottom, kDeviceWidth, 50*MCscale) font:[UIFont systemFontOfSize:MLwordFont_2] textColor:[UIColor whiteColor] backGroundColor:txtColors(25, 179, 130, 1) cornerRadius:0 text:@"开户" image:@""];
        [_invitationBtn addTarget:self action:@selector(invitationBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _invitationBtn;
}
-(void)setNavigationItem
{
    [self.navigationItem setTitle:@"邀请领现金"];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:MLwordFont_2],NSFontAttributeName, nil]];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:self.leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
}

-(void)invitationBtnClick
{
//开户
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


