//
//  EAAddAlarmViewController.m
//  SOMY
//
//  Created by easaa on 9/2/14.
//  Copyright (c) 2014 easaa. All rights reserved.
//

#import "EAAddAlarmViewController.h"

#import "EAMusicListViewController.h"
#import "EAWeekListViewController.h"
@interface EAAddAlarmViewController ()<EAWeekListDelegate,EAMusicListDelegate>
{
    CustomNavigation *myNavigationBar;
    UIDatePicker *datePicker;
    NSMutableDictionary *sendAlarmInfo;
    NSMutableDictionary *weekDictionary;
    UILabel *ringNameLabel;
    BOOL isEditAlarm;
    NSDictionary *receiveDictionary;
}
@end

@implementation EAAddAlarmViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        isEditAlarm = NO;
    }
    return self;
}

- (id)initWithAlarmInfomation:(NSDictionary *)infoDictionary
{
    self = [super init];
    if (self)
    {
        isEditAlarm = YES;
        receiveDictionary  = [NSDictionary dictionaryWithDictionary:infoDictionary];
    }
    return self;

    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    sendAlarmInfo = [NSMutableDictionary dictionary];
    weekDictionary = [NSMutableDictionary dictionary];
    
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorwithHexString:@"#EEEFF0"];
    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
    {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 20)];
        view.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:view];
    }
    myNavigationBar = [[CustomNavigation alloc]initWithFrame:CGRectMake(0, INCREMENT, 320, 44)];
    myNavigationBar.titleLabel.text = DPLocalizedString(@"Add Alarm");
    myNavigationBar.leftButton.hidden = NO;
    [myNavigationBar.leftButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    myNavigationBar.submitButton.hidden = NO;
    [myNavigationBar.submitButton addTarget:self action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:myNavigationBar];
    
    datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, myNavigationBar.frame.origin.y + myNavigationBar.frame.size.height, 320, 160)];
    datePicker.datePickerMode = UIDatePickerModeTime;
    
    [self.view addSubview:datePicker];
    
    UIView *cellView = [[UIView alloc]initWithFrame:CGRectMake(0, datePicker.frame.origin.y + datePicker.frame.size.height + 20, 320, 70)];
    [cellView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:cellView];
    
    UILabel *musicLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 72, 21)];
    musicLabel.text = DPLocalizedString(@"Ring");
    musicLabel.backgroundColor = [UIColor clearColor];
    [cellView addSubview:musicLabel];
    
    ringNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(190, 7, 102, 21)];
    ringNameLabel.backgroundColor = [UIColor clearColor];
    ringNameLabel.textAlignment = NSTextAlignmentRight;
    ringNameLabel.text = @"nice.mp3";
    [cellView addSubview:ringNameLabel];
    
    UIImageView *lineImage =[[UIImageView alloc]initWithFrame:CGRectMake(10, 35, 300, 1)];
    [lineImage setImage:[UIImage imageNamed:@"fenlanxian.png"]];
    [cellView addSubview:lineImage];
    
    UILabel *repeatLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 43, 72, 21)];
    repeatLabel.text = DPLocalizedString(@"Repeat");
    repeatLabel.backgroundColor = [UIColor clearColor];
    [cellView addSubview:repeatLabel];
    
    UIImageView *accessoryImage = [[UIImageView alloc]initWithFrame:CGRectMake(300, 10, 9, 15)];
    [accessoryImage setImage:[UIImage imageNamed:@"daoxiangjian.png"]];
    [cellView addSubview:accessoryImage];
    
    
    UIImageView *accessoryImage1 = [[UIImageView alloc]initWithFrame:CGRectMake(300, 46, 9, 15)];
    [accessoryImage1 setImage:[UIImage imageNamed:@"daoxiangjian.png"]];
    [cellView addSubview:accessoryImage1];
    
    UIButton *musicButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [musicButton setFrame:CGRectMake(0, 0, 320, 35)];
    [musicButton addTarget:self action:@selector(selectMusicAction) forControlEvents:UIControlEventTouchUpInside];
    [cellView addSubview:musicButton];
    
    UIButton *repeatButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [repeatButton setFrame:CGRectMake(0, 36, 320, 35)];
    [repeatButton addTarget:self action:@selector(selectRepeatAction) forControlEvents:UIControlEventTouchUpInside];
    [cellView addSubview:repeatButton];
    
    if (isEditAlarm)
    {
        NSArray * allLocalNotification=[[UIApplication sharedApplication] scheduledLocalNotifications];
        for (UILocalNotification * localNotification in allLocalNotification)
        {
            if ([ [receiveDictionary objectForKey:@"id"] isEqualToString:[localNotification.userInfo objectForKey:@"id"]])
            {
                datePicker.date = localNotification.fireDate;
                ringNameLabel.text = localNotification.soundName;
            }
        }
        
        UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [deleteButton setFrame:CGRectMake(0, cellView.frame.origin.y + cellView.frame.size.height + 20, 320, 35)];
        [deleteButton setTitle:DPLocalizedString(@"Delete") forState:UIControlStateNormal];
        [deleteButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [deleteButton setBackgroundColor:[UIColor whiteColor]];
        [deleteButton addTarget:self action:@selector(deleteAlarmAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:deleteButton];
    }
    
}
- (void)executeRefreshAlarmListAction
{
    if (_delegate&&[_delegate respondsToSelector:@selector(refreshAlarmListAction)])
    {
        [_delegate refreshAlarmListAction];
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)deleteAlarmAction
{
    NSArray * allLocalNotification=[[UIApplication sharedApplication] scheduledLocalNotifications];
    for (UILocalNotification * localNotification in allLocalNotification)
    {
        if ([ [receiveDictionary objectForKey:@"id"] isEqualToString:[localNotification.userInfo objectForKey:@"id"]])
        {
            [[UIApplication sharedApplication] cancelLocalNotification:localNotification];
        }
    }
    [self performSelector:@selector(executeRefreshAlarmListAction) withObject:nil afterDelay:0.1f];
}
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)selectMusicAction
{
    EAMusicListViewController *musicList = [[EAMusicListViewController alloc]init];
    musicList.delegate = self;
    musicList.isSelect = YES;
    [self.navigationController pushViewController:musicList animated:YES];
}
- (void)selectRepeatAction
{
    EAWeekListViewController *weekList = [[EAWeekListViewController alloc]init];
    weekList.delegate = self;
    [self.navigationController pushViewController:weekList animated:YES];
}

- (void)submitAction
{
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8)
    {
        if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)])
        {
            
            [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
        }
    }
    
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    formatter.dateFormat = @"HH:mm:00";
//    NSString *dateString = [formatter stringFromDate:datePicker.date];
    
    //创建本地通知
    UILocalNotification *newLocalNotification = [[UILocalNotification alloc] init];
    //设置触发的时间
    newLocalNotification.fireDate = datePicker.date;
    //设置重复的间隔单位
    newLocalNotification.repeatInterval = kCFCalendarUnitDay;
    //设置触发时间的时区
    newLocalNotification.timeZone = [NSTimeZone defaultTimeZone];
    //设置重复的日历单位
    newLocalNotification.repeatCalendar = [NSCalendar currentCalendar];
    //设置通知显示的主要内容--
    newLocalNotification.alertBody = @"您的时间到了";
    //设置通知显示时按钮标题
    //newLocalNotification.alertAction = @"去吧";
    //设置应用程序图标上标识的数字
    newLocalNotification.applicationIconBadgeNumber = newLocalNotification.applicationIconBadgeNumber++;
    //设置提醒声音 可以使用系统声音(静音)或自定义声音--
        newLocalNotification.soundName = UILocalNotificationDefaultSoundName;
    //自定义提醒声音 最长不能超过30秒
