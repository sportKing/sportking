//
//  FacebookNetwork.h
//  petDog
//
//  Created by CANUOVRX on 12/12/11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "FBConnect.h"


typedef enum facebookStateType{
    FacebookStateTypeMyAboutME,
    FacebookStateTypeMyCheckins,
    FacebookStateTypeMyLikes,
    FacebookStateTypeFriendList,
    FacebookStateTypeFriendCheckins,
    FacebookStateTypeFriendLikes,
    FacebookStateTypeFriendAboutME,
}FacebookStateType;


@protocol facebookDelegate <NSObject>
@optional
-(void)facebookLoginSuccess;
-(void)facebookLoginFailed;
-(void)facebookRequestDidFinish:(id)result;
-(void)facebookRequestFail;
@end


@interface FacebookNetwork : NSObject{
    
    FacebookStateType fbState;
    int timeCnt;
    BOOL isReceiveData;
}
@property(nonatomic, readwrite, assign)id<facebookDelegate> delegate;
//@property(nonatomic, readwrite, retain)Facebook*            facebook;
@property (nonatomic, assign) BOOL appUsageCheckEnabled;
@property(nonatomic,readwrite,assign)FacebookStateType fbState;

+(FacebookNetwork*)shareFacebook;

-(void)login;

-(void)requestProfileInfo;
-(void)requestME;
-(void)requestFriendInfo;

- (void)sendRequest:(NSArray *) targeted ;
//-(void)requestWithGraphPath:(NSString*)path;
@end
