//
//  AppManager.h
//  TelevisionGuide
//
//  Created by Kashima Takumi on 2014/02/15.
//  Copyright (c) 2014年 TEAM TAKOYAKI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppManager : NSObject
+ (id)sharedManager;

@property (strong, nonatomic, readonly, getter = getUUID) NSString *UUID;
@end
