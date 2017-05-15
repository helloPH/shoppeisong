//
//  OrderDetailDrawerView.m
//  ShopPeiSong
//
//  Created by MIAO on 2017/3/31.
//  Copyright © 2017年 妙灵科技. All rights reserved.
//

#import "OrderDetailDrawerView.h"
#import "Header.h"
@interface OrderDetailDrawerView ()
@property (nonatomic,strong)NSArray *nameArray,*imageArray;

@end
@implementation OrderDetailDrawerView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 15.0;
        self.layer.shadowRadius = 5.0;
        self.layer.shadowOpacity = 0.5;
        self.alpha = 0.95;
        self.layer.shadowOffset = CGSizeMake(0, 0);
        [self createUI];
    }
    return self;
}

-(NSArray *)nameArray
{
    if (!_nameArray) {
        _nameArray = @[@"修改附加",@"实付退差",@"商户热线",@"取消订单",@"提交修改",@"增加商品",@"送货导航",@"",@"取货导航",@"",@"",@""];
    }
    return _nameArray;
}
-(NSArray *)imageArray
{
    if (!_imageArray) {
        _imageArray = @[@"k1",@"k2",@"k3",@"k4",@"k5",@"k6",@"k7",@"",@"k8",@"",@"",@""];
    }
    return _imageArray;
}
-(void)createUI
{
    float btnWidth = self.width/3.0-1;
    float btnHeight = (self.height-25)/4.0-1;
    for (int i = 0; i <4; i++) {
        for (int j = 0; j<3 ; j++) {
            UIButton *button = [BaseCostomer buttonWithFrame:CGRectMake((btnWidth+1)*j, (btnHeight+1)*i+15*MCscale, btnWidth, btnHeight) font:[UIFont systemFontOfSize:MLwordFont_7] textColor:textColors backGroundColor:[UIColor clearColor] cornerRadius:0 text:self.nameArray[3*i+j] image:self.imageArray[3*i+j]];
            
            
            button.tag = 2000+3*i+j;
            [self customerButton:button];
            [self addSubview:button];
            
            if (j<2) {
                UIView *lineViewH = [BaseCostomer viewWithFrame:CGRectMake(button.right, button.top, 1, btnHeight) backgroundColor:lineColor];
                [self addSubview:lineViewH];
            }
            
            if (i<3) {
                UIView *lineViewV = [BaseCostomer viewWithFrame:CGRectMake(button.left, button.bottom, button.width, 1) backgroundColor:lineColor];
                [self addSubview:lineViewV];
            }
        }
    }
}

-(void)customerButton:(UIButton *)button
{
    float btnWidth = self.width/3.0-1;
    float btnHeight = (self.height-25)/4.0-1;
    button.imageEdgeInsets = UIEdgeInsetsMake(10*MCscale, btnWidth/2.0-15*MCscale,btnHeight-40*MCscale,btnWidth/2.0-15*MCscale);
    button.titleEdgeInsets = UIEdgeInsetsMake(btnHeight-30*MCscale,-35*MCscale, 2*MCscale,0);
    NSInteger index = button.tag - 2000;
    if (index == 7 ||index == 9 || index == 10||index ==11) {
//        button.enabled = NO;
    }
    else
    {
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}
-(void)buttonClick:(UIButton *)button
{
    if ([self.drawerDelegate respondsToSelector:@selector(selectedTargetWithIndex:)]) {
        [self.drawerDelegate selectedTargetWithIndex:button.tag];
    }
}
@end
