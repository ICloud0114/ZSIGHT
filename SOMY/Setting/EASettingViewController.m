//
//  EASettingViewController.m
//  SOMY
//
//  Created by easaa on 9/2/14.
//  Copyright (c) 2014 easaa. All rights reserved.
//

#import "EASettingViewController.h"
#import "EAChangePasswordViewController.h"
#import "EADeviceInfoViewController.h"
#import "EAFeedbackViewController.h"
#import "UIViewController+MMDrawerController.h"
@interface EASettingViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    UIButton *changeUnit;
    UIButton *wifiSwitch;
    UIButton *changeLanguage;
    UIButton *synchronousButton;
    CustomNavigation *myNavigationBar;
    UITableView *settingTableView;
}
@end

@implementation EASettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

    }
    return self;
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
- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorwithHexString:@"#EEEFF0"];
    // Do any additional setup after loading the view.
    myNavigationBar = [[CustomNavigation alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
    {
        [myNavigationBar setFrame:CGRectMake(0, 20, 320, 44)];
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 20)];
        view.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:view];

        
    }
    myNavigationBar.titleLabel.text = DPLocalizedString(@"Setting");
    myNavigationBar.leftButton.hidden = NO;
    [myNavigationBar.leftButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:myNavigationBar];
    
    changeUnit = [UIButton buttonWithType:UIButtonTypeCustom];
    [changeUnit setFrame:CGRectMake(self.view.frame.size.width - 90 - 5, 5, 90, 25)];
    [changeUnit setBackgroundImage:[UIImage imageNamed:@"sheshidu"] forState:UIControlStateNormal];
    [changeUnit setBackgroundImage:[UIImage imageNamed:@"huashidu"] forState:UIControlStateSelected];
    [changeUnit addTarget:self action:@selector(changeUnitAction) forControlEvents:UIControlEventTouchUpInside];
    
    wifiSwitch = [UIButton buttonWithType:UIButtonTypeCustom];
    [wifiSwitch setFrame:CGRectMake(self.view.frame.size.width - 90 - 5, 5, 90, 25)];
    [wifiSwitch setBackgroundImage:[UIImage imageNamed:@"kaiguankai"] forState:UIControlStateNormal];
    [wifiSwitch setBackgroundImage:[UIImage imageNamed:@"kaiguanguan"] forState:UIControlStateSelected];
    [wifiSwitch addTarget:self action:@selector(wifiSwitchAction) forControlEvents:UIControlEventTouchUpInside];
    
    changeLanguage = [UIButton buttonWithType:UIButtonTypeCustom];
    [changeLanguage setFrame:CGRectMake(self.view.frame.size.width - 90 - 5, 5, 90, 25)];
    [changeLanguage setBackgroundImage:[UIImage imageNamed:@"zhongwen"] forState:UIControlStateNormal];
    [changeLanguage setBackgroundImage:[UIImage imageNamed:@"yingwen"] forState:UIControlStateSelected];
    [changeLanguage addTarget:self action:@selector(changeLanguageAction) forControlEvents:UIControlEventTouchUpInside];
    
    synchronousButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [synchronousButton setFrame:CGRectMake(self.view.frame.size.width - 90 - 5, 5, 90, 25)];
    [synchronousButton setBackgroundImage:[UIImage imageNamed:@"kaiguanguan"] forState:UIControlStateNormal];
    [synchronousButton setBackgroundImage:[UIImage imageNamed:@"kaiguankai"] forState:UIControlStateSelected];
    [synchronousButton addTarget:self action:@selector(synchronousTemperatureAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    settingTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, myNavigationBar.frame.origin.y + myNavigationBar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    settingTableView.delegate = self;
    settingTableView.dataSource = self;
    [self.view addSubview:settingTableView];
    
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
#pragma mark tableviewDelegate
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
#pragma mark tableviewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
            return 1;
            break;
        case 1:
            return 3;
            break;
        case 2:
            return 4;
            break;
        default:
            break;
    }
    return 0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
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
                cell.textLabel.text = DPLocalizedString(@"Temperature Unit");
               
                [cell addSubview:changeUnit];
                if (ISFAHRENHEIT)
                {
                    changeUnit.selected = YES;
                }
                else
                {
                    
                }
            }
                break;
            case 1:
            {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                switch (indexPath.row)
                {
                    case 0:
                        cell.textLabel.text = DPLocalizedString(@"Equipment information");
                        break;
                    case 1:
                        cell.textLabel.text = DPLocalizedString(@"Feedback");
                        break;
                    case 2:
                        cell.textLabel.text = DPLocalizedString(@"Change the password");
                        break;
                    default:
                        break;
                }
            }
                break;
            case 2:
            {
                switch (indexPath.row)
                {
                    case 0:
                    {
                        cell.textLabel.text = DPLocalizedString(@"Wifi only upload");
                        [cell addSubview:wifiSwitch];
                    }
                        break;
                    case 1:
                    {
                        cell.textLabel.text = DPLocalizedString(@"Language Switch");
                        [cell addSubview:changeLanguage];
                        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"lan"] isEqualToString:@"zh-Hans"])
                        {

                        }
                        else if([[[NSUserDefaults standardUserDefaults] objectForKey:@"lan"] isEqualToString:@"en"])
                        {
                            changeLanguage.selected = YES;
                        }
                    }
                        break;
                    case 2:
                        cell.textLabel.text = DPLocalizedString(@"Software Upgrading");
                        break;
                        
                    case 3:
                    {
                        cell.textLabel.text = DPLocalizedString(@"Synchronous Temperature");
                        [cell addSubview:synchronousButton];
                        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"synchronous"])
                        {
                            synchronousButton.selected = YES;
                        }
                        else
                        {
                            synchronousButton.selected = NO;
                        }
                    }
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case 0:
        {
            
        }
            break;
        case 1:
        {
            switch (indexPath.row)
            {
                case 0:
                {
                    EADeviceInfoViewController *deviceInfo = [[EADeviceInfoViewController alloc]initWithNibName:@"EADeviceInfoViewController" bundle:nil];
                    [self.navigationController pushViewController:deviceInfo animated:YES];
                }
                    break;
                case 1:
                {
                    EAFeedbackViewController *feedback = [[EAFeedbackViewController alloc]init];
                    [self.navigationController pushViewController:feedback animated:YES];
                }
                    break;
                case 2:
                {
                    EAChangePasswordViewController *changePassword = [[EAChangePasswordViewController alloc]initWithNibName:@"EAChangePasswordViewController" bundle:nil];
                    [self.navigationController pushViewController:changePassword animated:YES];
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 2:
        {
            switch (indexPath.row)
            {
                case 0:
                {

                }
                    break;
                case 1:
                {

                }
                    break;
                case 2:
                {
                
                }
                    break;
                    case 3:
                {
                
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


- (void)changeUnitAction
{
    changeUnit.selected = !changeUnit.selected;
    if (changeUnit.selected)
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isF"];
        [[NSUserDefaults standardUserDefaults] synchronize];
       
        
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"isF"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeUnit" object:nil];
}


- (void)wifiSwitchAction
{
    wifiSwitch.selected = !wifiSwitch.selected;
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:DPLocalizedString(@"Tips") message:DPLocalizedString(@"Setting Success") delegate:self cancelButtonTitle:DPLocalizedString(@"Confirm") otherButtonTitles:nil, nil];
    [self.view addSubview:alert];
    [alert show];
    
}
- (void)changeLanguageAction
{
    changeLanguage.selected = !changeLanguage.selected;
    if (changeLanguage.selected)
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"en" forKey:@"lan"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"zh-Hans" forKey:@"lan"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    [settingTableView reloadData];
    myNavigationBar.titleLabel.text = DPLocalizedString(@"Setting");
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeLanguage" object:nil];
}
- (void)synchronousTemperatureAction
{
    synchronousButton.selected = !synchronousButton.selected;
    if (synchronousButton.selected)
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"synchronous"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"synchronous"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"synchronous" object:nil];
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
