//
//  PHMap.m
//  ShopPeiSong
//
//  Created by MIAO on 2017/5/12.
//  Copyright © 2017年 妙灵科技. All rights reserved.
//

#import "PHMap.h"
//#import <BaiduMapAPI_Base/BMKUserLocation.h>


@interface PHMapHelper()<BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>
@property (nonatomic,strong)BMKLocationService * locationService;

@property (nonatomic,strong)BMKGeoCodeSearch * geoCodeSearch;

@end
@implementation PHMapHelper
#pragma mark --  百度地图的定位代理
-(void)locationStartLocation:(block)startLocation locationing:(locationing)locationing stopLocation:(block)stopLocation{
    
    self.locationService = [[BMKLocationService alloc]init];
    self.locationService.delegate=self;
    [self.locationService startUserLocationService];
    
    self.startLocation=startLocation;
    self.locationing=locationing;
    self.stopLocation=stopLocation;
}
-(void)endLocation{
    if (self.locationService) {
        [self.locationService stopUserLocationService];
    }
}
// --  百度地图的定位代理
/**
 *在将要启动定位时，会调用此函数
 */
- (void)willStartLocatingUser{
    if (_startLocation) {
        _startLocation();
    }
    
}
/**
 *在停止定位后，会调用此函数
 */
- (void)didStopLocatingUser{
    if (_stopLocation) {
        _stopLocation();
    }
}
/**
 *用户方向更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation{
    if (_locationing) {
        _locationing(userLocation,nil);
    }
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    if (_locationing) {
        _locationing(userLocation,nil);
    }
}

/**
 *定位失败后，会调用此函数
 *@param error 错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error{
    if (_locationing) {
        _locationing(nil,error);
    }
}

#pragma mark -- 地理编码和反编码
// / 编码
-(void)geoWithAddress:(NSString *)address city:(NSString *)city block:(GeoBlock)geoBlock{
    
    self.geoCodeSearch = [[BMKGeoCodeSearch alloc]init];
    self.geoCodeSearch.delegate=self;
    BMKGeoCodeSearchOption * option = [[BMKGeoCodeSearchOption alloc]init];
    option.address=address;
    option.city=city;
    [self.geoCodeSearch geoCode:option];
    self.geoBlock=geoBlock;
}
-(void)regeoWithLocation:(CLLocationCoordinate2D )location block:(ReGeoBlock)geoBlock{
    
    self.geoCodeSearch = [[BMKGeoCodeSearch alloc]init];
    self.geoCodeSearch.delegate=self;
    BMKReverseGeoCodeOption * option = [[BMKReverseGeoCodeOption alloc]init];
    option.reverseGeoPoint=location;
    [self.geoCodeSearch reverseGeoCode:option];
    self.regeoBlock=geoBlock;
}
// -- 地理编码和反编码  的代理方法
-(void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    if (_geoBlock) {
        _geoBlock(result,error);
    }
}
-(void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    if (_regeoBlock) {
        _regeoBlock(result,error);
    }
}


@end
