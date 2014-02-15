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
    NSString *uuid = [manager getUUID];
    NSLog(@"UUID:%@", uuid);
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
