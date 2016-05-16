//
//  EAForgotPasswordViewController.m
//  SOMY
//
//  Created by easaa on 9/2/14.
//  Copyright (c) 2014 easaa. All rights reserved.
//

#import "EAForgotPasswordViewController.h"
#import "ATMHud.h"
#import "ATMHudDelegate.h"
@interface EAForgotPasswordViewController ()<ATMHudDelegate>
{
    CustomNavigation *myNavigationBar;
    ATMHud *hud;
}
@property (weak, nonatomic) IBOutlet UITextField *cellNumber;
@property (weak, nonatomic) IBOutlet UIButton *getMessage;
- (IBAction)getMessageAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *checkCode;
@property (weak, nonatomic) IBOutlet UITextField *oldTextField;
@property (weak, nonatomic) IBOutlet UITextField *checkTextField;
@property (weak, nonatomic) IBOutlet UIButton *submit;

@end

@implementation EAForgotPasswordViewController

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
    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
    {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 20)];
        view.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:view];
    }
    myNavigationBar = [[CustomNavigation alloc]initWithFrame:CGRectMake(0, INCREMENT, 320, 44)];
    myNavigationBar.titleLabel.text = DPLocalizedString(@"Forgot password");
    myNavigationBar.leftButton.hidden = NO;
    [myNavigationBar.leftButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:myNavigationBar];
    self.cellNumber.placeholder = DPLocalizedString(@"Input Email");
    self.checkCode.placeholder = DPLocalizedString(@"Input validation code");
    [self.getMessage setTitle:DPLocalizedString(@"Get Code") forState:UIControlStateNormal];
    [self.submit setTitle:DPLocalizedString(@"Submit") forState:UIControlStateNormal];
    self.oldTextField.placeholder = DPLocalizedString(@"Old Password");
    self.checkTextField.placeholder = DPLocalizedString(@"New Password");
    
    hud = [[ATMHud alloc]initWithDelegate:nil];
    [self.view addSubview:hud.view];
}
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.cellNumber endEditing:YES];
    [self.checkCode endEditing:YES];
    [self.oldTextField endEditing:YES];
    [self.checkTextField endEditing:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)getMessageAction:(id)sender
{
    if (self.cellNumber.text.length == 0) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:DPLocalizedString(@"Please fill out the complete information") delegate:nil cancelButtonTitle:DPLocalizedString(@"Confirm") otherButtonTitles:nil, nil];
        [alertView show];
        
        return;
    }
    if (![self validateEmail:self.cellNumber.text])
    {
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:DPLocalizedString(@"Please enter the correct mailbox number") delegate:nil cancelButtonTitle:DPLocalizedString(@"Confirm") otherButtonTitles:nil, nil];
        [alertView show];
        
        return;
    }
    [self getCheckCodeByEmail];
}

#pragma mark - 验证邮箱
- (BOOL) validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}
- (IBAction)submitAction:(id)sender
{
    if (self.cellNumber.text.length == 0 || self.checkCode.text.length == 0 || self.oldTextField.text.length == 0|| self.checkTextField.text.length == 0) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:DPLocalizedString(@"Please fill out the complete information") delegate:nil cancelButtonTitle:DPLocalizedString(@"Confirm") otherButtonTitles:nil, nil];
        [alertView show];
        
        return;
    }
    
    if (![self validateEmail:self.cellNumber.text])
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:DPLocalizedString(@"Please enter the correct mailbox number") delegate:nil cancelButtonTitle:DPLocalizedString(@"Confirm") otherButtonTitles:nil, nil];
        [alertView show];
        
        return;
    }
    if (![self.oldTextField.text isEqualToString:self.checkTextField.text])
    {
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:DPLocalizedString(@"Passwords do not match") delegate:nil cancelButtonTitle:DPLocalizedString(@"Confirm") otherButtonTitles:nil, nil];
        [alertView show];
        
        return;
    }
    [self updateUserPassword];
}

- (void)getCheckCodeByEmail
{
    dispatch_queue_t network_queue;
    network_queue = dispatch_queue_create("get_verify_code", nil);
    dispatch_async(network_queue, ^{
        
        
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:self.cellNumber.text,@"mobile",LANGUAGE_TYPE,@"lang_type", nil];
        NSString *request = [HTTPRequest requestForGetWithPramas:dict method:@"get_verify_code"];
        NSDictionary *dictionary = [JsonUtil jsonToDic:request];
        
        NSLog(@"dic==%@",dictionary);
        //turn to main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([[dictionary objectForKey:@"msg"]integerValue] == 1)
            {
                
                [hud setCaption:DPLocalizedString(@"Send Success")];
                [hud setActivity:NO];
                [hud setDelegate:nil];
                [hud show];
                [hud hideAfter:1.0f];
                
            }else
            {
                [hud setCaption:DPLocalizedString(@"Send Failed")];
                [hud setActivity:NO];
                [hud setDelegate:nil];
                [hud show];
                [hud hideAfter:1.0f];
                
                
            }
        });
    });
    
}
- (void)updateUserPassword
{
    dispatch_queue_t network_queue;
    network_queue = dispatch_queue_create("user_change_pwd", nil);
    dispatch_async(network_queue, ^{
        
        
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:self.cellNumber.text,@"mobile",LANGUAGE_TYPE,@"lang_type",self.checkCode.text,@"strcode",self.checkTextField.text,@"password", nil];
        NSString *request = [HTTPRequest requestForGetWithPramas:dict method:@"user_change_pwd"];
        NSDictionary *dictionary = [JsonUtil jsonToDic:request];
        
        NSLog(@"dic==%@",dictionary);
        //turn to main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([[dictionary objectForKey:@"msg"]integerValue] == 1)
            {
                
                [hud setCaption:DPLocalizedString(@"Update Success")];
                [hud setActivity:NO];
                [hud setDelegate:self];
                [hud show];
                [hud hideAfter:1.0f];
                
            }else
            {
                [hud setCaption:DPLocalizedString(@"Update Failed")];
                [hud setActivity:NO];
                [hud setDelegate:nil];
                [hud show];
                [hud hideAfter:1.0f];
                
                
            }
        });
    });
    
}

- (void)hudDidDisappear:(ATMHud *)_hud
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
