//
//  EAHistoryDetailViewController.m
//  SOMY
//
//  Created by easaa on 9/2/14.
//  Copyright (c) 2014 easaa. All rights reserved.
//

#import "EAHistoryDetailViewController.h"
#import "HistoryLineChartView.h"
#import "DataLibrary.h"
@interface EAHistoryDetailViewController ()
{
    CustomNavigation *myNavigationBar;
    HistoryLineChartView *lineChartView;
    NSMutableArray *historyArray;
    DataLibrary *dataBase;
}
@end

@implementation EAHistoryDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        historyArray = [NSMutableArray array];

        
    }
    return self;
}

- (id)initWithGetDataType:(BOOL)getLocalData
{
    self = [super init];
    if (self)
    {
        
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
    
    if (self.getLocalData)
    {
        dataBase = [DataLibrary shareDataLibrary];
        [self getLocalDataByTableName];
    }
    else
    {
        [self getHistoryTemperatureByDate];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorwithHexString:@"#EEEFF0"];
    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
    {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 20)];
        view.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:view];
    }
    myNavigationBar = [[CustomNavigation alloc]initWithFrame:CGRectMake(0, INCREMENT, 320, 44)];
    myNavigationBar.titleLabel.text = DPLocalizedString(@"Inquire record");
    myNavigationBar.leftButton.hidden = NO;
    [myNavigationBar.leftButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:myNavigationBar];
    
    lineChartView = [[HistoryLineChartView alloc] initWithFrame:CGRectMake(0, myNavigationBar.frame.origin.y + myNavigationBar.frame.size.height, SCREEN_WIDTH,SCREEN_HEIGHT -  TabbarHeight -myNavigationBar.frame.size.height )];
    
    lineChartView.dateName = self.selectDate;
    lineChartView.memberName = self.userName;
    lineChartView.topTemp = self.topTemperature;
    lineChartView.backgroundColor = [UIColor clearColor];
    
    [[self view] addSubview:lineChartView];
}

- (void)getLocalDataByTableName
{

     [lineChartView setYArrayWithMutableArray:[dataBase getallDataByDate:self.tableName]];
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
        
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                              self.userId,@"user_id",
                              self.memberId,@"member_id",
                              self.selectDate,@"test_time",
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

                NSArray *array = [dictionary objectForKey:@"data"];
                
                
                for (NSDictionary *dic in array)
                {
                    
                    NSString *temperature = [dic objectForKey:@"temperature"];
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
                    
                    NSInteger allMinutes = hours * 60 + minutes;
                    
                    NSLog(@"第%ld分钟",(long)allMinutes);
                    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
                    formatter.dateFormat = @"yyyy:MM:dd";
                    NSString *dateString = [formatter stringFromDate:whichDate];
                    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:temperature,@"TEMP",[NSString stringWithFormat:@"%ld",(long)allMinutes],@"TIME",dateString,@"DATE",nil];
//                    [historyArray addObject:dict];
                    [lineChartView setYArrayWithDictoinary:dict];
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

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
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
