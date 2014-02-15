//
//  CutomTableViewCell.h
//  TelevisionGuide
//
//  Created by Kashima Takumi on 2014/02/16.
//  Copyright (c) 2014年 TEAM TAKOYAKI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTableViewCell : UITableViewCell
- (void)setProgramImage:(UIImage *)image;
- (void)setServiceName:(NSString *)text;
- (void)setProgramDate:(NSString *)text;
- (void)setProgramTime:(NSString *)text;
- (void)setProgramTitle:(NSString *)text;
- (void)setProgramSubTitle:(NSString *)text;
@end
