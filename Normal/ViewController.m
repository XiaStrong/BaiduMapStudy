//
//  ViewController.m
//  Normal
//
//  Created by Xia_Q on 16/4/20.
//  Copyright (c) 2016年 X. All rights reserved.
//

#import "ViewController.h"
#import "PlaceViewController.h"
@interface ViewController ()<BMKMapViewDelegate,BMKPoiSearchDelegate,BMKLocationServiceDelegate>
{
    BMKPointAnnotation* _annotation;//标注类
    
    BMKPoiSearch *_searcher;//检索类
    
    BMKNearbySearchOption *_option;
    
    //搜索一次后包含所有标准，进行路径查询时剩余除了自己选中的标注点坐标外的其他所有标注，用于删除标注点
    NSMutableArray *_annotationArr;
    
    
    BMKLocationService *_locService;//定位
    
    
    CLLocationCoordinate2D _coor;//自己的坐标
}
@end

@implementation ViewController

-(void)creatBarButton{
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"creat" style:UIBarButtonItemStylePlain target:self action:@selector(creat)];
    
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"clear" style:UIBarButtonItemStylePlain target:self action:@selector(clear)];
    
    
    UIBarButtonItem *searchBtn=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchPlace)];
    
    self.navigationItem.leftBarButtonItems = @[leftButton,rightButton,searchBtn];
    self.view.backgroundColor = [UIColor colorWithWhite:0.217 alpha:1.000];
    
    
    

    
    UIBarButtonItem *jumpBtn=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(jump)];
    UIBarButtonItem *playBtn=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(play)];

    self.navigationItem.rightBarButtonItems = @[jumpBtn,playBtn];
    self.view.backgroundColor = [UIColor colorWithWhite:0.217 alpha:1.000];
    
}

//开始查询路径
-(void)play{

    //    [_mapView removeAnnotations:_annotationArr];
    //    [_annotationArr removeAllObjects];
 
}

-(void)jump{
    
    PlaceViewController *pc=[[PlaceViewController alloc]init];

    //切换之前添加block
    [pc setGetDic:^(NSDictionary *placeDic) {
        
        NSLog(@"%@",placeDic);

    }];
    
    [self.navigationController pushViewController:pc animated:YES];

}


//搜索附近的标注
-(void)searchPlace{
    
    
    // 清除屏幕中所有的annotation
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"搜索" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    
    UITextField *nameField = [alert textFieldAtIndex:0];
    nameField.placeholder = @"请输入需要搜索的东西";
    
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        
        UITextField *what = [alertView textFieldAtIndex:0];
        NSLog(@"%@",what.text);
        //检索
        _searcher =[[BMKPoiSearch alloc]init];
        _searcher.delegate = self;
        //发起检索
        
        _option = [[BMKNearbySearchOption alloc]init];
        _option.pageIndex = 0;
        _option.pageCapacity = 20;
        
//        CLLocationCoordinate2D coors = {39.915, 116.404};//此处是一个北京的坐标
        //自己的坐标
        _option.location = _coor;
        _option.keyword = what.text;
        
        //不等几秒后再检索不会生效
        [self performSelector:@selector(search) withObject:nil afterDelay:1.0f];
        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _annotationArr=[[NSMutableArray alloc]init];
    
    //设置地图等级
    [_mapView setZoomLevel:17];

    
    [self creatBarButton];
    
    //基本
    //    [self showBaseLevel];
    
    //几何图形
    //    [self creatJiHeTuXing];
    
    
    
    //定位
    [self getLocation];
}

-(void)getLocation{
    
    
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    //启动LocationService
    [_locService startUserLocationService];
    _mapView.showsUserLocation= NO;//先关闭显示的定位图层
    //普通定位态,罗盘态,跟随态
    NSLog(@"进入跟随态");
    _mapView.userTrackingMode = BMKUserTrackingModeFollow;//设置定位的状态
    _mapView.showsUserLocation = YES;//显示定位图层

}

//实现相关delegate 处理位置信息更新
//处理方向变更信息
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    [_mapView updateLocationData:userLocation];
//    NSLog(@"heading is %@",userLocation.heading);
}

//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
//    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    
    [_mapView updateLocationData:userLocation];
    CGFloat x=userLocation.location.coordinate.latitude;
    CGFloat y=userLocation.location.coordinate.longitude;
    _coor.latitude=x;
    _coor.longitude=y;
    [_locService stopUserLocationService];


}



