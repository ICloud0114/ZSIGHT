//
//  EAMainViewController.m
//  SOMY
//
//  Created by easaa on 9/2/14.
//  Copyright (c) 2014 easaa. All rights reserved.
//

#import "EAMainViewController.h"

#import "LineChartView.h"


#import "CircleView.h"
#import "UIViewController+MMDrawerController.h"

#import "LinkBlueViewController.h"
#import "EASuggestViewController.h"

#import <CoreLocation/CoreLocation.h>
#import "ZZMapViewController.h"
#import "EAMedicationGuideViewController.h"
#import "DataLibrary.h"


//#import "LeSimple.h"

@interface EAMainViewController ()<CLLocationManagerDelegate>
{
    UILabel *titleLabel;
    UIButton *connectButton;
    CLLocationManager *locManager;
    double lat;
    double lng;
    bool isLoading;
    CircleView *topView;
    LineChartView *lineView;
    BOOL ISHUA;
    NSInteger temperature;
    
    UIButton *searchHospital;
    UIButton *medicationGuide;
    UIButton *setWarnTemperature;
    
    NSInteger  oldMinutes;
    NSInteger  allMinutes;
    DataLibrary *dataLib;
    NSString *uploadTime;
    
    NSMutableDictionary *selectMemberDict;
    
//    LeSimple *simple;
    
    NSTimer *synchronousTimer;
    BOOL needRemind;
}
@end

@implementation EAMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        allMinutes = 0;
        temperature = 298;
        needRemind = YES;
        // Custom initialization
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeLanguageAction) name:@"changeLanguage" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeTemperatureUnit) name:@"changeUnit" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadwendu:) name:@"BlueData" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(OpenAlarmAction) name:@"OpenAlarm" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshLineView) name:@"refreshLineView" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopScanDeviceAction) name:@"synchronous" object:nil];
        
      dataLib = [DataLibrary shareDataLibrary];

    }
    return self;
}
-(void)reloadwendu:(NSNotification*)info
{
    NSString * string = [info object];
    if ( string.length > 0)
    {
        NSLog(@"data长度:%lu   %@",(unsigned long)string.length,string);
        NSString *rang1 = [string substringWithRange:NSMakeRange(16, 2)];
        NSString *rang2 = [string substringWithRange:NSMakeRange(19, 2)];
        NSString *power = [string substringWithRange:NSMakeRange(34, 2)];
        NSString *wendu = [NSString stringWithFormat:@"%@%@",rang1,rang2];

        if (needRemind &&[self hexStringFromString:power])
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:DPLocalizedString(@"Tips") message:DPLocalizedString(@"Low Power") delegate:nil cancelButtonTitle:DPLocalizedString(@"Do not remind") otherButtonTitles:nil, nil];
            [alert show];
            needRemind = NO;
        }
        
        temperature = [self hexStringFromString:wendu];
        
        NSLog(@"温度%ld",(long)temperature);

        if (temperature > topView.warnTemp * 10)
        {
            searchHospital.hidden = NO;
            medicationGuide.hidden = NO;
            
        }
        else
        {
            searchHospital.hidden = YES;
            medicationGuide.hidden = YES;
        }
        
    //分割时间
        NSDateComponents *comps;
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDate *nowDay = [NSDate date];
        comps =[calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit |NSDayCalendarUnit |NSHourCalendarUnit |NSMinuteCalendarUnit) fromDate:nowDay];
        NSInteger hours = [comps hour];
        NSInteger minutes = [comps minute];
        
        allMinutes = hours * 60 + minutes;
        
        NSLog(@"第%ld分钟",(long)allMinutes);
        
//        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
//        formatter.dateFormat = @"yyyyMMdd";
//        NSString *dateString = [formatter stringFromDate:nowDay];
        
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",(long)temperature],@"TEMP",[NSString stringWithFormat:@"%ld",(long)allMinutes],@"TIME",nil];
        
        [dataLib insertData:dict];
        
        NSDateFormatter *uploadFormatter = [[NSDateFormatter alloc]init];
        uploadFormatter.dateFormat = @"yyyy-MM-dd";
        uploadTime = [NSString stringWithFormat:@"%@+%ld:%ld:00",[uploadFormatter stringFromDate:[NSDate date]],(long)hours,(long)minutes];
        [self refreshAction];
    }
    
}

