//
//  EAWarnViewController.m
//  SOMY
//
//  Created by LoveLi1y on 14/11/28.
//  Copyright (c) 2014年 easaa. All rights reserved.
//

#import "EAWarnViewController.h"
#import "UIViewController+MMDrawerController.h"

//#import "EAMemberViewController.h"
//#import "EAHistoryListViewController.h"
//#import "EAMainViewController.h"
@interface EAWarnViewController ()<UITextFieldDelegate>
{
    CustomNavigation *myNavigationBar;

    UILabel *leftLabel;
    UILabel *rightLabel;
    UISlider *warnSlider;
    UITextField *tempTextField;
    UILabel *unitLabel0;
    UILabel *unitLabel;
    UILabel *remindLabel;
}

@end

@implementation EAWarnViewController

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
//    [self.mm_drawerController setLeftDrawerViewController:nil];
//    [self.mm_drawerController setRightDrawerViewController:nil];
}
- (void)viewWillDisappear:(BOOL)animated
{
//    EAMainViewController *mainViewController = [[EAMainViewController alloc]init];
//    self.delegate = mainViewController;
//    UINavigationController *navigation = [[UINavigationController alloc]initWithRootViewController:mainViewController];
//    
//    
//    EAMemberViewController *leftController = [[EAMemberViewController alloc] init];
//    leftController.delegate = mainViewController;
//    UINavigationController *navigationLeft = [[UINavigationController alloc]initWithRootViewController:leftController];
//    
//    EAHistoryListViewController *rightController = [[EAHistoryListViewController alloc] init];
//    mainViewController.delegate = rightController;
//    UINavigationController *navigationRight = [[UINavigationController alloc]initWithRootViewController:rightController];
//    
//    [self.mm_drawerController setLeftDrawerViewController:navigationLeft];
//    [self.mm_drawerController setRightDrawerViewController:navigationRight];
//    [self.mm_drawerController setCenterViewController:navigation];

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
    myNavigationBar.titleLabel.text = DPLocalizedString(@"Manual Control Setting");
    myNavigationBar.leftButton.hidden = NO;
    [myNavigationBar.leftButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    myNavigationBar.submitButton.hidden = NO;
    [myNavigationBar.submitButton addTarget:self action:@selector(submitWarnTemperatureAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:myNavigationBar];
    
    remindLabel = [[UILabel alloc]initWithFrame:CGRectMake(17, 137, 199, 55)];
    unitLabel0 = [[UILabel alloc]initWithFrame:CGRectMake(220, 154, 17, 21)];
    warnSlider = [[UISlider alloc]initWithFrame:CGRectMake(6, 254, 212, 31)];
    leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, 292, 50, 21)];
    rightLabel = [[UILabel alloc]initWithFrame:CGRectMake(190, 292, 50, 21)];
    tempTextField = [[UITextField alloc]initWithFrame:CGRectMake(240, 254, 55, 30)];
    unitLabel = [[UILabel alloc]initWithFrame:CGRectMake(298, 258, 17, 21)];
    
    [self.view addSubview:remindLabel];
    [self.view addSubview:unitLabel0];
    [self.view addSubview:warnSlider];
    [self.view addSubview:leftLabel];
    [self.view addSubview:rightLabel];
    [self.view addSubview:tempTextField];
    [self.view addSubview:unitLabel];
    
    
    [remindLabel setTextColor: [UIColor redColor]];
    [remindLabel setFont:[UIFont systemFontOfSize:15]];
    [remindLabel setTextAlignment:NSTextAlignmentRight];
    
    [unitLabel0 setTextColor: [UIColor redColor]];
    [unitLabel0 setFont:[UIFont systemFontOfSize:15]];
    
    
    [leftLabel setFont:[UIFont systemFontOfSize:12]];
    
    [rightLabel setFont:[UIFont systemFontOfSize:12]];
    
    
    
    [warnSlider addTarget:self action:@selector(sliderMoveAction:) forControlEvents:UIControlEventValueChanged];
    
    [tempTextField setFont:[UIFont systemFontOfSize:14]];
    [tempTextField setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
    [tempTextField setBackgroundColor:[UIColor whiteColor]];
    [tempTextField setTextAlignment:NSTextAlignmentRight];
    tempTextField.delegate = self;
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"isF"])
    {
        leftLabel.text = @"86˚F";
        rightLabel.text = @"107.6˚F";
        warnSlider.minimumValue = 86.0f;
        warnSlider.maximumValue = 107.6f;
        warnSlider.value = TemperatureChange(self.warnTemperature);
        
        unitLabel0.text = @"˚F";
        unitLabel.text = @"˚F";
        remindLabel.text = [NSString stringWithFormat:@"%@ %0.1f",DPLocalizedString(@"Warning temperature :"),TemperatureChange(self.warnTemperature)];
        tempTextField.text = [NSString stringWithFormat:@"%0.1f",TemperatureChange(self.warnTemperature)];
    }
    else
    {
        leftLabel.text = @"30˚C";
        rightLabel.text = @"42˚C";
        warnSlider.minimumValue = 30.0f;
        warnSlider.maximumValue = 42.0f;
        warnSlider.value = self.warnTemperature;
        unitLabel0.text = @"˚C";
        unitLabel.text = @"˚C";
        tempTextField.text = [NSString stringWithFormat:@"%0.1f",self.warnTemperature];
        remindLabel.text = [NSString stringWithFormat:@"%@ %0.1f",DPLocalizedString(@"Warning temperature :"),self.warnTemperature];
    }
    
    
}
- (void)sliderMoveAction:(id)sender
{
    UISlider *slider=sender;
     tempTextField.text = [NSString stringWithFormat:@"%0.1F",slider.value];
     remindLabel.text = [NSString stringWithFormat:@"%@ %0.1f",DPLocalizedString(@"Warning temperature :"),slider.value];
}
- (void)submitWarnTemperatureAction
{
    
    NSLog(@"设置温度%@", tempTextField.text);
    if ([self.delegate respondsToSelector:@selector(manualSettingWarnTemperature:)])
    {
        if (ISFAHRENHEIT)
        {
            CGFloat temperature = ([ tempTextField.text floatValue] - 32) / 1.8;
            NSLog(@"设置温度%0.1f",temperature);
            [self.delegate manualSettingWarnTemperature:[NSString stringWithFormat:@"%0.1f",temperature]];
        }
        else
        {
            [self.delegate manualSettingWarnTemperature: tempTextField.text];
        }
        
        [[NSUserDefaults standardUserDefaults]setObject:tempTextField.text forKey:@"warnTemperature"];
        [[NSUserDefaults standardUserDefaults]synchronize];

        
    }
    
    
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    
    if (iPhone4s)
    {
        

        [ remindLabel setFrame:CGRectMake(17, 87,  remindLabel.frame.size.width,  remindLabel.frame.size.height)];
        
        [ unitLabel0 setFrame:CGRectMake(220, 104,  unitLabel0.frame.size.width,  unitLabel0.frame.size.height)];
        
        
        [ warnSlider setFrame:CGRectMake(6, 154,  warnSlider.frame.size.width,  warnSlider.frame.size.height)];
        
        [ leftLabel setFrame:CGRectMake(8, 192,  leftLabel.frame.size.width,  leftLabel.frame.size.height)];
        
        [ rightLabel setFrame:CGRectMake(190, 192,  rightLabel.frame.size.width,  rightLabel.frame.size.height)];
        
        [ tempTextField setFrame:CGRectMake(240, 154,  tempTextField.frame.size.width,  tempTextField.frame.size.height)];
        
        
        [ unitLabel setFrame:CGRectMake(298, 158,  unitLabel.frame.size.width,  unitLabel.frame.size.height)];
        
        
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
     warnSlider.value = [textField.text floatValue];
    
    
    if (iPhone4s)
    {
        [ remindLabel setFrame:CGRectMake(17, 137, remindLabel.frame.size.width,  remindLabel.frame.size.height)];
        
        [ unitLabel0 setFrame:CGRectMake(220, 154,  unitLabel0.frame.size.width,  unitLabel0.frame.size.height)];
        
        
        [ warnSlider setFrame:CGRectMake(6, 254,  warnSlider.frame.size.width,  warnSlider.frame.size.height)];
        
        [ leftLabel setFrame:CGRectMake(8, 292,  leftLabel.frame.size.width,  leftLabel.frame.size.height)];
        
        [ rightLabel setFrame:CGRectMake(190, 292,  rightLabel.frame.size.width,  rightLabel.frame.size.height)];
        
        [ tempTextField setFrame:CGRectMake(240, 254,  tempTextField.frame.size.width,  tempTextField.frame.size.height)];
        
        
        [ unitLabel setFrame:CGRectMake(298, 258,  unitLabel.frame.size.width,  unitLabel.frame.size.height)];
    }
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    if ([ tempTextField.text floatValue] >  warnSlider.maximumValue)
    {
         tempTextField.text  =[NSString stringWithFormat:@"%0.1f",  warnSlider.maximumValue];
    }
    
    if ([ tempTextField.text floatValue] <  warnSlider.minimumValue)
    {
         tempTextField.text  =[NSString stringWithFormat:@"%0.1f",  warnSlider.minimumValue];
    }
     remindLabel.text = [NSString stringWithFormat:@"%@ %@",DPLocalizedString(@"Warning temperature :"), tempTextField.text];
    [ tempTextField resignFirstResponder];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
