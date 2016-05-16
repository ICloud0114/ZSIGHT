//
//  EALoginViewController.m
//  SOMY
//
//  Created by easaa on 9/2/14.
//  Copyright (c) 2014 easaa. All rights reserved.
//

#import "EALoginViewController.h"
#import "EAForgotPasswordViewController.h"
#import "EARegisterViewController.h"

#import "UIViewController+MMDrawerController.h"

#import "ATMHud.h"
#import "ATMHudDelegate.h"
@interface EALoginViewController ()<ATMHudDelegate>
{
    CustomNavigation *myNavigationBar;
    ATMHud *hud;
}
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *passwordLabel;
@property (weak, nonatomic) IBOutlet UIButton *areaSelect;
@property (weak, nonatomic) IBOutlet UIButton *areaSelectAction;
@property (weak, nonatomic) IBOutlet UITextField *cellPhone;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIButton *forgotPassword;
- (IBAction)forgotPasswordAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *regist;
- (IBAction)registAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *login;
- (IBAction)loginAction:(id)sender;


@end

@implementation EALoginViewController

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
    
    [self.emailLabel setText:DPLocalizedString(@"email")];
    [self.passwordLabel setText:DPLocalizedString(@"Secret")];
    [self.areaSelect setTitle:DPLocalizedString(@"CN +86") forState:UIControlStateNormal];
    self.cellPhone.placeholder = DPLocalizedString(@"Email");
    self.password.placeholder = DPLocalizedString(@"The login password");
    [self.forgotPassword setTitle: DPLocalizedString(@"Forgot password") forState:UIControlStateNormal];
    [self.regist setTitle: DPLocalizedString(@"Registering a new user") forState:UIControlStateNormal];
    [self.login setTitle:DPLocalizedString(@"The login") forState:UIControlStateNormal];
    self.areaSelect.tintColor = [UIColor colorwithHexString:@"#8fcbc4"];
    
    self.regist.tintColor = [UIColor colorwithHexString:@"#8fcbc4"];
    self.view.backgroundColor = [UIColor colorwithHexString:@"#EEEFF0"];
    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
    {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 20)];
        view.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:view];
    }
    myNavigationBar = [[CustomNavigation alloc]initWithFrame:CGRectMake(0, INCREMENT, 320, 44)];
    myNavigationBar.titleLabel.text = DPLocalizedString(@"The login");
    myNavigationBar.leftButton.hidden = NO;
    [myNavigationBar.leftButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:myNavigationBar];
    
    hud = [[ATMHud alloc]initWithDelegate:self];
    [self.view addSubview:hud.view];
    
    if (!([[NSUserDefaults standardUserDefaults] objectForKey:USERNAME] == nil || [[[NSUserDefaults standardUserDefaults] objectForKey:USERNAME] isEqualToString:@""]))
    {
        self.cellPhone.text = [[NSUserDefaults standardUserDefaults] objectForKey:USERNAME];
    }
    if (!([[NSUserDefaults standardUserDefaults] objectForKey:PASSWORD] == nil || [[[NSUserDefaults standardUserDefaults] objectForKey:PASSWORD] isEqualToString:@""]))
    {
        self.password.text = [[NSUserDefaults standardUserDefaults] objectForKey:PASSWORD];
    }
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

- (IBAction)forgotPasswordAction:(id)sender
{
    EAForgotPasswordViewController *forget = [[EAForgotPasswordViewController alloc]initWithNibName:@"EAForgotPasswordViewController" bundle:nil];
    [self.navigationController pushViewController:forget animated:YES];

}
- (IBAction)registAction:(id)sender
{
    EARegisterViewController *forget = [[EARegisterViewController alloc]initWithNibName:@"EARegisterViewController" bundle:nil];
    [self.navigationController pushViewController:forget animated:YES];

}
- (IBAction)loginAction:(id)sender
{
    
    
    if (self.cellPhone.text.length == 0) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:DPLocalizedString(@"Please input username") delegate:nil cancelButtonTitle:DPLocalizedString(@"Confirm") otherButtonTitles:nil, nil];
        [alertView show];

        return;
    }
    else if (self.password.text.length == 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:DPLocalizedString(@"Please input password") delegate:nil cancelButtonTitle:DPLocalizedString(@"Confirm") otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    
    [self requestForLogin];
}

- (void)requestForLogin
{
    [hud setCaption:DPLocalizedString(@"Loading..")];
    [hud setActivity:YES];
    [hud show];
    
    
    dispatch_queue_t network_queue;
    network_queue = dispatch_queue_create("login", nil);
    dispatch_async(network_queue, ^{
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys: self.cellPhone.text,@"user_name",self.password.text,@"password",LANGUAGE_TYPE,@"lang_type", nil];
        NSString *request = [HTTPRequest requestForGetWithPramas:dict method:@"user_login"];
        NSDictionary *dictionary = [JsonUtil jsonToDic:request];
        
        NSLog(@"dic==%@",dictionary);
        //turn to main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([[dictionary objectForKey:@"msg"]integerValue] == 1)
            {
//                NSString *data =  [dictionary objectForKey:@"data"];
//                data = [FBEncryptorDES decrypt:data keyString:@"SDFL#)@F"];
//                data = [data URLDecodedString];
                NSDictionary *dict = [[dictionary objectForKey:@"data"] firstObject];
                
                NSLog(@"begin================");
                NSLog(@"%@", dict);
                NSLog(@"end==================");
                
                [[NSUserDefaults standardUserDefaults] setObject:[dict objectForKey:@"id"] forKey:USERID];
                [[NSUserDefaults standardUserDefaults]synchronize];
                
                [[NSUserDefaults standardUserDefaults] setObject:self.cellPhone.text forKey:USERNAME];
                [[NSUserDefaults standardUserDefaults]synchronize];
                [[NSUserDefaults standardUserDefaults] setObject:self.password.text forKey:PASSWORD];
                [[NSUserDefaults standardUserDefaults]synchronize];
                [[NSUserDefaults standardUserDefaults]setBool:YES forKey:ISLOGIN];
                [[NSUserDefaults standardUserDefaults]synchronize];
                
                if ([self.delegate respondsToSelector:@selector(loginSuccessAndRefreshMemberView)])
                {
                    [self.delegate loginSuccessAndRefreshMemberView];
                }
                if ([dictionary objectForKey:@"msgbox"] != nil) {
                    [hud setCaption:[dictionary objectForKey:@"msgbox"]];
                    [hud setActivity:NO];
                    [hud update];
                    hud.delegate = self;
                    [hud hideAfter:1.0];
                }
                // Required
                //                [APService setupWithOption:launchOptions];
                //                [NSThread detachNewThreadSelector:@selector(saveSn) toTarget:self withObject:nil];
                
            }else
            {
                sleep(1);
                
                if ([dictionary objectForKey:@"msgbox"] != nil) {
                    [hud setCaption:[dictionary objectForKey:@"msgbox"]];
                    [hud setActivity:NO];
                    [hud update];
                    hud.delegate = nil;
                    [hud hideAfter:1.0];
                }else
                {
                    [hud setCaption:DPLocalizedString(@"Login Failed")];
                    [hud setActivity:NO];
                    [hud update];
                    hud.delegate = nil;
                    [hud hideAfter:1.0];
                }
                
            }
        });
    });
    
}


- (void)hudWillDisappear:(ATMHud *)_hud
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.cellPhone resignFirstResponder];
    [self.password resignFirstResponder];
}
@end
