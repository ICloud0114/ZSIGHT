//
//  EAWeekListViewController.m
//  SOMY
//
//  Created by easaa on 9/2/14.
//  Copyright (c) 2014 easaa. All rights reserved.
//

#import "EAWeekListViewController.h"
#import "EATableViewCell.h"
@interface EAWeekListViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    CustomNavigation *myNavigationBar;
    NSArray *weekArray;
    NSMutableDictionary *weekDictionary;
    
}
@end

@implementation EAWeekListViewController

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
    weekDictionary = [NSMutableDictionary dictionary];
    
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorwithHexString:@"#EEEFF0"];
    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
    {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 20)];
        view.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:view];
    }
    myNavigationBar = [[CustomNavigation alloc]initWithFrame:CGRectMake(0, INCREMENT, 320, 44)];
    myNavigationBar.titleLabel.text = DPLocalizedString(@"Datepicker");
    myNavigationBar.leftButton.hidden = NO;
    [myNavigationBar.leftButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    myNavigationBar.submitButton.hidden = NO;
    [myNavigationBar.submitButton addTarget:self action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:myNavigationBar];
    
    
    weekArray =@[@"Sunday",@"Monday",@"Tuesday",@"Wednesday",@"Thursday",@"Friday",@"Saturday"];
    
    for (int i = 0; i < 7; i++)
    {
        [weekDictionary setValue:@"NO" forKey:[weekArray objectAtIndex:i]];
    }
    UITableView *weekTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, myNavigationBar.frame.origin.y + myNavigationBar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - INCREMENT - myNavigationBar.frame.size.height) style:UITableViewStylePlain];
    [weekTableView setBackgroundColor:[UIColor colorwithHexString:@"#EEEFF0"]];
    weekTableView.delegate = self;
    weekTableView.dataSource = self;
    [self.view addSubview:weekTableView];
    
}
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)submitAction
{
    if ([self.delegate respondsToSelector:@selector(EAWeekListViewController:selectRepeatWeekByDictionary:)])
    {
        [self.delegate EAWeekListViewController:self selectRepeatWeekByDictionary:weekDictionary];
    }
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    EATableViewCell *cell = (EATableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSString *str = [weekArray objectAtIndex:indexPath.row];
    
    if ([[weekDictionary objectForKey:str] isEqualToString:@"NO"])
    {
        [weekDictionary setValue:@"YES" forKey:str];
        cell.selectImage.hidden = NO;
    }
    else
    {
        [weekDictionary setValue:@"NO" forKey:str];
        cell.selectImage.hidden = YES;
    }

}
#pragma mark TableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseID=@"cellID";
    EATableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:reuseID];
    if (cell==nil)
    {
        cell =[[[NSBundle mainBundle]loadNibNamed:@"EATableViewCell" owner:self options:nil]lastObject];
//       NSDictionary *dic = [contacts objectAtIndex:indexPath.row];
        NSString *str = [weekArray objectAtIndex:indexPath.row];
        cell.titleLabel.text = DPLocalizedString(str);
        if ([[weekDictionary objectForKey:str] isEqualToString:@"NO"])
        {
            cell.selectImage.hidden = YES;
        }
        else
        {
            cell.selectImage.hidden = NO;
        }
    }
    
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}



/*
#pragma mark - Navigation

 In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
     Get the new view controller using [segue destinationViewController].
     Pass the selected object to the new view controller.
}
*/

@end
