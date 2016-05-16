//
//  CircleView.h
//
//  Created by Jackie on 14-7-21.
//  Copyright (c) 2014年 Jackie. All rights reserved.
//  Version:1.0
//

#import <UIKit/UIKit.h>

@interface CircleView : UIView

@property (nonatomic, assign) CGFloat currentTemp;
@property (nonatomic, assign) CGFloat warnTemp;
@property (nonatomic, assign) BOOL    disabel375;       // 当温度超过 37.5时屏蔽37.5的警告
@property (nonatomic, assign) BOOL    disabel385;       // 当温度超过 38.5时屏蔽38.5的警告
@property (nonatomic, assign) BOOL    disabel395;       // 当温度超过 39.5时屏蔽39.5的警告
@property (nonatomic, assign) BOOL    bFah;             // 华氏温度显示标志
@property (nonatomic, assign) BOOL    manualWarnTemp;   // yes 不显示 小图标， no 显示小图标
- (id)initWithFrame:(CGRect)frame temperature:(CGFloat)temp;
@end
