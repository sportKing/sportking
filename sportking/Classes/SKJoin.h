//
//  SKJoin.h
//  sportking
//
//  Created by yang on 13/3/11.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface SKJoin : UIViewController{
    BOOL isShowMap;
    NSMutableArray *names;
    NSMutableArray *peoples;
    NSMutableArray *descripts;

}


@property(nonatomic,readwrite,retain)IBOutlet UITableView *table;
@property(nonatomic,readwrite,retain)IBOutlet MKMapView *map;
@end
