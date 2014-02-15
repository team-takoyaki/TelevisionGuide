//
//  ViewController.m
//  TelevisionGuide
//
//  Created by Kashima Takumi on 2014/02/11.
//  Copyright (c) 2014年 TEAM TAKOYAKI. All rights reserved.
//

#import "ViewController.h"
#import "AppManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    AppManager *manager = [AppManager sharedManager];
    NSString *uuid = [manager UUID];
    NSLog(@"UUID:%@", uuid);
    
    [manager updateRecommendWithTarget:self selector:@selector(onUpdate)];
    
   
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)onUpdate
{
    AppManager *manager = [AppManager sharedManager];
    NSArray *recommend = [manager recommend];
    for (Program *p in recommend) {
        NSLog(@"%@", [p programTitle]);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
