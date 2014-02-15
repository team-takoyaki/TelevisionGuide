//
//  Service.h
//  TelevisionGuide
//
//  Created by Kashima Takumi on 2014/02/15.
//  Copyright (c) 2014年 TEAM TAKOYAKI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Program : NSObject
@property (strong, nonatomic) NSString *programTitle;
@property (strong, nonatomic) NSString *programSubTitle;
@property (strong, nonatomic) NSString *programId;
@property (strong, nonatomic) NSString *eventId;
@property (strong, nonatomic) NSString *startTime;
@property (strong, nonatomic) NSString *endTime;
@property (strong, nonatomic) NSString *serviceId;
@property (strong, nonatomic) NSString *serviceName;
@end
