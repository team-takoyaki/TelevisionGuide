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
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) id grabbedObject;
@end

@implementation CustomTableView
@synthesize tableViewRecognizer;
@synthesize grabbedObject;

#define ADDING_CELL @"Continue..."
#define DONE_CELL @"Done"
#define DUMMY_CELL @"Dummy"
#define COMMITING_CREATE_CELL_HEIGHT 95
#define NORMAL_CELL_FINISHING_HEIGHT 95

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
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    CustomTableViewCell *cell = (CustomTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"CustomCell"];
//
////    [cell setProgramImage:[UIImage imageNamed:@"suntv.png"]];
////    [cell setServiceName:@"NHK総合"];
////    [cell setProgramDate:@"あす"];
////    [cell setProgramTime:@"午後7:15〜"];
////    [cell setProgramTitle:@"ダーウィンが来た！「珍鳥キーウィ飛ばない秘密」"];
////    [cell setProgramSubTitle:@"ニュージランドだけにくらす絶滅危惧種の鳥・キーウィ。大きさはニワトリほどだが、卵の重さはなんとニワトリの6倍！地中のミミズを捕まえる秘策など、珍鳥の秘密に迫る！"];
//    Program *p = _programs[indexPath.row];
//    [cell setProgramTitle:[NSString stringWithFormat:@"%@", [p programTitle]]];
//    [cell setProgramSubTitle:[NSString stringWithFormat:@"%@", [p programSubTitle]]];
//    [cell setServiceName:[NSString stringWithFormat:@"%@", [p serviceName]]];
//    [cell setProgramDate:[NSString stringWithFormat:@"%@", [p startTime]]];
//    [cell setProgramTime:[NSString stringWithFormat:@"%@", [p startTime]]];
//    
//    return cell;
//}

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


#pragma mark Private Method

- (void)moveRowToBottomForIndexPath:(NSIndexPath *)indexPath {
    [self beginUpdates];
    
    id object = [_programs objectAtIndex:indexPath.row];
    [_programs removeObjectAtIndex:indexPath.row];
    [_programs addObject:object];

    NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow:[_programs count] - 1 inSection:0];
    [self moveRowAtIndexPath:indexPath toIndexPath:lastIndexPath];

    [self endUpdates];

    [self performSelector:@selector(reloadVisibleRowsExceptIndexPath:) withObject:lastIndexPath afterDelay:JTTableViewRowAnimationDuration];
}

