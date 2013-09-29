//
//  SKMapDetail.h
//  sportking
//
//  Created by yang on 13/5/8.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface SKMapDetail : UIViewController{
    NSMutableArray *names;
}
@property(nonatomic,readwrite,retain)IBOutlet UILabel *sitename;
@property (retain, nonatomic) IBOutlet UITextView *address;
@property (retain, nonatomic) IBOutlet MKMapView *map;
@property(nonatomic,readwrite,retain)NSDictionary *data;

@end
