//
//  SKMapDetail.m
//  sportking
//
//  Created by yang on 13/5/8.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "SKMapDetail.h"

@interface SKMapDetail ()

@end

@implementation SKMapDetail
@synthesize sitename,address,map,data;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.sitename.text = [data objectForKey:@"sitename"];
    self.address.text = [data objectForKey:@"site"];
    
    //地圖加地標
    
    MKCoordinateSpan span;
    MKCoordinateRegion region;
    CLLocationCoordinate2D coordinate;
    
    coordinate.latitude = [[data objectForKey:@"x"] floatValue];
    coordinate.longitude = [[data objectForKey:@"y"] floatValue];
    span.latitudeDelta=0.010;
    span.longitudeDelta=0.010;
    region.span = span;
    region.center = coordinate;
    
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    annotation.title = [data objectForKey:@"sitename"];
    annotation.coordinate = coordinate;
    [self.map addAnnotation:annotation];
    [self.map setRegion:[self.map regionThatFits:region] animated:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setAddress:nil];
    [self setMap:nil];
    [super viewDidUnload];
}
@end
