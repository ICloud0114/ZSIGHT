//
//  LineChartView.m
//
//  Created by Jackie on 14-7-21.
//  Copyright (c) 2014年 Jackie. All rights reserved.
//  Version:0.8


#import "LineChartView.h"

#import "DataLibrary.h"

@interface LineChartView()
{
    CGRect initframe;
    CGFloat hInterval,vInterval;

    CGPoint _contentScroll;
    float  _pointerInterval;
    NSArray *_xAxisValues;
    BOOL    _touchLeft;
    BOOL    _touchRight;
    NSInteger _cHour;
    NSInteger _cMinute;
    NSMutableArray *_testArr;
    
    NSInteger _startTime;
    DataLibrary *dataLib;
    
    BOOL isZero;
    NSInteger scale; //刻度偏移
}

@end

@implementation LineChartView


- (void) setYArrayWithDictoinary:(NSDictionary *)dict
{
    NSLog(@"%s temp:%@",__FUNCTION__, dict);
    
    
    isZero = YES;
    
    if ([_yArray count])
    {
        if ([_yArray count] == 1560)
        {
            [_yArray removeAllObjects];
        }
        else
        {
            if ([[[_yArray lastObject]objectForKey:@"TIME"] isEqualToString:[dict objectForKey:@"TIME"]])
            {
                NSLog(@"%@",[[_yArray lastObject]objectForKey:@"TIME"]);
                [_yArray removeLastObject];
            }
        }
        
        
    }
    [_yArray addObject: dict];
    
    [self setNeedsDisplay];
    
    NSLog(@"%@",_yArray);
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor whiteColor];
    
    initframe = frame;
    if (self) {
        //默认值
        _leftPad = 50;
        _rightPad = 20;
        _topPad = 50;
        _endPad = 20;
        
        scale = 10;
        
        _touchLeft = NO;
        _touchRight = NO;
        _bFah = NO;
        
        isZero = YES;
        dataLib = [DataLibrary shareDataLibrary];
        
        _yArray = [[NSMutableArray alloc]initWithArray:[dataLib getAllDataByToday]];
    }

    return self;
}

- (void)drawRect:(CGRect)rect
{
    
    [self setClearsContextBeforeDrawing: YES];
    //remove subviews
    NSArray *views = [self subviews];
    for(UIView* view in views)
    {
        [view removeFromSuperview];
    }
    UILabel *remindLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 10, 160, 20)];
    [remindLabel setFont:[UIFont systemFontOfSize:12]];
    [remindLabel setBackgroundColor:[UIColor clearColor]];
    [remindLabel setTextColor:[UIColor grayColor]];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"selectDevice"])
    {
        NSString *string = [self hexStringFromString:[[NSUserDefaults standardUserDefaults] objectForKey:@"uuid"]];
        [remindLabel setText:[NSString stringWithFormat:@"%@:%@",DPLocalizedString(@"device number"),string]];
    }
    else
    {
        [remindLabel setText:DPLocalizedString(@"scan device")];
    }
    [self addSubview:remindLabel];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"warnTemperature"])
    {
        UILabel *warnLabel = [[UILabel alloc]initWithFrame:CGRectMake(remindLabel.frame.origin.x + remindLabel.frame.size.width, 10, 150, 20)];
        [warnLabel setTextAlignment:NSTextAlignmentRight];
        [warnLabel setFont:[UIFont systemFontOfSize:12]];
        [warnLabel setBackgroundColor:[UIColor clearColor]];
        [warnLabel setTextColor:[UIColor redColor]];
        if (ISFAHRENHEIT)
        {
            [warnLabel setText:[NSString stringWithFormat:@"%@ %@˚F",DPLocalizedString(@"Warning temperature :"),[[NSUserDefaults standardUserDefaults] objectForKey:@"warnTemperature"]]];
        }
        else
        {
            [warnLabel setText:[NSString stringWithFormat:@"%@ %@˚C",DPLocalizedString(@"Warning temperature :"),[[NSUserDefaults standardUserDefaults] objectForKey:@"warnTemperature"]]];
        }
        [self addSubview:warnLabel];
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGFloat backLineWidth = 0.05f;

    float x = _leftPad;
    float y = 0;
    
    vInterval = (initframe.size.height-_topPad-_endPad - scale)/4;// 34~42 每隔2度显示一个纵坐标
    hInterval = (initframe.size.width-_leftPad-_rightPad)/(4*60);//共显示48个点 5分钟*12*4小时
    
    // 纵坐标轴标签
    if (_bFah)
    {
        for (int i=0; i<=4; i++)
        {
            y = initframe.size.height - _endPad - (i * vInterval);
            
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(x-50,y-13, 45, 20)];//x 减22，y减10是为了字符减去字符宽高。
            [label setBackgroundColor:[UIColor clearColor]];
            [label setTextColor:[UIColor lightGrayColor]];
            label.numberOfLines = 1;
            label.textAlignment = NSTextAlignmentRight;
            label.adjustsFontSizeToFitWidth = YES;
            label.font = [UIFont systemFontOfSize:12.f];
//            [label.layer setBorderWidth:1.0];
            label.text = [NSString stringWithFormat:@"%.1f℉",((34+2 * i)*1.8+32.0)];// 34~46 每隔2度显示一个纵坐标
            [self addSubview:label];
            
//          刻度
            UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(x,y, 5, 1)];
            [lineLabel setBackgroundColor:[UIColor lightGrayColor]];
            [self addSubview:lineLabel];

        }
    }
    else
    {
        for (int i = 0; i<=4; i++)
        {
            y = initframe.size.height - _endPad - (i*vInterval);
            
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(x-45,y-13, 40, 20)];//x 减22，y减10是为了字符减去字符宽高。
            [label setBackgroundColor:[UIColor clearColor]];
            [label setTextColor:[UIColor lightGrayColor]];
            label.numberOfLines = 1;
            label.textAlignment = NSTextAlignmentRight;
            label.adjustsFontSizeToFitWidth = YES;
            label.font = [UIFont systemFontOfSize:13.f];
//            [label.layer setBorderWidth:1.0];
            label.text = [NSString stringWithFormat:@"%d℃",34+2*i];// 34~42 每隔2度显示一个纵坐标
            [self addSubview:label];
            
//          刻度
            UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(x,y, 5, 1)];
            [lineLabel setBackgroundColor:[UIColor lightGrayColor]];
            [self addSubview:lineLabel];
        }
    }
    
    NSDateComponents *comps;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *nowDay = [NSDate date];
    comps =[calendar components:(NSHourCalendarUnit |NSMinuteCalendarUnit) fromDate:nowDay];
    _cHour = [comps hour];
    _cMinute = [comps minute];
    
    
    // 横坐标轴标签
    x = _leftPad;
    y = initframe.size.height - _endPad;
    
    if (_touchLeft) {
        _startTime = _startTime - 4;
    }
    else if (_touchRight)
    {
        _startTime = _startTime + 4;
        if (_startTime > _cHour -2) {
            _startTime = _cHour -2;
        }
    }
    else
    {
        _startTime = (_cHour-2);
    }

    for (int i = 0; i < 5; i++)
    {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(x+i*(hInterval)*60-15, y, 50, 20)];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setTextColor:[UIColor lightGrayColor]];
        label.numberOfLines = 1;
        label.adjustsFontSizeToFitWidth = YES;
