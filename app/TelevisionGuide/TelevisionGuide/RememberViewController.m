//
//  ViewController.m
//  TelevisionGuide
//
//  Created by Kashima Takumi on 2014/02/11.
//  Copyright (c) 2014年 TEAM TAKOYAKI. All rights reserved.
//

#import "RememberViewController.h"
#import "AppManager.h"
#import "CustomTableViewCell.h"

@interface RememberViewController ()
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@end

@implementation RememberViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UISwipeGestureRecognizer *swipeRightGesture =
    [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeRight:)];
    swipeRightGesture.direction = UISwipeGestureRecognizerDirectionRight;
    
    self.headerView.userInteractionEnabled = YES;
    [self.headerView addGestureRecognizer:swipeRightGesture];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(onRefresh:) forControlEvents:UIControlEventValueChanged];
    _refreshControl = refreshControl;
    [_tableView addSubview:refreshControl];
    
    [_tableView registerClass:[CustomTableViewCell class] forCellReuseIdentifier:@"CustomCell"];
   
    [_tableView setDelegate:_tableView];
    [_tableView setDataSource:_tableView];
    
    AppManager *manager = [AppManager sharedManager];
    [manager updateRememberWithTarget:self selector:@selector(onUpdateTableViewCell)];
   
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)onUpdateTableViewCell
{
    AppManager *manager = [AppManager sharedManager];
    self.tableView.programs = (NSMutableArray *)[manager remember];
    
    [self.tableView reloadData];
    
    if (self.refreshControl.refreshing == YES) {
         [self.refreshControl endRefreshing];
    }
}

- (void)updateCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    // Update Cells
    Program *p = self.tableView.programs[indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@", [p programTitle]];
}

- (void)updateVisibleCells
{
    AppManager *manager = [AppManager sharedManager];
    [manager updateRecommendWithTarget:self selector:@selector(onUpdateTableViewCell)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onRefresh:(id)sender
{
    [_refreshControl beginRefreshing];
    
    [self updateVisibleCells];
}
//
//- (void)swipeRight:(UISwipeGestureRecognizer *)sender
//{
//    NSLog(@"右スワイプがされました．");
//    
//        [self performSegueWithIdentifier:@"gotoMainView" sender:self];
//}

@end
