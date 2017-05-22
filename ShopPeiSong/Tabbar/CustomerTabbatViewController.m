//
//  CustomerTabbatViewController.m
//  ShopPeiSong
//
//  Created by MIAO on 2017/3/6.
//  Copyright © 2017年 时元尚品. All rights reserved.
//

#import "CustomerTabbatViewController.h"
#import "PlatformViewController.h"
#import "OrdersViewController.h"
#import "MeViewController.h"
#import "Header.h"



#pragma mark --  little class
@interface PHTabbarButton()
@property (nonatomic,strong)UIImageView * img;
@property (nonatomic,strong)UILabel     * label;

@end
@implementation PHTabbarButton
-(UIImageView *)img{
    if (!_img) {
        _img=[[UIImageView alloc]initWithFrame:CGRectMake(0, 5, 25, 25)];
        [self addSubview:_img];
    }
    return _img;
}
-(UILabel *)label{
    if (!_label) {
        _label=[[UILabel alloc]initWithFrame:CGRectMake(0, self.img.frame.origin.y+self.img.frame.size.height+2, 20, 20)];
        _label.font=[UIFont systemFontOfSize:12];
        [self addSubview:_label];
        
    }
    return _label;
}
-(void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    [self upDateData];
    
}
-(void)upDateData{
    
    [_img setImage:self.selected?[self imageForState:UIControlStateSelected]:[self imageForState:UIControlStateNormal]];
    self.img.center=CGPointMake(self.frame.size.width/2, self.img.center.y);
    
    
    
    [self.label setText:self.selected?[self titleForState:UIControlStateSelected]:[self titleForState:UIControlStateNormal]];
    [self.label setTextColor:self.selected?[self titleColorForState:UIControlStateSelected]:[self titleColorForState:UIControlStateNormal]];
    [self.label sizeToFit];
    self.label.center=CGPointMake(self.frame.size.width/2, self.label.center.y);
    
    
    self.imageView.hidden=YES;
    self.titleLabel.hidden=YES;
}
-(void)setTitle:(NSString *)title forState:(UIControlState)state{
    [super setTitle:title forState:state];
    [self upDateData];
}
-(void)setImage:(UIImage *)image forState:(UIControlState)state{
    [super setImage:image forState:state];
    [self upDateData];
}
-(void)layoutSubviews{
    [super layoutSubviews];
    [self upDateData];
}

@end






#define ItemGap 10*MCscale
@interface CustomerTabbatViewController ()

@property(nonatomic,strong)NSArray *imageArray,*titleArray,*classArray,*selectedArray;
@end

@implementation CustomerTabbatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTabbar];

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    

    
}

-(NSArray *)imageArray
{
    if (!_imageArray) {
        _imageArray = @[@"label_1",@"label_2",@"label_3"];
    }
    return _imageArray;
}
-(NSArray *)titleArray
{
    if (!_titleArray) {
        _titleArray = @[@"平台",@"接单",@" 我 "];
    }
    return _titleArray;
}

-(NSArray *)classArray
{
    if (!_classArray) {
        _classArray = @[@"PlatformViewController",@"OrdersViewController",@"MeViewController"];
    }
    return _classArray;
}

-(NSArray *)selectedArray
{
    if (!_selectedArray) {
        _selectedArray = @[@"label_one_one",@"label_two_one",@"label_three_one"];
    }
    return _selectedArray;
}
-(void)setTabbar
{
    NSMutableArray *controllers = [[NSMutableArray alloc]init];
    for (NSString *title in self.classArray) {
        Class class = NSClassFromString(title);
        UIViewController *controller = [[class  alloc]init];
        controller.view.backgroundColor = [UIColor whiteColor];
        UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:controller];
        
        UINavigationBar *bar = navi.navigationBar;
        bar.translucent = YES;
        [bar setBarTintColor:txtColors(25, 182, 132, 1)];
        bar.tintColor = [UIColor whiteColor];
        [bar setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:17],NSForegroundColorAttributeName:[UIColor whiteColor]}];
        [controllers addObject:navi];
    }
    self.viewControllers = controllers;
    
    UIImageView *tabImageView = [BaseCostomer imageViewWithFrame:CGRectMake(0, 0, kDeviceWidth, 49) backGroundColor:txtColors(49, 197, 155, 1) cornerRadius:0 userInteractionEnabled:YES image:@""];
    tabImageView.tag = 10;
    self.tabBar.frame = CGRectMake(0, kDeviceHeight-49, kDeviceWidth, 49);
    [self.tabBar addSubview:tabImageView];
    
    CGFloat itemWidth = (kDeviceWidth - (self.classArray.count +1)*ItemGap)/self.classArray.count;
    for (int i = 0; i<self.classArray.count; i++) {
//        UIButton *button = [BaseCostomer buttonWithFrame:CGRectMake(ItemGap+(ItemGap+itemWidth)*i, 0, itemWidth, 49) font:[UIFont boldSystemFontOfSize:MLwordFont_9] textColor:txtColors(100, 100, 100, 1) backGroundColor:[UIColor clearColor] cornerRadius:0 text:self.titleArray[i] image:self.imageArray[i]];
//       
        
//        
       PHTabbarButton * button = [[PHTabbarButton alloc]initWithFrame:CGRectMake(ItemGap+(ItemGap+itemWidth)*i, 0, itemWidth, 49)];
        [button setBackgroundColor:[UIColor clearColor]];
        
        [button setTitle:self.titleArray[i] forState:UIControlStateNormal];

        
        
        
        button.tag = i+99;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self customerButton:button];
        [tabImageView addSubview:button];
    }
}

-(void)customerButton:(UIButton *)button
{
    
    
//    button.imageEdgeInsets = UIEdgeInsetsMake(5*MCscale, 25*MCscale, 20*MCscale, 25*MCscale);
//    button.titleEdgeInsets = UIEdgeInsetsMake(49 -18*MCscale, -60*MCscale, 2*MCscale,0);
//    button.imageView.contentMode=UIViewContentModeScaleAspectFit;
    
    
    [button setTitleColor:txtColors(34, 253, 189, 1) forState:UIControlStateSelected];
    [button setTitleColor:textBlackColor forState:UIControlStateNormal];
    NSInteger index = button.tag - 99;
    
    [button setImage:[UIImage imageNamed:self.selectedArray[index]] forState:UIControlStateSelected];
    [button setImage:[UIImage imageNamed:self.imageArray[index]] forState:UIControlStateNormal];
    if (index == 0) {
        button.selected = YES;
        self.selectedIndex = index;
    }
}
-(void)buttonClick:(UIButton *)sender
{
    
    UIImageView *imageView = [(UIImageView *)self.tabBar viewWithTag:10];
    NSArray *subview = imageView.subviews;
    NSInteger index = sender.tag - 99;
    self.selectedIndex = index;
    for (UIButton *button in subview) {
        button.selected = NO;
    }
    sender.selected = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setCustomIndex:(NSInteger)index{
   UIButton * btn= [self.tabBar viewWithTag:index+99];
    [self buttonClick:btn];
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
