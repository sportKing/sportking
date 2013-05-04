//
//  SKSelectJind.h
//  sportking
//
//  Created by yang on 13/3/13.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol selectKindDelegate <NSObject>

-(void)selectKindDidFinish:(int)kind;

@end

@interface SKSelectKind : UIViewController
@property(nonatomic,readwrite,retain)id<selectKindDelegate> delegate;

-(IBAction)button_click:(id)sender;
@end
