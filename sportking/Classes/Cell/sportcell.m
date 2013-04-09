//
//  sportcell.m
//  sport king
//
//  Created by yang on 13/2/21.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "sportcell.h"

@implementation sportcell
@synthesize people,name,descript;

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

@end
