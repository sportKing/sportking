//
//  mapCell.h
//  sportking
//
//  Created by yang on 13/9/28.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface mapCell : UITableViewCell

@property (retain, nonatomic) IBOutlet MKMapView *map;
@property(nonatomic,readwrite,assign)double x;
@property(nonatomic,readwrite,assign)double y;
@property(nonatomic,readwrite,retain)NSString *address;
-(void)setLocation;
@end
