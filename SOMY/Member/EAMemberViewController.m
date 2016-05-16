//
//  EAMemberViewController.m
//  SOMY
//
//  Created by easaa on 9/2/14.
//  Copyright (c) 2014 easaa. All rights reserved.
//

#import "EAMemberViewController.h"
#import "EALoginViewController.h"
#import "EASettingViewController.h"
#import "EAAddMemberViewController.h"
#import "EARemindViewController.h"
#import "EAAboutViewController.h"
#import "EAAddMemberViewController.h"
#import "EAMemberCell.h"
#import "UIViewController+MMDrawerController.h"

#import "YFJLeftSwipeDeleteTableView.h"

@interface EAMemberViewController ()<UITableViewDataSource, UITableViewDelegate,EARefreshMemberDelegate,EAAddMemberDelegate>
{
    UIButton *loginButton;
    
    UIScrollView *mainScrollView;
    
    YFJLeftSwipeDeleteTableView *userTableView;
    UITableView *settingTableView;
    NSArray* settingArray;
//    BOOL rootViewController;
    
    NSMutableArray *memberArray;
//    NSMutableArray *memberSelect;
}

@end

@implementation EAMemberViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
//        rootViewController = YES;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeLanguageAction) name:@"changeLanguage" object:nil];
        if ([[NSUserDefaults standardUserDefaults] objectForKey:ISLOGIN])
        {
            [self getMemberList];
        }
    }
    return self;
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)changeLanguageAction
{
    [settingTableView reloadData];
    [userTableView reloadData];
    
    [loginButton setTitle:DPLocalizedString(@"The login") forState:UIControlStateNormal];
    [loginButton setTitle:DPLocalizedString(@"Log out") forState:UIControlStateSelected];
}
- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
//    if (!rootViewController)
//    {
//        [self.mm_drawerController setMaximumLeftDrawerWidth:250];
//    }

}
- (void)viewDidAppear:(BOOL)animated
{
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    
}
- (void)viewDidLoad
{
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorwithHexString:@"#2B2B2B"];
    memberArray = [NSMutableArray array];
//    memberSelect = [NSMutableArray array];
    // Do any additional setup after loading the view.
    
//    [self.mm_drawerController setMaximumLeftDrawerWidth:320];
    
    mainScrollView = [[UIScrollView alloc]initWithFrame:self.view.frame];
    [mainScrollView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:mainScrollView];
    
    UIImageView *userPicture = [[UIImageView alloc]initWithFrame:CGRectMake((mainScrollView.frame.size.width - OFFSET - 64) / 2.0, 0, 64, 64)];
//    [userPicture setImage:[UIImage imageNamed:@"touxiang"]];
    userPicture.layer.cornerRadius = 32;
    [mainScrollView addSubview:userPicture];
    
    loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginButton setFrame:CGRectMake((mainScrollView.frame.size.width - OFFSET - 80) / 2.0, userPicture.frame.origin.y + userPicture.frame.size.height + 10, 80, 20)];
    
    [loginButton setTitle:DPLocalizedString(@"The login") forState:UIControlStateNormal];
    [loginButton setTitle:DPLocalizedString(@"Log out") forState:UIControlStateSelected];
    [loginButton setBackgroundImage:[UIImage imageNamed:@"tuichudenglu"] forState:UIControlStateSelected];
    [loginButton setBackgroundImage:[UIImage imageNamed:@"gengduodenglu"] forState:UIControlStateNormal];
    if ([[NSUserDefaults standardUserDefaults]objectForKey:ISLOGIN])
    {
        loginButton.selected = YES;
    }
    else
    {
        loginButton.selected = NO;
    }
    
    [loginButton addTarget:self action:@selector(loginOrLogoutAction) forControlEvents:UIControlEventTouchUpInside];
    [mainScrollView addSubview:loginButton];
    
    settingTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, userTableView.frame.origin.y + userTableView.frame.size.height + 20, mainScrollView.frame.size.width - OFFSET, 200) style:UITableViewStylePlain];
    settingTableView.backgroundColor = [UIColor clearColor];
    settingTableView.delegate = self;
    settingTableView.dataSource = self;
    [mainScrollView addSubview:settingTableView];
    
    userTableView = [[YFJLeftSwipeDeleteTableView alloc]initWithFrame:CGRectMake(0, loginButton.frame.origin.y + loginButton.frame.size.height + 20, mainScrollView.frame.size.width - OFFSET, 200) style:UITableViewStylePlain];
    userTableView.backgroundColor = [UIColor clearColor];
    userTableView.delegate = self;
    userTableView.dataSource = self;
    [mainScrollView addSubview:userTableView];

    [mainScrollView setContentSize:CGSizeMake(mainScrollView.frame.size.width, settingTableView.frame.origin.y + settingTableView.frame.size.height - 40)];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

