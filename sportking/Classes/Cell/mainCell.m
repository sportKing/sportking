//
//  mainCell.m
//  sportking
//
//  Created by yang on 13/9/28.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "mainCell.h"

@implementation mainCell

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
    [_title release];
    [_content release];
    [super dealloc];
}
@end