#pragma mark UITableViewDatasource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSObject *object = [_programs objectAtIndex:indexPath.row];
    UIColor *backgroundColor = [[UIColor whiteColor] colorWithHueOffset:0.12 * indexPath.row / [self tableView:tableView numberOfRowsInSection:indexPath.section]];
    if ([object isEqual:ADDING_CELL]) {
        NSString *cellIdentifier = nil;
        JTTransformableTableViewCell *cell = nil;

        // IndexPath.row == 0 is the case we wanted to pick the pullDown style
        if (indexPath.row == 0) {
            cellIdentifier = @"PullDownTableViewCell";
            cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            
            if (cell == nil) {
                cell = [JTTransformableTableViewCell transformableTableViewCellWithStyle:JTTransformableTableViewCellStylePullDown
                                                                       reuseIdentifier:cellIdentifier];
                cell.textLabel.adjustsFontSizeToFitWidth = YES;

                cell.textLabel.textColor = [UIColor blackColor];
            }
            
            
            cell.finishedHeight = COMMITING_CREATE_CELL_HEIGHT;
            if (cell.frame.size.height > COMMITING_CREATE_CELL_HEIGHT * 2) {
                cell.imageView.image = [UIImage imageNamed:@"reload.png"];
                cell.tintColor = [UIColor blackColor];
                cell.textLabel.text = @"Return to list...";
            } else if (cell.frame.size.height > COMMITING_CREATE_CELL_HEIGHT) {
                cell.imageView.image = nil;
                // Setup tint color
                cell.tintColor = backgroundColor;
                cell.textLabel.text = @"Release to create cell...";
            } else {
                cell.imageView.image = nil;
                // Setup tint color
                cell.tintColor = backgroundColor;
                cell.textLabel.text = @"Continue Pulling...";
            }
            cell.contentView.backgroundColor = [UIColor whiteColor];
            cell.textLabel.shadowOffset = CGSizeMake(0, 1);
            cell.textLabel.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
            return cell;

        } else {
            // Otherwise is the case we wanted to pick the pullDown style
            cellIdentifier = @"UnfoldingTableViewCell";
            cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

            if (cell == nil) {
                cell = [JTTransformableTableViewCell transformableTableViewCellWithStyle:JTTransformableTableViewCellStyleUnfolding
                                                                       reuseIdentifier:cellIdentifier];
                cell.textLabel.adjustsFontSizeToFitWidth = YES;
                cell.textLabel.textColor = [UIColor blackColor];
            }
            
            // Setup tint color
            cell.tintColor = backgroundColor;
            
            cell.finishedHeight = COMMITING_CREATE_CELL_HEIGHT;
            if (cell.frame.size.height > COMMITING_CREATE_CELL_HEIGHT) {
                cell.textLabel.text = @"Release to create cell...";
            } else {
                cell.textLabel.text = @"Continue Pinching...";
            }
            cell.contentView.backgroundColor = [UIColor whiteColor];
            cell.textLabel.shadowOffset = CGSizeMake(0, 1);
            cell.textLabel.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
            return cell;
        }
    
    } else {

        static NSString *cellIdentifier = @"CustomCell";
        CustomTableViewCell *cell = (CustomTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"CustomCell"];
        
//        cell.textLabel.text = [NSString stringWithFormat:@"%@", (NSString *)object];
//        cell.textLabel.text = [NSString stringWithFormat:@"%@", [p programTitle]];
        cell.textLabel.backgroundColor = [UIColor whiteColor];
        if ([object isEqual:DONE_CELL]) {
            cell.textLabel.textColor = [UIColor grayColor];
            cell.contentView.backgroundColor = [UIColor darkGrayColor];
        } else if ([object isEqual:DUMMY_CELL]) {
            cell.textLabel.text = @"";
            cell.contentView.backgroundColor = [UIColor whiteColor];
        } else {
            cell.textLabel.textColor = [UIColor blackColor];
            cell.contentView.backgroundColor = backgroundColor;
        }
        cell.textLabel.shadowOffset = CGSizeMake(0, 1);
        cell.textLabel.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
        
        cell.backgroundColor = [UIColor whiteColor];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        
        ////ここを編集
        UIView *cellView = [[UIView alloc] init];


        UIImage *image = [UIImage imageNamed:@"remember_minai.png"];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        [imageView setTag:555];
        [cellView addSubview:imageView];
        
        UIImage *image2 = [UIImage imageNamed:@"main_miru.png"];
        UIImageView *imageView2 = [[UIImageView alloc] initWithImage:image2];
        [imageView setTag:666];
        [cellView addSubview:imageView2];

        
        cell.backgroundView = cellView;
        
        Program *p = _programs[indexPath.row];
        NSURL *url = [NSURL URLWithString:[p programImage]];
        NSData *data = [NSData dataWithContentsOfURL:url];
        
        [cell setProgramImage:[[UIImage alloc] initWithData:data]];
        [cell setProgramTitle:[NSString stringWithFormat:@"%@", [p programTitle]]];
        [cell setProgramSubTitle:[NSString stringWithFormat:@"%@", [p programSubTitle]]];
        [cell setServiceName:[NSString stringWithFormat:@"%@", [p serviceName]]];
        [cell setProgramDate:[NSString stringWithFormat:@"%@", [p programDay]]];
        [cell setProgramTime:[NSString stringWithFormat:@"%@", [p programTime]]];
        
        return cell;
    }
}

#pragma mark UITableViewDelegate
#pragma mark -
#pragma mark JTTableViewGestureAddingRowDelegate

- (void)gestureRecognizer:(JTTableViewGestureRecognizer *)gestureRecognizer needsAddRowAtIndexPath:(NSIndexPath *)indexPath {
return;
//    [self.rows insertObject:ADDING_CELL atIndex:indexPath.row];
}

- (void)gestureRecognizer:(JTTableViewGestureRecognizer *)gestureRecognizer needsCommitRowAtIndexPath:(NSIndexPath *)indexPath {
    [_programs replaceObjectAtIndex:indexPath.row withObject:@"Added!"];
    JTTransformableTableViewCell *cell = (id)[gestureRecognizer.tableView cellForRowAtIndexPath:indexPath];

    BOOL isFirstCell = indexPath.section == 0 && indexPath.row == 0;
    if (isFirstCell && cell.frame.size.height > COMMITING_CREATE_CELL_HEIGHT * 2) {
        [_programs removeObjectAtIndex:indexPath.row];
        [self deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
        // Return to list
    }
    else {
        cell.finishedHeight = NORMAL_CELL_FINISHING_HEIGHT;
        cell.imageView.image = nil;
        cell.textLabel.text = @"Just Added!";
    }
}

- (void)gestureRecognizer:(JTTableViewGestureRecognizer *)gestureRecognizer needsDiscardRowAtIndexPath:(NSIndexPath *)indexPath {
    [_programs removeObjectAtIndex:indexPath.row];
}

// Uncomment to following code to disable pinch in to create cell gesture
//- (NSIndexPath *)gestureRecognizer:(JTTableViewGestureRecognizer *)gestureRecognizer willCreateCellAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.section == 0 && indexPath.row == 0) {
//        return indexPath;
//    }
//    return nil;
//}

#pragma mark JTTableViewGestureEditingRowDelegate

- (void)gestureRecognizer:(JTTableViewGestureRecognizer *)gestureRecognizer didEnterEditingState:(JTTableViewCellEditingState)state forRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self cellForRowAtIndexPath:indexPath];

    UIView *backgroundView = cell.backgroundView;

    UIImageView *imageView1 = (UIImageView *)[backgroundView viewWithTag:555];
    UIImageView *imageView2 = (UIImageView *)[backgroundView viewWithTag:666];

    UIColor *backgroundColor = nil;
    switch (state) {
        case JTTableViewCellEditingStateMiddle:
            backgroundColor = [[UIColor whiteColor] colorWithHueOffset:0.12 * indexPath.row / [self tableView:self numberOfRowsInSection:indexPath.section]];
            break;
        case JTTableViewCellEditingStateRight:
            backgroundColor = [UIColor whiteColor];
            
            [backgroundView bringSubviewToFront:imageView1];
            break;
        default:
            backgroundColor = [UIColor whiteColor];
            [backgroundView bringSubviewToFront:imageView2];
            break;
    }
    cell.contentView.backgroundColor = [UIColor whiteColor];
    if ([cell isKindOfClass:[JTTransformableTableViewCell class]]) {
        ((JTTransformableTableViewCell *)cell).tintColor = backgroundColor;
    }
}

