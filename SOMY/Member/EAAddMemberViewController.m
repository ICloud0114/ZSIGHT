//
//  EAAddMemberViewController.m
//  SOMY
//
//  Created by easaa on 9/2/14.
//  Copyright (c) 2014 easaa. All rights reserved.
//

#import "EAAddMemberViewController.h"
#import "UIViewController+MMDrawerController.h"
@interface EAAddMemberViewController ()<UIAlertViewDelegate>
{
    CustomNavigation *myNavigationBar;
}
@property (weak, nonatomic) IBOutlet UILabel *addUserLabel;
- (IBAction)addMemberAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *memberTextField;
@property (weak, nonatomic) IBOutlet UIButton *addMenberButton;

@end

@implementation EAAddMemberViewController

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
    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
    {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 20)];
        view.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:view];
    }
    myNavigationBar = [[CustomNavigation alloc]initWithFrame:CGRectMake(0, INCREMENT, 320, 44)];
    myNavigationBar.titleLabel.text = DPLocalizedString(@"Add user");
    myNavigationBar.leftButton.hidden = NO;
    [myNavigationBar.leftButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:myNavigationBar];
    self.addUserLabel.text = DPLocalizedString(@"Enter the user name");
    [self.addMenberButton setTitle:DPLocalizedString(@"Submit") forState:UIControlStateNormal];
}
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.memberTextField resignFirstResponder];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

- (IBAction)addMemberAction:(id)sender
{
    if (self.memberTextField.text.length == 0) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:DPLocalizedString(@"Please input username") delegate:nil cancelButtonTitle:DPLocalizedString(@"Confirm") otherButtonTitles:nil, nil];
        [alertView show];
        
        return;
    }
    dispatch_queue_t network_queue;
    network_queue = dispatch_queue_create("add_member_user", nil);
    dispatch_async(network_queue, ^{
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults]objectForKey:USERID],@"user_id",self.memberTextField.text,@"member_name",LANGUAGE_TYPE,@"lang_type", nil];
        NSString *request = [HTTPRequest requestForGetWithPramas:dict method:@"add_member_user"];
        NSDictionary *dictionary = [JsonUtil jsonToDic:request];
        
        NSLog(@"dic==%@",dictionary);
        //turn to main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([[dictionary objectForKey:@"msg"]integerValue] == 1)
            {
                
                if ([self.delegate respondsToSelector:@selector(addMemberSuccessAndRefreshMemberList)]) {
                    [self.delegate addMemberSuccessAndRefreshMemberList];
                }
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:DPLocalizedString(@"Add Success") delegate:self cancelButtonTitle:DPLocalizedString(@"Confirm") otherButtonTitles:nil, nil];
                [alertView show];
                
            }else
            {
                sleep(1);
                
                if ([dictionary objectForKey:@"msgbox"] != nil)
                {
                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:DPLocalizedString(@"Add Failed") delegate:nil cancelButtonTitle:DPLocalizedString(@"Confirm") otherButtonTitles:nil, nil];
                    [alertView show];
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

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
