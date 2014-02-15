//
//  AppManager.m
//  TelevisionGuide
//
//  Created by Kashima Takumi on 2014/02/15.
//  Copyright (c) 2014年 TEAM TAKOYAKI. All rights reserved.
//

#import "AppManager.h"
#import <AFNetworking.h>
#import "AppList.h"
#import "MusicList.h"
#import <ifaddrs.h>
#import <arpa/inet.h>
#import <AddressBook/AddressBook.h>

#define RECOMMEND_URL @"http://api.team-takoyaki.com/recommend.php"
#define REMEMBER_URL @"http://api.team-takoyaki.com/remember.php"
#define REQUEST_APP_URL @"http://api.team-takoyaki.com/recommend.php"
#define REQUEST_GEO_URL @"http://api.team-takoyaki.com/recommend.php"
#define REQUEST_COMPUS_URL @"http://api.team-takoyaki.com/recommend.php"
#define REQUEST_IP_ADDRESS_URL @"http://api.team-takoyaki.com/recommend.php"
#define REQUEST_MUSIC_LIST_URL @"http://api.team-takoyaki.com/recommend.php"
#define REQUEST_CONTACT_LIST_URL @"http://api.team-takoyaki.com/recommend.php"

@interface AppManager()
- (void)initUUID;

@property (strong, nonatomic, readwrite) NSString *UUID;
@property (strong, nonatomic) NSMutableArray *recommend;
@property (strong, nonatomic) NSMutableArray *remember;
@end

@implementation AppManager

@synthesize UUID = _UUID;
@synthesize recommend = _recommend;
@synthesize remember = _remember;

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
        _remember = [[NSMutableArray alloc] init];
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

- (NSArray *)remember
{
    return (NSArray *)_remember;
}

- (void)updateRememberWithTarget:(id)aTarget selector:(SEL)aSelector
{
    NSString *urlString = [NSString stringWithFormat:@"%@?user_id=%@", REMEMBER_URL, _UUID];

    NSLog(@"REQUEST URL: %@", urlString);

    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // NSLog(@"response: %@", responseObject);
        _remember = [[NSMutableArray alloc] init];
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
            
            [_remember addObject:program];
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

- (void)requestAppList
{
    NSString *appListParam = [AppList getAppList];

    NSString *urlString = [NSString stringWithFormat:@"%@?app=%@", REQUEST_APP_URL, appListParam];

    NSLog(@"REQUEST URL: %@", urlString);

    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)requestGeoList:(NSString *)geoInfo
{
    NSString *urlString = [NSString stringWithFormat:@"%@?geo=%@", REQUEST_GEO_URL, geoInfo];

    NSLog(@"REQUEST URL: %@", urlString);

    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)requestCompusList:(NSString *)geoInfo
{
    NSString *urlString = [NSString stringWithFormat:@"%@?compus=%@", REQUEST_COMPUS_URL, geoInfo];

    NSLog(@"REQUEST URL: %@", urlString);

    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)requestIPAddress
{

    NSString *urlString = [NSString stringWithFormat:@"%@?ip=%@", REQUEST_IP_ADDRESS_URL, [self getIPAddress]];

    NSLog(@"REQUEST URL: %@", urlString);

    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (NSString *)getIPAddress {
    NSString *address = @"";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    success = getifaddrs(&interfaces);
    if (success == 0) {
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"pdp_ip0"] ||
                   [[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    freeifaddrs(interfaces);
    return address;
}

- (void)requestMusicList
{
    NSArray *musics = [MusicList getMusicList];
    NSString *musicParams = @"";
    
    for (NSString *m in musics) {
        musicParams = [NSString stringWithFormat:@"%@,%@", musicParams, m];
    }
    
    NSString *escapedString = (NSString*)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                            kCFAllocatorDefault,
                            (CFStringRef)musicParams, // ←エンコード前の文字列(NSStringクラス)
                            NULL,
                            (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                            kCFStringEncodingUTF8));
    
    NSString *urlString = [NSString stringWithFormat:@"%@?artists=%@", REQUEST_MUSIC_LIST_URL, escapedString];

    NSLog(@"REQUEST URL: %@", urlString);

    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)requestContactList
{
//    ABAddressBookRef addressBook = ABAddressBook
//    NSString *urlString = [NSString stringWithFormat:@"%@?born_date=%@&address=%@", REQUEST_CONTACT_LIST_URL, escapedString];

//    NSLog(@"REQUEST URL: %@", urlString);
//
//    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
//    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Error: %@", error);
//    }];
}

@end
