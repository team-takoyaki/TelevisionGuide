//
//  AppList.m
//  TelevisionGuide
//
//  Created by Takashi Honda on 2014/02/16.
//  Copyright (c) 2014年 TEAM TAKOYAKI. All rights reserved.
//

#import "AppList.h"


@interface AppList()

@end

@implementation AppList

+ (void) sendAppList
{

    NSMutableArray *appList = [NSMutableArray array];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"schemes" ofType:@"plist"];
    
    NSString *escapedPath = [path stringByReplacingOccurrencesOfString:@" "
                                                                     withString:@"\\ "];
    NSLog(@"%@", escapedPath);
    
    // ファイルマネージャを作成
    NSFileManager *fileManager = [NSFileManager defaultManager];
 
    // ファイルが存在しないか?
    if (![fileManager fileExistsAtPath:path]) { // yes
        NSLog(@"plistが存在しません．");
        return;
    }
 
    // plistを読み込む
    NSArray *schemes = [NSArray arrayWithContentsOfFile:path];
    NSLog(@"%@", schemes);
    for (NSDictionary *aScheme in schemes) {
        NSLog(@"%@", aScheme);
        NSString *url = [NSString stringWithFormat:@"%@://", [aScheme objectForKey:@"url_scheme"]];
        BOOL canOpen = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:url]];
        // オープン可能＝インストールされている
        if (canOpen) {
            NSLog(@"%@\t:installed", [aScheme objectForKey:@"app_name"]);
            [appList addObject:[aScheme objectForKey:@"app_name"]];
        }
        // オープンできない＝インストールされていない
        else {
            NSLog(@"%@\t:not installed", [aScheme objectForKey:@"app_name"]);
        }
    }

    if ([appList count] == 0) {
        return;
    }

    NSString *baseString = @"app=";
    int count = 1;
    
    for (NSString *appName in appList) {
        NSLog(@"%@", appName);
        baseString = [NSString stringWithFormat:@"%@%@",baseString, appName];
        
        if (count < [appList count]) {
            baseString = [NSString stringWithFormat:@"%@,", baseString];
        }
        count++;
    }

    //ここでURL送る処理書いといね

    NSLog(@"%@", baseString);
}

@end