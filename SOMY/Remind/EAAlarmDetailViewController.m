//
//  EAAlarmDetailViewController.m
//  SOMY
//
//  Created by easaa on 9/16/14.
//  Copyright (c) 2014 easaa. All rights reserved.
//

#import "EAAlarmDetailViewController.h"
#import "EAMusicListViewController.h"
#import "EAWeekListViewController.h"
#import "UIViewController+MMDrawerController.h"
@interface EAAlarmDetailViewController ()
{
    CustomNavigation *myNavigationBar;
}
@property (weak, nonatomic) IBOutlet UILabel *musicLabel;
@property (weak, nonatomic) IBOutlet UILabel *repeatLabel;
@property (weak, nonatomic) IBOutlet UILabel *musicNameLabel;
- (IBAction)selectMusicAction:(id)sender;

- (IBAction)selectRepeatAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *delete;

@end

@implementation EAAlarmDetailViewController

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
//    [self.mm_drawerController setMaximumLeftDrawerWidth:320];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor colorwithHexString:@"#EEEFF0"];
    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
    {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 20)];
        view.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:view];
    }
    myNavigationBar = [[CustomNavigation alloc]initWithFrame:CGRectMake(0, INCREMENT, 320, 44)];
    myNavigationBar.titleLabel.text = DPLocalizedString(@"Pill Reminder");
    myNavigationBar.leftButton.hidden = NO;
    [myNavigationBar.leftButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:myNavigationBar];
    self.musicLabel.text = DPLocalizedString(@"Ring");
    self.repeatLabel.text = DPLocalizedString(@"Repeat");
    [self.delete setTitle:DPLocalizedString(@"Delete") forState:UIControlStateNormal];
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

- (IBAction)selectMusicAction:(id)sender
{
    EAMusicListViewController *musicList = [[EAMusicListViewController alloc]init];
    [self.navigationController pushViewController:musicList animated:YES];
    
}

- (IBAction)selectRepeatAction:(id)sender
{
    EAWeekListViewController *weekList = [[EAWeekListViewController alloc]init];
    [self.navigationController pushViewController:weekList animated:YES];
}
@end
