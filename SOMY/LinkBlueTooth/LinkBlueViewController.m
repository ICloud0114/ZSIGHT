//
//  LinkBlueViewController.m
//  SOMY
//
//  Created by smile on 14-10-11.
//  Copyright (c) 2014年 easaa. All rights reserved.
//

#import "LinkBlueViewController.h"
#import "LeSimple.h"


@interface LinkBlueViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    LeSimple *simple;
    NSTimer *myTimer;
    NSMutableArray *array;
    CustomNavigation *myNavigationBar;
}
@end

@implementation LinkBlueViewController
@synthesize tableView;

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadUI:) name:@"reloadUI" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadwendu:) name:@"BlueData" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopNstimerOrNot) name:@"synchronous" object:nil];
        array =[[NSMutableArray alloc] init];
    }
    return self;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

}
//-(void)reloadUI:(NSNotification*)info
//{
//    
//    [array removeAllObjects];
//    NSArray *names = [[NSArray alloc] initWithArray:[info object]];
//    for (CBPeripheral *peripheral in names)
//    {
//        if ([peripheral.name isEqualToString:@"Somy T01"])
//        {
//            [array addObject:peripheral];
//        }
//    }
//    [tableView reloadData];
//}

- (void)stopNstimerOrNot
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"synchronous"])
    {
        [simple stop];
        if (myTimer)
        {
            [myTimer invalidate];
            myTimer = nil;
        }
    }
    else
    {
        NSLog(@"结束同步");
    }
}
-(void)reloadwendu:(NSNotification*)info
{
    
    NSString * string = [info object];
    if ( string.length > 0)
    {
        NSLog(@"data长度:%lu   %@",(unsigned long)string.length,string);
        NSString *range = [string substringWithRange:NSMakeRange(10, 6)];
        NSString *uuid = [NSString stringWithFormat:@"%@",range];
        for (NSString *str in array)
        {
            if ([uuid isEqualToString:str])
            {
                return;
            }
        }
        [array addObject:uuid];
    }
    [tableView reloadData];
}
-(void)timerFired:(id)sender
{
    [simple stop];
    [simple searchDevice];
    
   

}
- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorwithHexString:@"#EEEFF0"];
    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
    {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 20)];
        view.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:view];
    }
    myNavigationBar = [[CustomNavigation alloc]initWithFrame:CGRectMake(0, INCREMENT, 320, 44)];
    myNavigationBar.titleLabel.text = DPLocalizedString(@"Devices List");
    myNavigationBar.leftButton.hidden = NO;
    [myNavigationBar.leftButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:myNavigationBar];
    
    myTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
    
//    self.title = @"蓝牙设备";
    tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, myNavigationBar.frame.origin.y + myNavigationBar.frame.size.height,320 , self.view.frame.size.height - INCREMENT - myNavigationBar.frame.size.height) style:UITableViewStylePlain];
    [tableView setBackgroundColor:[UIColor colorwithHexString:@"#EEEFF0"]];

    [self.view addSubview:tableView];
    tableView.delegate = self;
    tableView.dataSource = self;
    
    simple = [LeSimple shareLeSimple];
    
}
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark
#pragma mark - Table view delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [array count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    cell.backgroundColor = [UIColor clearColor];
//    NSInteger uuid = [self hexStringFromString:[array objectAtIndex:indexPath.row]];
//    cell.textLabel.text = [self hexStringFromString:[array objectAtIndex:indexPath.row]];
//     cell.detailTextLabel.text = [peripheral isConnected] ? @"Connected" : @"Not connected";
    
    
    UILabel *label0 = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 100, 30)];
    [label0 setBackgroundColor:[UIColor clearColor]];
    label0.text = @"ZSIGHT";
    [label0 setFont:[UIFont systemFontOfSize:18.0f]];
    [cell addSubview:label0];
    
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(20, 35, 100, 20)];
    [label1 setBackgroundColor:[UIColor clearColor]];
    label1.text = [self hexStringFromString:[array objectAtIndex:indexPath.row]];
    [label1 setFont:[UIFont systemFontOfSize:15.0f]];
    [cell addSubview:label1];

    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"selectDevice"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [[NSUserDefaults standardUserDefaults]setObject:[array objectAtIndex:indexPath.row] forKey:@"uuid"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [self.navigationController popViewControllerAnimated:YES];

}


#pragma mark 将二进制字符串转成十进制 8位字符串
- (NSString *)hexStringFromString:(NSString *)string
{
    NSInteger num = 0;
    NSInteger count = 0;
    
    for(int i = 0; i < string.length ; i++)
    {
        NSString *a = [string substringWithRange:NSMakeRange(i, 1)];
        if ([a isEqualToString:@"a"])
        {
            num = 10;
        }
        else if([a isEqualToString:@"b"])
        {
            num = 11;
        }
        else if([a isEqualToString:@"c"])
        {
            num = 12;
        }
        else if([a isEqualToString:@"d"])
        {
            num = 13;
        }
        else if([a isEqualToString:@"e"])
        {
            num = 14;
        }
        else if([a isEqualToString:@"f"])
        {
            num = 15;
        }
        else
        {
            num = [a integerValue];
        }
        NSInteger m = 1;
        for (int j = 0; j < string.length - 1 - i;j++)
        {
            m *= 16;
        }
        count += num *m;
    }
    //不足八位补 0
    NSString *myString = [NSString stringWithFormat:@"%ld",(long)count];
    NSString *preString = @"";
    for (int i = 0; i < 8 - myString.length; i ++)
    {
        preString = [preString stringByAppendingString:@"0"];
    }
    myString = [preString stringByAppendingString:myString];
    return myString;
}
@end