#pragma mark 获取用户列表
- (void)getMemberList
{
    dispatch_queue_t network_queue;
    network_queue = dispatch_queue_create("login", nil);
    dispatch_async(network_queue, ^{
        
        
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults]objectForKey:USERID],@"user_id",LANGUAGE_TYPE,@"lang_type", nil];
        NSString *request = [HTTPRequest requestForGetWithPramas:dict method:@"get_member_list"];
        NSDictionary *dictionary = [JsonUtil jsonToDic:request];
        
        NSLog(@"dic==%@",dictionary);
        //turn to main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([[dictionary objectForKey:@"msg"]integerValue] == 1)
            {
                //                NSString *data =  [dictionary objectForKey:@"data"];
                //                data = [FBEncryptorDES decrypt:data keyString:@"SDFL#)@F"];
                //                data = [data URLDecodedString];
                
                [memberArray removeAllObjects];
                if ([[dictionary objectForKey:@"data"] isKindOfClass:[NSArray class]])
                {
                    NSArray *allMember = [dictionary objectForKey:@"data"];
                    
                    NSLog(@"begin================");
                    NSLog(@"%@", allMember);
                    NSLog(@"end==================");
                    
                    for (int i = 0; i < allMember.count; i ++)
                    {
                        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"selectMember"])
                        {
                            if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"selectMember"] isKindOfClass:[NSDictionary class]])
                            {
                                NSDictionary * dict =  [[NSUserDefaults standardUserDefaults] objectForKey:@"selectMember"];
                                
                                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                                
                                NSDictionary *memberDic = [allMember objectAtIndex:i];
                                
                                if ([[memberDic objectForKey:@"id"]integerValue] == [[dict objectForKey:@"id"] integerValue])
                                {
                                    [dic setValue:@"YES" forKey:@"isSelect"];
                                }
                                else
                                {
                                    [dic setValue:@"NO" forKey:@"isSelect"];
                                }
                                
                                [dic setObject:[memberDic objectForKey:@"member_name"] forKey:@"member_name"];
                                [dic setObject:[memberDic objectForKey:@"id"] forKey:@"id"];
                                [dic setObject:[memberDic objectForKey:@"user_id"] forKey:@"user_id"];
                                [memberArray addObject:dic];
                            }
                            
                        }
                        else
                        {
                            
                            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                            
                            NSDictionary *memberDic = [allMember objectAtIndex:i];
                            
                            [dic setValue:@"NO" forKey:@"isSelect"];
                            
                            [dic setObject:[memberDic objectForKey:@"member_name"] forKey:@"member_name"];
                            [dic setObject:[memberDic objectForKey:@"id"] forKey:@"id"];
                            [dic setObject:[memberDic objectForKey:@"user_id"] forKey:@"user_id"];
                            [memberArray addObject:dic];
                        }
                        
                        
                        
                    }
                }
               
                
                [self refreshTableView];
                //                [self performSelector:@selector(updateHud) withObject:nil afterDelay:1.0];
                
                
                // Required
                //                [APService setupWithOption:launchOptions];
                //                [NSThread detachNewThreadSelector:@selector(saveSn) toTarget:self withObject:nil];
                
            }else
            {
                sleep(1);
                
                if ([dictionary objectForKey:@"msgbox"] != nil) {
                    //                    [hud setCaption:[dictionary objectForKey:@"msgbox"]];
                    //                    [hud setActivity:NO];
                    //                    [hud update];
                    //                    hud.delegate = nil;
                    //                    [hud hideAfter:1.0];
                }else
                {
                    //                    [hud setCaption:@"登录失败"];
                    //                    [hud setActivity:NO];
                    //                    [hud update];
                    //                    hud.delegate = nil;
                    //                    [hud hideAfter:1.0];
                }
                
            }
        });
    });

}