-(void)search{
    
    BOOL flag = [_searcher poiSearchNearBy:_option];
    if(flag)
    {
        NSLog(@"周边检索发送成功");
    }
    else
    {
        NSLog(@"周边检索发送失败");
    }
}

//实现PoiSearchDeleage处理回调结果
- (void)onGetPoiResult:(BMKPoiSearch*)searcher result:(BMKPoiResult*)poiResultList errorCode:(BMKSearchErrorCode)error
{
    if (error == BMK_SEARCH_NO_ERROR) {
        //在此处理正常结果
        
        //<本次POI搜索的总结果数
        //        NSLog(@"%d",poiResultList.totalPoiNum);
        //<当前页的POI结果数
        //        NSLog(@"%d",poiResultList.currPoiNum);
        //<本次POI搜索的总页数
        //        NSLog(@"%d",poiResultList.pageNum);
        //<当前页的索引
        //        NSLog(@"%d",poiResultList.pageIndex);
        //POI列表，成员是BMKPoiInfo
        
        //        NSLog(@"%d_%@",poiResultList.poiInfoList.count,poiResultList.poiInfoList);
        
        NSArray *BMKPoiInfoArr=poiResultList.poiInfoList;
        
        
        for( BMKPoiInfo *a in BMKPoiInfoArr) {
            if ([a isKindOfClass:[BMKPoiInfo class]]) {
//                NSLog(@"%@__%@__%@__%@__%@__%d",a.name,a.address,a.city,a.phone,a.postcode,a.epoitype);
                //                [self creatSignWith:a.pt withAddress:a.name];
                
                BMKPointAnnotation *annotation = [[BMKPointAnnotation alloc]init];
                annotation.coordinate = a.pt;
                annotation.title = a.name;
                [_mapView addAnnotation:annotation];
                
                [_annotationArr addObject:annotation];
                
            }
        }
        
        //<城市列表，成员是BMKCityListInfo
        //        NSLog(@"%d_%@",poiResultList.cityList.count,poiResultList.cityList);
        
        
    }
    else if (error == BMK_SEARCH_AMBIGUOUS_KEYWORD){
        //当在设置城市未找到结果，但在其他城市找到结果时，回调建议检索城市列表
        // result.cityList;
        NSLog(@"起始点有歧义");
    } else {
        NSLog(@"抱歉，未找到结果");
    }
}


#pragma mark-几何图形
-(void)creatJiHeTuXing{
    // 添加单折线覆盖物
    //        CLLocationCoordinate2D coors[2] = {0};
    //    coors[0].latitude = 39.315;
    //    coors[0].longitude = 116.304;
    //    coors[1].latitude = 39.515;
    //    coors[1].longitude = 116.504;
    //    BMKPolyline* polyline = [BMKPolyline polylineWithCoordinates:coors count:2];
    //    [_mapView addOverlay:polyline];
    
    //添加折线多段颜色绘制能力
    CLLocationCoordinate2D coords[5] = {0};
    coords[0].latitude = 39.965;
    coords[0].longitude = 116.404;
    coords[1].latitude = 39.925;
    coords[1].longitude = 116.454;
    coords[2].latitude = 39.955;
    coords[2].longitude = 116.494;
    coords[3].latitude = 39.905;
    coords[3].longitude = 116.554;
    coords[4].latitude = 39.965;
    coords[4].longitude = 116.604;
    //构建分段颜色索引数组
    NSArray *colorIndexs = [NSArray arrayWithObjects:
                            [NSNumber numberWithInt:2],
                            [NSNumber numberWithInt:0],
                            [NSNumber numberWithInt:1],
                            [NSNumber numberWithInt:2], nil];
    
    //构建BMKPolyline,使用分段颜色索引，其对应的BMKPolylineView必须设置colors属性
    BMKPolyline *colorfulPolyline = [BMKPolyline polylineWithCoordinates:coords count:5 textureIndex:colorIndexs];
    [_mapView addOverlay:colorfulPolyline];
    
}

