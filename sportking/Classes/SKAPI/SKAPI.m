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
@synthesize userName = userName_;
@synthesize activitys = activitys_;
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
        self.userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"SK_USERNAME"];
        activitys_ = [[NSMutableArray alloc] init];
        NSLog(@"%@ %@",self.userID,self.userName);
        if (self.userID) {
            [self getMyActivity];
        }
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

-(void)getGroupDataBy:(int)kind{
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:API_URL]];
    [request setPostValue:@"getteam" forKey:@"method"];
    [request setPostValue:[NSString stringWithFormat:@"%d",kind] forKey:@"id"];
    [request setRequestMethod:@"POST"];
    
    [request setCompletionBlock:^{
        NSString *response = [request responseString];
        NSDictionary *JSON = [response JSONValue];
        
#ifdef DEBUG_MODE
        NSLog(@"get Group %@ ",response);
#endif
        
        if ([delegate respondsToSelector:@selector(SKAPI:didGetGroupData:)]) {
            [delegate SKAPI:self didGetGroupData:JSON];
        }
    }];
    
    [request startAsynchronous];
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
//    NSLog(@"joinid %@",joinID);
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:API_URL]];
    [request setPostValue:@"getmessage" forKey:@"method"];
    [request setPostValue:joinID forKey:@"team_no"];
    [request setRequestMethod:@"POST"];
    
    [request setCompletionBlock:^{
        NSString *response = [request responseString];
        NSDictionary *JSON = [response JSONValue];
        
#ifdef DEBUG_MODE
        NSLog(@"get Join Msg %@ ",JSON);
#endif
        
        if ([delegate respondsToSelector:@selector(SKAPI:didGetMessageData:)]) {
            [delegate SKAPI:self didGetMessageData:JSON];
        }
    }];
    
    [request setFailedBlock:^{
        
    }];
    
    [request startAsynchronous];
}

-(void)getMyActivity{
    [self.activitys removeAllObjects];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:API_URL]];
    [request setPostValue:@"getinfo" forKey:@"method"];
    [request setPostValue:self.userID forKey:@"fbid"];
    [request setRequestMethod:@"POST"];
    
    [request setCompletionBlock:^{
        NSString *response = [request responseString];
        NSDictionary *JSON = [response JSONValue];
        
#ifdef DEBUG_MODE
        NSLog(@"get myactivity %@ ",JSON);
#endif
        for (NSDictionary *dic in JSON) {
            [activitys_ addObject:dic];
//            [activitys_ addObject:[dic objectForKey:@"team_no"]];
        }
        
    }];
    
    [request setFailedBlock:^{
        
    }];
    
    [request startAsynchronous];
}

#pragma mark - send data

-(void)sendPostNewJoinFromArguments:(NSDictionary*)arguments{
    /*
     type : 球類
     userName:userName
     activeName: 活動名稱
     activeLocation:活動地點
     activeDate:活動時間
     activeContent:活動內容
     x:精度
     y:緯度
     */
//    NSLog(@"send team%@",arguments);
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:API_URL]];
    [request setPostValue:@"postteam" forKey:@"method"];
    [request setPostValue:[NSString stringWithFormat:@"%@",[arguments objectForKey:@"type"]] forKey:@"id"];
    [request setPostValue:self.userName forKey:@"organizer"];
    [request setPostValue:self.userID forKey:@"fbid"];
    [request setPostValue:[NSString stringWithFormat:@"%@",[arguments objectForKey:@"activeName"]] forKey:@"acative_name"];
    [request setPostValue:[NSString stringWithFormat:@"%@",[arguments objectForKey:@"activeLocation"]] forKey:@"site"];
    [request setPostValue:[NSString stringWithFormat:@"%@",[arguments objectForKey:@"activeDate"]] forKey:@"date"];
    [request setPostValue:[NSString stringWithFormat:@"%@",[arguments objectForKey:@"activeContent"]] forKey:@"content"];
    [request setPostValue:[NSString stringWithFormat:@"%@",[arguments objectForKey:@"x"]] forKey:@"x"];
    [request setPostValue:[NSString stringWithFormat:@"%@",[arguments objectForKey:@"y"]] forKey:@"y"];
    [request setRequestMethod:@"POST"];
    
    [request setCompletionBlock:^{
        [self getMyActivity];
    }];
    [request startAsynchronous];
}

-(void)sendJoinActiveByID:(NSString*)activeId{
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:API_URL]];
    [request setPostValue:@"join" forKey:@"method"];
    [request setPostValue:[NSString stringWithFormat:@"%@",activeId] forKey:@"no"];
    [request setPostValue:self.userID forKey:@"fbid"];
    [request setRequestMethod:@"POST"];
    
    [request setCompletionBlock:^{
        [self getMyActivity];
    }];
    
    [request startAsynchronous];
}

-(void)sendLeaveActiveByID:(NSString *)activeId{
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:API_URL]];
    [request setPostValue:@"cancle" forKey:@"method"];
    [request setPostValue:[NSString stringWithFormat:@"%@",activeId] forKey:@"no"];
    [request setPostValue:self.userID forKey:@"fbid"];
    [request setRequestMethod:@"POST"];
    
    [request setCompletionBlock:^{
        [self getMyActivity];
    }];
    
    [request startAsynchronous];
}

-(void)sendJoinMessageFromArguments:(NSDictionary*)arguments{
//no:	這留言隸屬於哪一團的no
//fbid: 留言者fbid
//name:	留言者姓名
//content:	留言內容

    NSLog(@"%@",arguments);
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:API_URL]];
    [request setPostValue:@"postmessage" forKey:@"method"];
    [request setPostValue:[NSString stringWithFormat:@"%@",[arguments objectForKey:@"no"]] forKey:@"no"];
    [request setPostValue:self.userName forKey:@"name"];
    [request setPostValue:self.userID forKey:@"fbid"];
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
