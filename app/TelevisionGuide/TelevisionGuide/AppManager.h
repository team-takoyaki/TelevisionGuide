//
//  AppManager.h
//  TelevisionGuide
//
//  Created by Kashima Takumi on 2014/02/15.
//  Copyright (c) 2014年 TEAM TAKOYAKI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Program.h"

@interface AppManager : NSObject
+ (id)sharedManager;

/*
* ex.
*   [manager updateRecommendWithTarget:target
*                    selector:@selector(callback)];
*/
- (void)updateRecommendWithTarget:(id)aTarget selector:(SEL)aSelector;
- (void)updateRememberWithTarget:(id)aTarget selector:(SEL)aSelector;
- (void)requestAppList;
- (void)requestMusicList;
- (void)requestGeoList:(NSString *)geoInfo;
- (void)requestCompusList:(NSString *)geoInfo;
- (void)requestIPAddress;
- (NSArray *)recommend;
- (NSArray *)remember;

@property (strong, nonatomic, readonly) NSString *UUID;
@end
