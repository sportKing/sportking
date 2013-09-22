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
@optional
#pragma mark - GetDataResponse
- (void)SKAPI:(SKAPI *)skAPI didGetPlaceData:(NSDictionary *)result;
- (void)SKAPI:(SKAPI *)skAPI didGetGroupData:(NSDictionary *)result;
- (void)SKAPI:(SKAPI *)skAPI didGetRuleData:(NSDictionary *)result;
- (void)SKAPI:(SKAPI *)skAPI didGetTeachData:(NSDictionary *)result;
- (void)SKAPI:(SKAPI *)skAPI didGetMessageData:(NSDictionary *)result;
- (void)SKAPI:(SKAPI *)skAPI didGetJoinMemberData:(NSDictionary *)result;
- (void)SKAPI:(SKAPI *)skAPI didGetMyActivyData:(NSDictionary *)result;

@end

@interface SKAPI : NSObject{
    id<SKAPIDelegate> delegate;
    NSString *userID_;
}
@property(nonatomic,readwrite,retain)NSString *userID;
@property (nonatomic, readwrite, retain)id<SKAPIDelegate> delegate;

/* Share System*/
+(SKAPI *) sharedSKAPI;

/* get data */
-(void)getPlaceDataByKind:(int)kind X:(float)X Y:(float)Y;  /* 取得場地資料 */
-(void)getGroupDataBy:(int)kind;                            /* 取得某球類活動 */
-(void)getRuleDataByKind:(int)kind;                         /* 取得某球類規則 */
-(void)getTeachDataByKind:(int)kind;                        /* 取得某球類教學 */
-(void)getJoinMemberFromJoinID:(NSString*)joinID;           /* 取得活動參加者 */
-(void)getJoinMessageFromJoinID:(NSString*)joinID;          /* 取得活動留言 */
-(void)getMyActivity;                                       /* 取得我參加的活動 */

/* send data */
-(void)sendPostNewJoinFromArguments:(NSDictionary*)arguments;   /* 創造一個新活動 */
-(void)sendJoinActiveFromArguments:(NSDictionary*)arguments;    /* 加入一個活動 */
-(void)sendJoinMessageFromArguments:(NSDictionary*)arguments;   /* 在活動留言 */

@end
