//
//  SKAPI.h
//  sportking
//
//  Created by yang on 13/6/4.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SKAPI;

@protocol SKAPIDelegate <NSObject>

#pragma mark - GetDataResponse
- (void)SKAPI:(SKAPI *)skAPI didGetPlaceData:(NSDictionary *)result;
- (void)SKAPI:(SKAPI *)skAPI didGetGroupData:(NSDictionary *)result;
- (void)SKAPI:(SKAPI *)skAPI didGetRuleData:(NSDictionary *)result;
- (void)SKAPI:(SKAPI *)skAPI didGetTeachData:(NSDictionary *)result;
- (void)SKAPI:(SKAPI *)skAPI didGetMessageData:(NSDictionary *)result;
- (void)SKAPI:(SKAPI *)skAPI didGetJoinMemberData:(NSDictionary *)result;

@end

@interface SKAPI : NSObject{
    id<SKAPIDelegate> delegate;
}
@property (nonatomic, readwrite, retain)id<SKAPIDelegate> delegate;

/* Share System*/
+(SKAPI *) sharedSKAPI;

/* get data */
-(void)getPlaceDataByKind:(int)kind X:(float)X Y:(float)Y;
-(void)getGroupData;
-(void)getRuleDataByKind:(int)kind;
-(void)getTeachData;
-(void)getJoinMemberFromJoinID:(NSString*)joinID;
-(void)getJoinMessageFromJoinID:(NSString*)joinID;

/* send data */
-(void)sendPostNewJoin:(NSDictionary*)dictionary;
-(void)sendJoinActiveFromJoinID:(NSString*)joinID joinerID:(NSString*)joinerID;
-(void)sendJoinMessageFromJoinID:(NSString*)joinID joinerID:(NSString*)joinerID;

@end