//转换温度
- (NSInteger)hexStringFromString:(NSString *)string
{
    NSInteger num = 0;
    NSInteger count = 0;
    
    for(int i = 0; i < string.length ; i++)
    {
        NSString *a = [string substringWithRange:NSMakeRange(i, 1)];
        if ([a isEqualToString:@"a"])
        {
            num = 10;
        }
        else if([a isEqualToString:@"b"])
        {
            num = 11;
        }
        else if([a isEqualToString:@"c"])
        {
            num = 12;
        }
        else if([a isEqualToString:@"d"])
        {
            num = 13;
        }
        else if([a isEqualToString:@"e"])
        {
            num = 14;
        }
        else if([a isEqualToString:@"f"])
        {
            num = 15;
        }
        else
        {
            num = [a integerValue];
        }
        NSInteger m = 1;
        for (int j = 0; j < 3-i;j++)
        {
            m *= 16;
        }
        count += num *m;
    }
//    CGFloat f = count / 10.0;
    
//    return f;
    return count;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)changeLanguageAction
{
    titleLabel.text = DPLocalizedString(@"SOMY THERMOMETER");
    [setWarnTemperature setTitle:DPLocalizedString(@"Manual set") forState:UIControlStateNormal];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"synchronous"])
    {
        [connectButton setTitle:DPLocalizedString(@"Synchronous") forState:UIControlStateNormal];
    }
    else
    {
        [connectButton setTitle:DPLocalizedString(@"scan") forState:UIControlStateNormal];
    }
    
    [topView setNeedsDisplay];
    [lineView setNeedsDisplay];
}

- (void)changeTemperatureUnit
{
    if (ISFAHRENHEIT)
    {
        topView.bFah = YES;
        lineView.bFah = YES;
    }
    else
    {
        topView.bFah = NO;
        lineView.bFah = NO;
    }
    [topView setNeedsDisplay];
    [lineView setNeedsDisplay];
}

