//
//  PHMap.h
//  ShopPeiSong
//
//  Created by MIAO on 2017/5/12.
//  Copyright © 2017年 妙灵科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Map/BMKMapView.h>

#import "RouteAnnotation.h"
typedef void(^locationing)(BMKUserLocation * location,NSError * error);// error  0表示正常
typedef void(^block)();

typedef void(^GeoBlock)(BMKGeoCodeResult * result,BMKSearchErrorCode  error);
typedef void(^ReGeoBlock)(BMKReverseGeoCodeResult * result,BMKSearchErrorCode  error);


@interface PHMapHelper : NSObject


//定位
@property (nonatomic,strong)block startLocation;
@property (nonatomic,strong)block stopLocation;
@property (nonatomic,strong)locationing locationing;
-(void)locationStartLocation:(block)startLocation locationing:(locationing)locationing stopLocation:(block)stopLocation;
-(void)endLocation;

//编码
@property (nonatomic,strong)GeoBlock geoBlock;
@property (nonatomic,strong)ReGeoBlock regeoBlock;
-(void)geoWithAddress:(NSString *)address city:(NSString *)city block:(GeoBlock)geoBlock;
-(void)regeoWithLocation:(CLLocationCoordinate2D )location block:(ReGeoBlock)geoBlock;

@end




#pragma mark -- mapview
@interface PHMapView:BMKMapView
@property (nonatomic,strong)void (^hasLoadBlock)();
-(instancetype)initWithFrame:(CGRect)frame;

/**
 *  路径规划
 */
-(void)routeWithStartPoint:(CLLocationCoordinate2D)startLocation endPoint:(CLLocationCoordinate2D)endLocation;
@end



