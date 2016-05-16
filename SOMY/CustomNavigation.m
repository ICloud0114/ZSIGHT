//
//  CustomNavigation.m
//  ReporterClient
//
//  Created by smile on 14-4-14.
//  Copyright (c) 2014年 easaa. All rights reserved.
//

#import "CustomNavigation.h"

@implementation CustomNavigation

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _backgroundImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [self addSubview:_backgroundImageView];
        [_backgroundImageView setImage:[UIImage imageNamed:@"top.png"]];
        
        _backgroundImageView.backgroundColor = [UIColor whiteColor];
        
        _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leftButton setFrame:CGRectMake(0, 0, 40, 44)];
//        [_leftButton setBackgroundColor:[UIColor redColor]];
        [self addSubview:_leftButton];
        _leftButton.hidden = YES;
        [_leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_leftButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
//        [_leftButton setBackgroundImage:[UIImage imageNamed:@"quxiao.png"] forState:UIControlStateNormal];
//        [_leftButton setBackgroundImage:[UIImage imageNamed:@"quxiao.png"] forState:UIControlStateHighlighted];
        UIImageView *leftImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 12, 20, 20)];
        [leftImage setImage:[UIImage imageNamed:@"quxiao.png"]];
        [_leftButton addSubview:leftImage];
        
        _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addButton setFrame:CGRectMake(self.frame.size.width - 40, 0, 40, 44)];
        [self addSubview:_addButton];
        _addButton.hidden = YES;
        [_addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_addButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
//        [_addButton setBackgroundImage:[UIImage imageNamed:@"liebiaotianjia.png"] forState:UIControlStateNormal];
//        [_addButton setBackgroundImage:[UIImage imageNamed:@"liebiaotianjia.png"] forState:UIControlStateHighlighted];
        UIImageView *addImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 12, 20, 20)];
        [addImage setImage:[UIImage imageNamed:@"liebiaotianjia.png"]];
        [_addButton addSubview:addImage];
        
        _submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_submitButton setFrame:CGRectMake(self.frame.size.width - 85  , 0, 85, 44)];
        [self addSubview:_submitButton];
        _submitButton.hidden = YES;
        [_submitButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_submitButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [_submitButton setTitle:DPLocalizedString(@"Complete") forState:UIControlStateNormal];
        
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 7, 200, 30)];
        [self addSubview:_titleLabel];
        [_titleLabel setTextAlignment:NSTextAlignmentCenter];
        [_titleLabel setBackgroundColor:[UIColor clearColor]];
        [_titleLabel setTextColor:[UIColor colorwithHexString:@"#3f3f3f"]];
        [_titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
        
        UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 43.5f, 320, 0.5)];
        [lineLabel setBackgroundColor:[UIColor colorWithRed:101/255.0f green:141/255.0f blue:137/255.0f alpha:1.0f]];
        [self addSubview:lineLabel];
        
    
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
