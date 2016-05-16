//
//  CircleView.m
//
//  Created by Jackie on 14-7-21.
//  Copyright (c) 2014年 Jackie. All rights reserved.
//  Version:1.0

#import "CircleView.h"
#import <AVFoundation/AVFoundation.h>
@interface CircleView()
{
    UIImageView *_circleShape;
    BOOL        _bWarning;
    CGPoint     _beginPoint;
    CGPoint     _targetPoint;
    CGFloat     _angle;
    UIImageView *_targetView;
    BOOL        _bmoveEnable;
    double      _t2;
    double      _t1;
    double      _t3;
    BOOL        _jumpPoint;
    UILabel     *_temperatureLabel;
    UILabel     *remindLabel;
    BOOL        _touchedTempTarget;

    AVAudioPlayer *audioPlayer;
}

@end

@implementation CircleView

- (id)initWithFrame:(CGRect)frame temperature:(CGFloat)temp
{
    self = [super initWithFrame:frame];
    
    _currentTemp = temp;
    _warnTemp = 37.5;
    _bWarning = NO;
    _bmoveEnable = NO;
    _t2 = 0;
    _t1 = 0;
    _jumpPoint = NO;
    _disabel375 = NO;
    _disabel385 = NO;
    _disabel395 = NO;
    _touchedTempTarget = NO;
    _bFah = NO;
    _angle = 0;
    
    [self setBackgroundColor:[UIColor colorWithRed:145.0/255.0 green:203.0/255.0 blue:196.0/255.0 alpha:1]];
    
    _angle = -M_PI*0.35;
    _targetPoint = CGPointMake(frame.size.width*0.135, frame.size.height*0.388);
    if (iPhone5)
    {
        _targetPoint = CGPointMake(self.frame.size.width*0.136, self.frame.size.height*0.415);
    }

    return self;
}

- (void)setBFah:(BOOL)bFah
{
    _bFah = bFah;
    [self setNeedsDisplay];
}

- (void) setWarnTemp:(CGFloat)warnTemp
{
    _warnTemp = warnTemp;
    [self setNeedsDisplay];
    
}

