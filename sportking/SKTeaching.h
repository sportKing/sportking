//
//  SKTeaching.h
//  sportking
//
//  Created by Ruei Yan, Huang on 13/6/5.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SKTeaching : UIViewController{
    NSMutableArray *names;
    NSMutableArray *teachDatas;
}

@property(nonatomic,readwrite,retain)IBOutlet UIButton *hiddenBtn;
@property (retain, nonatomic) IBOutlet UITableView *table;
@property(nonatomic,readwrite,retain)IBOutlet UIImageView *sportImg;
@end
