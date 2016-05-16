//
//  LineChartView.h
//
//  Created by Jackie on 14-7-21.
//  Copyright (c) 2014年 Jackie. All rights reserved.
//  Version:0.8

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface LineChartView : UIView

// 横竖轴显示标签
@property (nonatomic, strong) NSMutableArray *hDesc;
@property (nonatomic, strong) NSMutableArray *vDesc;

// 点信息
@property (nonatomic, strong) NSMutableArray *yArray;

// 上下左右margin
@property (nonatomic, assign) NSInteger leftPad;
@property (nonatomic, assign) NSInteger rightPad;
@property (nonatomic, assign) NSInteger topPad;
@property (nonatomic, assign) NSInteger endPad;

@property (nonatomic, assign) BOOL      bFah;             // 华氏温度显示标志


- (void) setYArrayWithDictoinary:(NSDictionary *)dict;
@end
