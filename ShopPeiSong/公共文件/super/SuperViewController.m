//
//  SuperViewController.m
//  ShopPeiSong
//
//  Created by MIAO on 2017/5/12.
//  Copyright © 2017年 妙灵科技. All rights reserved.
//

#import "SuperViewController.h"

@interface SuperViewController ()

@end

@implementation SuperViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    [self setNavigationItem];

    // Do any additional setup after loading the view.
}
-(void)setNavigationItem
{
    self.navigationController.navigationBar.tintColor=naviBarTintColor;
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:MLwordFont_2],NSFontAttributeName, nil]];
    
    
    UIButton * leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, NVbtnWight, NVbtnWight)];
    [leftBtn setImage:[UIImage imageNamed:@"返回按钮"] forState:UIControlStateNormal];
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    [leftBtn addTarget:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = leftItem;

}
-(void)pop{
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