- (void)OpenAlarmAction
{
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"OpenAlarm"])
    {
        
        topView.disabel375 = YES;
        topView.disabel385 = YES;
        topView.disabel385 = YES;
        NSLog(@"警报关闭");
    }
    else
    {
        topView.disabel375 = NO;
        topView.disabel385 = NO;
        topView.disabel385 = NO;
        
        NSLog(@"警报开启");
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    selectMemberDict = [NSMutableDictionary dictionary];
    
    // Do any additional setup after loading the view.
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 44)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = DPLocalizedString(@"SOMY THERMOMETER");
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor GREENCOLOR];
    self.navigationItem.titleView = titleLabel;
    
    topView = [[CircleView alloc] initWithFrame:CGRectMake(0, INCREMENT + TabbarHeight, SCREEN_WIDTH, SCREEN_HEIGHT * 0.46) temperature:(temperature / 10.0)];
    [[self view] addSubview:topView];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"isF"])
    {
        topView.bFah = YES;
    }
    else
    {
        topView.bFah = NO;
    }
    UIImageView *blueTooth = [[UIImageView alloc]initWithFrame:CGRectMake(topView.frame.origin.x + 10, topView.frame.origin.y + 10, 50, 24)];
    [blueTooth setImage:[UIImage imageNamed:@"yilianjie"]];
    [self.view addSubview:blueTooth];
    
    connectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [connectButton setFrame:CGRectMake(blueTooth.frame.origin.x +20, blueTooth.frame.origin.y, 100, blueTooth.frame.size.height)];
    [connectButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [connectButton setTitle:DPLocalizedString(@"scan") forState:UIControlStateNormal];
    connectButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [connectButton addTarget:self action:@selector(searchDeviceAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:connectButton];
    
    UIButton *refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [refreshButton setFrame:CGRectMake(SCREEN_WIDTH - 10 - 18,blueTooth.frame.origin.y, 18, 18)];
    [refreshButton setBackgroundImage:[UIImage imageNamed:@"shuaxin"] forState:UIControlStateNormal];
    [refreshButton setBackgroundImage:[UIImage imageNamed:@"shuaxin"] forState:UIControlStateHighlighted];
    [refreshButton addTarget:self action:@selector(refreshAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:refreshButton];
    
    
    lineView = [[LineChartView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT * 0.46 + INCREMENT + TabbarHeight, SCREEN_WIDTH, SCREEN_HEIGHT * 0.44)];
//    lineView.backgroundColor = [UIColor purpleColor];
    if (ISFAHRENHEIT)
    {
        lineView.bFah = YES;
    }
    else
    {
        lineView.bFah = NO;
    }
    [[self view] addSubview:lineView];
    
    [self setupLeftMenuButton];
    [self setupRightMenuButton];
    
    searchHospital = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchHospital setFrame:CGRectMake(10,topView.frame.origin.y + topView.frame.size.height - 40, 16, 24 )];
    [searchHospital addTarget:self action:@selector(searchHospitalAction) forControlEvents:UIControlEventTouchUpInside];
    [searchHospital setBackgroundImage:[UIImage imageNamed:@"fujinyiyuan"] forState:UIControlStateNormal];
    [searchHospital setBackgroundImage:[UIImage imageNamed:@"fujinyiyuan"] forState:UIControlStateHighlighted];
    
    [self.view addSubview:searchHospital];
    
    medicationGuide = [UIButton buttonWithType:UIButtonTypeCustom];
    [medicationGuide setFrame:CGRectMake(topView.frame.size.width - 25 - 10, searchHospital.frame.origin.y, 25, 25 )];
    [medicationGuide addTarget:self action:@selector(medicationGuideAction) forControlEvents:UIControlEventTouchUpInside];
    [medicationGuide setBackgroundImage:[UIImage imageNamed:@"yongyaozhinan"] forState:UIControlStateNormal];
    [medicationGuide setBackgroundImage:[UIImage imageNamed:@"yongyaozhinan"] forState:UIControlStateHighlighted];
    
    [self.view addSubview:medicationGuide];
    
    
    setWarnTemperature = [UIButton buttonWithType:UIButtonTypeCustom];
    [setWarnTemperature setFrame:CGRectMake((topView.frame.size.width - 100)/2, topView.frame.origin.y + topView.frame.size.height - 30, 100, 30 )];
    [setWarnTemperature setTitle:DPLocalizedString(@"Manual set") forState:UIControlStateNormal];
    [setWarnTemperature addTarget:self action:@selector(setWarnTemperatureAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:setWarnTemperature];
    
    
//    locManager = [[CLLocationManager alloc] init];
//    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8) {
//        //获取授权认证
//        [locManager requestAlwaysAuthorization];
//        [locManager requestWhenInUseAuthorization];
//    }
//    locManager.delegate = self;
//    locManager.desiredAccuracy = kCLLocationAccuracyBest;
//    locManager.distanceFilter = 1000.0f;
//    [locManager startUpdatingLocation];
    
    
    if (topView.currentTemp <= topView.warnTemp * 10)
    {
        searchHospital.hidden = YES;
        medicationGuide.hidden = YES;
    }
    else
    {
//        searchHospital.hidden = NO;
        medicationGuide.hidden = NO;
    }
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"selectMember"])
    {
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"selectMember"] isKindOfClass:[NSDictionary class]])
        {
            [selectMemberDict  setDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"selectMember"]];

            if ([self.delegate respondsToSelector:@selector(refreshHistoryListWithInfomation:)])
            {
                [self.delegate refreshHistoryListWithInfomation:selectMemberDict];
            }
            [self synchronousAction];
        }
    }
    
}
//手动设置温度
- (void)setWarnTemperatureAction
{
    EAWarnViewController *setWarn = [[EAWarnViewController alloc] init];
    setWarn.delegate = self;
    setWarn.warnTemperature = topView.warnTemp;
    [self.navigationController pushViewController:setWarn animated:YES];
}


- (void)searchDeviceAction
{
    
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"selectDevice"])
    {
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"selectDevice"];
    }
    LinkBlueViewController *ctl = [[LinkBlueViewController alloc] init];
    ctl.bluetoothType = BluetoothTypeHeartRate;
    [self.navigationController pushViewController:ctl animated:YES];
}
- (void)medicationGuideAction
{
    NSLog(@"用药指南");
    EAMedicationGuideViewController *medicationGuice = [[EAMedicationGuideViewController alloc]init];
    [self.navigationController pushViewController:medicationGuice animated:YES];
}


- (void)searchHospitalAction
{
    if (isLoading)
    {
        ZZMapViewController *controller = [[ZZMapViewController alloc] initWithG:@"医院"];
        controller.lat = lat;
        controller.lng = lng;
        [self.navigationController pushViewController:controller animated:YES];
    }else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                       message:@"正在定位中请稍后。。"
                                                      delegate:self
                                             cancelButtonTitle:@"取消"
                                             otherButtonTitles:nil];
        [alert show];
    }

}

