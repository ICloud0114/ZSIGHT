//
//  MyNavigationController.m
//  MMClothing
//
//  Created by easaa on 12-12-3.
//  Copyright (c) 2012年 easaa. All rights reserved.
//

#import "MyNavigationController.h"
@interface MyNavigationController ()

@end

@implementation MyNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        if ([self.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]){
            [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"top_bg.png"] forBarMetrics:UIBarMetricsDefault];
        }
        
       
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [super pushViewController:viewController animated:YES];
    if (viewController.navigationItem.leftBarButtonItem== nil && [self.viewControllers count] > 1)
    {
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];//55 34
        backBtn.frame = CGRectMake(0, 0, 32, 32);
        [backBtn addTarget:self action:@selector(popself) forControlEvents:UIControlEventTouchUpInside];
//        [backBtn setTitle:@"  返回" forState:UIControlStateNormal];
        backBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [backBtn setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        [backBtn setBackgroundImage:[UIImage imageNamed:@"back_h"] forState:UIControlStateHighlighted];
        [viewController.navigationController.navigationBar addSubview:backBtn];
        
        UIBarButtonItem *backItem=[[UIBarButtonItem alloc]initWithCustomView:backBtn];
        viewController.navigationItem.leftBarButtonItem = backItem;
        [backItem release];
        
    }
    
}

-(void)popself
{
    [self popViewControllerAnimated:YES];

}
@end