// This is needed to be implemented to let our delegate choose whether the panning gesture should work
- (BOOL)gestureRecognizer:(JTTableViewGestureRecognizer *)gestureRecognizer canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)gestureRecognizer:(JTTableViewGestureRecognizer *)gestureRecognizer commitEditingState:(JTTableViewCellEditingState)state forRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableView *tableView = gestureRecognizer.tableView;
    

    
    NSIndexPath *rowToBeMovedToBottom = nil;

    [tableView beginUpdates];
    if (state == JTTableViewCellEditingStateLeft) {
        // An example to discard the cell at JTTableViewCellEditingStateLeft
//        AppManager *manager = [AppManager sharedManager];
//        
//        Program *p = [_programs objectAtIndex:indexPath.row];        
//        [manager requestForget:[p programId]];
//        UIImageView *imageView = (UIImageView *)[backgroundView viewWithTag:555];
//        [backgroundView bringSubviewToFront:imageView];
        AppManager *manager = [AppManager sharedManager];
        Program *p = _programs[indexPath.row];
        [manager requestForget:p.programId];
        [_programs removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    } else if (state == JTTableViewCellEditingStateRight) {
        // An example to retain the cell at commiting at JTTableViewCellEditingStateRight
//        [self.rows replaceObjectAtIndex:indexPath.row withObject:DONE_CELL];
//        AppManager *manager = [AppManager sharedManager];
//        Program *p = [_programs objectAtIndex:indexPath.row];
//        
//        [manager requestRemember:[p programId]];
//        UIImageView *imageView = (UIImageView *)[backgroundView viewWithTag:666];
//        [backgroundView bringSubviewToFront:imageView];

        AppManager *manager = [AppManager sharedManager];
        Program *p = _programs[indexPath.row];
        [manager requestRemember:p.programId];

        [_programs removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
        
//        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
//        rowToBeMovedToBottom = indexPath;
    } else {
        // JTTableViewCellEditingStateMiddle shouldn't really happen in
        // - [JTTableViewGestureDelegate gestureRecognizer:commitEditingState:forRowAtIndexPath:]
    }
    [tableView endUpdates];


    // Row color needs update after datasource changes, reload it.
    [tableView performSelector:@selector(reloadVisibleRowsExceptIndexPath:) withObject:indexPath afterDelay:JTTableViewRowAnimationDuration];

    if (rowToBeMovedToBottom) {
        [self performSelector:@selector(moveRowToBottomForIndexPath:) withObject:rowToBeMovedToBottom afterDelay:JTTableViewRowAnimationDuration * 2];
    }
}

#pragma mark JTTableViewGestureMoveRowDelegate

- (BOOL)gestureRecognizer:(JTTableViewGestureRecognizer *)gestureRecognizer canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)gestureRecognizer:(JTTableViewGestureRecognizer *)gestureRecognizer needsCreatePlaceholderForRowAtIndexPath:(NSIndexPath *)indexPath {
    self.grabbedObject = [_programs objectAtIndex:indexPath.row];
    [_programs replaceObjectAtIndex:indexPath.row withObject:DUMMY_CELL];
}

- (void)gestureRecognizer:(JTTableViewGestureRecognizer *)gestureRecognizer needsMoveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    id object = [_programs objectAtIndex:sourceIndexPath.row];
    [_programs removeObjectAtIndex:sourceIndexPath.row];
    [_programs insertObject:object atIndex:destinationIndexPath.row];
}

- (void)gestureRecognizer:(JTTableViewGestureRecognizer *)gestureRecognizer needsReplacePlaceholderForRowAtIndexPath:(NSIndexPath *)indexPath {
    [_programs replaceObjectAtIndex:indexPath.row withObject:self.grabbedObject];
    self.grabbedObject = nil;
}


@end
