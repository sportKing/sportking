//
//  SKAddActivity.h
//  sportking
//
//  Created by yang on 13/9/25.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>


@interface SKAddActivity : UIViewController{
    int type;
    float X,Y;
    CLLocationCoordinate2D nowLocation;
}
@property (retain, nonatomic) IBOutlet UIScrollView *scrollview;
@property (retain, nonatomic) IBOutlet UITextField *activityName;
@property (retain, nonatomic) IBOutlet UIButton *typeBtn;
@property (retain, nonatomic) IBOutlet UITextField *activityTime;
@property (retain, nonatomic) IBOutlet UITextField *activityLocation;
@property (retain, nonatomic) IBOutlet MKMapView *map;
@property (retain, nonatomic) IBOutlet UITextView *activityContent;

-(IBAction)changeKind:(id)sender;
-(IBAction)tapView:(id)sender;

@end
