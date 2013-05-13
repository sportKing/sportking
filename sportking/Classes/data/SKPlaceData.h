//
//  SKPlaceData.h
//  sportking
//
//  Created by yang on 13/5/11.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SKPlaceData : NSObject

@property(nonatomic,readwrite,assign)int siteID;
@property(nonatomic,readwrite,retain)NSString* name;
@property(nonatomic,readwrite,retain)NSString* address;


@end