- (void)refreshAction
{
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"isF"])
    {
        topView.bFah = YES;
        lineView.bFah = YES;
    }
    else
    {
        topView.bFah = NO;
        lineView.bFah = NO;
    }
    
    [topView setCurrentTemp:(temperature / 10.0)];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",(long)temperature],@"TEMP",[NSString stringWithFormat:@"%ld",(long)allMinutes],@"TIME",nil];
    
    [lineView setYArrayWithDictoinary:dict];
    if ([selectMemberDict count])
    {
        
        if ([[NSUserDefaults standardUserDefaults]objectForKey:@"selectDevice"])
        {
            if (oldMinutes == allMinutes)
            {
                return;
            }
            else
            {
                oldMinutes = allMinutes;
                [self addUserMemberTemperature];
            }
            
        }
       
    }
    
}
- (void)refreshLineView
{
    [lineView setNeedsDisplay];
}


- (void)synchronousAction
{
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"synchronous"])
    {
        NSLog(@"远程同步");
    
        synchronousTimer = [NSTimer scheduledTimerWithTimeInterval:60.0 target:self selector:@selector(getSynchronousTemperature) userInfo:nil repeats:YES];
    
    }
    else
    {
        NSLog(@"结束同步");
        if (synchronousTimer)
        {
            [synchronousTimer invalidate];
            synchronousTimer = nil;
        }
        
        [lineView.yArray removeAllObjects];
        [self refreshAction];
        [self getHistoryTemperatureByDate];
        
    }
}
- (void)stopScanDeviceAction
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"synchronous"])
    {
        NSLog(@"button 不可用");
        
        if ([selectMemberDict count])
        {
            [self synchronousAction];
        }
        [connectButton setTitle:DPLocalizedString(@"Synchronous") forState:UIControlStateNormal];
        connectButton.userInteractionEnabled = NO;
    }
    else
    {
        NSLog(@"button 可用");
        [connectButton setTitle:DPLocalizedString(@"scan") forState:UIControlStateNormal];
        connectButton.userInteractionEnabled = YES;
        
    }
}

- (void)getSynchronousTemperature
{
    NSLog(@"--->获取同步数据");
//    [lineView.yArray removeAllObjects];
//    [self refreshAction];
    [self getHistoryTemperatureByDate];
}

#pragma mark 手动设置温度代理

- (void)manualSettingWarnTemperature:(NSString *)warnTemperature
{
    topView.manualWarnTemp = YES;
    [topView setWarnTemp:[warnTemperature floatValue]];
    
    [lineView setNeedsDisplay];
    
}
#pragma mark 上传温度
- (void)addUserMemberTemperature
{
    dispatch_queue_t network_queue;
    network_queue = dispatch_queue_create("add_user_temperature", nil);
    dispatch_async(network_queue, ^{
        
        
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                              [selectMemberDict objectForKey:@"user_id"],@"user_id",
                              LANGUAGE_TYPE,@"lang_type",
                              [selectMemberDict objectForKey:@"id"],@"member_id",
                              @"0",@"device_id",
                              [NSString stringWithFormat:@"%ld",(long)temperature],@"temperature",
                              uploadTime,@"test_time",
                              nil];
        NSString *request = [HTTPRequest requestForGetWithPramas:dict method:@"add_user_temperature"];
        NSDictionary *dictionary = [JsonUtil jsonToDic:request];
        
        NSLog(@"dic==%@",dictionary);
        //turn to main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([[dictionary objectForKey:@"msg"]integerValue] == 1)
            {
                //                NSString *data =  [dictionary objectForKey:@"data"];
                //                data = [FBEncryptorDES decrypt:data keyString:@"SDFL#)@F"];
                //                data = [data URLDecodedString]
//                NSLog(@"添加成功");
            }
            else
            {
                sleep(1);
                
                if ([dictionary objectForKey:@"msgbox"] != nil) {
                    //                    [hud setCaption:[dictionary objectForKey:@"msgbox"]];
                    //                    [hud setActivity:NO];
                    //                    [hud update];
                    //                    hud.delegate = nil;
                    //                    [hud hideAfter:1.0];
                }else
                {
                    //                    [hud setCaption:@"登录失败"];
                    //                    [hud setActivity:NO];
                    //                    [hud update];
                    //                    hud.delegate = nil;
                    //                    [hud hideAfter:1.0];
                }
                
            }
        });
    });
}

