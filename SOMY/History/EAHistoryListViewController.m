//
//  EAHistoryListViewController.m
//  SOMY
//
//  Created by easaa on 9/2/14.
//  Copyright (c) 2014 easaa. All rights reserved.
//

#import "EAHistoryListViewController.h"
#import "EAHistoryDetailViewController.h"
#import "SVPullToRefresh.h"
#import "EAAlarmListCell.h"

#import "UIViewController+MMDrawerController.h"

#import "DataLibrary.h"
@interface EAHistoryListViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    CustomNavigation *myNavigationBar;
    UITableView *historyTableview;
    NSMutableArray *historyArray;
    NSMutableDictionary *memberDictionary;
    NSInteger pageIndex;
    NSInteger pageSize;
    NSString *localTableName;
    BOOL selectMember;
    DataLibrary *dataLib;
}
@end

@implementation EAHistoryListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        selectMember = NO;
        pageIndex = 1;
        pageSize = 10;
        historyArray = [NSMutableArray array];
        memberDictionary = [NSMutableDictionary dictionary];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeLanguageAction) name:@"changeLanguage" object:nil];
        dataLib = [DataLibrary shareDataLibrary];
        [historyArray addObjectsFromArray:[dataLib getAllTableFromLibrary]];
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
//    if ([memberDictionary count])
//    {
//        [self getHistoryTemperatureList:YES];
//    }
    
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = YES;
    
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
    historyTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, myNavigationBar.frame.origin.y + myNavigationBar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - INCREMENT - myNavigationBar.frame.size.height) style:UITableViewStylePlain];
    [historyTableview setBackgroundColor:[UIColor colorwithHexString:@"#EEEFF0"]];
//    [historyTableview setBackgroundColor:[UIColor redColor]];
    historyTableview.delegate = self;
    historyTableview.dataSource = self;
    [self.view addSubview:historyTableview];
    
    __weak EAHistoryListViewController *controller = self;
    
    [historyTableview addPullToRefreshWithActionHandler:^{
        [controller refreshHistoryListAction];
    }];
    if ([memberDictionary count])
    {
        [historyTableview addInfiniteScrollingWithActionHandler:^{
            [controller getHistoryTemperatureList:NO];
        }];
        
        
        [self getHistoryTemperatureList:YES];
    }
   
}
- (void)back
{
    [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
        
    }];
    
}

- (void)changeLanguageAction
{
    myNavigationBar.titleLabel.text = DPLocalizedString(@"Inquire record");
}
#pragma mark refreshHistoryListDelegate
- (void)refreshHistoryListWithInfomation:(NSDictionary *)dictionary
{
    [memberDictionary setDictionary:dictionary];
    selectMember = YES;
    
    if ([historyArray count])
    {
        [historyArray removeAllObjects];
    }
    [self getHistoryTemperatureList:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark tableviewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 66.0f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    EAAlarmListCell *cell = (EAAlarmListCell*)[tableView cellForRowAtIndexPath:indexPath];
    
    EAHistoryDetailViewController *historyDetail = [[EAHistoryDetailViewController alloc]init];
    if (selectMember)
    {
        historyDetail.userId = [memberDictionary objectForKey:@"user_id"];
        historyDetail.memberId = [memberDictionary objectForKey:@"id"];
        historyDetail.userName = [memberDictionary objectForKey:@"member_name"];
        historyDetail.getLocalData = NO;
    }
    else
    {
        historyDetail.getLocalData = YES;
        NSInteger row = [historyArray count] - indexPath.row - 1;
        
        historyDetail.tableName = [historyArray objectAtIndex:row];
    }
    
    historyDetail.selectDate = cell.alarmTime.text;
    historyDetail.topTemperature = cell.weekday.text;
    [self.navigationController pushViewController:historyDetail animated:YES];
}
#pragma mark tableviewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [historyArray count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseID=@"cellID";
    EAAlarmListCell *cell=[tableView dequeueReusableCellWithIdentifier:reuseID];
    if (cell==nil)
    {
        cell =[[[NSBundle mainBundle]loadNibNamed:@"EAAlarmListCell" owner:self options:nil]lastObject];
    }
    NSInteger row = [historyArray count] - indexPath.row - 1;
    if (selectMember)
    {
        NSString *whichDateString = [[historyArray objectAtIndex:indexPath.row]objectForKey:@"test_time"];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        dateFormatter.dateFormat = @"MM/dd/yyyy HH:mm:ss";
        NSDate *whichDate = [dateFormatter dateFromString:whichDateString];
        NSDateFormatter *newDateFormatter = [[NSDateFormatter alloc]init];
        newDateFormatter.dateFormat = @"yyyy-MM-dd";
        cell.alarmTime.text = [newDateFormatter stringFromDate:whichDate];
        
        NSString *tempString = [[historyArray objectAtIndex:indexPath.row]objectForKey:@"temperature"];
        cell.weekday.text = [NSString stringWithFormat:@"%@ %0.1f %@",DPLocalizedString(@"Top Temperature: "),TemperatureChange([tempString floatValue] / 10.0),TEMPERATUREUNIT];

    }
    else
    {
//        cell.alarmTime.text =[historyArray objectAtIndex:row];
        NSString *string = [historyArray objectAtIndex:row];
        NSString *dateStr = [string substringFromIndex:1];
        
        NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
        formatter1.dateFormat = @"yyyyMMdd";
        NSDate *date = [formatter1 dateFromString:dateStr];
        
        NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
        formatter2.dateFormat = @"yyyy-MM-dd";
        
        NSString *string2 = [formatter2 stringFromDate:date];
        cell.alarmTime.text = string2;
        
        NSString *string3 =[dataLib getMaxTemperatureFromTable:string];
        cell.weekday.text = [NSString stringWithFormat:@"%@ %0.1f %@",DPLocalizedString(@"Top Temperature: "),TemperatureChange([string3 floatValue] / 10.0),TEMPERATUREUNIT];
    }
        cell.switchButton.hidden = YES;
    return cell;
}

