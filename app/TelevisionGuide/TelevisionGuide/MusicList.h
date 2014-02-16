//
//  MusicList.h
//  TelevisionGuide
//
//  Created by Takashi Honda on 2014/02/16.
//  Copyright (c) 2014年 TEAM TAKOYAKI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface MusicList : NSObject <MPMediaPickerControllerDelegate>

+ (NSArray *)getMusicList;

@end
