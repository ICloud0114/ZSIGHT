//
//  EAFeedbackViewController.m
//  SOMY
//
//  Created by easaa on 9/2/14.
//  Copyright (c) 2014 easaa. All rights reserved.
//

#import "EAFeedbackViewController.h"
#import "ATMHud.h"
#import "ATMHudDelegate.h"
@interface EAFeedbackViewController ()<UITextViewDelegate,ATMHudDelegate>
{
    CustomNavigation *myNavigationBar;
    UITextView *showTextView;
    UITextView *writeFeedback;
    ATMHud *hud;
}
@end

@implementation EAFeedbackViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
//-(void)viewDidDisappear:(BOOL)animated
//{
//    [[NSNotificationCenter defaultCenter]removeObserver:self];
//}
//
//-(void)viewDidAppear:(BOOL)animated
//{
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillShow:)
//                                                 name:UIKeyboardWillShowNotification
//                                               object:nil];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillHide:)
//                                                 name:UIKeyboardWillHideNotification
//                                               object:nil];
//}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorwithHexString:@"#EEEFF0"];
    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
    {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 20)];
        view.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:view];
    }
    myNavigationBar = [[CustomNavigation alloc]initWithFrame:CGRectMake(0, INCREMENT, 320, 44)];
    myNavigationBar.titleLabel.text = DPLocalizedString(@"Feedback");
    myNavigationBar.leftButton.hidden = NO;
    [myNavigationBar.leftButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [myNavigationBar.submitButton setTitle:DPLocalizedString(@"Submit") forState:UIControlStateNormal];
    [myNavigationBar.submitButton setHidden:NO];
    [myNavigationBar.submitButton addTarget:self action:@selector(onSubmitAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:myNavigationBar];
    
    showTextView = [[UITextView alloc]initWithFrame:CGRectMake(5, myNavigationBar.frame.origin.y + myNavigationBar.frame.size.height + 20, 310, 150)];
    showTextView.text = @"";
    [self.view addSubview:showTextView];
    
//    writeFeedback = [[UITextView alloc]initWithFrame:CGRectMake(5, showTextView.frame.origin.y + showTextView.frame.size.height + 30, 310, 120)];
//    writeFeedback.text = @"write";
//    [self.view addSubview:writeFeedback];
    
    hud = [[ATMHud alloc]initWithDelegate:nil];
    [self.view addSubview:hud.view];
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [showTextView endEditing:YES];
}
- (void)onSubmitAction
{
//    [self.navigationController popViewControllerAnimated:YES];
    
    dispatch_queue_t network_queue;
    network_queue = dispatch_queue_create("user_leave_message", nil);
    dispatch_async(network_queue, ^{
        
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                              [[NSUserDefaults standardUserDefaults]objectForKey:USERID],@"user_id",
                              LANGUAGE_TYPE,@"lang_type",
                              showTextView.text,@"content",
                              
                              nil];
        NSString *request = [HTTPRequest requestForGetWithPramas:dict method:@"user_leave_message"];
        NSDictionary *dictionary = [JsonUtil jsonToDic:request];
        
        NSLog(@"dic==%@",dictionary);
        //turn to main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([[dictionary objectForKey:@"msg"]integerValue] == 1)
            {
                //                NSString *data =  [dictionary objectForKey:@"data"];
                //                data = [FBEncryptorDES decrypt:data keyString:@"SDFL#)@F"];
                //                data = [data URLDecodedString]
                //                NSLog(@"添加成功");
                [hud setCaption:[dictionary objectForKey:@"msgbox"]];
                [hud setActivity:NO];
                [hud show];
                hud.delegate = self;
                [hud hideAfter:1.0];
                
            }
            else
            {
                sleep(1);
                
                if ([dictionary objectForKey:@"msgbox"] != nil) {
                    [hud setCaption:[dictionary objectForKey:@"msgbox"]];
                    [hud setActivity:NO];
                    [hud show];
                    hud.delegate = nil;
                    [hud hideAfter:1.0];
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

#pragma mark hudDelegate
- (void)hudDidDisappear:(ATMHud *)_hud
{
    [self.navigationController popViewControllerAnimated:YES];
    
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
//#pragma mark keyboard notification
//
//-(void) keyboardWillShow:(NSNotification *)notification
//{
//    
//    NSDictionary*info=[notification userInfo];
//    CGSize kbSize=[[info objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue].size;
//    //
//    if (writeFeedback.isFirstResponder)
//    {
//        [writeFeedback setFrame:CGRectMake(5, SCREEN_HEIGHT - kbSize.height - 120, 310, 120)];
//    }
//    
//}
//
//-(void) keyboardWillHide:(NSNotification *)note
//{
//    if (writeFeedback.isFirstResponder)
//    {
//        [writeFeedback setFrame:CGRectMake(5, SCREEN_HEIGHT - kbSize.height - 120, 310, 120)];
//    }
//}


#pragma mark UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    return YES;
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
