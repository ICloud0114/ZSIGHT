//
//  EAChangePasswordViewController.m
//  SOMY
//
//  Created by easaa on 9/2/14.
//  Copyright (c) 2014 easaa. All rights reserved.
//

#import "EAChangePasswordViewController.h"

@interface EAChangePasswordViewController ()
{
    CustomNavigation *myNavigationBar;
}
@property (weak, nonatomic) IBOutlet UILabel *oldLabel;
@property (weak, nonatomic) IBOutlet UILabel *passwordLabel;
@property (weak, nonatomic) IBOutlet UILabel *checkLabel;
@property (weak, nonatomic) IBOutlet UITextField *oldPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *checkPasswordTextField;
- (IBAction)submitAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *submit;

@end

@implementation EAChangePasswordViewController

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
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor colorwithHexString:@"#EEEFF0"];
    myNavigationBar = [[CustomNavigation alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
    {
        [myNavigationBar setFrame:CGRectMake(0, 20, 320, 44)];
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 20)];
        view.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:view];
        
    }
    myNavigationBar.titleLabel.text = DPLocalizedString(@"Change the password");
    myNavigationBar.leftButton.hidden = NO;
    [myNavigationBar.leftButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:myNavigationBar];
    
    self.oldLabel.text = DPLocalizedString(@"Old Password");
    self.passwordLabel.text = DPLocalizedString(@"New Password");
    self.checkLabel.text = DPLocalizedString(@"New Password");
    [self.submit setTitle:DPLocalizedString(@"Confirm") forState:UIControlStateNormal];
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

- (IBAction)submitAction:(id)sender
{
    dispatch_queue_t network_queue;
    network_queue = dispatch_queue_create("login", nil);
    dispatch_async(network_queue, ^{
        
        
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults]objectForKey:USERID],@"user_id",self.oldPasswordTextField.text,@"old_password",self.passwordTextField.text,@"new_password",LANGUAGE_TYPE,@"lang_type", nil];
        NSString *request = [HTTPRequest requestForGetWithPramas:dict method:@"change_pwd"];
        NSDictionary *dictionary = [JsonUtil jsonToDic:request];
        
        NSLog(@"dic==%@",dictionary);
        //turn to main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([[dictionary objectForKey:@"msg"]integerValue] == 1)
            {
                //                NSString *data =  [dictionary objectForKey:@"data"];
                //                data = [FBEncryptorDES decrypt:data keyString:@"SDFL#)@F"];
                //                data = [data URLDecodedString];
               
                UIAlertView *alart = [[UIAlertView alloc]initWithTitle:nil message: [dictionary objectForKey:@"msgbox"] delegate:nil cancelButtonTitle:DPLocalizedString(@"Confirm") otherButtonTitles:nil, nil];
                [alart show];
                
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
@end
