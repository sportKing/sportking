//
//  SKKnowledge.h
//  sportking
//
//  Created by yang on 13/3/11.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SKKnowledge : UIViewController{
    NSMutableArray *names;
}
@property(nonatomic,readwrite,retain)IBOutlet UIButton *hiddenBtn;
@property (retain, nonatomic) IBOutlet UITableView *table;


@end
