//
//  EAAlarmListViewController.m
//  SOMY
//
//  Created by easaa on 9/2/14.
//  Copyright (c) 2014 easaa. All rights reserved.
//

#import "EAAlarmListViewController.h"

#import "EAAddAlarmViewController.h"

#import "UIViewController+MMDrawerController.h"

#import "EAAlarmListCell.h"
@interface EAAlarmListViewController ()<UITableViewDataSource, UITableViewDelegate,EAAddAlarmDelegate>
{
    CustomNavigation *myNavigationBar;
    UITableView *alarmTableView;
    NSMutableArray *alarmList;
}
@end

@implementation EAAlarmListViewController

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
    
    alarmList = [NSMutableArray array];
    // Do any additional setup after loading the view.
//    [self.mm_drawerController setMaximumLeftDrawerWidth:320];
    self.view.backgroundColor = [UIColor colorwithHexString:@"#EEEFF0"];
    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
    {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 20)];
        view.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:view];
    }
    myNavigationBar = [[CustomNavigation alloc]initWithFrame:CGRectMake(0, INCREMENT, 320, 44)];
    myNavigationBar.titleLabel.text = DPLocalizedString(@"List");
    myNavigationBar.leftButton.hidden = NO;
    [myNavigationBar.leftButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    myNavigationBar.addButton.hidden = NO;
    [myNavigationBar.addButton addTarget:self action:@selector(addAlarmAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:myNavigationBar];
    
    //本地闹钟
    NSArray * allLocalNotification=[[UIApplication sharedApplication] scheduledLocalNotifications];
    for (UILocalNotification * localNotification in allLocalNotification)
    {
//        NSString * alarmValue=[localNotification.userInfo objectForKey:@"AlarmKey"];
//        if ([alarmKey isEqualToString:alarmValue])
//        {
//            [[UIApplication sharedApplication] cancelLocalNotification:localNotification];
//        }
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setDictionary:localNotification.userInfo];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"HH:mm:ss";
        NSString *dateString = [formatter stringFromDate:localNotification.fireDate];

        [dict setValue:dateString forKey:@"date"];
        [alarmList addObject:dict];
    }
    
    NSLog(@"local notification ------>%@",alarmList);
    
    alarmTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, myNavigationBar.frame.origin.y + myNavigationBar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - INCREMENT - myNavigationBar.frame.size.height) style:UITableViewStylePlain];
    [alarmTableView setBackgroundColor:[UIColor colorwithHexString:@"#EEEFF0"]];
    alarmTableView.delegate = self;
    alarmTableView.dataSource = self;
    [self.view addSubview:alarmTableView];
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
#pragma mark TableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSDictionary *dict = [alarmList objectAtIndex:indexPath.row];
    
    EAAddAlarmViewController *editAlarm = [[EAAddAlarmViewController alloc]initWithAlarmInfomation:dict];
    editAlarm.delegate = self;
    
    [self.navigationController pushViewController:editAlarm animated:YES];
}
#pragma mark TableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [alarmList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseID=@"cellID";
    EAAlarmListCell *cell=[tableView dequeueReusableCellWithIdentifier:reuseID];
    if (cell==nil)
    {
        cell =[[[NSBundle mainBundle]loadNibNamed:@"EAAlarmListCell" owner:self options:nil]lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    NSDictionary * dict = [alarmList objectAtIndex:indexPath.row];
    NSString *str = [dict objectForKey:@"date"];
    cell.alarmTime.text = str;
    cell.weekday.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    
    cell.switchButton.tag = indexPath.row;
    if ([[dict objectForKey:@"state"] isEqualToString:@"YES"])
    {
        cell.switchButton.selected = NO;
    }
    else
    {
        cell.switchButton.selected = YES;
    }
    [cell.switchButton addTarget:self action:@selector(onSwitchButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 66;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (void)onSwitchButtonAction:(UIButton *)sender
{
    UIButton *btn = sender;
    btn.selected = !btn.selected;
    
    EAAlarmListCell *cell = (EAAlarmListCell *)btn.superview.superview;
    cell.switchButton.selected = btn.selected;

    NSArray * allLocalNotification=[[UIApplication sharedApplication] scheduledLocalNotifications];
    
    UILocalNotification *localNotification = [allLocalNotification objectAtIndex:btn.tag];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:localNotification.userInfo];
    [[UIApplication sharedApplication]cancelLocalNotification:localNotification];
    
    if (cell.switchButton.selected)
    {
        [[alarmList objectAtIndex:btn.tag] setValue:@"NO" forKey:@"state"];
        [dict setValue:@"NO" forKey:@"state"];
    }
    else
    {
         [[alarmList objectAtIndex:btn.tag] setValue:@"YES" forKey:@"state"];
        [dict setValue:@"YES" forKey:@"state"];
    }
    
    localNotification.userInfo = dict;
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

- (void)addAlarmAction
{
    EAAddAlarmViewController *addAlarm = [[EAAddAlarmViewController alloc]init];
    addAlarm.delegate = self;
    [self.navigationController pushViewController:addAlarm animated:YES];
}

#pragma mark EAAddAlarmDelegate

- (void)EAAddAlarmViewController:(EAAddAlarmViewController *)controller addNewAlarmByDictionary:(NSDictionary *)alarmDictionary
{
    [alarmList insertObject:alarmDictionary atIndex:0];
    [alarmTableView reloadData];
    
}
- (void)refreshAlarmListAction
{
    [alarmList removeAllObjects];
    
    NSArray * allLocalNotification=[[UIApplication sharedApplication] scheduledLocalNotifications];
    for (UILocalNotification * localNotification in allLocalNotification)
    {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setDictionary:localNotification.userInfo];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"HH:mm:ss";
        NSString *dateString = [formatter stringFromDate:localNotification.fireDate];
        
        [dict setValue:dateString forKey:@"date"];
        [alarmList addObject:dict];
    }
    [alarmTableView reloadData];
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