//        [label.layer setBorderWidth:1.0];
        label.font = [UIFont systemFontOfSize:13.f];
        [label setText:[NSString stringWithFormat:@"%2li:%02lih",(_startTime+i)<0?((_startTime+i)+24):(_startTime+i),(long)_cMinute]];
        [self addSubview:label];
    }
    
    {   // 横竖坐标轴
        CGContextSetLineWidth(context, 20 * backLineWidth);//主线宽度
        CGContextSetStrokeColorWithColor(context, [UIColor lightGrayColor].CGColor);
        
        // 纵坐标轴
        CGContextMoveToPoint(context, x, y);
        CGContextAddLineToPoint(context,  x, _topPad-3);
        
        // 四条纵线
        CGContextMoveToPoint(context, x+(hInterval)*60, y);
        CGContextAddLineToPoint(context,  x+(hInterval)*60, _topPad-3);
        
        CGContextMoveToPoint(context, x+(hInterval)*120, y);
        CGContextAddLineToPoint(context,  x+(hInterval)*120, _topPad-3);
        
        CGContextMoveToPoint(context, x+(hInterval)*180, y);
        CGContextAddLineToPoint(context,  x+(hInterval)*180, _topPad-3);
        
        CGContextMoveToPoint(context, x+(hInterval)*240, y);
        CGContextAddLineToPoint(context,  x+(hInterval)*240, _topPad-3);
        
        // 横坐标轴
        CGContextMoveToPoint(context, x, y);
        CGContextAddLineToPoint(context,  initframe.size.width-_rightPad, y);
        
        CGContextStrokePath(context);
    }
    
    //折线
    CGContextSetLineWidth(context, 20 * backLineWidth);//主线宽度
    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
    
    NSInteger sHour = _cHour;
    NSInteger sMinute = _cMinute;

    NSInteger now = sHour * 60+sMinute;
    NSInteger twoHours = now - 120;
    if (twoHours < 0)
    {
        twoHours += 1440;
    }
    
    NSLog(@"tow hours ago minute is %ld",(long)twoHours);
    NSString *timeStr = [NSString stringWithFormat:@"%ld",(long)twoHours];
    NSString *temperStr = @"0.0";
    int twoHoursIndex = 0;
    
    int i = 0;
    for (; i < [_yArray count]; i++)
    {
        if ([[_yArray[i] objectForKey:@"TIME"] isEqualToString:timeStr]) {
            temperStr = [_yArray[i] objectForKey:@"TEMP"];
            twoHoursIndex = i;
            break;
        }
    }
    
    if (i == [_yArray count])
    {
        twoHoursIndex = 0;
        temperStr = @"0.0";
    }
    
    x = (int)_leftPad;
    y = initframe.size.height - _endPad;

    if (0)//_touchRight || _touchLeft)
    {
        _touchLeft = NO;
        _touchRight = NO;
        
        NSInteger num = 2 * 60;
        if (_startTime >= _cHour-2) {
            num = 24 - (_startTime - _cHour +2)*12;
        }
        
        for (int j = 0; j < num; j++)
        {
            CGContextMoveToPoint(context, x,y);
            for (id obj in _yArray)
            {
//                if ([[obj objectForKey:@"TIME"] integerValue] == (_startTime*60+_cMinute-(_cMinute%5)+j*5))
                if ([[obj objectForKey:@"TIME"] integerValue] == (_startTime * 60 + _cMinute + j))
                {
                    y = initframe.size.height-_endPad-([[obj objectForKey:@"TEMP"] integerValue] - 340)/10.0 / 8.0 * (initframe.size.height-_topPad-_endPad);
                    break;
                }
                
                x = _leftPad + hInterval*j;
            }
            CGContextAddLineToPoint(context, x, y);
        }
    }
    else
    {
////        hInterval = 0.89;
//        y = initframe.size.height-_endPad-([[_yArray[0] objectForKey:@"TEMP"] integerValue] - 340)/10.0/8.0*(initframe.size.height-_topPad-_endPad);
        
        for (int i = 1; i < 2 * 60; i++)
        {
            int j = 0;
            for (; j < [_yArray count]; j++)
            {
                NSInteger whichTime;
                if (twoHours + i >=1440)
                {
                    whichTime = twoHours + i - 1440;
                }
                else
                {
                    whichTime = twoHours + i;
                }
                
                
                if ([[_yArray[j] objectForKey:@"TIME"] isEqualToString:[NSString stringWithFormat:@"%ld",(long)whichTime]])
                {
                    
//                    if (j == [_yArray count] - 1)
//                    {
                        if ([[_yArray[j]objectForKey:@"TEMP"]integerValue] <= 340)
                        {
                            y = initframe.size.height-_endPad-(340 - 340) / 80.0 * (initframe.size.height - _topPad - _endPad - scale);
                            if (isZero)
                            {
                                CGContextMoveToPoint(context, x,y);
                                isZero = NO;
                                break;
                            }
                            
                            CGContextAddLineToPoint(context, x, y);
                        }
                        else if ([[_yArray[j]objectForKey:@"TEMP"]integerValue] >= 420)
                        {
                            y = initframe.size.height-_endPad-(340 - 340) / 80.0 * (initframe.size.height - _topPad - _endPad - scale);
                            if (isZero)
                            {
                                CGContextMoveToPoint(context, x,y);
                                isZero = NO;
                                break;
                            }
                            
                            CGContextAddLineToPoint(context, x, y);
                        }
                        else
                        {
                            y = initframe.size.height-_endPad-([[_yArray[j] objectForKey:@"TEMP"] integerValue] - 340) / 80.0 * (initframe.size.height - _topPad - _endPad - scale);
                            if (isZero)
                            {
                                CGContextMoveToPoint(context, x,y);
                                isZero = NO;
                                break;
                            }
                            
                            CGContextAddLineToPoint(context, x, y);
                        }
//                    }
//                    else if ([[_yArray[j] objectForKey:@"TIME"]integerValue] == [[_yArray[j + 1] objectForKey:@"TIME"]integerValue] - 1)
//                    {
//                        if ([[_yArray[j]objectForKey:@"TEMP"]integerValue] <= 340)
//                        {
//                            
//                            //                        CGContextMoveToPoint(context, x,y);
//                            //                        CGContextAddLineToPoint(context, x, y);
//                            isZero = YES;
//                            //                        CGContextSetStrokeColorWithColor(context, [UIColor purpleColor].CGColor);
//                            break;
//                        }
//                        else if ([[_yArray[j]objectForKey:@"TEMP"]integerValue] >= 420)
//                        {
//                            y = initframe.size.height-_endPad-(420 - 340)/10.0/8.0 * (initframe.size.height-_topPad-_endPad);
//                            if (isZero)
//                            {
//                                CGContextMoveToPoint(context, x,y);
//                                isZero = NO;
//                                break;
//                            }
//                            
//                            CGContextAddLineToPoint(context, x, y);
//                        }
//                        else
//                        {
//                            y = initframe.size.height-_endPad-([[_yArray[j] objectForKey:@"TEMP"] integerValue] - 340)/10.0/8.0*(initframe.size.height-_topPad-_endPad);
//                            if (isZero)
//                            {
//                                CGContextMoveToPoint(context, x,y);
//                                isZero = NO;
//                                break;
//                            }
//                            CGContextAddLineToPoint(context, x, y);
//                        }
//
//                    }
//                    else
//                    {
//                        if ([[_yArray[j]objectForKey:@"TEMP"]integerValue] <= 340)
//                        {
//
//                            isZero = YES;
//                            break;
//                        }
//                        else if ([[_yArray[j]objectForKey:@"TEMP"]integerValue] >= 420)
//                        {
//                            y = initframe.size.height-_endPad-(420 - 340)/10.0/8.0 * (initframe.size.height-_topPad-_endPad);
//                            if (isZero)
//                            {
//                                CGContextMoveToPoint(context, x,y);
//                                isZero = YES;
//                                break;
//                            }
//                            
//                            CGContextAddLineToPoint(context, x, y);
//                        }
//                        else
//                        {
//                            y = initframe.size.height-_endPad-([[_yArray[j] objectForKey:@"TEMP"] integerValue] - 340)/10.0/8.0*(initframe.size.height-_topPad-_endPad);
//                            if (isZero)
//                            {
//                                CGContextMoveToPoint(context, x,y);
//                                isZero = YES;
//                                break;
//                            }
//                            CGContextAddLineToPoint(context, x, y);
//                        }
//                        isZero = YES;
//                        
//                    }
                    
                    isZero = NO;
                    break;
                }
                else
                {
                    if (j == [_yArray count] - 1)
                    {
                        y = initframe.size.height - _endPad;
                        CGContextMoveToPoint(context, x,y);
                        isZero = YES;
                        break;
                        
                    }
                }
            }
            
            
            
            x += hInterval;
        }
    }
    CGContextStrokePath(context);
}

//- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    _contentScroll=[[touches anyObject] locationInView:self];
//    NSLog(@"begin point x=%f,y=%f",_contentScroll.x,_contentScroll.y);
//}
//
////-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
////{
////    CGPoint touchLocation=[[touches anyObject] locationInView:self];
////    CGPoint prevouseLocation=[[touches anyObject] previousLocationInView:self];
////    float xDiffrance=touchLocation.x-prevouseLocation.x;
////    float yDiffrance=touchLocation.y-prevouseLocation.y;
////    
////    _contentScroll.x+=xDiffrance;
////    _contentScroll.y+=yDiffrance;
////    
////    if (_contentScroll.x < 0) {
////        _contentScroll.x=0;
////    }
////    else
////    {
////        _touched = YES;
////    }
////
////    
////    [self setNeedsDisplay];
////}
//
//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    CGPoint touchLocation=[[touches anyObject] locationInView:self];
//    if (touchLocation.x - _contentScroll.x > 100) {
//        _touchLeft = YES;
//        [self setNeedsDisplay];
//    }
//    
//    if (_contentScroll.x - touchLocation.x > 100)
//    {
//        _touchRight = YES;
//        [self setNeedsDisplay];
//    }
//    
//    NSLog(@"end point x=%f,y=%f",touchLocation.x,touchLocation.y);
//    
//}

