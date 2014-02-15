//
//  Location.h
//  TelevisionGuide
//
//  Created by Kashima Takumi on 2014/02/16.
//  Copyright (c) 2014年 TEAM TAKOYAKI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface Location : NSObject <CLLocationManagerDelegate>
-(id)init;
-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation*)newLocation fromLocation:(CLLocation*)oldLocation;
-(void)locationManager:(CLLocationManager*)manager didUpdateHeading:(CLHeading*)newHeading;

@property (nonatomic, strong) CLLocationManager *lm;
@end
