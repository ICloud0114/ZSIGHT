//
//  EARemindViewController.m
//  SOMY
//
//  Created by easaa on 9/2/14.
//  Copyright (c) 2014 easaa. All rights reserved.
//

#import "EARemindViewController.h"
#import "EAAlarmListViewController.h"
#import "EAMusicListViewController.h"

#import "UIViewController+MMDrawerController.h"
@interface EARemindViewController ()<UITableViewDataSource, UITableViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    CustomNavigation *myNavigationBar;
    UITableView *remindTableView;
    NSMutableArray *repeatTimeArr;
    NSString *repeatTimeStr;
    UIPickerView *repeatTime;
    
    UIButton *alarmSwitch;
}
@end

@implementation EARemindViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    if (self.navigationController.viewControllers.count == 1)
    {
        [self.mm_drawerController setMaximumLeftDrawerWidth:250];
    }
    else
    {
        [self.mm_drawerController setMaximumLeftDrawerWidth:320];
    }
    
}
- (void)viewDidDisappear:(BOOL)animated
{
    NSLog(@"disappear");
}
- (void)viewDidLoad
{
    [super viewDidLoad];
//    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.view.backgroundColor = [UIColor colorwithHexString:@"#EEEFF0"];
    // Do any additional setup after loading the view.
//    repeatTimeStr = @"不再报";
    myNavigationBar = [[CustomNavigation alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
    {
        [myNavigationBar setFrame:CGRectMake(0, 20, 320, 44)];

        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 20)];
        view.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:view];

        
    }
    myNavigationBar.titleLabel.text = DPLocalizedString(@"Remind");
    myNavigationBar.leftButton.hidden = NO;
    [myNavigationBar.leftButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:myNavigationBar];
    
    remindTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, myNavigationBar.frame.origin.y + myNavigationBar.frame.size.height, self.view.frame.size.width, 180) style:UITableViewStylePlain];
    remindTableView.dataSource = self;
    remindTableView.delegate = self;
    [self.view addSubview:remindTableView];
    
    repeatTime = [[UIPickerView alloc]initWithFrame:CGRectMake(0, remindTableView.frame.origin.y + remindTableView.frame.size.height, self.view.frame.size.width, 162)];
    repeatTime.dataSource = self;
    repeatTime.delegate = self;
    repeatTime.hidden = YES;
    [self.view addSubview:repeatTime];
    
    NSArray *timeArr = @[DPLocalizedString(@"No more"),DPLocalizedString(@"One hours"),DPLocalizedString(@"Two hours")];
    repeatTimeArr = [NSMutableArray arrayWithArray:timeArr];
    
    alarmSwitch = [UIButton buttonWithType:UIButtonTypeCustom];
    [alarmSwitch setFrame:CGRectMake(self.view.frame.size.width - 55 - 10, 5, 55, 25)];
    [alarmSwitch setBackgroundImage:[UIImage imageNamed:@"kaiguankai"] forState:UIControlStateNormal];
    [alarmSwitch setBackgroundImage:[UIImage imageNamed:@"kaiguanguan"] forState:UIControlStateSelected];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"OpenAlarm"])
    {
        [alarmSwitch setSelected:YES];
    }
    else
    {
        [alarmSwitch setSelected:NO];
    }
    
    [alarmSwitch addTarget:self action:@selector(alarmSwitchAction) forControlEvents:UIControlEventTouchUpInside];
    
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


- (void)alarmSwitchAction
{
    alarmSwitch.selected = !alarmSwitch.selected;
    if (!alarmSwitch.selected)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:DPLocalizedString(@"Tips") message:DPLocalizedString(@"Heat Alert Opened") delegate:nil cancelButtonTitle:DPLocalizedString(@"Confirm") otherButtonTitles:nil, nil];
        [self.view addSubview:alert];
        [alert show];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"OpenAlarm"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:DPLocalizedString(@"Tips") message:DPLocalizedString(@"Heat Alert Closed") delegate:nil cancelButtonTitle:DPLocalizedString(@"Confirm") otherButtonTitles:nil, nil];
        [self.view addSubview:alert];
        [alert show];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"OpenAlarm"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"OpenAlarm" object:nil];
}

#pragma mark TableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseID=@"cellID";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:reuseID];
//    if (cell==nil)
//    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        switch (indexPath.section)
        {
            case 0:
            {
                switch (indexPath.row)
                {
                    case 0:
                    {
                        cell.textLabel.text = DPLocalizedString(@"Heat alert");
                        [cell addSubview:alarmSwitch];
                    }
                        break;
                    case 1:
                    {
                        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                        cell.textLabel.text = DPLocalizedString(@"Ring");
                        UILabel *musicLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 100 - 30, 7, 100, 21)];
                        musicLabel.backgroundColor = [UIColor clearColor];
                        musicLabel.textAlignment = NSTextAlignmentRight;
                        musicLabel.text = repeatTimeStr;
                        [cell addSubview:musicLabel];
                    }
                        
                        break;
                    default:
                        break;
                }
                
            }
                break;
            case 1:
            {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                switch (indexPath.row)
                {
                    case 0:
                    {
                        cell.textLabel.text = DPLocalizedString(@"Pill Reminder");
                    }
                        
                        break;
                    case 1:
                    {
                        cell.textLabel.text = DPLocalizedString(@"Alarm recovery time");
                        UILabel *repeatTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 100 - 30, 7, 100, 21)];
                        repeatTimeLabel.backgroundColor = [UIColor clearColor];
                        repeatTimeLabel.textAlignment = NSTextAlignmentRight;
                        repeatTimeLabel.text = repeatTimeStr;
                        [cell addSubview:repeatTimeLabel];
                    }
                        break;
                    default:
                        break;
                }
            }
                break;
            default:
                break;
        }
//    }
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
#pragma mark TableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 10)];
    [view setBackgroundColor:[UIColor colorwithHexString:@"#EEEFF0"]];
    return view;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 10)];
    [view setBackgroundColor:[UIColor colorwithHexString:@"#EEEFF0"]];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case 0:
        {
            switch (indexPath.row)
            {
                case 0:
                {
                    
                }
                    break;
                case 1:
                {
                    EAMusicListViewController *musicList = [[EAMusicListViewController alloc]init];
                    musicList.isSelect = NO;
                    [self.navigationController pushViewController:musicList animated:YES];
                }
                    break;
                default:
                    break;
            }
            
        }
            break;
        case 1:
        {
            switch (indexPath.row)
            {
                case 0:
                {
                    EAAlarmListViewController *alarmList = [[EAAlarmListViewController alloc]init];
                    [self.navigationController pushViewController:alarmList animated:YES];
                }
                    break;
                case 1:
                {
                    repeatTime.hidden = !repeatTime.hidden;
                }
                    break;
                default:
                    break;
            }
        }
            break;
        default:
            break;
    }
}



#pragma mark UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return repeatTimeArr.count;
}

#pragma mark UIPickerViewDelegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return repeatTimeArr[row];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    repeatTimeStr = repeatTimeArr[row];
    [remindTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
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