- (void)refreshTableView
{
    [userTableView reloadData];
    [settingTableView setFrame:CGRectMake(0, userTableView.frame.origin.y + userTableView.frame.size.height + 20, userTableView.frame.size.width, 200)];
    [mainScrollView setContentSize:CGSizeMake(mainScrollView.frame.size.width, settingTableView.frame.origin.y + settingTableView.frame.size.height - 40)];
}
//登陆或退出登陆
-(void)loginOrLogoutAction
{
    if (loginButton.selected)
    {
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:ISLOGIN];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"selectMember"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        [memberArray removeAllObjects];
        [self refreshTableView];
        loginButton.selected = !loginButton.selected;
    }
    else
    {
        EALoginViewController *login = [[EALoginViewController alloc]initWithNibName:@"EALoginViewController" bundle:nil];
        login.delegate = self;
        [self.navigationController pushViewController:login animated:YES];
        [self.mm_drawerController setMaximumLeftDrawerWidth:320];
    }
    
   
}
#pragma mark 登录成功后重新刷新列表
-(void)loginSuccessAndRefreshMemberView
{
    [self getMemberList];
    loginButton.selected = YES;
}
#pragma mark 添加用户
- (void)addUserAction
{
    EAAddMemberViewController *addMember = [[EAAddMemberViewController alloc]initWithNibName:@"EAAddMemberViewController" bundle:nil];
    addMember.delegate = self;
    [self.navigationController pushViewController:addMember animated:YES];
    [self.mm_drawerController setMaximumLeftDrawerWidth:320];
}
#pragma mark 添加用户成功后重新刷新列表
-(void)addMemberSuccessAndRefreshMemberList
{
    [self getMemberList];
}
#pragma mark 删除用户
- (void)deleteUserMemberByMemberId:(NSString *)memberId
{
    dispatch_queue_t network_queue;
    network_queue = dispatch_queue_create("delete_member_user", nil);
    dispatch_async(network_queue, ^{
        
        
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:memberId,@"member_id",LANGUAGE_TYPE,@"lang_type", nil];
        NSString *request = [HTTPRequest requestForGetWithPramas:dict method:@"delete_member_user"];
        NSDictionary *dictionary = [JsonUtil jsonToDic:request];
        
        NSLog(@"dic==%@",dictionary);
        //turn to main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([[dictionary objectForKey:@"msg"]integerValue] == 1)
            {
                if ([[NSUserDefaults standardUserDefaults] objectForKey:@"selectMember"])
                {
                    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"selectMember"] isKindOfClass:[NSDictionary class]])
                    {
                        NSDictionary * dict =  [[NSUserDefaults standardUserDefaults] objectForKey:@"selectMember"];
                        if ([memberId integerValue] == [[dict objectForKey:@"id"]integerValue])
                        {
                            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"selectMember"];
                            [[NSUserDefaults standardUserDefaults] synchronize];
                        }
                    }
                }
            
                [self getMemberList];
                
            }
            else
            {
                sleep(1);
                
                if ([dictionary objectForKey:@"msgbox"] != nil) {
                    //                    [hud setCaption:[dictionary objectForKey:@"msgbox"]];
                    //                    [hud setActivity:NO];
                    //                    [hud update];
                    //                    hud.delegate = nil;
                    //                    [hud hideAfter:1.0];
                }else
                {
                    //                    [hud setCaption:@"登录失败"];
                    //                    [hud setActivity:NO];
                    //                    [hud update];
                    //                    hud.delegate = nil;
                    //                    [hud hideAfter:1.0];
                }
                
            }
        });
    });
}

#pragma mark tableViewDelegate
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
    [footerView setBackgroundColor:[UIColor colorwithHexString:@"#2b2b2b"]];
    if (tableView == userTableView)
    {
        UIImageView *addImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 14 - 50, 5, 14, 14)];
        [addImage setImage:[UIImage imageNamed:@"tianjiarenyuan"]];
        UILabel *addLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 50, 0, 30, 20)];
        addLabel.backgroundColor = [UIColor clearColor];
        addLabel.font = [UIFont systemFontOfSize:15];
        addLabel.textColor = [UIColor whiteColor];
        addLabel.text = DPLocalizedString(@"Add");
        [footerView addSubview:addLabel];
        [footerView addSubview:addImage];
        UITapGestureRecognizer *addUser = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addUserAction)];
        [footerView addGestureRecognizer:addUser];
    }
    
    return footerView;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
    [headerView setBackgroundColor:[UIColor colorwithHexString:@"#2b2b2b"]];
    if (tableView == userTableView)
    {
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.font = [UIFont systemFontOfSize:15];
        titleLabel.text = DPLocalizedString(@"Selected user");
        [headerView addSubview:titleLabel];
    }
    else if(tableView == settingTableView)
    {
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.font = [UIFont systemFontOfSize:15];
        titleLabel.text = DPLocalizedString(@"Setting");
        [headerView addSubview:titleLabel];
    }
    else
    {
        return 0;
    }

    return headerView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 20;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
}

