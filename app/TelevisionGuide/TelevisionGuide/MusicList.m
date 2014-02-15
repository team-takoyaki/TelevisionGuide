//
//  MusicList.m
//  TelevisionGuide
//
//  Created by Takashi Honda on 2014/02/16.
//  Copyright (c) 2014年 TEAM TAKOYAKI. All rights reserved.
//

#import "MusicList.h"

@interface MusicList()

@end

@implementation MusicList

+ (void) sendMusicList
{
    NSLog(@"test");
    MPMediaQuery *query = [MPMediaQuery artistsQuery];
    NSArray *allTracks = [[[MPMediaQuery alloc] init] items] ;
    MPMediaQuery *everything = [[MPMediaQuery alloc] init];
    NSSortDescriptor *sorter = [NSSortDescriptor sortDescriptorWithKey:MPMediaItemPropertyPlayCount ascending:NO];
    NSArray *sortedSongsArray = [[everything items] sortedArrayUsingDescriptors:[NSArray arrayWithObject:sorter]];
    
    if ([sortedSongsArray count] == 0) {
        return;
    }
    
    for (int i = 0; i < 4; i++) {
        NSLog(@"%@", sortedSongsArray[i]);
    }
//    for( MPMediaItem *item in [query items])
//    {
//        NSLog(@"%@", [item valueForProperty:MPMediaItemPropertyTitle]);
//        ++counter;
//        if(counter > 4) break; // 全部出すと多いのでこの辺でbreak
//    }
}
@end
