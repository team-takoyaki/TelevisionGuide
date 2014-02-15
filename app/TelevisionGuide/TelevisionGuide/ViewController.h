//
//  ViewController.h
//  TelevisionGuide
//
//  Created by Kashima Takumi on 2014/02/11.
//  Copyright (c) 2014年 TEAM TAKOYAKI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTableView.h"
#import <CoreLocation/CoreLocation.h>
#import <AddressBookUI/AddressBookUI.h>

@interface ViewController : UIViewController <CLLocationManagerDelegate, ABPeoplePickerNavigationControllerDelegate>
@property (strong, nonatomic) IBOutlet CustomTableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *headerView;
@end