//
//- (NSInteger) calcTotalPotDisplay
//{
//
//}
#pragma mark 将二进制字符串转成十进制 8位字符串
- (NSString *)hexStringFromString:(NSString *)string
{
    NSInteger num = 0;
    NSInteger count = 0;
    
    for(int i = 0; i < string.length ; i++)
    {
        NSString *a = [string substringWithRange:NSMakeRange(i, 1)];
        if ([a isEqualToString:@"a"])
        {
            num = 10;
        }
        else if([a isEqualToString:@"b"])
        {
            num = 11;
        }
        else if([a isEqualToString:@"c"])
        {
            num = 12;
        }
        else if([a isEqualToString:@"d"])
        {
            num = 13;
        }
        else if([a isEqualToString:@"e"])
        {
            num = 14;
        }
        else if([a isEqualToString:@"f"])
        {
            num = 15;
        }
        else
        {
            num = [a integerValue];
        }
        NSInteger m = 1;
        for (int j = 0; j < string.length - 1 - i;j++)
        {
            m *= 16;
        }
        count += num *m;
    }
    //不足八位补 0
    NSString *myString = [NSString stringWithFormat:@"%d",count];
    NSString *preString = @"";
    for (int i = 0; i < 8 - myString.length; i ++)
    {
        preString = [preString stringByAppendingString:@"0"];
    }
    myString = [preString stringByAppendingString:myString];
    return myString;
}
@end
