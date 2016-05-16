//
//  ZZMapViewController.h
//  ZZDaheNewspaperIPhone
//
//  Created by easaa on 6/17/13.
//  Copyright (c) 2013 wangshaosheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "ZZNearByDetailInfoViewController.h"
@interface ZZMapViewController : UIViewController<MKMapViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    MKMapView *mapView;
    UITableView *mapTabelView;
    //    BMKSearch     *_search;
    NSArray *listArray;
    NSString *_g;
    UIBarButtonItem *rightBtnItem;
    UIButton *rightBtn;
}
-(id)initWithG:(NSString*)g;
//@property (nonatomic,retain)CustomNavigation *navigationBar_ZZ;
@property(nonatomic,retain)NSMutableArray *mapdataArray;
@property(nonatomic,assign) double lat;
@property(nonatomic,assign) double lng;

@end
