//
//  CallOutAnnotationVifew.h
//  IYLM
//
//  Created by Jian-Ye on 12-11-8.
//  Copyright (c) 2012年 Jian-Ye. All rights reserved.
//
#import <MapKit/MapKit.h>
#import "JingDianMapCell.h"

@interface CallOutAnnotationVifew : MKAnnotationView 

@property (nonatomic,retain)UIView *contentView;
@property (nonatomic,readwrite,retain)JingDianMapCell *cell;
@end