- (void)setCurrentTemp:(CGFloat)currentTemp
{
    _currentTemp = currentTemp;
    [self setNeedsDisplay];
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
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (_currentTemp > _warnTemp)
    {
        _bWarning = YES;
        CGContextSetFillColorWithColor(context, [UIColor colorWithRed:0xff/255.0 green:0x34/255.0 blue:0x41/255.0 alpha:1.0].CGColor);
        
        NSString *main_ring_dir_path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Ring.bundle"];
        NSString *ring_path = [main_ring_dir_path stringByAppendingPathComponent:@"nice.mp3"];
        NSURL *url = [[NSURL alloc]initWithString:ring_path];
        if (![[NSUserDefaults standardUserDefaults]objectForKey:@"OpenAlarm"])
        {
            if (audioPlayer)
            {
                [audioPlayer stop];
            }
            else
            {
                audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
            }
            [audioPlayer setNumberOfLoops:1]; // 设置为-1可以实现无限循环播放
            [audioPlayer setPan:1.0f];    // 设置左右声道
            [audioPlayer prepareToPlay];  // 准备数据，播放前必须设置
            
            [self performSelector:@selector(palyAction) withObject:nil afterDelay:0.1f];
        }
        
    }
    else
    {
        _bWarning = NO;
        CGContextSetFillColorWithColor(context, [UIColor colorWithRed:145.0/255.0 green:203.0/255.0 blue:196.0/255.0 alpha:1].CGColor);
    }
    
//    if (_touchedTempTarget == NO)
//    {
//        if (_currentTemp < 37.5)
//        {
//            _warnTemp = 37.5;
//            _disabel375 = NO;
//            _disabel385 = NO;
//            _disabel395 = NO;
//        }
//        else if (_currentTemp >=37.5 && _currentTemp < 38.5)
//        {
//            if (_disabel375)
//            {
//                _warnTemp = 38.5;
//            }
//            else
//            {
//                _warnTemp = 37.5;
//            }
//            _disabel385 = NO;
//            _disabel395 = NO;
//        }
//        else if (_currentTemp >=38.5 && _currentTemp < 39.5)
//        {
//            _warnTemp = 39.5;
//            if (!_disabel385) {
//                if (!_disabel375) {
//                    _warnTemp = 37.5;
//                }
//                else
//                {
//                    _warnTemp = 38.5;
//                }
//            }
//            _disabel395 = NO;
//        }
//        else if (_currentTemp >= 39.5)
//        {
//            _warnTemp = 39.5;
//        }
//    }

    CGContextFillRect(context, rect);
    
    // 外框图
    _circleShape = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"wenduji.png"]];
    [_circleShape setFrame:CGRectMake(0, rect.size.width*0.08, _circleShape.image.size.width*0.6, _circleShape.image.size.height*0.6)];
    [_circleShape setCenter:CGPointMake(rect.size.width*0.5, rect.size.height*0.53)];
    
    // 温度计里面的芯的颜色
    UIBezierPath *path0 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(_circleShape.bounds.size.width*0.5, _circleShape.bounds.size.width*0.5)
                                                         radius:97.f
                                                     startAngle:M_PI*12.0/16.0
                                                       endAngle:M_PI*36.98/16.0
                                                      clockwise:YES];
    
    CAShapeLayer *layer0 = [CAShapeLayer layer];
    layer0.frame         = self.bounds;                // 与showView的frame一致
    layer0.strokeColor   = [UIColor colorWithRed:0xd5/255.0 green:0xf3/255.0 blue:0xee/255.0 alpha:1].CGColor;   // 边缘线的颜色//#D5F3EE
    layer0.fillColor     = [UIColor clearColor].CGColor;   // 闭环填充的颜色
    layer0.lineCap       = kCALineCapRound;               // 边缘线的类型
    layer0.path          = path0.CGPath;                    // 从贝塞尔曲线获取到形状
    layer0.lineWidth     = 3.0f;                           // 线条宽度
    layer0.strokeStart   = 0.0f;
    layer0.strokeEnd     = 1.0f;
    
    // 小原点图
    UIImageView *pointView = [[UIImageView alloc]init];
    if (_bWarning) {
        [pointView setImage:[UIImage imageNamed:@"wendujihongyuan.png"]];
    }
    else
    {
        [pointView setImage:[UIImage imageNamed:@"wendujiyuan.png"]];
    }
    [pointView setFrame:CGRectMake(0, 0, pointView.image.size.width*0.6, pointView.image.size.height*0.6)];
    [pointView setCenter:CGPointMake(_circleShape.bounds.size.width*0.2, _circleShape.bounds.size.height*0.915)];
    
    // 标示文字label 37.5
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, _circleShape.bounds.size.height*0.4, 25, 12)];

    if (_bFah)
    {
        [label1 setText:@"99.5"];
    }
    else
    {
        [label1 setText:@"37.5"];
    }

    [label1 setFont:[UIFont systemFontOfSize:9.0]];
    [label1 setTextColor:[UIColor redColor]];
    [label1 setBackgroundColor:[UIColor clearColor]];
    [label1 setTextAlignment:NSTextAlignmentCenter];
    CGAffineTransform transform = CGAffineTransformMakeRotation(-0.4*M_PI);
    label1.transform = CGAffineTransformScale(transform, 1, 1);
    
    
    // 贝塞尔曲线(短直线，用于指示文字位置)
    UIBezierPath *path1 = [UIBezierPath bezierPath];
    [path1 moveToPoint:CGPointMake(3, _circleShape.bounds.size.height*0.41)];
    [path1 addLineToPoint:CGPointMake(8, _circleShape.bounds.size.height*0.41+2.0)];

    CAShapeLayer *layer1 = [CAShapeLayer layer];
    layer1.frame         = self.bounds;                // 与showView的frame一致
    layer1.strokeColor   = [UIColor blueColor].CGColor;;   // 边缘线的颜色
    layer1.fillColor     = [UIColor clearColor].CGColor;   // 闭环填充的颜色
    layer1.lineCap       = kCALineCapRound;               // 边缘线的类型
    layer1.path          = path1.CGPath;                    // 从贝塞尔曲线获取到形状
    layer1.lineWidth     = 0.2f;                           // 线条宽度
    layer1.strokeStart   = 0.0f;
    layer1.strokeEnd     = 1.0f;
    
    // 标示文字label 38.5
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(_circleShape.bounds.size.width*0.44, 3, 25, 12)];
    
    if (_bFah)
    {
        [label2 setText:@"101.3"];
    }
    else
    {
        [label2 setText:@"38.5"];
    }
    
    [label2 setFont:[UIFont systemFontOfSize:9.0]];
    [label2 setTextColor:[UIColor redColor]];
    [label2 setBackgroundColor:[UIColor clearColor]];
    [label2 setTextAlignment:NSTextAlignmentCenter];
    
    // 贝塞尔曲线(短直线，用于指示文字位置)
    UIBezierPath *path2 = [UIBezierPath bezierPath];
    [path2 moveToPoint:CGPointMake(_circleShape.bounds.size.width*0.5, 0)];
    [path2 addLineToPoint:CGPointMake(_circleShape.bounds.size.width*0.5,5)];
    
    CAShapeLayer *layer2 = [CAShapeLayer layer];
    layer2.frame         = self.bounds;                // 与showView的frame一致
    layer2.strokeColor   = [UIColor blueColor].CGColor;;   // 边缘线的颜色
    layer2.fillColor     = [UIColor clearColor].CGColor;   // 闭环填充的颜色
    layer2.lineCap       = kCALineCapRound;               // 边缘线的类型
    layer2.path          = path2.CGPath;                    // 从贝塞尔曲线获取到形状
    layer2.lineWidth     = 0.2f;                           // 线条宽度
    layer2.strokeStart   = 0.0f;
    layer2.strokeEnd     = 1.0f;
    
    // 标示文字label 39.5
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(_circleShape.bounds.size.width*0.885, _circleShape.bounds.size.height*0.4, 25, 12)];
    
    if (_bFah)
    {
        [label3 setText:@"103.1"];
    }
    else
    {
        [label3 setText:@"39.5"];
    }

    [label3 setFont:[UIFont systemFontOfSize:9.0]];
    [label3 setTextColor:[UIColor redColor]];
    [label3 setBackgroundColor:[UIColor clearColor]];
    [label3 setTextAlignment:NSTextAlignmentCenter];
    CGAffineTransform transform1 = CGAffineTransformMakeRotation(0.4*M_PI);
    label3.transform = CGAffineTransformScale(transform1, 1, 1);
    
    
    // 贝塞尔曲线(短直线，用于指示文字位置)
    UIBezierPath *path3 = [UIBezierPath bezierPath];
    [path3 moveToPoint:CGPointMake(_circleShape.bounds.size.width-3, _circleShape.bounds.size.height*0.41)];
    [path3 addLineToPoint:CGPointMake(_circleShape.bounds.size.width-8,_circleShape.bounds.size.height*0.41+2.0)];
    
    CAShapeLayer *layer3 = [CAShapeLayer layer];
    layer3.frame         = self.bounds;                // 与showView的frame一致
    layer3.strokeColor   = [UIColor blueColor].CGColor;;   // 边缘线的颜色
    layer3.fillColor     = [UIColor clearColor].CGColor;   // 闭环填充的颜色
    layer3.lineCap       = kCALineCapRound;               // 边缘线的类型
    layer3.path          = path3.CGPath;                    // 从贝塞尔曲线获取到形状
    layer3.lineWidth     = 0.2f;                           // 线条宽度
    layer3.strokeStart   = 0.0f;
    layer3.strokeEnd     = 1.0f;
    
    CGFloat angle = 0.0;
    if (_currentTemp > 40.5) {
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"温度过高，请检查温度计是否正确使用！" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        //        [alert show];
        
        angle = 74.0;
    }
    else if (_currentTemp < 37.5)
    {
        
        if (_currentTemp <= 34.0)
        {
            angle = 24.0;
        }
        else
        {
            angle = 24.0 + ( _currentTemp - 34.0) * 2.95;
        }
        
    }
    else
    {
        angle = (_currentTemp - 37.5)*13.6 + 34.3;
    }

    
    UIBezierPath *path4 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(_circleShape.bounds.size.width*0.5, _circleShape.bounds.size.width*0.5)
                                                             radius:97.f
                                                         startAngle:M_PI*24.0/32.0
                                                           endAngle:M_PI*angle/32.0
                                                          clockwise:YES];
    
    CAShapeLayer *layer4 = [CAShapeLayer layer];
    layer4.frame         = self.bounds;                // 与showView的frame一致
    if (_bWarning) {
        layer4.strokeColor   = [UIColor colorWithRed:0xff/255.0 green:0x34/255.0 blue:0x41/255.0 alpha:1.0].CGColor;
    }
    else
    {
        layer4.strokeColor   = [UIColor colorWithRed:0x6f/255.0 green:0xe0/255.0 blue:0xe9/255.0 alpha:1].CGColor;   // 边缘线的颜色//#6FE0E9
    }
    layer4.fillColor     = [UIColor clearColor].CGColor;   // 闭环填充的颜色
    layer4.lineCap       = kCALineCapRound;               // 边缘线的类型
    layer4.path          = path4.CGPath;                    // 从贝塞尔曲线获取到形状
    layer4.lineWidth     = 3.0f;                           // 线条宽度
    layer4.strokeStart   = 0.0f;
    layer4.strokeEnd     = 1.0f;
    
    _targetView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shedingtubiao.png"]];
    [_targetView setFrame:CGRectMake(_targetPoint.x, _targetPoint.y, _targetView.image.size.width*0.3, _targetView.image.size.height*0.3)];
    [_targetView setTransform:CGAffineTransformMakeRotation(_angle)];
    if (self.manualWarnTemp)
    {
        _targetView.hidden = YES;
    }
    //显示温度
    _temperatureLabel = [[UILabel alloc] initWithFrame:CGRectMake(70,_circleShape.bounds.size.height*0.45, 180, 60)];
    _temperatureLabel.textAlignment = NSTextAlignmentCenter;
    _temperatureLabel.textColor = [UIColor whiteColor];
    _temperatureLabel.backgroundColor = [UIColor clearColor];
    if (_currentTemp <= 30.0f || _currentTemp >= 42.0f)
    {
        _temperatureLabel.font = [UIFont systemFontOfSize:36];
        _temperatureLabel.text = DPLocalizedString(@"overflow");
    }
    else
    {
        if(_currentTemp >= 42.0f)
        {
            _currentTemp = 42.0f;
        }
        
        NSMutableAttributedString *str;
        if (_bFah) {
            str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.1f℉",_currentTemp*1.8+32.0]];//℉℃
        }
        else
        {
            str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.1f℃",_currentTemp]];//℃
        }
        
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0,[str length])];
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:60] range:NSMakeRange(0, [str length] - 3)];
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:36] range:NSMakeRange([str length] - 3, 3)];
        _temperatureLabel.attributedText = str;
    }
   //提示
    
    remindLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 120) / 2 , _temperatureLabel.frame.origin.y + _temperatureLabel.frame.size.height + 5, 120, 35)];
    remindLabel.textAlignment = NSTextAlignmentCenter;
    remindLabel.backgroundColor = [UIColor clearColor];
    remindLabel.textColor = [UIColor whiteColor];
    remindLabel.font = [UIFont systemFontOfSize:24];
    if (_currentTemp >= _warnTemp)
    {
        remindLabel.text = DPLocalizedString(@"Warning");
    }
    else if (_currentTemp >= 36.5)
    {
        remindLabel.text = DPLocalizedString(@"Normal");
    }
    else
    {
        remindLabel.text = @"";
    }
    
    [_circleShape.layer addSublayer:layer0];
    [_circleShape addSubview:pointView];
    [_circleShape.layer addSublayer:layer4];
    [_circleShape addSubview:label1];
    [_circleShape.layer addSublayer:layer1];
    [_circleShape addSubview:label2];
    [_circleShape.layer addSublayer:layer2];
    [_circleShape addSubview:label3];
    [_circleShape.layer addSublayer:layer3];
    
    [self addSubview:_circleShape];
    [self addSubview:_targetView];
    [self addSubview:_temperatureLabel];
    [self addSubview:remindLabel];
}

