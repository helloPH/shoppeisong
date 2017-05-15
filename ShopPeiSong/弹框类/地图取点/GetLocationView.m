//
//  GetLocationView.m
//  ShopPeiSong
//
//  Created by MIAO on 2017/5/9.
//  Copyright © 2017年 妙灵科技. All rights reserved.
//

#import "GetLocationView.h"
#import "PHMap.h"
#import "Header.h"

@interface GetLocationView()<BMKMapViewDelegate>
@property (nonatomic,strong)PHMapHelper * helper;


@property (nonatomic,strong)BMKMapView * mapView;


@property (nonatomic,strong)UIImageView * markView;
@end
@implementation GetLocationView
-(instancetype)init{
    if (self=[super init]) {
        [self newView];
    }
    return self;
}
-(void)newView{
    
    self.frame=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    UITapGestureRecognizer * tap  = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(disAppear)];
    [self addGestureRecognizer:tap];
    self.alpha=0;
    CGFloat lenghOfSideOfMap = [UIScreen mainScreen].bounds.size.width*0.8;
    _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, lenghOfSideOfMap,lenghOfSideOfMap )];
    _mapView.layer.cornerRadius=10;
    _mapView.layer.masksToBounds=YES;
    [self addSubview:_mapView];
    _mapView.center=CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2);
    _mapView.delegate=self;
    
    
    _markView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"定位"]];
    _markView.frame=CGRectMake(0, 0, 40, 40);
    [self addSubview:_markView];
    _markView.center=CGPointMake(_mapView.centerX, _mapView.centerY-_markView.height/2);
    _helper = [PHMapHelper new] ;
    [_helper locationStartLocation:^{
    } locationing:^(BMKUserLocation *location, NSError *error) {
        if (error) {
            return ;
        }
        BMKCoordinateRegion region;
        region.center=CLLocationCoordinate2DMake(location.location.coordinate.latitude, location.location.coordinate.longitude);
        region.span=_mapView.region.span;
        [_mapView setRegion:region];
        
        [_helper endLocation];
    } stopLocation:^{
        
        
        
    }];
}
-(void)appear{
    __block GetLocationView * weakSelf = self;
    self.alpha=0;
    [[UIApplication sharedApplication].delegate.window addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.alpha=1;
    }];
    
    
}
-(void)disAppear{
 
    __block GetLocationView * weakSelf = self;
    if (_block) {
        double latitude = _mapView.region.center.latitude;
        double longitude = _mapView.region.center.longitude;
        _block(latitude,longitude);
        
        [weakSelf removeFromSuperview];
         weakSelf = nil;
    }
    


}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