//代理事件
//单线
//- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id <BMKOverlay>)overlay{
//    if ([overlay isKindOfClass:[BMKPolyline class]]){
//        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
//        polylineView.strokeColor = [[UIColor purpleColor] colorWithAlphaComponent:1];
//        polylineView.lineWidth = 5.0;
//
//        return polylineView;
//    }
//    return nil;
//}


//多线
- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id <BMKOverlay>)overlay
{
    if ([overlay isKindOfClass:[BMKPolyline class]]) {
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.lineWidth = 5;
        /// 使用分段颜色绘制时，必须设置（内容必须为UIColor）
        polylineView.colors = [NSArray arrayWithObjects:[UIColor greenColor], [UIColor redColor], [UIColor yellowColor], nil];
        return polylineView;
    }
    
    return nil;
}





#pragma mark-标注功能

-(void)creatSignWith:(CLLocationCoordinate2D)coor withAddress:(NSString *)address{
    
    BMKPointAnnotation *annotation = [[BMKPointAnnotation alloc]init];
    annotation.coordinate = coor;
    annotation.title = address;
    [_mapView addAnnotation:annotation];
    
}

//清除标注
-(void)clear{
    // 清除屏幕中所有的annotation
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];

    
//    if (_annotation != nil) {
//        [_mapView removeAnnotation:_annotation];
//        _annotation = nil;
//    }
    
}
//创建标注
-(void)creat{
    if (_annotation == nil) {
        _annotation = [[BMKPointAnnotation alloc]init];
        CLLocationCoordinate2D coor;
        coor.latitude = 39.915;
        coor.longitude = 116.404;
        _annotation.coordinate = coor;
        _annotation.title = @"这里是北京";
        [_mapView addAnnotation:_annotation];
    }else{
        NSLog(@"已经有标注");
    }
}





- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    
    NSString *AnnotationViewID =@"mark";
    
    //根据坐标生成标注，返回View
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        
        // 检查是否有重用的缓存
        BMKAnnotationView* newAnnotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
        // 缓存没有命中，自己构造一个，一般首次添加annotation代码会运行到此处
        if (newAnnotationView ==nil) {
            newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
            ((BMKPinAnnotationView*)newAnnotationView).pinColor = BMKPinAnnotationColorRed;
            // 设置重天上掉下的效果(annotation)
            ((BMKPinAnnotationView*)newAnnotationView).animatesDrop = YES;

        }
        // 设置位置
        newAnnotationView.centerOffset = CGPointMake(0, -(newAnnotationView.frame.size.height * 0.5));
        newAnnotationView.annotation = annotation;
        // 单击弹出泡泡，弹出泡泡前提annotation必须实现title属性
        newAnnotationView.canShowCallout = YES;
        // 设置是否可以拖拽
        newAnnotationView.draggable = NO;

        
        //此处是简单版的，可以无视
//        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
//        newAnnotationView.pinColor = BMKPinAnnotationColorRed;
//        //动画效果,从天上掉下来的动画
//        newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
//        //提供类似大头针效果的annotation view
        
        
        return newAnnotationView;
    }
    return nil;
}

- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
    //打印选中地点的坐标
    [mapView bringSubviewToFront:view];
    [mapView setNeedsDisplay];
    _annotation=view.annotation;
    NSLog(@"%f__%f",view.annotation.coordinate.latitude,view.annotation.coordinate.longitude);
}


#pragma mark-百度热力图层
-(void)showBaseLevel{
    
    //设置地图为空白类型
    //    _mapView.mapType = BMKMapTypeNone;
    
    //切换为卫星图
    //    [_mapView setMapType:BMKMapTypeSatellite];
    
    //切换为普通地图
    //    [_mapView setMapType:BMKMapTypeStandard];
    
    //打开实时路况图层
    //    [_mapView setTrafficEnabled:YES];
    
    //关闭实时路况图层
    //    [_mapView setTrafficEnabled:NO];
    
    
    //打开百度城市热力图图层（百度自有数据）
    //    [_mapView setBaiduHeatMapEnabled:YES];
    
    
    //关闭百度城市热力图图层（百度自有数据）
    //    [_mapView setBaiduHeatMapEnabled:NO];
}


#pragma mark-基本标配
-(void)viewWillAppear:(BOOL)animated
{
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}

-(void)viewWillDisappear:(BOOL)animated
{
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    
    //不使用时将delegate设置为 nil
    _searcher.delegate = nil;
    _locService.delegate = nil;

    
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
