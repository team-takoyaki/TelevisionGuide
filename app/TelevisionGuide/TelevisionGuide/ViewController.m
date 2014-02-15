//
//  ViewController.m
//  TelevisionGuide
//
//  Created by Kashima Takumi on 2014/02/11.
//  Copyright (c) 2014年 TEAM TAKOYAKI. All rights reserved.
//

#import "ViewController.h"
#import "AppManager.h"
#import "CustomTableViewCell.h"

@interface ViewController ()
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    UISwipeGestureRecognizer *swipeLeftGesture =
    [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(view_SwipeLeft:)];
    
    swipeLeftGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    self.headerView.userInteractionEnabled = YES;
    [self.headerView addGestureRecognizer:swipeLeftGesture];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(onRefresh:) forControlEvents:UIControlEventValueChanged];
    _refreshControl = refreshControl;
    [_tableView addSubview:refreshControl];
    
    [_tableView registerClass:[CustomTableViewCell class] forCellReuseIdentifier:@"CustomCell"];
   
    [_tableView setDelegate:_tableView];
    [_tableView setDataSource:_tableView];
   
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onRefresh:(id)sender
{
    [_refreshControl beginRefreshing];
    [_refreshControl endRefreshing];
}

- (void)view_SwipeLeft:(UISwipeGestureRecognizer *)sender
{
    NSLog(@"左スワイプがされました．");
}

@end
