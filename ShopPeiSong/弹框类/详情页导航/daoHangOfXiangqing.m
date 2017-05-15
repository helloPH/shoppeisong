//
//  daoHangOfXiangqing.m
//  ShopPeiSong
//
//  Created by MIAO on 2017/4/27.
//  Copyright © 2017年 妙灵科技. All rights reserved.
//

#import "daoHangOfXiangqing.h"
#import "Header.h"

#import <BaiduMapAPI_Map/BMKMapView.h>




@interface daoHangOfXiangqing()


@property (nonatomic,strong)BMKMapView * map;


@end
@implementation daoHangOfXiangqing
-(instancetype)init{
    if (self=[super init]) {
        self.frame=CGRectMake(0, 0, kDeviceWidth, kDeviceHeight);
        self.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}
-(BMKMapView *)map{
    if (!_map) {
        _map=[BMKMapView new];
        [self addSubview:_map];
    }
    return _map;
}
#pragma mark -- location delegate
-(void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    
    
    
}
-(void)layoutSubviews{
    [super layoutSubviews];
    self.map.frame=CGRectMake(0, 0, kDeviceWidth, kDeviceHeight*0.6);
    
}
-(void)tap:(UITapGestureRecognizer *)tap{
    if (_block) {
        _block();
    }
}


@end
