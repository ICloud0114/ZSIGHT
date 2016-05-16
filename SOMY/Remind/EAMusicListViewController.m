//
//  EAMusicListViewController.m
//  SOMY
//
//  Created by easaa on 9/2/14.
//  Copyright (c) 2014 easaa. All rights reserved.
//

#import "EAMusicListViewController.h"
#import "EATableViewCell.h"
#import "EAAppDelegate.h"

#import <AVFoundation/AVFoundation.h>

@interface EAMusicListViewController ()<UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    CustomNavigation *myNavigationBar;
    NSString *musicName;
    
    NSArray *listArray;
    AVAudioPlayer *audioPlayer;
    NSMutableArray *musicArray;
}
@end

@implementation EAMusicListViewController

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
    
    listArray = [NSArray array];
    musicArray = [NSMutableArray array];
    NSFileManager *file = [NSFileManager defaultManager];
    NSBundle *bundle =[NSBundle mainBundle];
    NSString *str = [bundle pathForResource:@"Ring" ofType:@"bundle"];
    if ([file fileExistsAtPath:str])
    {
        listArray = [file contentsOfDirectoryAtPath:str error:nil];
    }
    for (int i = 0; i < listArray.count; i ++)
    {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:@"NO" forKey:[listArray objectAtIndex:i]];
        [musicArray addObject:dic];
    }
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorwithHexString:@"#EEEFF0"];
    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
    {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 20)];
        view.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:view];
    }
    myNavigationBar = [[CustomNavigation alloc]initWithFrame:CGRectMake(0, INCREMENT, 320, 44)];
    myNavigationBar.titleLabel.text = DPLocalizedString(@"Ring");
    myNavigationBar.leftButton.hidden = NO;
    [myNavigationBar.leftButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    if (_isSelect)
    {
        myNavigationBar.submitButton.hidden = NO;
        [myNavigationBar.submitButton addTarget:self action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
    }
    [self.view addSubview:myNavigationBar];
    
    UITableView *musicTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, myNavigationBar.frame.origin.y + myNavigationBar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - INCREMENT - myNavigationBar.frame.size.height) style:UITableViewStylePlain];
    [musicTableView setBackgroundColor:[UIColor colorwithHexString:@"#EEEFF0"]];
    musicTableView.delegate = self;
    musicTableView.dataSource = self;
    [self.view addSubview:musicTableView];
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)submitAction
{
    if ([self.delegate respondsToSelector:@selector(EAMusicListViewController:selectMusicByString:)])
    {
        [self.delegate EAMusicListViewController:self selectMusicByString:musicName];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self back];
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
#pragma mark -
#pragma mark Table View Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return [listArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseID=@"cellID";
    EATableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:reuseID];
    if (cell==nil)
    {
        cell =[[[NSBundle mainBundle]loadNibNamed:@"EATableViewCell" owner:self options:nil]lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    
    NSUInteger row = [indexPath row];
    
    NSDictionary *dic = [musicArray objectAtIndex:row];
    
    NSString*nameSection = [listArray objectAtIndex:row];
//    if (_isSelect)
//    {
        if ([[dic objectForKey:nameSection] isEqualToString:@"NO"])
        {
            cell.selectImage.hidden = YES;
        }
        else
        {
            cell.selectImage.hidden = NO;
        }
//    }
//    else
//    {
//        cell.selectImage.hidden = YES;
//    }
    cell.titleLabel.text = nameSection;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    NSString *nameSection = [listArray objectAtIndex:row];
//    if (_isSelect)
//    {
        EATableViewCell *cell = (EATableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
        
        
        
        for (int i = 0; i < listArray.count; i ++)
        {
            NSMutableDictionary *dic = [musicArray objectAtIndex:i];
            NSString *str = [listArray objectAtIndex:i];
            if (i == row)
            {
                [dic setObject:@"YES" forKey:str];
                cell.selectImage.hidden = NO;
            }
            else
            {
                [dic setObject:@"NO" forKey:str];
                cell.selectImage.hidden = YES;
            }
        }
        [tableView reloadData];
        
        musicName = nameSection;
//    }
    
    NSString *main_ring_dir_path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Ring.bundle"];
    NSString *ring_path = [main_ring_dir_path stringByAppendingPathComponent:nameSection];
    NSURL *url = [[NSURL alloc]initWithString:ring_path];
    
    [audioPlayer stop];
    audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
    [audioPlayer setNumberOfLoops:1]; // 设置为-1可以实现无限循环播放
    [audioPlayer setPan:1.0f];    // 设置左右声道
    [audioPlayer prepareToPlay];  // 准备数据，播放前必须设置
    
//    AVAudioSession *session = [AVAudioSession sharedInstance];
//    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
//    [session setActive:YES error:nil];
    
    [self performSelector:@selector(palyAction) withObject:nil afterDelay:0.1f];
    
}
- (void)palyAction
{
    [audioPlayer play];
}

@end
