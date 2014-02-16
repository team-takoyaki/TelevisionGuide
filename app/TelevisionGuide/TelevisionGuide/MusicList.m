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

+ (NSArray *)getMusicList
{

//    MPMediaQuery *query = [MPMediaQuery artistsQuery];
//    NSArray *allTracks = [[[MPMediaQuery alloc] init] items] ;
    MPMediaQuery *everything = [[MPMediaQuery alloc] init];
    NSSortDescriptor *sorter = [NSSortDescriptor sortDescriptorWithKey:MPMediaItemPropertyPlayCount ascending:NO];
    NSArray *sortedSongsArray = [[everything items] sortedArrayUsingDescriptors:[NSArray arrayWithObject:sorter]];
    
//    for (int i = 0; i < 4; i++) {
//        NSLog(@"%@", sortedSongsArray[i]);
//    }
    
//    return sortedSongsArray;
//
//    for (int i = 0; i < 4; i++) {
//        NSLog(@"%@", sortedSongsArray[i]);
//    }
    NSMutableArray *array = [[NSMutableArray alloc] init];
    int count = 0;
    for( MPMediaItem *item in sortedSongsArray)
    {
        NSString *artist = [item valueForProperty:MPMediaItemPropertyArtist];
        [array addObject:artist];
        
        count++;
        if (count == 10) {
            break;
        }
    }
    return array;
}
@end
