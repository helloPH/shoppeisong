//
//  GuideViewController.m
//  ShopPeiSong
//
//  Created by MIAO on 2017/6/27.
//  Copyright © 2017年 妙灵科技. All rights reserved.
//

#import "GuideViewController.h"
#import "GestureViewController.h"



@interface GuideViewController ()

@end

@implementation GuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self newView];
    
    self.view.alpha=1;
    [UIView animateWithDuration:3 animations:^{
        self.view.alpha=0.95;
    }completion:^(BOOL finished) {
        [self tapAction:nil];
    }];
    // Do any additional setup after loading the view.
}
-(void)newView{
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    [self.view addSubview:imageView];
    imageView.image=[UIImage imageNamed:@"lauch"];
    imageView.userInteractionEnabled=YES;
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [imageView addGestureRecognizer:tap];
}

-(void)tapAction:(UITapGestureRecognizer *)tap{
    GestureViewController *gestureVC = [[GestureViewController alloc]init];
    [UIApplication sharedApplication].delegate.window.rootViewController = gestureVC;
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
