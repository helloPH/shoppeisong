//
//  LoginViewController.m
//  ShopPeiSong
//
//  Created by MIAO on 2017/5/12.
//  Copyright © 2017年 妙灵科技. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()
@property (nonatomic,strong)UIScrollView * mainScrollView;


@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    [self newView];
    // Do any additional setup after loading the view.
}
-(void)initData{
    
}
-(void)reshData{
    
    
    
}
-(void)reshView{
    
    
    
}
-(void)newNavi{
    
}
-(void)newView{
    self.mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
    self.mainScrollView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:self.mainScrollView];
    
    

    
    
    CGFloat setY = 40*MCscale;
    for (int i = 0 ; i < 4 ; i ++) {
        CGFloat fieldW = kDeviceWidth - 40*MCscale;
        CGFloat fieldH = 50*MCscale;
        
        CGFloat fieldX = 20*MCscale;
        CGFloat fieldY = setY;

    
        UITextField * field = [[UITextField alloc]initWithFrame:CGRectMake(fieldX, fieldY, fieldW, fieldH)];
        [_mainScrollView addSubview:field];
    
        
    }
    
    UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(20*MCscale, setY +40*MCscale, kDeviceWidth-40*MCscale, 30*MCscale)];
    [btn setTitle:@"登录" forState:UIControlStateNormal];
    
    
    
    
    
    
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
