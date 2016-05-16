//
//  UIActionSheet+PrivateAction.m
//  Hotel
//
//  Created by easaa on 13-1-26.
//  Copyright (c) 2013年 easaa. All rights reserved.
//

#import "UIActionSheet+PrivateAction.h"

@implementation UIActionSheet (PrivateAction)
-(void)layoutSubviews{
    [super layoutSubviews];
    NSLog(@"tag %d",self.tag);
    if (self.tag == 0 || self.tag == 1213) {
        return;
    }
    double ViewHeight = super.self.superview.frame.size.height;
    NSLog(@"%f",ViewHeight);
    if (ViewHeight == 504) {
        ViewHeight = 330;
    }else
    {
        ViewHeight = 330-80;
    }
    double NavBarHeight = 44;
    double customViewHeight = 50;
    
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, ViewHeight - customViewHeight -NavBarHeight, 320, NavBarHeight)];
    navBar.barStyle = UIBarStyleBlackOpaque;
    NSString *str = @"";
//    if (self.tag == 5) {
//        str = @"选择距离";
//    }else if(self.tag ==2)
//    {
//        str = @"选择品牌";
//    }else if(self.tag == 3)
//    {
//        str = @"选择星级范围";
//
//    }else if(self.tag == 4)
//    {
//        str = @"选择价格范围";
//    }else if(self.tag == 7)
//    {
//        str = @"选择房间数";
//    }else if(self.tag == 8)
//    {
//        str = @"选择房间保留时间";
//    }
    UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:str];
    UIButton *leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame=CGRectMake(0, 0, 55, 35);
    leftBtn.titleLabel.font=[UIFont systemFontOfSize:14];
//    [leftBtn setTitle:@"  取消" forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(docancel) forControlEvents:UIControlEventTouchUpInside];
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal ];
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"back_h"] forState:UIControlStateHighlighted];
    UIBarButtonItem *leftButton = [[[UIBarButtonItem alloc] initWithCustomView:leftBtn] autorelease];

    
    navItem.leftBarButtonItem = leftButton;
    
    UIButton *rightBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:@"确定" forState:UIControlStateNormal];
    rightBtn.titleLabel.font=[UIFont systemFontOfSize:14];
    rightBtn.frame=CGRectMake(0, 0, 55, 35);
    [rightBtn addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"top_icon02"] forState:UIControlStateNormal ];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"top_icon02_h"] forState:UIControlStateHighlighted];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
    navItem.rightBarButtonItem = rightButton;
    
    NSArray *array = [[NSArray alloc] initWithObjects:navItem, nil];
    [navItem release];
    [navBar setItems:array];
    [array release];
    [self.superview addSubview:navBar];
    [navBar release];
}

- (void) done{
    [self.delegate actionSheet:self clickedButtonAtIndex:0];
    [self dismissWithClickedButtonIndex:0 animated:YES];
    
}

- (void) docancel{
    [self.delegate actionSheet:self clickedButtonAtIndex:1];
    [self dismissWithClickedButtonIndex:1 animated:YES];
    
}
@end
