//
//  ZZMapViewController.m
//  ZZDaheNewspaperIPhone
//
//  Created by easaa on 6/17/13.
//  Copyright (c) 2013 wangshaosheng. All rights reserved.
//

#import "ZZMapViewController.h"
#import "CustonMKAnnotation.h"
#import "NSString+URLEncoding.h"
#import "JSONKit.h"
#import "MapData.h"
@interface ZZMapViewController ()
{
    CustomNavigation *myNavigationBar;
}
@end

@implementation ZZMapViewController

@synthesize lat,lng;
@synthesize mapdataArray;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

-(id)initWithG:(NSString*)g
{
    self = [super init];
    if (self) {
        _g = g;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView
 {
 }
 */
-(void)mapList
{
    [UIView beginAnimations:@"animationID" context:nil];
	[UIView setAnimationDuration:0.7f];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationRepeatAutoreverses:NO];
//    if (mapView.hidden) {
//        [_navigationBar_ZZ.addButton setBackgroundImage:[UIImage imageNamed:@"top_icon_liebiao@2x.png"] forState:UIControlStateNormal];
//        [_navigationBar_ZZ.addButton setBackgroundImage:[UIImage imageNamed:@"top_icon_liebiao_h@2x.png"] forState:UIControlStateHighlighted];
//        //        self.navigationItem.rightBarButtonItem.title = @"列表";
//        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view cache:YES];
//        [UIView commitAnimations];
//        mapTabelView.hidden = YES;
//        mapView.hidden = NO;
//    }else
//    {
//        [_navigationBar_ZZ.addButton setBackgroundImage:[UIImage imageNamed:@"top_icon_map@2x.png"] forState:UIControlStateNormal];
//        [_navigationBar_ZZ.addButton setBackgroundImage:[UIImage imageNamed:@"top_icon_map_h@2x.png"] forState:UIControlStateHighlighted];
//        //        self.navigationItem.rightBarButtonItem.title = @"地图";
//        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];
//        [UIView commitAnimations];
//        mapTabelView.hidden = NO;
//        mapView.hidden = YES;
//    }
    
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor colorwithHexString:@"#EEEFF0"];
    myNavigationBar = [[CustomNavigation alloc]initWithFrame:CGRectMake(0, INCREMENT, 320, 44)];
    myNavigationBar.titleLabel.text = DPLocalizedString(@"Medication Guide");
    myNavigationBar.leftButton.hidden = NO;
    [myNavigationBar.leftButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:myNavigationBar];
//    _navigationBar_ZZ = [[CustomNavigation alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
//    [self.view addSubview:_navigationBar_ZZ];
//
//    
//    [_navigationBar_ZZ.leftButton setFrame:CGRectMake(10, 6, 49, 31)];
//    [_navigationBar_ZZ.leftButton setBackgroundImage:[UIImage imageNamed:@"back_btn@2x.png"] forState:UIControlStateNormal];
//    [_navigationBar_ZZ.leftButton setBackgroundImage:[UIImage imageNamed:@"back_btn_h@2x.png"] forState:UIControlStateHighlighted];
////    [_navigationBar_ZZ.leftButton setTitle:@"  返回" forState:UIControlStateNormal];
//    [_navigationBar_ZZ.leftButton addTarget:self action:@selector(backLastViewController:) forControlEvents:UIControlEventTouchUpInside];
//    
//    [_navigationBar_ZZ.addButton setFrame:CGRectMake(250, 2, 70, 40)];
//    [_navigationBar_ZZ.addButton setBackgroundImage:[UIImage imageNamed:@"top_icon_liebiao@2x.png"] forState:UIControlStateNormal];
//    [_navigationBar_ZZ.addButton setBackgroundImage:[UIImage imageNamed:@"top_icon_liebiao_h@2x.png"] forState:UIControlStateHighlighted];
//    [_navigationBar_ZZ.addButton addTarget:self action:@selector(mapList) forControlEvents:UIControlEventTouchUpInside];
//    [_navigationBar_ZZ.titleLabel setText:self.title];
    
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = lat;
    coordinate.longitude = lng;
    //    [_search poiSearchNearBy:_g center:coordinate radius:5000 pageIndex:0];
    mapTabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, myNavigationBar.frame.origin.y + myNavigationBar.frame.size.height, 320, self.view.frame.size.height - INCREMENT - myNavigationBar.frame.size.height)];
    mapTabelView.delegate = self;
    mapTabelView.dataSource = self;
    mapTabelView.hidden = YES;
    [self.view addSubview:mapTabelView];
    mapdataArray=[[NSMutableArray alloc]init];
    
    
    
    mapView=[[MKMapView alloc]initWithFrame:CGRectMake(0,  myNavigationBar.frame.origin.y + myNavigationBar.frame.size.height, 320, self.view.frame.size.height -INCREMENT - myNavigationBar.frame.size.height)];
    [mapView setDelegate:self];
    mapView.showsUserLocation = YES;
    //    CLLocationCoordinate2D center;
    //    center.latitude=lat;
    //    center.longitude=lng;
    //    MKCoordinateSpan span;
    //    span.latitudeDelta=0.1;
    //    span.longitudeDelta=0.1;
    //    MKCoordinateRegion region={center,span};
    //    [mapView setRegion:region];
    [self.view addSubview:mapView];
    
    
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
//    {
//        [_navigationBar_ZZ setFrame:CGRectMake(0, 0, 320, 64)];
//        [_navigationBar_ZZ.leftButton setFrame:CGRectMake(10, 26, 49, 31)];
//        [_navigationBar_ZZ.addButton setFrame:CGRectMake(250, 22, 70, 40)];
//        [mapTabelView setFrame:CGRectMake(0, 64, 320, self.view.bounds.size.height-64)];
//        [mapView setFrame:CGRectMake(0, 64, 320, self.view.bounds.size.height-64)];
//    }
    
    
    //设置地图中心
    [NSThread detachNewThreadSelector:@selector(getRequest) toTarget:self withObject:nil];
    
    
}
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)backLastViewController:(UIButton *)senderButton
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)getRequest
{
    NSString *url=[NSString stringWithFormat:@"http://api.map.baidu.com/place/v2/search?ak=E018c85913193a1e90f761d75e78bd5b&output=json&query=%@&page_size=10&page_num=0&scope=1&location=%f,%f&radius=5000",[_g URLEncodedString],lat,lng];
    NSString* request=[HTTPRequest requestForGet:url];
    NSDictionary *dic=[request objectFromJSONString];
    NSArray *dataArr=[dic objectForKey:@"results"];
    for (int index=0; index<dataArr.count; index++) {
        MapData *data=[MapData data];
        data.lat=[[[[dataArr objectAtIndex:index] objectForKey:@"location"] objectForKey:@"lat"] doubleValue];
        data.lng=[[[[dataArr objectAtIndex:index] objectForKey:@"location"] objectForKey:@"lng"] doubleValue];
        data.nameStr=[[dataArr objectAtIndex:index] objectForKey:@"name"];
        data.addressStr=[[dataArr objectAtIndex:index] objectForKey:@"address"];
        data.telephoneStr=[[dataArr objectAtIndex:index] objectForKey:@"telephone"];
        [mapdataArray addObject:data];
    }
    NSMutableArray *citems = [[NSMutableArray alloc] init];
    if (mapdataArray.count > 0) {
        for (int i = 0; i<mapdataArray.count; i++) {
            MapData *data = [mapdataArray objectAtIndex:i];
            CustonMKAnnotation *ann = [[CustonMKAnnotation alloc] init];
            CLLocationCoordinate2D coordinate2D;
            coordinate2D.latitude=data.lat;
            coordinate2D.longitude=data.lng;
            ann.coordinate=coordinate2D;
            [ann setTitle:data.nameStr];
            [ann setSubtitle:data.addressStr];
            ann.tag = i;
            [citems addObject:ann];

        }
        [mapTabelView reloadData];
    }
    [mapView addAnnotations:citems];

    CLLocationCoordinate2D coordinate;
    coordinate.latitude = lat;
    coordinate.longitude = lng;
    //    MKCoordinateSpan span;
    //    span.latitudeDelta=0.05;
    //    span.longitudeDelta=0.05;
    //    MKCoordinateRegion viewRegion;
    //    viewRegion.center=coordinate;
    //    viewRegion.span=span;
    //    [mapView setRegion:viewRegion];
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(coordinate,5000, 500);
    MKCoordinateRegion adjustedRegion = [mapView regionThatFits:viewRegion];
    //    以上代码创建出来一个符合MapView横纵比例的区域
    [mapView setRegion:adjustedRegion animated:YES];
    
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc
{
//    //    _search.delegate = nil;
//    //    [_search release];
//    mapTabelView.delegate = nil;
//    [mapTabelView release];
//    mapView.delegate = nil;
//    [mapView release];
//    [rightBtnItem release];
//    [super dealloc];
}
-(void)conDidFinish:(NSData *)finishdata tag:(int)tagid
{
    NSDictionary *dic=[finishdata objectFromJSONData];
    NSArray *dataArr=[dic objectForKey:@"results"];
    for (int index=0; index<dataArr.count; index++) {
        MapData *data=[MapData data];
        data.lat=[[[[dataArr objectAtIndex:index] objectForKey:@"location"] objectForKey:@"lat"] doubleValue];
        data.lng=[[[[dataArr objectAtIndex:index] objectForKey:@"location"] objectForKey:@"lng"] doubleValue];
        data.nameStr=[[dataArr objectAtIndex:index] objectForKey:@"name"];
        data.addressStr=[[dataArr objectAtIndex:index] objectForKey:@"address"];
        data.telephoneStr=[[dataArr objectAtIndex:index] objectForKey:@"telephone"];
        [mapdataArray addObject:data];
    }
    NSMutableArray *citems = [[NSMutableArray alloc] init];
    if (mapdataArray.count > 0) {
        for (int i = 0; i<mapdataArray.count; i++) {
            MapData *data = [mapdataArray objectAtIndex:i];
            CustonMKAnnotation *ann = [[CustonMKAnnotation alloc] init];
            CLLocationCoordinate2D coordinate2D;
            coordinate2D.latitude=data.lat;
            coordinate2D.longitude=data.lng;
            ann.coordinate=coordinate2D;
            [ann setTitle:data.nameStr];
            [ann setSubtitle:data.addressStr];
            ann.tag = i;
            [citems addObject:ann];

        }
        [mapTabelView reloadData];
    }
    [mapView addAnnotations:citems];

    CLLocationCoordinate2D coordinate;
    coordinate.latitude = lat;
    coordinate.longitude = lng;
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(coordinate,5000, 500);
    MKCoordinateRegion adjustedRegion = [mapView regionThatFits:viewRegion];
    //    以上代码创建出来一个符合MapView横纵比例的区域
    [mapView setRegion:adjustedRegion animated:YES];
    
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



- (MKAnnotationView *)mapView:(MKMapView *)mV viewForAnnotation:(id <MKAnnotation>)annotation
{
    if (annotation == mV.userLocation) {
        ((MKPointAnnotation*)annotation).title = @"我的位置";
        return nil;
    }
    MKPinAnnotationView *pinView = nil;
    static NSString *defaultPinID = @"custom pin";
    pinView = (MKPinAnnotationView *)[mV dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
    if ( pinView == nil )
    {
        pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:defaultPinID];
        [pinView setDraggable:YES];
    }
    pinView.pinColor = MKPinAnnotationColorRed;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [button setTag:((CustonMKAnnotation*)annotation).tag];
    [button addTarget:self action:@selector(goToInfo:) forControlEvents:UIControlEventTouchUpInside];
    pinView.rightCalloutAccessoryView =button;
    pinView.canShowCallout = YES;
    pinView.animatesDrop = YES;
    return pinView;
}
- (void)goToInfo:(UIButton*)sender{
    //    BMKPoiInfo *result = [listArray objectAtIndex:sender.tag];
    //    MapDeatilViewController *mapviewdd=[[MapDeatilViewController alloc]init];
    //    mapviewdd.newresult=result;
    //    mapviewdd.title=@"详细信息";
    //    mapviewdd.pageData=pageData;
    //    [self.navigationController pushViewController:mapviewdd animated:YES];
    //    [mapviewdd release];
    
    //到详细页面
//    MapData *data=[mapdataArray objectAtIndex:sender.tag];
//    ZZNearByDetailInfoViewController *mapviewdd=[[ZZNearByDetailInfoViewController alloc]init];
//    //    mapviewdd.newresult=result;
//    mapviewdd.mapdetail=data;
//    mapviewdd.title=@"详细信息";
//    [self.navigationController pushViewController:mapviewdd animated:YES];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return mapdataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int index = indexPath.row;
    //    BMKPoiInfo *result = [listArray objectAtIndex:index];
    MapData *data=[mapdataArray objectAtIndex:index];
    static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                       reuseIdentifier: SimpleTableIdentifier];
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    //    cell.textLabel.text = result.name;
    //    cell.detailTextLabel.text = result.address;
    cell.textLabel.text = data.nameStr;
    cell.detailTextLabel.text = data.addressStr;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int index = indexPath.row;
    //    BMKPoiInfo *result = [listArray objectAtIndex:index];
    //    MapDeatilViewController *mapviewdd=[[MapDeatilViewController alloc]init];
    //    mapviewdd.newresult=result;
    //    mapviewdd.title=@"详细信息";
    //    [self.navigationController pushViewController:mapviewdd animated:YES];
    //    [mapviewdd release];
    
    //到详细页面
    MapData *data=[mapdataArray objectAtIndex:index];
    ZZNearByDetailInfoViewController *mapviewdd=[[ZZNearByDetailInfoViewController alloc]init];
    //    mapviewdd.newresult=result;
    mapviewdd.mapdetail=data;
    mapviewdd.title=@"详细信息";
    [self.navigationController pushViewController:mapviewdd animated:YES];

    
}


@end
