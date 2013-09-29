//
//  mapCell.m
//  sportking
//
//  Created by yang on 13/9/28.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "mapCell.h"

@implementation mapCell
@synthesize x,y,address;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_map release];
    [super dealloc];
}
-(void)layoutSubviews{
    [super layoutSubviews];
    [self setLocation];
}

-(void)setLocation{
    
    MKCoordinateSpan span;
    MKCoordinateRegion region;
    CLLocationCoordinate2D coordinate;
    
    coordinate.latitude = x;
    coordinate.longitude = y;
    span.latitudeDelta=0.010;
    span.longitudeDelta=0.010;
    region.span = span;
    region.center = coordinate;
    
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    annotation.title = @"活動地點";
    annotation.subtitle = address;
    annotation.coordinate = coordinate;
    [self.map addAnnotation:annotation];
    [self.map setRegion:[self.map regionThatFits:region] animated:YES];
    
}
@end