- (void)getHistoryTemperatureByDate
{
    dispatch_queue_t network_queue;
    network_queue = dispatch_queue_create("get_user_temperature_detail", nil);
    dispatch_async(network_queue, ^{
        
        
        //        user_id=238
        //        member_id=379
        //        member_name=ttt
        //        device_id=
        //        page_id=1
        //        page_size=30
        //        lang_type=语言类型(中文:Zh-Hans,英文:en)
        
        
        //        {
        //            id = 381;
        //            isSelect = NO;
        //            "member_name" = rrr;
        //            "user_id" = 238;
        //        }
        NSDateFormatter *Formatter = [[NSDateFormatter alloc]init];
        Formatter.dateFormat = @"yyyy-MM-dd";
        NSString *nowDate = [Formatter stringFromDate:[NSDate  date]];
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                              [selectMemberDict objectForKey:@"user_id"] ,@"user_id",
                              [selectMemberDict objectForKey:@"id"],@"member_id",
                              nowDate,@"test_time",
                              @"0",@"device_id",
                              LANGUAGE_TYPE,@"lang_type",
                              nil];
        NSString *request = [HTTPRequest requestForGetWithPramas:dict method:@"get_user_temperature_list"];
        NSDictionary *dictionary = [JsonUtil jsonToDic:request];
        
        NSLog(@"dic==%@",dictionary);
        //turn to main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([[dictionary objectForKey:@"msg"]integerValue] == 1)
            {
                [lineView.yArray removeAllObjects];
                NSArray *array = [dictionary objectForKey:@"data"];
                
                
                for (NSDictionary *dic in array)
                {
                    
                    NSString *getTemper = [dic objectForKey:@"temperature"];
                    NSString *timeString = [dic objectForKey:@"test_time"];
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
                    dateFormatter.dateFormat = @"MM/dd/yyyy HH:mm:ss";
                    NSDate *whichDate = [dateFormatter dateFromString:timeString];
                    
                    //分割时间
                    NSDateComponents *comps;
                    NSCalendar *calendar = [NSCalendar currentCalendar];
                    comps =[calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit |NSDayCalendarUnit |NSHourCalendarUnit |NSMinuteCalendarUnit) fromDate:whichDate];
                    NSInteger hours = [comps hour];
                    NSInteger minutes = [comps minute];
                    
                    NSInteger addMinutes = hours * 60 + minutes;
                    
                    NSLog(@"第%ld分钟",(long)addMinutes);
                    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
                    formatter.dateFormat = @"yyyy:MM:dd";
                    NSString *dateString = [formatter stringFromDate:whichDate];
                    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:getTemper,@"TEMP",[NSString stringWithFormat:@"%ld",(long)addMinutes],@"TIME",dateString,@"DATE",nil];
                    //                    [historyArray addObject:dict];
                    
                    [lineView setYArrayWithDictoinary:dict];
                }
                if ([[NSUserDefaults standardUserDefaults] objectForKey:@"synchronous"])
                {
                    if ([array count])
                    {
                        NSDictionary *dict = [array lastObject];
                        CGFloat current = [[dict objectForKey:@"temperature"] intValue] / 10.0;
                        NSLog(@"current =====%f",current);
                        [topView setCurrentTemp:current];
                    }
                }
                
            }else
            {
                
                if ([dictionary objectForKey:@"msgbox"] != NULL) {
                    
                    //                        [hud setCaption:[dictionary objectForKey:@"msgbox"]];
                    //                        [hud setActivity:NO];
                    //                        [hud update];
                    
                }else
                {
                    
                    //                        [hud setCaption:@"网络出问题了"];
                    //                        [hud setActivity:NO];
                    //                        [hud update];
                }
            }
        });
    });
    
}

#pragma mark selectMemberDelegate

- (void)selectMemberWithInfomation:(NSDictionary *)dictionary
{
    [selectMemberDict  setDictionary:dictionary];
    NSLog(@"select-->%@",dictionary);
    
    if ([self.delegate respondsToSelector:@selector(refreshHistoryListWithInfomation:)])
    {
        [self.delegate refreshHistoryListWithInfomation:selectMemberDict];
    }
    [self synchronousAction];
//    [lineView.yArray removeAllObjects];
//    [self refreshAction];
//    [self getHistoryTemperatureByDate];
    
}
#pragma mark 获取定位 ios2.0-6.0
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    [manager stopUpdatingLocation];
    lat = newLocation.coordinate.latitude;
    lng = newLocation.coordinate.longitude;
    CLGeocoder *geoCoder = [[CLGeocoder alloc]init];
    [geoCoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error)
     {
        
         MKPlacemark *palcemark = (MKPlacemark *)[placemarks objectAtIndex:0];
         
         //         NSString *addressString = [[[NSString alloc]initWithFormat:@"%@%@%@%@%@",palcemark.administrativeArea,palcemark.locality,palcemark.subLocality,palcemark.thoroughfare,palcemark.subThoroughfare] autorelease];
         NSString *addressString = @"";
         if (palcemark.administrativeArea != nil)
         {
             addressString = [addressString stringByAppendingString:palcemark.administrativeArea];
         }
         if (palcemark.locality != nil)
         {
             addressString = [addressString stringByAppendingString:palcemark.locality];
         }
         if (palcemark.subLocality != nil)
         {
             addressString = [addressString stringByAppendingString:palcemark.subLocality];
         }
         if (palcemark.thoroughfare != nil)
         {
             addressString = [addressString stringByAppendingString:palcemark.thoroughfare];
         }
         if (palcemark.subThoroughfare != nil)
         {
             addressString = [addressString stringByAppendingString:palcemark.subThoroughfare];
         }
         isLoading=YES;
         
     }];

}

