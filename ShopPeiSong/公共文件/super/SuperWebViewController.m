//
//  SuperWebViewController.m
//  ShopPeiSong
//
//  Created by MIAO on 2017/7/18.
//  Copyright © 2017年 妙灵科技. All rights reserved.
//

#import "SuperWebViewController.h"

@interface SuperWebViewController ()
@property (nonatomic,strong)NSString * naviTitle;
@property (nonatomic,strong)NSString * urlString;

@property (nonatomic,strong)UIWebView * webView;
@end

@implementation SuperWebViewController
+(instancetype)insWithTitle:(NSString *)title urlString:(NSString *)urlString{
    SuperWebViewController * webC = [SuperWebViewController new];
    webC.naviTitle= title;
    webC.urlString = urlString;
    [webC newView];
    return webC;
}

-(void)newView{
    self.navigationItem.title = _naviTitle;
    
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    [self.view addSubview:_webView];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_urlString]]];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
