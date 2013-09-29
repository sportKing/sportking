//
//  msgCell.h
//  sportking
//
//  Created by yang on 13/9/28.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MoPhotograph.h"
@interface msgCell : UITableViewCell
@property (retain, nonatomic) IBOutlet MoPhotograph *headImage;
@property (retain, nonatomic) IBOutlet UILabel *nameLabel;
@property (retain, nonatomic) IBOutlet UITextView *msgLabel;

@end
