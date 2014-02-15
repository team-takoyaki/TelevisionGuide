//
//  RecomendViewController.m
//  TelevisionGuide
//
//  Created by Takashi Honda on 2014/02/15.
//  Copyright (c) 2014年 TEAM TAKOYAKI. All rights reserved.
//

#import "RecommendViewController.h"
#import "AppManager.h"
#import "ViewController.h"
#import "MusicList.h"

@interface RecommendViewController ()

@end

@implementation RecommendViewController
@synthesize programArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImage *mainTitleImage = [UIImage imageNamed:@"main_title.png"];

    UIImageView *imageView = [[UIImageView alloc] initWithImage:mainTitleImage];
    UISwipeGestureRecognizer *swipeLeftGesture =
    [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(view_SwipeLeft:)];
    
    swipeLeftGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    [imageView addGestureRecognizer:swipeLeftGesture];
    [self.navigationController.navigationBar addSubview:imageView];
    
	// Do any additional setup after loading the view.
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(onRefresh:) forControlEvents:UIControlEventValueChanged];
    AppManager *manager = [AppManager sharedManager];
    [manager updateRecommendWithTarget:self selector:@selector(onUpdate)];
    self.programArray = [manager recommend];
    self.refreshControl = refreshControl;
}

- (void)onUpdate
{
    AppManager *manager = [AppManager sharedManager];
    self.programArray = [manager recommend];
    
    if (self.refreshControl.refreshing == YES) {
         [self.refreshControl endRefreshing];
    }
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//テーブルに含まれるセクションの数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;	// 0 -> 1 に変更
}

//行に表示するデータの件数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.programArray count];
}

//行が選択された時の挙動
-(void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  // ハイライトを外す
  [tv deselectRowAtIndexPath:indexPath animated:YES];
  [self performSegueWithIdentifier:@"gotoRememberViewController" sender:self];
    
  //ハイライト解除
  [tv deselectRowAtIndexPath:indexPath animated:YES];
}

//行に表示するデータの編集
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    [self updateCell:cell atIndexPath:indexPath];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    //YESを返すと編集可能状態
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // 削除する
//        NSInteger row = [indexPath row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

- (void) updateCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    // Update Cells
    Program *p = self.programArray[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@", [p programTitle]];
}

- (void) updateVisibleCells {
    AppManager *manager = [AppManager sharedManager];
    [manager updateRecommendWithTarget:self selector:@selector(onUpdate)];
    self.programArray = [manager recommend];
    for (UITableViewCell *cell in [self.tableView visibleCells]){
        [self updateCell:cell atIndexPath:[self.tableView indexPathForCell:cell]];
    }
}


- (void)onRefresh:(id)sender {
    [self.refreshControl beginRefreshing];
    //この間にデータを表示する処理
    [self updateVisibleCells];
//    [self.refreshControl endRefreshing];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ( [[segue identifier] isEqualToString:@"gotoCellDetail"] ) {
    }
}

- (void)view_SwipeLeft:(UISwipeGestureRecognizer *)sender
{
    NSLog(@"左スワイプがされました．");
}

@end
