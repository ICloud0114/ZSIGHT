//
//  CustonMKAnnotation.h
//  book
//
//  Created by easaa on 13-1-30.
//  Copyright (c) 2013年 easaa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MKShape.h>
#import <MapKit/MKFoundation.h>
#import <CoreLocation/CLLocation.h>

MK_CLASS_AVAILABLE(NA, 4_0)
@interface CustonMKAnnotation : MKShape {
    @package
    CLLocationCoordinate2D _coordinate;
    NSInteger _tag;
}

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, assign) NSInteger tag;
@end
