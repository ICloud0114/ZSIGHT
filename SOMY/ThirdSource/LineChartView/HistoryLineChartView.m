//
//  LineChartView.m
//
//  Created by Jackie on 14-7-21.
//  Copyright (c) 2014年 Jackie. All rights reserved.
//  Version:0.8


#import "HistoryLineChartView.h"

#import "DataLibrary.h"

@interface HistoryLineChartView()
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
    BOOL isFirstPoint;
    NSInteger scale; //刻度偏移20
    
}

@end

@implementation HistoryLineChartView

- (void) setYArrayWithMutableArray:(NSMutableArray *)array
{
    [_yArray addObjectsFromArray:array];
}
- (void) setYArrayWithDictoinary:(NSDictionary *)dict
{
    NSLog(@"%s temp:%@",__FUNCTION__, dict);
    
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
        _topPad = 100;
        _endPad = 5;
        scale = 20;
        _touchLeft = NO;
        _touchRight = NO;
        _bFah = NO;
        _yArray = [NSMutableArray array];
        
        isZero = YES;
        isFirstPoint = YES;
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
    
    if (self.dateName == nil)
    {
        self.dateName = @"";
    }
    if (self.memberName == nil)
    {
        self.memberName = @"";
    }
    if (self.topTemp == nil)
    {
        self.topTemp = @"";
    }
    UILabel *label0 = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, 250, 40)];
    [label0 setBackgroundColor:[UIColor clearColor]];
    [label0 setFont:[UIFont systemFontOfSize:24.0f]];
    [label0 setText:[NSString stringWithFormat:@"%@   %@",self.dateName,self.memberName]];
    
    [label0 setTextColor:[UIColor redColor]];
    
    [self addSubview:label0];
    
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(20, label0.frame.origin.y + label0.frame.size.height + 5, 250, 30)];
    [label1 setBackgroundColor:[UIColor clearColor]];
    [label1 setFont:[UIFont systemFontOfSize:18.0f]];
    [label1 setText:[NSString stringWithFormat:@"%@",self.topTemp]];
    
    [label1 setTextColor:[UIColor blackColor]];
    
    [self addSubview:label1];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGFloat backLineWidth = 0.05f;
    
    float x = _leftPad;
    float y = 0;
    
    vInterval = (initframe.size.height-_topPad-_endPad - 6 - scale)/4;// 34~42 每隔2度显示一个纵坐标
    hInterval = (initframe.size.width-_leftPad-_rightPad)/(4 * 6 * 60);//共显示48个点 5分钟*12*4小时
    
    // 纵坐标轴标签
    if (ISFAHRENHEIT)
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
            label.text = [NSString stringWithFormat:@"%.1f℉",((34+2*i)*1.8+32.0)];// 34~46 每隔2度显示一个纵坐标
            [self addSubview:label];
            
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
            UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(x,y, 5, 1)];
            [lineLabel setBackgroundColor:[UIColor lightGrayColor]];
            [self addSubview:lineLabel];
        }
    }
    
//    NSDateComponents *comps;
//    NSCalendar *calendar = [NSCalendar currentCalendar];
//    NSDate *nowDay = [NSDate date];
//    comps =[calendar components:(NSHourCalendarUnit |NSMinuteCalendarUnit) fromDate:nowDay];
//    _cHour = [comps hour];
//    _cMinute = [comps minute];
    
    
    // 横坐标轴标签
    x = _leftPad;
    y = initframe.size.height - _endPad;
    
    if (_touchLeft)
    {
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
    
    for (int i = 0; i < 5; i++) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(x+i*(hInterval) * 360 - 25, y, 50, 20)];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setTextColor:[UIColor lightGrayColor]];
        label.numberOfLines = 1;
        label.adjustsFontSizeToFitWidth = YES;
        //        [label.layer setBorderWidth:1.0];
        label.font = [UIFont systemFontOfSize:13.0f];
        [label setText:[NSString stringWithFormat:@"%2i:00h",6 * i]];
        [self addSubview:label];
    }
    
    {   // 横竖坐标轴
        CGContextSetLineWidth(context, 20*backLineWidth);//主线宽度
        CGContextSetStrokeColorWithColor(context, [UIColor lightGrayColor].CGColor);
        
        // 纵坐标轴
        CGContextMoveToPoint(context, x, y);
        CGContextAddLineToPoint(context,  x, _topPad-3);
        
        // 四条纵线
        CGContextMoveToPoint(context, x+(hInterval) * 360, y);
        CGContextAddLineToPoint(context,  x+(hInterval)* 360, _topPad-3);
        
        CGContextMoveToPoint(context, x+(hInterval) * 360 * 2, y);
        CGContextAddLineToPoint(context,  x+(hInterval)* 360 * 2, _topPad-3);
        
        CGContextMoveToPoint(context, x+(hInterval) * 360 * 3, y);
        CGContextAddLineToPoint(context,  x+(hInterval)* 360 * 3, _topPad-3);
        
        CGContextMoveToPoint(context, x+(hInterval) * 360 * 4, y);
        CGContextAddLineToPoint(context,  x+(hInterval) * 360 * 4, _topPad-3);
        
        // 横坐标轴
        CGContextMoveToPoint(context, x, y);
        CGContextAddLineToPoint(context,  initframe.size.width-_rightPad, y);
        
        CGContextStrokePath(context);
    }
    
    //折线
    CGContextSetLineWidth(context, 10 * backLineWidth);//主线宽度
    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
    
