//
//  AppManager.m
//  TelevisionGuide
//
//  Created by Kashima Takumi on 2014/02/15.
//  Copyright (c) 2014年 TEAM TAKOYAKI. All rights reserved.
//

#import "AppManager.h"

@interface AppManager()
- (void)initUUID;
@property (strong, nonatomic, readwrite) NSString *UUID;
@end

@implementation AppManager

@synthesize UUID = _UUID;

static AppManager* sharedInstance = nil;
 
+ (id)sharedManager
{
    //static SingletonTest* sharedSingleton;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[AppManager alloc]init];
    });
    return sharedInstance;
}

- (id)init
{
    AppManager *manager = [super init];
    if (manager) {
        [manager initUUID];
    }
    return manager;
}

- (void)initUUID
{
    NSUUID *vendorUUID = [UIDevice currentDevice].identifierForVendor;
    [self setUUID:vendorUUID.UUIDString];
}

+ (id)allocWithZone:(NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [super allocWithZone:zone];
    });
    return sharedInstance; 
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

@end
