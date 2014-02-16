//
//  Location.m
//  TelevisionGuide
//
//  Created by Kashima Takumi on 2014/02/16.
//  Copyright (c) 2014年 TEAM TAKOYAKI. All rights reserved.
//

#import "Location.h"

@implementation Location


- (id)init
{
    self = [super init];
    if (self) {
        [self startUpdate];
    }
    return self;
}

-(void)startUpdate
{
    _lm = [[CLLocationManager alloc] init];
    _lm.delegate = self;
    _lm.distanceFilter = 100.0;
    _lm.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    [_lm startUpdatingLocation];
    [_lm startUpdatingHeading];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    
    
    NSLog(@"場所:%f %f", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
    [_lm stopUpdatingLocation];
}

-(void)locationManager:(CLLocationManager*)manager didUpdateHeading:(CLHeading*)newHeading
{
    if (newHeading.headingAccuracy < 0) return;

    CLLocationDirection theHeading = ((newHeading.trueHeading > 0) ? newHeading.trueHeading : newHeading.magneticHeading);
    NSLog(@"場所:%@",  [NSString stringWithFormat:@"Direction : %f", theHeading]);
    
    [_lm stopUpdatingHeading];
}

@end