#pragma mark TableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == userTableView)
    {
            CGRect rect = tableView.frame;
            rect.size.height = [memberArray count] * 35 + 20 + 20;
            tableView.frame = rect;
            return [memberArray count];
    }
    else if (tableView == settingTableView)
    {
        CGRect rect = tableView.frame;
        rect.size.height = 3 * 35 + 20 + 20;
        rect.origin.y = userTableView.frame.origin.y + userTableView.frame.size.height + 20;
        tableView.frame = rect;
        return 3;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == userTableView)
    {
        EAMemberCell *cell = [tableView dequeueReusableCellWithIdentifier:@"memberCell"];
        cell =[[[NSBundle mainBundle]loadNibNamed:@"EAMemberCell" owner:self options:nil]objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.memberLabel.text = [[memberArray objectAtIndex:indexPath.row]objectForKey:@"member_name"];
        if ([[[memberArray objectAtIndex:indexPath.row] objectForKey:@"isSelect"] isEqualToString:@"YES"])
        {
            cell.selectImage.hidden = NO;
        }
        else
        {
            cell.selectImage.hidden = YES;
        }
        return cell;
    }
    else if(tableView == settingTableView)
    {
        static NSString *reuseID=@"cellID";
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:reuseID];
//        if (cell==nil) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.contentView.backgroundColor = [UIColor colorwithHexString:@"#3f3f3f"];
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            UIImageView *accessoryView = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 9 - 10, 10, 9, 15)];
            [accessoryView setImage:[UIImage imageNamed:@"gengduodaohangjian"]];
            [cell addSubview:accessoryView];
            cell.textLabel.textColor = [UIColor whiteColor];
            switch (indexPath.row)
            {
                case 0:
                {
                    cell.textLabel.text = DPLocalizedString(@"Setting");
                }
                    
                    break;
                case 1:
                {
                    cell.textLabel.text = DPLocalizedString(@"Remind");
                }
                    
                    break;
                case 2:
                {
                    
                }
                    cell.textLabel.text = DPLocalizedString(@"About us");
                    break;
                default:
                    break;
            }
//        }
        return cell;
    }
    
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    rootViewController = NO;
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
   
    if (tableView == userTableView)
    {
        EAMemberCell *cell = (EAMemberCell*)[tableView cellForRowAtIndexPath:indexPath];
        
        for (int i = 0; i < memberArray.count; i ++)
        {
            NSMutableDictionary *dic = [memberArray objectAtIndex:i];
            if (i == indexPath.row)
            {
                [dic setObject:@"YES" forKey:@"isSelect"];
                cell.selectImage.hidden = NO;
                if ([self.delegate respondsToSelector:@selector(selectMemberWithInfomation:)])
                {
                    [self.delegate selectMemberWithInfomation:dic];
                }
                [[NSUserDefaults standardUserDefaults] setObject:dic forKey:@"selectMember"];
                [[NSUserDefaults standardUserDefaults]synchronize];
            }
            else
            {
                [dic setObject:@"NO" forKey:@"isSelect"];
                cell.selectImage.hidden = YES;
            }
        }
        [tableView reloadData];
    }
    else if(tableView == settingTableView)
    {
        [self.mm_drawerController setMaximumLeftDrawerWidth:320];
        switch (indexPath.row)
        {
            case 0:
            {
                EASettingViewController *setting = [[EASettingViewController alloc]init];
                [self.navigationController pushViewController:setting animated:YES];
            }
                break;
            case 1:
            {
                EARemindViewController *remind = [[EARemindViewController alloc]init];
                [self.navigationController pushViewController:remind animated:YES];
            }
                break;
            case 2:
            {
                EAAboutViewController *about = [[EAAboutViewController alloc]initWithNibName:@"EAAboutViewController" bundle:nil];
                [self.navigationController pushViewController:about animated:YES];
            }
                break;
            default:
                break;
        }
    }
    
}
//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//	return UITableViewCellEditingStyleDelete;
//}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        // Delete the row from the data source
        [self deleteUserMemberByMemberId:[[memberArray objectAtIndex:indexPath.row]objectForKey:@"id"]];
//         [memberArray removeObjectAtIndex:indexPath.row];
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        NSLog(@"--->delete!!");
        [self refreshTableView];
    }
   
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

@end
