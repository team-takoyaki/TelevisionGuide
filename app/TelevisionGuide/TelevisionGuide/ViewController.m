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
-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation*)newLocation fromLocation:(CLLocation*)oldLocation;
-(void)locationManager:(CLLocationManager*)manager didUpdateHeading:(CLHeading*)newHeading;

@property (nonatomic, strong) CLLocationManager *lm;

@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic) BOOL isSwipe;
@property (nonatomic, strong) UIImageView *nextHeaderView;
@property (nonatomic) CGPoint touchBeganPoint;
@property (nonatomic) CGRect originalNextFrame;
@property (nonatomic) CGRect originalFrame;
@end

@implementation ViewController

@synthesize isSwipe = _isSwipe;
@synthesize nextHeaderView = _nextHeaderView;
@synthesize headerView = _headerView;
@synthesize touchBeganPoint = _touchBeganPoint;

- (void)viewDidLoad
{
    [super viewDidLoad];

//    UISwipeGestureRecognizer *swipeLeftGesture =
//    [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeLeft:)];
//    swipeLeftGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    
    AppManager *manager = [AppManager sharedManager];
    
    _lm = [[CLLocationManager alloc] init];
    _lm.delegate = self;
    _lm.distanceFilter = 100.0;
    _lm.desiredAccuracy = kCLLocationAccuracyHundredMeters;
//    [_lm startUpdatingLocation];
//    [_lm startUpdatingHeading];
//    [manager requestAppList];
    
//    [manager requestIPAddress];
    [manager requestMusicList];
    
    _nextHeaderView = [[UIImageView alloc] initWithFrame:CGRectMake(_headerView.frame.size.width, _headerView.frame.origin.y, 320, 55)];
    [_nextHeaderView setImage:[UIImage imageNamed:@"remember_title_2.png"]];
    [self.view addSubview:_nextHeaderView];
    
    self.headerView.userInteractionEnabled = YES;
  
//    [self.headerView addGestureRecognizer:swipeLeftGesture];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(onRefresh:) forControlEvents:UIControlEventValueChanged];
    _refreshControl = refreshControl;
    [_tableView addSubview:refreshControl];
    
    [_tableView registerClass:[CustomTableViewCell class] forCellReuseIdentifier:@"CustomCell"];
   
    [_tableView setDelegate:_tableView];
    [_tableView setDataSource:_tableView];
    
//    AppManager *manager = [AppManager sharedManager];
    [manager updateRecommendWithTarget:self selector:@selector(onUpdateTableViewCell)];
   
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)onUpdateTableViewCell
{
    AppManager *manager = [AppManager sharedManager];
    self.tableView.programs = (NSMutableArray *)[manager recommend];
    
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

- (void)swipeLeft:(UISwipeGestureRecognizer *)sender
{
    NSLog(@"左スワイプがされました．");
    
    [self performSegueWithIdentifier:@"gotoRememberView" sender:self];
}

- (void)gotoRememberView
{
    [self performSegueWithIdentifier:@"gotoRememberView" sender:self];
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
        
        if (location.x > 290) {
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
        
        if (_isSwipe && location.x < 140) {
            _headerView.frame = CGRectMake(320, _originalFrame.origin.y, _originalFrame.size.width, _originalFrame.size.height);
            _nextHeaderView.frame = CGRectMake(00, _originalNextFrame.origin.y, _originalNextFrame.size.width, _originalNextFrame.size.height);
            
            [self gotoRememberView];
        } else if (_isSwipe) {
            NSLog(@"swipe cancel");
            _headerView.frame = _originalFrame;
            _nextHeaderView.frame = _originalNextFrame;
        }
	}
}

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    
    NSLog(@"場所:%f %f", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
    AppManager *m = [AppManager sharedManager];
    [m requestGeoList:[NSString stringWithFormat:@"%f,%f", newLocation.coordinate.latitude, newLocation.coordinate.longitude]];
    [_lm stopUpdatingLocation];
}

-(void)locationManager:(CLLocationManager*)manager didUpdateHeading:(CLHeading*)newHeading
{
    if (newHeading.headingAccuracy < 0) return;

    CLLocationDirection theHeading = ((newHeading.trueHeading > 0) ? newHeading.trueHeading : newHeading.magneticHeading);
    NSLog(@"場所:%@",  [NSString stringWithFormat:@"Direction : %f", theHeading]);
    
    AppManager *m = [AppManager sharedManager];
    [m requestCompusList:[NSString stringWithFormat:@"%f", theHeading]];
    
    [_lm stopUpdatingHeading];
}


@end
