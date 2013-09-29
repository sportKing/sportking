//
//  SKJoin.h
//  sportking
//
//  Created by yang on 13/3/11.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKAddActivity.h"

@interface SKJoin : UIViewController{
    NSMutableArray *joinDatas;
}

@property(nonatomic,readwrite,retain)IBOutlet UITableView *table;
@property(nonatomic,readwrite,retain)IBOutlet UIButton *hiddenBtn;
@property(nonatomic,readwrite,retain)IBOutlet UIImageView *sportImg;

-(IBAction)addActivity:(id)sender;

@end
