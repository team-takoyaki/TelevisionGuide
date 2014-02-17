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
@property (nonatomic) BOOL isSwipe;
@property (nonatomic, strong) UIImageView *nextHeaderView;
@property (nonatomic) CGPoint touchBeganPoint;
@property (nonatomic) CGRect originalNextFrame;
@property (nonatomic) CGRect originalFrame;
@end

@implementation RememberViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _nextHeaderView = [[UIImageView alloc] initWithFrame:CGRectMake(-_headerView.frame.size.width, _headerView.frame.origin.y, 320, 55)];
    [_nextHeaderView setImage:[UIImage imageNamed:@"main_title.png"]];
    [self.view addSubview:_nextHeaderView];
    
    self.headerView.userInteractionEnabled = YES;
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(onRefresh:) forControlEvents:UIControlEventValueChanged];
    _refreshControl = refreshControl;
    [_tableView addSubview:refreshControl];
    
    [_tableView registerClass:[CustomTableViewCell class] forCellReuseIdentifier:@"CustomCell"];
   
    [_tableView setDelegate:_tableView];
    [_tableView setDataSource:_tableView];
    
    self.tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    
    AppManager *manager = [AppManager sharedManager];
    [manager updateRememberWithTarget:self selector:@selector(onUpdateTableViewCell)];
   
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)onUpdateTableViewCell
{
    AppManager *manager = [AppManager sharedManager];
    self.tableView.programs = (NSMutableArray *)[manager remember];
   
    [self.tableView reloadData];
    
    if (self.tableView.programs.count > 0) {
        self.tableView.separatorStyle  = UITableViewCellSeparatorStyleSingleLine;
    }
    
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
    [manager updateRememberWithTarget:self selector:@selector(onUpdateTableViewCell)];
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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (touches.count > 1) {
        return;
    }
    
    _isSwipe = NO;
    
	// マルチタッチ
    for (UITouch *touch in touches) {
		CGPoint location = [touch locationInView:self.view];
		NSLog(@"x座標:%f y座標:%f",location.x,location.y);
        
        if (location.x < 40 && location.y < 80) {
            _originalFrame = _headerView.frame;
            _originalNextFrame = _nextHeaderView.frame;
            _isSwipe = YES;
            _touchBeganPoint.x = location.x;
        }
	}
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	// マルチタッチ
    for (UITouch *touch in touches) {
		CGPoint location = [touch locationInView:self.view];
//		NSLog(@"x座標:%f y座標:%f",location.x,location.y);
        if (_isSwipe) {
            float moveX = _touchBeganPoint.x - location.x;
            if (moveX > 0) {
                return;
            }
            NSLog(@"moveX:%f", moveX);
            _headerView.frame = CGRectMake(_originalFrame.origin.x - moveX, _originalFrame.origin.y, _originalFrame.size.width, _originalFrame.size.height);
            
            _nextHeaderView.frame = CGRectMake(_originalNextFrame.origin.x - moveX, _originalNextFrame.origin.y, _originalNextFrame.size.width, _originalNextFrame.size.height);
        }
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	// マルチタッチ
    for (UITouch *touch in touches) {
		CGPoint location = [touch locationInView:self.view];
		NSLog(@"x座標:%f y座標:%f",location.x,location.y);
        
        if (_isSwipe && location.x > 180) {
            _headerView.frame = CGRectMake(320, _originalFrame.origin.y, _originalFrame.size.width, _originalFrame.size.height);
            _nextHeaderView.frame = CGRectMake(0, _originalNextFrame.origin.y, _originalNextFrame.size.width, _originalNextFrame.size.height);
            
            [self gotoMainView];
        } else if (_isSwipe) {
            NSLog(@"swipe cancel");
            _headerView.frame = _originalFrame;
            _nextHeaderView.frame = _originalNextFrame;
        }
	}
}

- (void)gotoMainView
{
    [self performSegueWithIdentifier:@"gotoMainView" sender:self];
}

//- (void)swipeRight:(UISwipeGestureRecognizer *)sender
//{
//    NSLog(@"右スワイプがされました．");
//    [self performSegueWithIdentifier:@"gotoMainView" sender:self];
//}



@end