//    int sHour = _cHour;
//    int sMinute = _cMinute;
//    
//    int now = sHour*60+sMinute;
//    int twoHours = now - 120;
//    if (twoHours < 0)
//    {
//        twoHours += 1440;
//    }
//    
//    NSLog(@"tow hours ago minute is %d",twoHours);
//    NSString *timeStr = [NSString stringWithFormat:@"%d",twoHours];
//    NSString *temperStr = @"34.0";
//    int twoHoursIndex = 0;
    
//    int i = 0;
//    for (; i < [_yArray count]; i++)
//    {
//        if ([[_yArray[i] objectForKey:@"TIME"] isEqualToString:timeStr])
//        {
//            temperStr = [_yArray[i] objectForKey:@"TEMP"];
//            twoHoursIndex = i;
//            break;
//        }
//    }
//    
//    if (i == [_yArray count])
//    {
//        twoHoursIndex = 0;
//        temperStr = @"34.0";
//    }
    
    x = (int)_leftPad;
    y = initframe.size.height-_endPad;
    
    if (0)//_touchRight || _touchLeft)
    {
        _touchLeft = NO;
        _touchRight = NO;
        
        NSInteger num = 2*60;
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
                    y = initframe.size.height-_endPad-([[obj objectForKey:@"TEMP"] integerValue] - 340)/10.0/8.0*(initframe.size.height-_topPad-_endPad);
                    break;
                }
                
                x = _leftPad + hInterval*j;
            }
            CGContextAddLineToPoint(context, x, y);
        }
    }
    else
    {
        //        hInterval = 0.89;
        
        for (int i = 0; i < 24 * 60; i++)
        {
            int j = 0;
        
            for (; j < [_yArray count]; j++)
            {
                
//                if (j == [_yArray count] - 1)
//                {
                    if ([[_yArray[j] objectForKey:@"TIME"] isEqualToString:[NSString stringWithFormat:@"%d",i]])
                    {
//                        isFirstPoint = YES;
                        
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
//                }
//                else if ([[_yArray[j] objectForKey:@"TIME"]integerValue] == [[_yArray[j + 1] objectForKey:@"TIME"]integerValue] - 1)
//                {
//                    if ([[_yArray[j] objectForKey:@"TIME"] isEqualToString:[NSString stringWithFormat:@"%d",i]])
//                    {
//                        if ([[_yArray[j]objectForKey:@"TEMP"]integerValue] <= 340)
//                        {
//                            isZero = YES;
//                            break;
//                        }
//                        else if ([[_yArray[j]objectForKey:@"TEMP"]integerValue] >= 420)
//                        {
//                            y = initframe.size.height-_endPad-(420 - 340)/80.0*(initframe.size.height-_topPad-_endPad);
//                            if (isZero)
//                            {
//                                CGContextMoveToPoint(context, x,y);
//                                isZero = NO;
//                                break;
//                            }
//                            
//                            CGContextAddLineToPoint(context, x, y);
//
//                        }
//                        else
//                        {
//                            y = initframe.size.height-_endPad-([[_yArray[j] objectForKey:@"TEMP"] integerValue] -340)/80.0*(initframe.size.height-_topPad-_endPad);
//                            if (isZero)
//                            {
//                                CGContextMoveToPoint(context, x,y);
//                                isZero = NO;
//                                break;
//                            }
//                            
//                            CGContextAddLineToPoint(context, x, y);
//
//                        }
//                        
//                        //                    CGContextAddLineToPoint(context, x, y);
//                        break;
//                    }
//               
//                }
//                else
//                {
//                    if ([[_yArray[j] objectForKey:@"TIME"] isEqualToString:[NSString stringWithFormat:@"%d",i]])
//                    {
//                        if ([[_yArray[j]objectForKey:@"TEMP"]integerValue] <= 340)
//                        {
//                            isZero = YES;
//                            break;
//                        }
//                        else if ([[_yArray[j]objectForKey:@"TEMP"]integerValue] >= 420)
//                        {
//                            y = initframe.size.height-_endPad-(420 - 340)/80.0*(initframe.size.height-_topPad-_endPad);
//                            if (isZero)
//                            {
//                                CGContextMoveToPoint(context, x,y);
//                                isZero = YES;
//                                break;
//                            }
//                            
//                            CGContextAddLineToPoint(context, x, y);
//                            
//                        }
//                        else
//                        {
//                            y = initframe.size.height-_endPad-([[_yArray[j] objectForKey:@"TEMP"] integerValue] -340)/80.0 * (initframe.size.height-_topPad-_endPad);
//                            if (isZero)
//                            {
//                                CGContextMoveToPoint(context, x,y);
//                                isZero = YES;
//                                break;
//                            }
//                            CGContextAddLineToPoint(context, x, y);
//                            
//                        }
//                        
//                        //                    CGContextAddLineToPoint(context, x, y);
//                        isZero = YES;
//                        break;
//                    }
//                }
                
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

@end
