//
//  SKFindPlace.h
//  sportking
//
//  Created by yang on 13/3/9.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface SKFindPlace : UIViewController{
    BOOL isShowMap;
    NSMutableArray *placeDic;
    int selectIndex;
}

@property(nonatomic,readwrite,retain)IBOutlet UITableView *table;
@property(nonatomic,readwrite,retain)IBOutlet MKMapView *map;
@property(nonatomic,readwrite,retain)IBOutlet UIButton *hiddenBtn;
@property(nonatomic,readwrite,retain)IBOutlet UIImageView *sportImg;

@end
