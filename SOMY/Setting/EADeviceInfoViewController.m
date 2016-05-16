//
//  EADeviceInfoViewController.m
//  SOMY
//
//  Created by easaa on 9/2/14.
//  Copyright (c) 2014 easaa. All rights reserved.
//

#import "EADeviceInfoViewController.h"

@interface EADeviceInfoViewController ()
{
    CustomNavigation *myNavigationBar;
}
@property (weak, nonatomic) IBOutlet UILabel *deviceTitle;
@property (weak, nonatomic) IBOutlet UILabel *hardwareTitle;
@property (weak, nonatomic) IBOutlet UILabel *versionsTitle;

@property (weak, nonatomic) IBOutlet UILabel *deviceLabel;
@property (weak, nonatomic) IBOutlet UILabel *hardwareLabel;
@property (weak, nonatomic) IBOutlet UILabel *versionsLabel;

@property (weak, nonatomic) IBOutlet UIButton *deviceUpdateAction;
@end

@implementation EADeviceInfoViewController

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
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor colorwithHexString:@"#EEEFF0"];
    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
    {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 20)];
        view.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:view];
    }
    myNavigationBar = [[CustomNavigation alloc]initWithFrame:CGRectMake(0, INCREMENT, 320, 44)];
    myNavigationBar.titleLabel.text = DPLocalizedString(@"Equipment information");
    myNavigationBar.leftButton.hidden = NO;
    [myNavigationBar.leftButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:myNavigationBar];
    
    self.deviceTitle.text = DPLocalizedString(@"Equipment ID");
    self.hardwareTitle.text = DPLocalizedString(@"Hardware ID");
    self.versionsTitle.text = DPLocalizedString(@"Firmware version");
    [self.deviceUpdateAction setTitle:DPLocalizedString(@"Equipment upgrades") forState:UIControlStateNormal];
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

@end
