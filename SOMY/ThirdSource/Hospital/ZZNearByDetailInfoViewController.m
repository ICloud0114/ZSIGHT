//
//  ZZNearByDetailInfoViewController.m
//  ZZDaheNewspaperIPhone
//
//  Created by wangshaosheng on 13-6-7.
//  Copyright (c) 2013年 wangshaosheng. All rights reserved.
//

#import "ZZNearByDetailInfoViewController.h"

@interface ZZNearByDetailInfoViewController ()

@end

@implementation ZZNearByDetailInfoViewController
@synthesize mapdetail;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor blackColor]];
    
    _navigationBar_ZZ = [[CustomNavigation alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    [self.view addSubview:_navigationBar_ZZ];

    
    [_navigationBar_ZZ.leftButton setFrame:CGRectMake(10, 6, 49, 31)];
    [_navigationBar_ZZ.leftButton setBackgroundImage:[UIImage imageNamed:@"back_btn@2x.png"] forState:UIControlStateNormal];
    [_navigationBar_ZZ.leftButton setBackgroundImage:[UIImage imageNamed:@"back_btn_h@2x.png"] forState:UIControlStateHighlighted];
//    [_navigationBar_ZZ.leftButton setTitle:@"  返回" forState:UIControlStateNormal];
    [_navigationBar_ZZ.leftButton addTarget:self action:@selector(backLastViewController:) forControlEvents:UIControlEventTouchUpInside];
    
    [_navigationBar_ZZ.titleLabel setText:@"周边信息"];
    
    
    namelab=[[UILabel alloc]initWithFrame:CGRectMake(10, 54, 300, 20)];
    namelab.backgroundColor=[UIColor clearColor];
    //    namelab.text=[NSString stringWithFormat:@"店名:%@",newresult.name];
    namelab.text=[NSString stringWithFormat:@"店名:%@",mapdetail.nameStr];
    [self.view addSubview:namelab];
    
    addresslab=[[UILabel alloc]initWithFrame:CGRectMake(10, 84, 300, 20)];
    addresslab.backgroundColor=[UIColor clearColor];
    addresslab.text=[NSString stringWithFormat:@"地址:%@",mapdetail.addressStr];
    //    addresslab.text=[NSString stringWithFormat:@"地址:%@",newresult.address];
    [self.view addSubview:addresslab];
    
    phonelab=[[UILabel alloc]initWithFrame:CGRectMake(10, 114, 300, 20)];
    phonelab.backgroundColor=[UIColor clearColor];
    //    if (newresult.phone==NULL) {
    //        phonelab.text=@"电话:暂无数据";
    //    }
    //    else{
    //        phonelab.text=[NSString stringWithFormat:@"电话:%@",newresult.phone];
    //    }
    if (mapdetail.telephoneStr==NULL) {
        phonelab.text=@"电话:暂无数据";
    }
    else{
        phonelab.text=[NSString stringWithFormat:@"电话:%@",mapdetail.telephoneStr];
    }
    
    [self.view addSubview:phonelab];
    
    MKMapView *mapView=[[MKMapView alloc]initWithFrame:CGRectMake(0, 144, 320, self.view.frame.size.height-144)];
    mapView.delegate=self;
    [self.view addSubview:mapView];
    mapView.showsUserLocation = YES;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        [_navigationBar_ZZ setFrame:CGRectMake(0, 0, 320, 64)];
        [_navigationBar_ZZ.leftButton setFrame:CGRectMake(10, 26, 49, 31)];
        [namelab setFrame:CGRectMake(10, 74, 300, 20)];
        [addresslab setFrame:CGRectMake(10, 104, 300, 20)];
        [phonelab setFrame:CGRectMake(10, 134, 300, 20)];
        [mapView setFrame:CGRectMake(0, 164, 320, self.view.bounds.size.height-164)];
    }
    
    NSMutableArray *citems=[[NSMutableArray alloc]init];
    MKPointAnnotation *ann = [[MKPointAnnotation alloc] init];
    //    ann.coordinate = newresult.pt;
    //    [ann setTitle:newresult.name];
    //    [ann setSubtitle:newresult.phone];
    CLLocationCoordinate2D coordinate2D;
    coordinate2D.longitude=mapdetail.lng;
    coordinate2D.latitude=mapdetail.lat;
    ann.coordinate=coordinate2D;
    [ann setTitle:mapdetail.nameStr];
    [ann setSubtitle:mapdetail.telephoneStr];
    [citems addObject:ann];

    [mapView addAnnotations:citems];
    CLLocationCoordinate2D coordinate;
    //    coordinate.latitude = newresult.pt.latitude;
    //    coordinate.longitude = newresult.pt.longitude;
    coordinate.latitude = mapdetail.lat;
    coordinate.longitude = mapdetail.lng;
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(coordinate,500, 300);
    MKCoordinateRegion adjustedRegion = [mapView regionThatFits:viewRegion];
    //    以上代码创建出来一个符合MapView横纵比例的区域
    [mapView setRegion:adjustedRegion animated:YES];

}
- (MKAnnotationView *)mapView:(MKMapView *)mV viewForAnnotation:(id <MKAnnotation>)annotation
{
    if (annotation == mV.userLocation) {
        ((MKPointAnnotation*)annotation).title = @"我的位置";
        return nil;
    }
    MKPinAnnotationView *pinView = nil;
    pinView.pinColor = MKPinAnnotationColorRed;
    return pinView;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)backLastViewController:(UIButton *)senderButton
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
