//
//  CustomTableView.m
//  TelevisionGuide
//
//  Created by Kashima Takumi on 2014/02/16.
//  Copyright (c) 2014年 TEAM TAKOYAKI. All rights reserved.
//

#import "CustomTableView.h"
#import "CustomTableViewCell.h"
#import "AppManager.h"

@interface CustomTableView()
@end

@implementation CustomTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _programs = [[NSMutableArray alloc] init];
    }
    return self;
}

//テーブルに含まれるセクションの数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

//行に表示するデータの件数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _programs.count;
}

//行が選択された時の挙動
-(void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  Program *p = self.programs[indexPath.row];
  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:p.programUrl]];
    
  //ハイライト解除
  [tv deselectRowAtIndexPath:indexPath animated:YES];
}

//行に表示するデータの編集
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomTableViewCell *cell = (CustomTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"CustomCell"];

//    [cell setProgramImage:[UIImage imageNamed:@"suntv.png"]];
//    [cell setServiceName:@"NHK総合"];
//    [cell setProgramDate:@"あす"];
//    [cell setProgramTime:@"午後7:15〜"];
//    [cell setProgramTitle:@"ダーウィンが来た！「珍鳥キーウィ飛ばない秘密」"];
//    [cell setProgramSubTitle:@"ニュージランドだけにくらす絶滅危惧種の鳥・キーウィ。大きさはニワトリほどだが、卵の重さはなんとニワトリの6倍！地中のミミズを捕まえる秘策など、珍鳥の秘密に迫る！"];
    Program *p = _programs[indexPath.row];
    [cell setProgramTitle:[NSString stringWithFormat:@"%@", [p programTitle]]];
    [cell setProgramSubTitle:[NSString stringWithFormat:@"%@", [p programSubTitle]]];
    [cell setServiceName:[NSString stringWithFormat:@"%@", [p serviceName]]];
    [cell setProgramDate:[NSString stringWithFormat:@"%@", [p startTime]]];
    [cell setProgramTime:[NSString stringWithFormat:@"%@", [p startTime]]];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    //YESを返すと編集可能状態
    return YES;
}

//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        // 削除する
////        NSInteger row = [indexPath row];
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//    }   
//    else if (editingStyle == UITableViewCellEditingStyleInsert) {
//        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//    }   
//}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 95;
}
@end
