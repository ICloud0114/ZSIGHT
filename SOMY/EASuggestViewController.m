//
//  EASuggestViewController.m
//  ZSIGHT
//
//  Created by LoveLi1y on 15/1/4.
//  Copyright (c) 2015年 easaa. All rights reserved.
//

#import "EASuggestViewController.h"

@interface EASuggestViewController ()
{
    CustomNavigation *myNavigationBar;
}
@end

@implementation EASuggestViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor colorwithHexString:@"#EEEFF0"];
    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
    {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 20)];
        view.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:view];
    }
    myNavigationBar = [[CustomNavigation alloc]initWithFrame:CGRectMake(0, INCREMENT, 320, 44)];
    myNavigationBar.titleLabel.text = DPLocalizedString(@"SOMY THERMOMETER");
    myNavigationBar.leftButton.hidden = NO;
    [myNavigationBar.leftButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:myNavigationBar];
    
    UILabel *firstLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, myNavigationBar.frame.origin.y + myNavigationBar.frame.size.height + 20, 210, 35)];
    firstLabel.text = DPLocalizedString(@"The current temperature is");
    UILabel *tempLabel = [[UILabel alloc]initWithFrame:CGRectMake(firstLabel.frame.origin.x + firstLabel.frame.size.width, firstLabel.frame.origin.y, 100, 35)];
    
    tempLabel.text = [NSString stringWithFormat:@"%@%@",self.tempString,TEMPERATUREUNIT];
    tempLabel.textColor = [UIColor redColor];
    [self.view addSubview:tempLabel];
    [self.view addSubview:firstLabel];
//    "Recommend the use of physical cooling" = "建议使用物理降温";
//    "Please place the forehead with ice for 15 min" = "请用冰块放置额头，持续15分钟";
    UILabel *secondLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, firstLabel.frame.origin.y + firstLabel.frame.size.height + 10, 300, 70)];
    secondLabel.numberOfLines = 0;
    secondLabel.text = DPLocalizedString(@"Recommend the use of physical cooling");
    UILabel *thirdLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, secondLabel.frame.origin.y + secondLabel.frame.size.height + 10, 300, 70)];
    thirdLabel.numberOfLines = 0;
    thirdLabel.text = DPLocalizedString(@"Please place the forehead with ice for 15 min");
    
    [self.view addSubview:secondLabel];
    [self.view addSubview:thirdLabel];
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
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