#pragma mark 获取定位 ios6.0-->
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    if (locations.count > 0)
    {
        lat = ((CLLocation *)[locations objectAtIndex:0]).coordinate.latitude;
        lng = ((CLLocation *)[locations objectAtIndex:0]).coordinate.longitude;
    }
    [manager stopUpdatingLocation];
    
    CLGeocoder *geoCoder = [[CLGeocoder alloc]init];
    [geoCoder reverseGeocodeLocation:(CLLocation *)[locations objectAtIndex:0] completionHandler:^(NSArray *placemarks, NSError *error)
     {
         MKPlacemark *palcemark = (MKPlacemark *)[placemarks objectAtIndex:0];
         //         NSString *addressString = [[[NSString alloc]initWithFormat:@"%@%@%@%@%@",palcemark.administrativeArea,palcemark.locality,palcemark.subLocality,palcemark.thoroughfare,palcemark.subThoroughfare] autorelease];
         
         NSString *addressString = @"";
         if (palcemark.administrativeArea != nil)
         {
             addressString = [addressString stringByAppendingString:palcemark.administrativeArea];
         }
         if (palcemark.locality != nil)
         {
             addressString = [addressString stringByAppendingString:palcemark.locality];
         }
         if (palcemark.subLocality != nil)
         {
             addressString = [addressString stringByAppendingString:palcemark.subLocality];
         }
         if (palcemark.thoroughfare != nil)
         {
             addressString = [addressString stringByAppendingString:palcemark.thoroughfare];
         }
         if (palcemark.subThoroughfare != nil)
         {
             addressString = [addressString stringByAppendingString:palcemark.subThoroughfare];
         }
         
         isLoading=YES;
        
     }];
    
}


-(void)setupLeftMenuButton
{
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(0, 0, 40, 44)];
//    [leftButton setBackgroundImage:[UIImage imageNamed:@"gengduo"] forState:UIControlStateNormal];
//    [leftButton setBackgroundImage:[UIImage imageNamed:@"gengduo"] forState:UIControlStateHighlighted];
    [leftButton addTarget:self action:@selector(leftDrawerButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *leftImage = [[UIImageView alloc]initWithFrame:CGRectMake(7, 12, 25, 19)];
    [leftImage setImage:[UIImage imageNamed:@"gengduo"]];
    [leftButton addSubview:leftImage];
    
    [self.navigationController.navigationBar addSubview:leftButton];
    
}

-(void)setupRightMenuButton
{
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setFrame:CGRectMake(SCREEN_WIDTH - 40, 0, 40, 44)];
//    [rightButton setBackgroundImage:[UIImage imageNamed:@"tixingtubiao"] forState:UIControlStateNormal];
//    [rightButton setBackgroundImage:[UIImage imageNamed:@"tixingtubiao"] forState:UIControlStateHighlighted];
    
    UIImageView *rightImage = [[UIImageView alloc]initWithFrame:CGRectMake(12, 10, 15, 23)];
    [rightImage setImage:[UIImage imageNamed:@"tixingtubiao"]];
    [rightButton addSubview:rightImage];
    
    [rightButton addTarget:self action:@selector(rightDrawerButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:rightButton];
}

#pragma mark - Button Handlers
-(void)leftDrawerButtonPress:(id)sender
{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];

}

-(void)rightDrawerButtonPress:(id)sender
{
    if (temperature > topView.warnTemp * 10)
    {
        EASuggestViewController *suggest = [[EASuggestViewController alloc]init];
        suggest.tempString = [NSString stringWithFormat:@"%0.1f",temperature / 10.0];
        [self.navigationController pushViewController:suggest animated:YES];
    }

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
