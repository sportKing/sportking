//
//  SKAPI.m
//  sportking
//
//  Created by yang on 13/6/4.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "SKAPI.h"
#import "ASIFormDataRequest.h"
#import "JSON.h"

@implementation SKAPI
@synthesize delegate;
static SKAPI* sharedSKAPI = nil;
NSString *const API_URL = @"http://huang-yao-building.com/db/API.php";

+(SKAPI *) sharedSKAPI {
	if(sharedSKAPI == nil){
		sharedSKAPI = [[SKAPI alloc] init];
	}
	return sharedSKAPI;
}


#pragma mark - get data

-(void)getPlaceDataByKind:(int)kind X:(float)X Y:(float)Y{    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:API_URL]];
    [request setPostValue:@"getPlace" forKey:@"method"];
    [request setPostValue:[NSString stringWithFormat:@"%d",kind] forKey:@"id"];
    [request setPostValue:[NSString stringWithFormat:@"%f",X] forKey:@"x"];
    [request setPostValue:[NSString stringWithFormat:@"%f",Y] forKey:@"y"];
    [request setRequestMethod:@"POST"];
    [request startAsynchronous];
    
    [request setCompletionBlock:^{
        NSString *response = [request responseString];
        NSDictionary *JSON = [response JSONValue];

        if ([delegate respondsToSelector:@selector(SKAPI:didGetPlaceData:)]) {
            [delegate SKAPI:self didGetPlaceData:JSON];
        }
    }];
    
    [request setFailedBlock:^{
    
    }];
    
    [request startAsynchronous];
}

-(void)getGroupData{
    
}

-(void)getRuleDataByKind:(int)kind{
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:API_URL]];
    [request setPostValue:@"getrule" forKey:@"method"];
    [request setPostValue:[NSString stringWithFormat:@"%d",kind] forKey:@"id"];
    [request setRequestMethod:@"POST"];
    [request startAsynchronous];
    
    [request setCompletionBlock:^{
        NSString *response = [request responseString];
        NSDictionary *JSON = [response JSONValue];

        if ([delegate respondsToSelector:@selector(SKAPI:didGetRuleData:)]) {
            [delegate SKAPI:self didGetRuleData:JSON];
        }
    }];
    
    [request setFailedBlock:^{
        
    }];
    
    [request startAsynchronous];

    
}

-(void)getTeachData{
    
}

-(void)getJoinMemberFromJoinID:(NSString*)joinID{
    
}

-(void)getJoinMessageFromJoinID:(NSString*)joinID{
    
}

#pragma mark - send data

-(void)sendPostNewJoin:(NSDictionary*)dictionary{
    
}

-(void)sendJoinActiveFromJoinID:(NSString*)joinID joinerID:(NSString*)joinerID{
    
}

-(void)sendJoinMessageFromJoinID:(NSString*)joinID joinerID:(NSString*)joinerID{
    
}

@end
