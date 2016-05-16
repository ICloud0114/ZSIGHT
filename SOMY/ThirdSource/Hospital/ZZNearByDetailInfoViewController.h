//
//  ZZNearByDetailInfoViewController.h
//  ZZDaheNewspaperIPhone
//
//  Created by wangshaosheng on 13-6-7.
//  Copyright (c) 2013年 wangshaosheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "MapData.h"

@interface ZZNearByDetailInfoViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,MKMapViewDelegate>
{
//    UIView *showAllView;
//    BMKSearch *search;
//    BMKMapView *mapView;
//    BMKPoiResult *cityListInfo;
    UITableView *searchResultTableView;
    UILabel *namelab;
    UILabel *addresslab;
    UILabel *phonelab;

}

@property (nonatomic,retain)CustomNavigation *navigationBar_ZZ;
@property(nonatomic,retain)MapData *mapdetail;

@end
