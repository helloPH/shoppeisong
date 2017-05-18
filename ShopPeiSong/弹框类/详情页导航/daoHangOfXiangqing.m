//
//  daoHangOfXiangqing.m
//  ShopPeiSong
//
//  Created by MIAO on 2017/4/27.
//  Copyright © 2017年 妙灵科技. All rights reserved.
//

#import "daoHangOfXiangqing.h"
#import "Header.h"

#import "PHMap.h"




@interface daoHangOfXiangqing()
@property (nonatomic,strong)PHMapView * map;
@end
@implementation daoHangOfXiangqing
-(instancetype)init{
    if (self=[super init]) {
        [self newView];
    }
    return self;
}
-(void)newView{

    
    self.frame=CGRectMake(0, 0, kDeviceWidth, kDeviceHeight);
    self.backgroundColor=[UIColor clearColor];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(disAppear)];
    [self addGestureRecognizer:tap];
    _map = [[PHMapView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth*0.8, kDeviceWidth*0.8)];
    [self addSubview:_map];
    _map.center=CGPointMake(self.width/2, self.height/2);
    
    
    _map.backgroundColor = [UIColor whiteColor];
    _map.layer.cornerRadius = 15.0;
    self.layer.shadowOpacity = 0.5;
    self.layer.shadowOffset = CGSizeMake(0, 0);
    _map.layer.masksToBounds=YES;
}

-(void)layoutSubviews{
    [super layoutSubviews];
}
-(void)appear{
    [[UIApplication sharedApplication].delegate.window addSubview:self];
    self.alpha=0;
    [_map routeWithStartPoint:CLLocationCoordinate2DMake(self.qiLati, self.qiLongi) endPoint:CLLocationCoordinate2DMake(self.zhongLati, self.zhongLongi)];
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha=1;
        
    }];
}
-(void)disAppear{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha=0;
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
