//
//  EAAppDelegate.m
//  SOMY
//
//  Created by easaa on 9/2/14.
//  Copyright (c) 2014 easaa. All rights reserved.
//

#import "EAAppDelegate.h"

#import "EAMainViewController.h"
#import "EAMemberViewController.h"
#import "EAHistoryListViewController.h"

#import "MMDrawerController.h"
#import "MMExampleDrawerVisualStateManager.h"

#import <AVFoundation/AVFoundation.h>
@implementation EAAppDelegate
{
    AVAudioPlayer *audioPlayer;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    //本地通知
//    UILocalNotification *local = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
//    [[UIApplication sharedApplication]cancelAllLocalNotifications];
    
    //取消登陆
//    if([[NSUserDefaults standardUserDefaults] objectForKey:ISLOGIN])
//    {
//        [[NSUserDefaults standardUserDefaults]removeObjectForKey:ISLOGIN];
//        [[NSUserDefaults standardUserDefaults]synchronize];
//    }
    

    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    //使手机不进入锁屏状态
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
//    [[UIApplication sharedApplication] setMinimumBackgroundFetchInterval:300];
    //移除设备
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"selectDevice"])
    {
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"selectDevice"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    //取消手动警报温度
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"warnTemperature"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    //取消同步
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"synchronous"])
    {
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"synchronous"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    ///默认语言
    if (![[NSUserDefaults standardUserDefaults]objectForKey:@"lan"])
    {
        NSString *current = [[NSLocale preferredLanguages] objectAtIndex:0];
        NSString *path = [[NSBundle mainBundle]pathForResource:@"LanguageList" ofType:@"plist"];
        NSArray *lanArray = [NSArray arrayWithContentsOfFile:path];
        BOOL flag = NO;
        for (NSDictionary *dict in lanArray) {
            if ([[dict allKeys]containsObject:current]) {
                flag = YES;
                break;
            }
        }
        if (!flag) {
            current = [[[lanArray firstObject]allKeys]firstObject];
        }
        [[NSUserDefaults standardUserDefaults]setObject:current forKey:@"lan"];
        
    }

    EAMainViewController *mainViewController = [[EAMainViewController alloc]init];
    UINavigationController *navigation = [[UINavigationController alloc]initWithRootViewController:mainViewController];
    
    EAMemberViewController *leftController = [[EAMemberViewController alloc] init];
    leftController.delegate = mainViewController;
    UINavigationController *navigationLeft = [[UINavigationController alloc]initWithRootViewController:leftController];
    
    EAHistoryListViewController *rightController = [[EAHistoryListViewController alloc] init];
    mainViewController.delegate = rightController;
    UINavigationController *navigationRight = [[UINavigationController alloc]initWithRootViewController:rightController];
    
    //设置左右和中间三个viewController
    //    MMDrawerController * drawerController = [[MMDrawerController alloc]
    //                                             initWithCenterViewController:navigation
    //                                             leftDrawerViewController:navigationLeft
    //                                             rightDrawerViewController:navigationRight];
    MMDrawerController * drawerController = [[MMDrawerController alloc]
                                             initWithCenterViewController:navigation
                                             leftDrawerViewController:navigationLeft
                                             rightDrawerViewController:navigationRight];
    
    [drawerController setMaximumRightDrawerWidth:320.0f];
    [drawerController setMaximumLeftDrawerWidth:250.0f];
    //关闭阴影
    drawerController.showsShadow = NO;
    //打开抽屉的方式
    [drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    //关闭抽屉的方式
    [drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    
    //设置抽屉控制器的alpha从0到1的动画
    [drawerController
     setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible)
     {
         MMDrawerControllerDrawerVisualStateBlock block;
         //单例
         block = [[MMExampleDrawerVisualStateManager sharedManager]
                  drawerVisualStateBlockForDrawerSide:drawerSide];
         if(block)
         {
             block(drawerController, drawerSide, percentVisible);
         }
     }];
//    [[[UIApplication sharedApplication]keyWindow] setRootViewController:drawerController];
    self.window.rootViewController = drawerController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
//当程序在前台时，本地通知触发这个方法
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    
    if ([[notification.userInfo objectForKey:@"state"]isEqualToString:@"YES"])
    {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"EEEE";
        NSString *weekString = [self changeByString:[formatter stringFromDate:notification.fireDate]];
        
        NSLog(@"星期几--->%@",weekString);
        NSLog(@"infomation ---->%@",notification.userInfo);
        NSDictionary *dict = [notification.userInfo objectForKey:@"week"];
        if ([dict objectForKey:weekString])
        {
            if ([[dict objectForKey:weekString] isEqualToString:@"YES"])
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"该吃药了"
                                                                    message:[NSString stringWithFormat:@"药不能停"]
                                                                   delegate:self
                                                          cancelButtonTitle:nil
                                                        otherButtonTitles:DPLocalizedString(@"Confirm")
                                          , nil];
                [alertView show];
                if (![notification.soundName isEqualToString:@""])
                {
                    NSString *main_ring_dir_path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Ring.bundle"];
                    NSString *ring_path = [main_ring_dir_path stringByAppendingPathComponent:notification.soundName];
                    NSURL *url = [[NSURL alloc]initWithString:ring_path];
                    
                    audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
                    
                    [audioPlayer setNumberOfLoops:1]; // 设置为-1可以实现无限循环播放
                    [audioPlayer setPan:1.0f];    // 设置左右声道
                    [audioPlayer prepareToPlay];  // 准备数据，播放前必须设置
                    
//                    AVAudioSession *session = [AVAudioSession sharedInstance];
//                    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
//                    [session setActive:YES error:nil];
                    
                    [self performSelector:@selector(palyAction) withObject:nil afterDelay:0.1f];
                }
            }
        }
    }
    
}

- (void)palyAction
{
    [audioPlayer play];
}

- (NSString *)changeByString:(NSString *)weekString
{
    NSDictionary *weekDictionary = [NSDictionary dictionaryWithObjectsAndKeys:@"Monday",@"星期一",@"Tuesday",@"星期二",@"Wednesday",@"星期三",@"Thursday",@"星期四",@"Friday",@"星期五",@"Saturday",@"星期六",@"Sunday",@"星期日", nil];
    
    if ([weekDictionary objectForKey:weekString])
    {
        return [weekDictionary objectForKey:weekString];
    }
    else
    {
        return weekString;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [audioPlayer stop];
}
//+(void)playSound:(int)soundID
//{
//    SystemSoundID id = soundID;
//    AudioServicesPlaySystemSound(id);
//}

@end
