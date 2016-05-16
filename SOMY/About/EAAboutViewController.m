//
//  EAAboutViewController.m
//  SOMY
//
//  Created by easaa on 9/2/14.
//  Copyright (c) 2014 easaa. All rights reserved.
//

#import "EAAboutViewController.h"
#import "UIViewController+MMDrawerController.h"
@interface EAAboutViewController ()
{
    CustomNavigation *myNavigationBar;
}
@end

@implementation EAAboutViewController

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
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor colorwithHexString:@"#EEEFF0"];
//    self.navigationItem.title = @"添加用户";
    myNavigationBar = [[CustomNavigation alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
    {
        [myNavigationBar setFrame:CGRectMake(0, 20, 320, 44)];
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 20)];
        view.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:view];

        
    }
    myNavigationBar.titleLabel.text = DPLocalizedString(@"About");
    myNavigationBar.leftButton.hidden = NO;
    [myNavigationBar.leftButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:myNavigationBar];
    
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
