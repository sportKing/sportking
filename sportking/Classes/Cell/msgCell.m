//
//  msgCell.m
//  sportking
//
//  Created by yang on 13/9/28.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "msgCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation msgCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_headImage release];
    [_nameLabel release];
    [_msgLabel release];
    [super dealloc];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.headImage.layer.masksToBounds = YES;
    self.headImage.layer.cornerRadius = self.headImage.frame.size.height/2;
}

@end
