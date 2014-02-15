//
//  AppManager.m
//  TelevisionGuide
//
//  Created by Kashima Takumi on 2014/02/15.
//  Copyright (c) 2014年 TEAM TAKOYAKI. All rights reserved.
//

#import "AppManager.h"
#import <AFNetworking.h>

#define RECOMMEND_URL @"http://api.team-takoyaki.com/recommend.php"

@interface AppManager()
- (void)initUUID;

@property (strong, nonatomic, readwrite) NSString *UUID;
@property (strong, nonatomic) NSMutableArray *recommend;
@end

@implementation AppManager

@synthesize UUID = _UUID;
@synthesize recommend = _recommend;

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
        _recommend = [[NSMutableArray alloc] init];
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

- (NSArray *)recommend
{
    return (NSArray *)_recommend;
}

- (void)updateRecommendWithTarget:(id)aTarget selector:(SEL)aSelector
{
    NSString *urlString = [NSString stringWithFormat:@"%@?user_id=%@", RECOMMEND_URL, _UUID];

    NSLog(@"REQUEST URL: %@", urlString);

    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // NSLog(@"response: %@", responseObject);
        _recommend = [[NSMutableArray alloc] init];
        NSArray *programs = (NSArray *)responseObject;
        for (NSDictionary *dict in programs) {
            Program *program = [[Program alloc] init];
            NSString *pId = (NSString *)[dict objectForKey:@"id"];
            [program setProgramId:pId];
            
            NSString *pTitle = (NSString *)[dict objectForKey:@"title"];
            [program setProgramTitle:pTitle];
            
            NSString *pSubTitle = (NSString *)[dict objectForKey:@"subtitle"];
            [program setProgramSubTitle:pSubTitle];
            
            NSString *eId = (NSString *)[dict objectForKey:@"event_id"];
            [program setEventId:eId];
            
            NSString *sTime = (NSString *)[dict objectForKey:@"start_time"];
            [program setStartTime:sTime];
            
            NSString *eTime = (NSString *)[dict objectForKey:@"end_time"];
            [program setEndTime:eTime];
            
            NSDictionary *dict2 = (NSDictionary *)[dict objectForKey:@"service"];
            NSString *sId = (NSString *)[dict2 objectForKey:@"id"];
            [program setServiceId:sId];
            
            NSString *sName = (NSString *)[dict2 objectForKey:@"name"];
            [program setServiceName:sName];
            
            NSString *pUrl = (NSString *)[dict objectForKey:@"nhk_online_url"];
            [program setProgramUrl:pUrl];
            
            [_recommend addObject:program];
        }
        
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        if (aTarget && aSelector) {
            [aTarget performSelector:aSelector];
        }
        #pragma clang diagnostic pop
//        for (Program *p in _recommend) {
//            NSLog(@"ProgramName: %@", [p programTitle]);
//        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

@end
