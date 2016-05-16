//
//  EARegisterViewController.m
//  SOMY
//
//  Created by easaa on 9/2/14.
//  Copyright (c) 2014 easaa. All rights reserved.
//

#import "EARegisterViewController.h"

@interface EARegisterViewController ()<UIAlertViewDelegate>
{
    CustomNavigation *myNavigationBar;
}
@property (weak, nonatomic) IBOutlet UITextField *cellPhoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *userName;
- (IBAction)registerAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *areaSelectButton;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;

@end

@implementation EARegisterViewController

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
    myNavigationBar.titleLabel.text = DPLocalizedString(@"Registered");
    myNavigationBar.leftButton.hidden = NO;
    [myNavigationBar.leftButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:myNavigationBar];
    
    [self.areaSelectButton setTitle:DPLocalizedString(@"CN +86") forState:UIControlStateNormal];
    [self.registerButton setTitle:DPLocalizedString(@"Registered") forState:UIControlStateNormal];
    self.cellPhoneNumber.placeholder = DPLocalizedString(@"Email");
    self.password.placeholder = DPLocalizedString(@"The login password");
    self.userName.placeholder = DPLocalizedString(@"Enter the user name");
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

- (IBAction)registerAction:(id)sender
{
    if (self.cellPhoneNumber.text.length == 0 || self.password.text.length == 0 || self.userName.text.length == 0) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:DPLocalizedString(@"Please fill out the complete information") delegate:nil cancelButtonTitle:DPLocalizedString(@"Confirm") otherButtonTitles:nil, nil];
        [alertView show];
        
        return;
    }
    if (![self validateEmail:self.cellPhoneNumber.text])
    {
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:DPLocalizedString(@"Please enter the correct mailbox number") delegate:nil cancelButtonTitle:DPLocalizedString(@"Confirm") otherButtonTitles:nil, nil];
        [alertView show];

        return;
    }
    
    dispatch_queue_t network_queue;
    network_queue = dispatch_queue_create("register", nil);
    dispatch_async(network_queue, ^{
        NSDictionary *postDic = [NSDictionary dictionaryWithObjectsAndKeys:self.userName.text,@"user_name",
                                 self.password.text,@"password",
                                 self.cellPhoneNumber.text,@"mobile",
                                 LANGUAGE_TYPE,@"lang_type",
                                 nil];
        NSString *paramsJson = [JsonFactory dictoryToJsonStr:postDic];
        
        //    NSLog(@"requestParamstr %@",paramsJson);
        //加密
        paramsJson = [[FBEncryptorDES encrypt:paramsJson
                                    keyString:@"SDFL#)@F"] uppercaseString];
        NSString *signs= [NSString stringWithFormat:@"SDFL#)@FMethod%@Params%@SDFL#)@F",@"user_register",paramsJson];
        signs = [[FBEncryptorDES md5:signs] uppercaseString];
        
        NSString *urlStr = [NSString stringWithFormat:SOMYAPI,@"user_register",paramsJson,signs];
        //            NSString *urlStr = [NSString stringWithFormat:@"http://192.168.0.23:16327/api/GetFetationInfo.ashx?Method=%@&Params=%@&Sign=%@",@"add_note",paramsJson,signs];
        NSString *postString = nil;
        //            NSData *postData = [self htmlImageString:tem textViewString:postString];
        NSString *request = [HTTPRequest requestForPost:urlStr :postString];
        //            NSString *request = [HTTPRequest requestForHtmlPost:urlStr :postData];
        NSDictionary *dictionary = [JsonUtil jsonToDic:request];
        
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
//            [hud hide];
        });
        
        double delayInSeconds = 0.5;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            if ([[dictionary objectForKey:@"msg"]intValue] == 1)
            {
                dispatch_queue_t network_queue;
                network_queue = dispatch_queue_create("add_member_user", nil);
                dispatch_async(network_queue, ^{
                    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[[dictionary objectForKey:@"data"] objectForKey:@"id"],@"user_id",[[dictionary objectForKey:@"data"] objectForKey:@"user_name"],@"member_name",LANGUAGE_TYPE,@"lang_type", nil];
                    NSString *request = [HTTPRequest requestForGetWithPramas:dict method:@"add_member_user"];
                    NSDictionary *dictionary = [JsonUtil jsonToDic:request];
                    
                    NSLog(@"dic==%@",dictionary);
                    //turn to main thread
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if ([[dictionary objectForKey:@"msg"]integerValue] == 1)
                        {
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
//                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"注册成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                [alertView show];

            }else
            {
                if ([dictionary objectForKey:@"msgbox"] != nil) {
                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:DPLocalizedString(@"Regist Failed") delegate:nil cancelButtonTitle:DPLocalizedString(@"Confirm") otherButtonTitles:nil, nil];
                    [alertView show];

                    
                }else
                {
                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:DPLocalizedString(@"can not connect") delegate:nil cancelButtonTitle:DPLocalizedString(@"Confirm") otherButtonTitles:nil, nil];
                    [alertView show];

                    
                }
            }
        });
        
    });
}
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.cellPhoneNumber resignFirstResponder];
    [self.password resignFirstResponder];
    [self.userName resignFirstResponder];
}

#pragma mark - 验证邮箱
- (BOOL) validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}
#pragma mark - 验证手机号码

- (BOOL)isMobileNumber:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1(([0-9])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    //    NSString *strRex = @"^((13[0-9])|(15[^4,//D])|(18[0,5-9]))//d{8}$";
    //    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", strRex];
    //    if ([predicate evaluateWithObject:mobileNum])
    //    {
    //        return YES;
    //    }
    //    return NO;
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
