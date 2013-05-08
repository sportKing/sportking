//
//  SKNetWork.h
//  sportking
//
//  Created by yang on 13/5/4.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SERVERNAME "127.0.0.1"

@protocol NewWorkDelegate <NSObject>
-(void)networkDidReceivePlaceData:(NSDictionary*)dic;
-(void)networkDidReceiveJoinData;
@end

@interface SKNetWork : NSObject{
    
}

@property(nonatomic,readwrite,retain)id<NewWorkDelegate> delegate;
-(void)getPlaceData;
@end