//    newLocalNotification.soundName = @"sweet.mp3";
    
    newLocalNotification.soundName = ringNameLabel.text;
    
    
    [sendAlarmInfo setObject:weekDictionary forKey:@"week"];
    
     NSArray * allLocalNotification=[[UIApplication sharedApplication] scheduledLocalNotifications];
    
    if (isEditAlarm)
    {
        [sendAlarmInfo setValue:[sendAlarmInfo objectForKey:@"id"] forKey:@"id"];
        [sendAlarmInfo setValue:[sendAlarmInfo objectForKey:@"state"] forKey:@"state"];
       
        for (UILocalNotification * localNotification in allLocalNotification)
        {
            if ([ [receiveDictionary objectForKey:@"id"] isEqualToString:[localNotification.userInfo objectForKey:@"id"]])
            {
                [[UIApplication sharedApplication] cancelLocalNotification:localNotification];
            }
        }
    }
    else
    {
        NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
        long long int date = (long long int)time;
        [sendAlarmInfo setValue:[NSString stringWithFormat:@"%lld",date] forKey:@"id"];
        [sendAlarmInfo setValue:@"YES" forKey:@"state"];
    }
    //设置传递的参数
    newLocalNotification.userInfo = [NSDictionary dictionaryWithDictionary:sendAlarmInfo];
    //在系统消息队列中注册消息--
    [[UIApplication sharedApplication] scheduleLocalNotification:newLocalNotification];
    
    [self performSelector:@selector(executeRefreshAlarmListAction) withObject:nil afterDelay:0.1f];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark WeekListDelegate

- (void)EAWeekListViewController:(EAWeekListViewController *)controller selectRepeatWeekByDictionary:(NSMutableDictionary *)weekInfomation
{
    [weekDictionary setValuesForKeysWithDictionary:weekInfomation];
}

#pragma mark MusicListDelegate

- (void)EAMusicListViewController:(EAMusicListViewController *)controller selectMusicByString:(NSString *)musicName
{
    ringNameLabel.text = musicName;

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
