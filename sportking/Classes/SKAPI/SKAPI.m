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
@synthesize userID = userID_;
static SKAPI* sharedSKAPI = nil;
NSString *const API_URL = @"http://huang-yao-building.com/db/API.php";

+(SKAPI *) sharedSKAPI {
	if(sharedSKAPI == nil){
		sharedSKAPI = [[SKAPI alloc] init];
	}
	return sharedSKAPI;
}

-(id)init{
    self = [super init];
    if (self) {
        self.userID = [[NSUserDefaults standardUserDefaults] objectForKey:@"SK_USERID"];
    }
    return self;
}


#pragma mark - get data

-(void)getPlaceDataByKind:(int)kind X:(float)X Y:(float)Y{    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:API_URL]];
    [request setPostValue:@"getPlace" forKey:@"method"];
    [request setPostValue:[NSString stringWithFormat:@"%d",kind] forKey:@"id"];
    [request setPostValue:[NSString stringWithFormat:@"%f",X] forKey:@"x"];
    [request setPostValue:[NSString stringWithFormat:@"%f",Y] forKey:@"y"];
    [request setRequestMethod:@"POST"];
    
    [request setCompletionBlock:^{
        NSString *response = [request responseString];
        NSDictionary *JSON = [response JSONValue];
#ifdef DEBUG_MODE
        NSLog(@"get Place %@ ",response);
#endif
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
    
    [request setCompletionBlock:^{
        NSString *response = [request responseString];
        NSDictionary *JSON = [response JSONValue];
        
#ifdef DEBUG_MODE
        NSLog(@"get Rule %@ ",response);
#endif

        if ([delegate respondsToSelector:@selector(SKAPI:didGetRuleData:)]) {
            [delegate SKAPI:self didGetRuleData:JSON];
        }
    }];
    
    [request setFailedBlock:^{
        
    }];
    
    [request startAsynchronous];
}

-(void)getTeachDataByKind:(int)kind{
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:API_URL]];
    [request setPostValue:@"getteach" forKey:@"method"];
    [request setPostValue:[NSString stringWithFormat:@"%d",kind] forKey:@"id"];
    [request setRequestMethod:@"POST"];
    
    [request setCompletionBlock:^{
        NSString *response = [request responseString];
        NSDictionary *JSON = [response JSONValue];
        
#ifdef DEBUG_MODE
        NSLog(@"get Teach %@ ",response);
#endif
        
        if ([delegate respondsToSelector:@selector(SKAPI:didGetTeachData:)]) {
            [delegate SKAPI:self didGetTeachData:JSON];
        }
    }];
    
    [request setFailedBlock:^{
        
    }];
    
    [request startAsynchronous];
}

-(void)getJoinMemberFromJoinID:(NSString*)joinID{
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:API_URL]];
    [request setPostValue:@"getmember" forKey:@"method"];
    [request setPostValue:[NSString stringWithFormat:@"%@",joinID] forKey:@"id"];
    [request setRequestMethod:@"POST"];
    
    [request setCompletionBlock:^{
        NSString *response = [request responseString];
        NSDictionary *JSON = [response JSONValue];
        
#ifdef DEBUG_MODE
        NSLog(@"get Join Member %@ ",response);
#endif
        
        if ([delegate respondsToSelector:@selector(SKAPI:didGetJoinMemberData:)]) {
            [delegate SKAPI:self didGetJoinMemberData:JSON];
        }
    }];
    
    [request setFailedBlock:^{
        
    }];
    
    [request startAsynchronous];
}

-(void)getJoinMessageFromJoinID:(NSString*)joinID{
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:API_URL]];
    [request setPostValue:@"getmessage" forKey:@"method"];
    [request setPostValue:[NSString stringWithFormat:@"%@",joinID] forKey:@"id"];
    [request setRequestMethod:@"POST"];
    
    [request setCompletionBlock:^{
        NSString *response = [request responseString];
        NSDictionary *JSON = [response JSONValue];
        
#ifdef DEBUG_MODE
        NSLog(@"get Join Msg %@ ",response);
#endif
        
        if ([delegate respondsToSelector:@selector(SKAPI:didGetMessageData:)]) {
            [delegate SKAPI:self didGetMessageData:JSON];
        }
    }];
    
    [request setFailedBlock:^{
        
    }];
    
    [request startAsynchronous];
}

#pragma mark - send data

-(void)sendPostNewJoinFromArguments:(NSDictionary*)arguments{
//    Method=postgroup
//    id:哪一項運動的sport_no 		acative_name : 活動名稱			organizer	:主辦人名稱
//site:地點(地址)
//date:日期時間(datetime)		total_number_of_people: 上線人數		x:經度
//y:緯度
//region:地區

//    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:API_URL]];
//    [request setPostValue:@"join" forKey:@"method"];
//    [request setPostValue:[NSString stringWithFormat:@"%@",[arguments objectForKey:@"joinID"]] forKey:@"no"];
//    [request setPostValue:[NSString stringWithFormat:@"%@",[arguments objectForKey:@"joinerID"]] forKey:@"id"];
//    [request setRequestMethod:@"POST"];
//    
//    [request setCompletionBlock:^{
//        
//    }];
//    
//    [request setFailedBlock:^{
//        
//    }];
//    
//    [request startAsynchronous];
}

-(void)sendJoinActiveFromArguments:(NSDictionary*)arguments{
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:API_URL]];
    [request setPostValue:@"join" forKey:@"method"];
    [request setPostValue:[NSString stringWithFormat:@"%@",[arguments objectForKey:@"joinID"]] forKey:@"no"];
    [request setPostValue:[NSString stringWithFormat:@"%@",[arguments objectForKey:@"joinerID"]] forKey:@"id"];
    [request setRequestMethod:@"POST"];
    
    [request setCompletionBlock:^{
        
    }];
    
    [request setFailedBlock:^{
        
    }];
    
    [request startAsynchronous];
}

-(void)sendJoinMessageFromArguments:(NSDictionary*)arguments{
//no:	這留言隸屬於哪一團的no
//name:	留言者姓名
//content:	留言內容
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:API_URL]];
    [request setPostValue:@"postmessage" forKey:@"method"];
    [request setPostValue:[NSString stringWithFormat:@"%@",[arguments objectForKey:@"joinID"]] forKey:@"no"];
    [request setPostValue:[NSString stringWithFormat:@"%@",[arguments objectForKey:@"name"]] forKey:@"name"];
    [request setPostValue:[NSString stringWithFormat:@"%@",[arguments objectForKey:@"content"]] forKey:@"content"];
    [request setRequestMethod:@"POST"];
    
//    [request setCompletionBlock:^{
//        
//    }];
//    
//    [request setFailedBlock:^{
//        
//    }];
    
    [request startAsynchronous];
}

@end
