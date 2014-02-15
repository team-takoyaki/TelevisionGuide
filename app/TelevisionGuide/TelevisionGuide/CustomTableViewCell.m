//
//  CutomTableViewCell.m
//  TelevisionGuide
//
//  Created by Kashima Takumi on 2014/02/16.
//  Copyright (c) 2014年 TEAM TAKOYAKI. All rights reserved.
//

#import "CustomTableViewCell.h"

@interface CustomTableViewCell()
@property (nonatomic, strong) UIImageView *programImageView;
@property (nonatomic, strong) UILabel *serviceNameLabel;
@property (nonatomic, strong) UILabel *programDateLabel;
@property (nonatomic, strong) UILabel *programTimeLabel;
@property (nonatomic, strong) UILabel *programTitleLabel;
@property (nonatomic, strong) UILabel *programSubTitleLabel;
@end

@implementation CustomTableViewCell

@synthesize programImageView = _programImageView;
@synthesize serviceNameLabel = _serviceNameLabel;
@synthesize programDateLabel = _programDateLabel;
@synthesize programTimeLabel = _programTimeLabel;
@synthesize programTitleLabel = _programTitleLabel;
@synthesize programSubTitleLabel = _programSubTitleLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        self.textLabel.text = @"Hello";
//        UIImage *image = [UIImage imageNamed:@"suntv.png"];
//        [_imageView setImage:image];

        self.programImageView = [[UIImageView alloc] initWithFrame:CGRectMake(11, 10, 41, 41)];
        [_programImageView setBackgroundColor:[UIColor whiteColor]];
        [self.contentView addSubview:_programImageView];
        
        self.serviceNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(4, 48, 55, 23)];
//        [self.serviceNameLabel setBackgroundColor:[UIColor blueColor]];
        [_serviceNameLabel setBackgroundColor:[UIColor whiteColor]];
        [_serviceNameLabel setFont:[UIFont fontWithName:@"HiraKakuProN-W3" size:8]];
        [_serviceNameLabel setTextAlignment:NSTextAlignmentCenter];
        [_serviceNameLabel setTextColor:[UIColor grayColor]];
        [self.contentView addSubview:_serviceNameLabel];
        
        self.programDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(4, 60, 55, 23)];
        [_programDateLabel setBackgroundColor:[UIColor whiteColor]];
        [_programDateLabel setFont:[UIFont fontWithName:@"HiraKakuProN-W3" size:8]];
        [_programDateLabel setTextAlignment:NSTextAlignmentCenter];
        [_programDateLabel setTextColor:[UIColor grayColor]];
        [self.contentView addSubview:_programDateLabel];
        
        self.programTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 72, 70, 23)];
        [_programTimeLabel setBackgroundColor:[UIColor whiteColor]];
        [_programTimeLabel setFont:[UIFont fontWithName:@"HiraKakuProN-W3" size:8]];
        [_programTimeLabel setTextAlignment:NSTextAlignmentCenter];
        [_programTimeLabel setTextColor:[UIColor grayColor]];
        [self.contentView addSubview:_programTimeLabel];
       
        self.programTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, -5, 240, 58)];
        [_programTitleLabel setFont:[UIFont fontWithName:@"HiraKakuProN-W6" size:14]];
        [_programTitleLabel setTextAlignment:NSTextAlignmentLeft];
        [_programTitleLabel setBackgroundColor:[UIColor whiteColor]];
        _programTitleLabel.numberOfLines = 2;
        [self.contentView addSubview:_programTitleLabel];
        
        self.programSubTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, 42, 240, 50)];
        [_programSubTitleLabel setFont:[UIFont fontWithName:@"HiraKakuProN-W3" size:10]];
        [_programSubTitleLabel setTextAlignment:NSTextAlignmentLeft];
        [_programSubTitleLabel setTextColor:[UIColor grayColor]];
        _programSubTitleLabel.numberOfLines = 3;
        [self.contentView addSubview:_programSubTitleLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setProgramImage:(UIImage *)image
{
    [self.programImageView setImage:image];
}

- (void)setServiceName:(NSString *)text
{
    [self.serviceNameLabel setText:text];
}

- (void)setProgramDate:(NSString *)text
{
    [self.programDateLabel setText:text];
}

- (void)setProgramTime:(NSString *)text
{
    [self.programTimeLabel setText:text];
}

- (void)setProgramTitle:(NSString *)text
{
    NSMutableParagraphStyle *paragrahStyle = [[NSMutableParagraphStyle alloc] init];
    paragrahStyle.minimumLineHeight = 18;
    paragrahStyle.maximumLineHeight = 18;
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text];
    [attributedText addAttribute:NSParagraphStyleAttributeName
                           value:paragrahStyle
                           range:NSMakeRange(0, attributedText.length)];
    [self.programTitleLabel setAttributedText:attributedText];
}

- (void)setProgramSubTitle:(NSString *)text
{
    NSMutableParagraphStyle *paragrahStyle = [[NSMutableParagraphStyle alloc] init];
    paragrahStyle.minimumLineHeight = 14;
    paragrahStyle.maximumLineHeight = 14;
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text];
    [attributedText addAttribute:NSParagraphStyleAttributeName
                           value:paragrahStyle
                           range:NSMakeRange(0, attributedText.length)];
    [self.programSubTitleLabel setAttributedText:attributedText];
}
@end