- (void)refreshHistoryListAction
{
    if ([memberDictionary count])
    {
        [self getHistoryTemperatureList:YES];
    }
    else
    {
        if ([historyArray count])
        {
            [historyArray removeAllObjects];
        }
        [historyArray addObjectsFromArray:[dataLib getAllTableFromLibrary]];
        [historyTableview reloadData];
        [historyTableview.pullToRefreshView stopAnimating];
    }
}
- (void)getHistoryTemperatureList:(BOOL)isFirst
{
    
    if (isFirst)
    {
        pageIndex = 1;
       
    }
    dispatch_queue_t network_queue;
    network_queue = dispatch_queue_create("getHistoryTemperatureList", nil);
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
                            [memberDictionary objectForKey:@"user_id"],@"user_id",
                            [memberDictionary objectForKey:@"id"],@"member_id",
                            [memberDictionary objectForKey:@"member_name"],@"member_name",
                            @"0",@"device_id",
                            [NSString stringWithFormat:@"%ld",(long)pageIndex],@"page_id",
                            [NSString stringWithFormat:@"%ld",(long)pageSize],@"page_size",
                            LANGUAGE_TYPE,@"lang_type",
                              nil];
        NSString *request = [HTTPRequest requestForGetWithPramas:dict method:@"get_user_temperature_date_list"];
        NSDictionary *dictionary = [JsonUtil jsonToDic:request];
        
        NSLog(@"dic==%@",dictionary);
        //turn to main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([[dictionary objectForKey:@"msg"]integerValue] == 1)
            {
//                NSLog(@"dictioanry :%@",[dictionary description]);
//                NSString *dataString = [dictionary objectForKey:@"data"];
//                dataString = [FBEncryptorDES decrypt:dataString keyString:@"SDFL#)@F"];
//                dataString = [dataString URLDecodedString];
//                NSArray *array = [JsonUtil jsonToArray:dataString];
                NSArray *array = [dictionary objectForKey:@"data"];
                if ([historyArray count])
                {
                    [historyArray removeAllObjects];
                }
                [historyArray addObjectsFromArray:array];
                
                [historyTableview reloadData];
                if (isFirst)
                {
                    [historyTableview.pullToRefreshView stopAnimating];
                }
                else
                {
                    [historyTableview.infiniteScrollingView stopAnimating];
                }
                
                if (array.count < pageSize)
                {
                    historyTableview.infiniteScrollingView.enabled = NO;
                    historyTableview.contentInset = UIEdgeInsetsZero;
                }
                else
                {
                    pageIndex ++;
                }
                
//                if (isFirst)
//                {
//                    [hud hideAfter:1.0f];
//                }
            }else
            {
                if (isFirst)
                {
                    [historyTableview.pullToRefreshView stopAnimating];
                }
                else
                {
                    [historyTableview.infiniteScrollingView stopAnimating];
                }
                
                
                if ([dictionary objectForKey:@"msgbox"] != NULL) {
                    if (isFirst)
                    {
//                        [hud setCaption:[dictionary objectForKey:@"msgbox"]];
//                        [hud setActivity:NO];
//                        [hud update];
                    }
                }else
                {
                    if (isFirst) {
                        
//                        [hud setCaption:@"网络出问题了"];
//                        [hud setActivity:NO];
//                        [hud update];
                    }
                }
                if (isFirst)
                {
//                    [hud hideAfter:1.0f];
                }
            }
        });
    });
    
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
