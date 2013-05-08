//
//  SKNetWork.m
//  sportking
//
//  Created by yang on 13/5/4.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "SKNetWork.h"
#import "AFNetworking.h"

@implementation SKNetWork
@synthesize delegate;

-(id)init{
    self = [super init];
    if (self) {
        
        
    }
    
    return self;
}

-(void)getPlaceData{
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:SERVERNAME]];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        if ([self.delegate respondsToSelector:@selector(networkDidReceivePlaceData)]) {
            [self.delegate networkDidReceivePlaceData:nil];
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response,NSError *error, id JSON) {
        NSLog(@"error:%@,response:%@",error,response);
    }];
    [operation start];
}


@end