- (void)palyAction
{
    [audioPlayer play];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"%s",__FUNCTION__);
    UITouch *touch = [touches anyObject];
    
    _beginPoint = [touch locationInView:self];
    
    CGPoint nowPoint = [touch locationInView:_targetView];
    
    _touchedTempTarget = YES;
    
    int h = 20;
    
     NSLog(@"--------- begin point x=%f,y=%f",_beginPoint.x+_targetView.bounds.size.width/2.0-nowPoint.x,_beginPoint.y+_targetView.bounds.size.height-nowPoint.y);
    if (CGRectContainsPoint( CGRectMake(_targetView.frame.origin.x-h, _targetView.frame.origin.y-h, _targetView.frame.size.width+h, _targetView.frame.size.height+h)  ,_beginPoint)) {
        _bmoveEnable = YES;
    }
    else
    {
        _bmoveEnable = NO;
    }
    

    
}

//- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    NSLog(@"%s",__FUNCTION__);
//    
//    UITouch *touch = [touches anyObject];
//    
//    CGPoint nowPoint = [touch locationInView:self];
//    CGPoint nowPoint2 = [touch locationInView:_targetView];
//    CGPoint nowPoint1 = CGPointMake(nowPoint.x+_targetView.bounds.size.width/2.0-nowPoint2.x,nowPoint.y+_targetView.bounds.size.height-nowPoint2.y);
//    NSLog(@"nowpoint1 x=%f, y=%f",nowPoint1.x, nowPoint.y);
//    
//    float cx = self.bounds.size.width*0.5;
//    float cy = self.bounds.size.height*0.46;
//
//    float radius = sqrtf(ABS(nowPoint.x -cx)*ABS(nowPoint.x -cx) + ABS(nowPoint.y - cy)*ABS(nowPoint.y - cy));
//    
//    if(_bmoveEnable && radius < 140 && radius > 60 && nowPoint.y < 160)
//    {
//        float r = 107;
//        float y1 = sqrtf((r*r)*(nowPoint.y - cy)*(nowPoint.y - cy)/((nowPoint.x-cx)*(nowPoint.x-cx)+(nowPoint.y-cy)*(nowPoint.y-cy)))+cy;
//        float y2 = -sqrtf((r*r)*(nowPoint.y - cy)*(nowPoint.y - cy)/((nowPoint.x-cx)*(nowPoint.x-cx)+(nowPoint.y-cy)*(nowPoint.y-cy)))+cy;
//
//        float x1 = (y1 - cy)*(nowPoint.x - cx)/(nowPoint.y-cy)+cy;
//        float x2 = (y2 - cy)*(nowPoint.x - cx)/(nowPoint.y-cy)+cy;
//        
//        float d1 = sqrtf(ABS(x1 -_beginPoint.x)*ABS(x1 -_beginPoint.x) + ABS(y1-_beginPoint.y)*ABS(y1-_beginPoint.y));
//        float d2 = sqrtf(ABS(x2 -_beginPoint.x)*ABS(x2 -_beginPoint.x) + ABS(y2-_beginPoint.y)*ABS(y2-_beginPoint.y));
//        float x = 0;
//        float y = 0;
//        
//        if (d1 < d2)
//        {
//            x = x1;
//            y = y1;
//        }
//        else
//        {
//            x = x2;
//            y = y2;
//        }
//        if (iPhone5) {
//            x = x + 30;
//        }
//        else
//        {
//            x = x + 50;
//        }
//        y = y - 15;
//        
//        
//        NSLog(@"current x=%f, y=%f",x, y);
//        [_targetView setFrame:CGRectMake(x, y, _targetView.image.size.width*0.5, _targetView.image.size.height*0.5)];
//        _targetPoint = CGPointMake(x,y);
//        
//        double t = 0;
//        if (nowPoint1.x > 159.490509) {
//            t = acos(((x - cx) * (123.299004 - cx) + (y - cy) * (35.000000 - cy)) / (r * r))+1.643367;
//        }
//        else
//        {
//             t = acos(((x - cx) * (71 - cx) + (y - cy) * (165 - cy)) / (r * r));
//        }
//        
//        NSLog(@"t1 %f",t);
//
//        
//        if (t < 0.3) {
//            _warnTemp = 37.0;
//        }
//        else if (t > 3.7)
//        {
//            _warnTemp = 40.0;
//        }
//        else
//        {
//            _warnTemp = t/1.164 +36.805;
//        }
//        
//        NSLog(@"warn temperature %f",_warnTemp);
//    }
//    else
//    {
//        _bmoveEnable = NO;
//    }
//
//    _beginPoint = nowPoint;
//    
//}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"%s",__FUNCTION__);
    UITouch *touch = [touches anyObject];
    
    _beginPoint = [touch locationInView:self];
    
