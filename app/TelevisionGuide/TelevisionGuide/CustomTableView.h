//
//  CustomTableView.h
//  TelevisionGuide
//
//  Created by Kashima Takumi on 2014/02/16.
//  Copyright (c) 2014年 TEAM TAKOYAKI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JTTableViewGestureRecognizer.h"
#import "JTTransformableTableViewCell.h"
#import "UIColor+JTGestureBasedTableViewHelper.h"

@interface CustomTableView : UITableView <UITableViewDataSource, UITableViewDelegate, JTTableViewGestureEditingRowDelegate, JTTableViewGestureAddingRowDelegate, JTTableViewGestureMoveRowDelegate>
@property (nonatomic, strong) NSMutableArray *programs;
@property (nonatomic, strong) JTTableViewGestureRecognizer *tableViewRecognizer;
@end
