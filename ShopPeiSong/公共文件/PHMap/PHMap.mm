//
//  PHMap.m
//  ShopPeiSong
//
//  Created by MIAO on 2017/5/12.
//  Copyright © 2017年 妙灵科技. All rights reserved.
//

#import "PHMap.h"
#import <BaiduMapAPI_Search/BMKRouteSearch.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Map/BMKAnnotation.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
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
@interface PHMapView()<BMKMapViewDelegate,BMKRouteSearchDelegate>
@property (nonatomic,strong)BMKRouteSearch * routeSearch;
@end

@implementation PHMapView
-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self initData];
    }
    return self;
}
-(void)initData{
    self.delegate=self;
}
#pragma mark  --- mapView 代理
-(void)mapViewDidFinishLoading:(BMKMapView *)mapView{
    if (_hasLoadBlock) {
        _hasLoadBlock();
    }
}
#pragma mark - BMKMapViewDelegate

- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[RouteAnnotation class]]) {
        return [(RouteAnnotation*)annotation getRouteAnnotationView:view];
    }
    return nil;
}

- (BMKOverlayView*)mapView:(BMKMapView *)map viewForOverlay:(id<BMKOverlay>)overlay
{
    if ([overlay isKindOfClass:[BMKPolyline class]]) {
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.fillColor = [[UIColor alloc] initWithRed:0 green:1 blue:1 alpha:1];
        polylineView.strokeColor = [[UIColor alloc] initWithRed:0 green:0 blue:1 alpha:0.7];
        polylineView.lineWidth = 3.0;
        return polylineView;
    }
    return nil;
}
/**
 *  路径规划
 */
#pragma mark -- 路径规划
-(void)routeWithStartPoint:(CLLocationCoordinate2D)startLocation endPoint:(CLLocationCoordinate2D)endLocation{
    _routeSearch = [[BMKRouteSearch alloc]init];
    _routeSearch.delegate=self;
    
    /**
     *  根据 路径规划的不同可以 重新定义以下的 方法
     */
    BMKRidingRoutePlanOption * ridingOption = [[BMKRidingRoutePlanOption alloc]init];
    
    BMKPlanNode * fromNode = [[BMKPlanNode alloc]init];
    fromNode.pt=startLocation;

    
    
    BMKPlanNode * toNode = [[BMKPlanNode alloc]init];
    toNode.pt=endLocation;

    
    
    ridingOption.from=fromNode;
    ridingOption.to=toNode;
    
    if ([_routeSearch ridingSearch:ridingOption]) {
        NSLog(@"路径规划成功");
    }else{
        NSLog(@"路径规划失败");
    };
    
}
-(void)onGetRidingRouteResult:(BMKRouteSearch *)searcher result:(BMKRidingRouteResult *)result errorCode:(BMKSearchErrorCode)error{
    NSLog(@"onGetRidingRouteResult error:%d", (int)error);
    NSArray* array = [NSArray arrayWithArray:self.annotations];
    [self removeAnnotations:array];
    array = [NSArray arrayWithArray:self.overlays];
    [self removeOverlays:array];
    if (error == BMK_SEARCH_NO_ERROR) {
        BMKRidingRouteLine* plan = (BMKRidingRouteLine*)[result.routes objectAtIndex:0];
        NSInteger size = [plan.steps count];
        int planPointCounts = 0;
        for (int i = 0; i < size; i++) {
            BMKRidingStep* transitStep = [plan.steps objectAtIndex:i];
            if (i == 0) {
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.starting.location;
                item.title = @"起点";
                item.type = 0;
                [self addAnnotation:item]; // 添加起点标注
            }else if(i==size-1){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.terminal.location;
                item.title = @"终点";
                item.type = 1;
                [self addAnnotation:item]; // 添加起点标注
            }else{
                //添加annotation节点
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = transitStep.entrace.location;
                item.title = transitStep.instruction;
                item.degree = (int)transitStep.direction * 30;
                item.type = 4;
                [self addAnnotation:item];
                [item getRouteAnnotationView:self];
            }

            
            //轨迹点总数累计
            planPointCounts += transitStep.pointsCount;
        }
        
        //轨迹点
        BMKMapPoint * temppoints = new BMKMapPoint[planPointCounts];
        int i = 0;
        for (int j = 0; j < size; j++) {
            BMKRidingStep* transitStep = [plan.steps objectAtIndex:j];
            int k=0;
            for(k=0;k<transitStep.pointsCount;k++) {
                temppoints[i].x = transitStep.points[k].x;
                temppoints[i].y = transitStep.points[k].y;
                i++;
            }
            
        }
        // 通过points构建BMKPolyline
        BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
        [self addOverlay:polyLine]; // 添加路线overlay
        delete []temppoints;
        [self mapViewFitPolyLine:polyLine];
    } else if (error == BMK_SEARCH_AMBIGUOUS_ROURE_ADDR) {
        //检索地址有歧义,返回起点或终点的地址信息结果：BMKSuggestAddrInfo，获取到推荐的poi列表
        NSLog(@"检索地址有岐义，请重新输入。");
        [self showGuide];
    }
}
-(void)onGetIndoorRouteResult:(BMKRouteSearch *)searcher result:(BMKIndoorRouteResult *)result errorCode:(BMKSearchErrorCode)error{
    
}
-(void)onGetDrivingRouteResult:(BMKRouteSearch *)searcher result:(BMKDrivingRouteResult *)result errorCode:(BMKSearchErrorCode)error{
    
}
-(void)onGetWalkingRouteResult:(BMKRouteSearch *)searcher result:(BMKWalkingRouteResult *)result errorCode:(BMKSearchErrorCode)error{
    
}


#pragma mark --

//根据polyline设置地图范围
- (void)mapViewFitPolyLine:(BMKPolyline *) polyLine {
    CGFloat ltX, ltY, rbX, rbY;
    if (polyLine.pointCount < 1) {
        return;
    }
    BMKMapPoint pt = polyLine.points[0];
    ltX = pt.x, ltY = pt.y;
    rbX = pt.x, rbY = pt.y;
    for (int i = 1; i < polyLine.pointCount; i++) {
        BMKMapPoint pt = polyLine.points[i];
        if (pt.x < ltX) {
            ltX = pt.x;
        }
        if (pt.x > rbX) {
            rbX = pt.x;
        }
        if (pt.y > ltY) {
            ltY = pt.y;
        }
        if (pt.y < rbY) {
            rbY = pt.y;
        }
    }
    BMKMapRect rect;
    rect.origin = BMKMapPointMake(ltX , ltY);
    rect.size = BMKMapSizeMake(rbX - ltX, rbY - ltY);
    [self setVisibleMapRect:rect];
    self.zoomLevel = self.zoomLevel - 0.3;
}
//检索提示
-(void)showGuide
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"检索提示"
                                                    message:@"检索地址有岐义，请重新输入。"
                                                   delegate:self
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
}



@end