//    CGPoint nowPoint = [touch locationInView:_targetView];
 
    if (iPhone5)
    {
        if (_beginPoint.x<SCREEN_WIDTH*0.35) {
            _targetPoint = CGPointMake(self.frame.size.width*0.136, self.frame.size.height*0.415);
            _angle = -M_PI*0.35;
            _warnTemp = 37.5;
        }
        else if (_beginPoint.x < SCREEN_WIDTH*0.65)
        {
            _targetPoint = CGPointMake(self.frame.size.width*0.48, self.frame.size.height*0.095);
            _angle = 0;
            _warnTemp = 38.5;
        }
        else
        {
            _targetPoint = CGPointMake(self.frame.size.width*0.82, self.frame.size.height*0.415);
            _angle = M_PI*0.35;
            _warnTemp = 39.5;
        }
    }
    else
    {
        if (_beginPoint.x<SCREEN_WIDTH*0.35) {
            _targetPoint = CGPointMake(self.frame.size.width*0.135, self.frame.size.height*0.388);
            _angle = -M_PI*0.35;
            _warnTemp = 37.5;
        }
        else if (_beginPoint.x < SCREEN_WIDTH*0.65)
        {
            _targetPoint = CGPointMake(self.frame.size.width*0.48, self.frame.size.height*0.02);//CGPointMake(153,0);
            _angle = -M_PI*0;
            _warnTemp = 38.5;
        }
        else
        {
            _targetPoint = CGPointMake(self.frame.size.width*0.82, self.frame.size.height*0.4);//CGPointMake(252,78);
            _angle = M_PI*0.35;
            _warnTemp = 39.5;
        }
    }
    [_targetView removeFromSuperview];
    
    self.manualWarnTemp = NO;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"warnTemperature"])
    {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"warnTemperature"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshLineView" object:nil];
    [self setNeedsDisplay];
}

@end
