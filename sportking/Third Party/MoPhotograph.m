//
//  MoPhotograph.m
//  Record
//
//  Created by CANUOVRX on 12/12/8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MoPhotograph.h"
#import <QuartzCore/QuartzCore.h>

@implementation MoPhotograph
@synthesize photoSize;
//@synthesize target,selector;
@synthesize delegate;

-(void)loadRequestURL:(NSString*)url user_id:(NSString*)uid{

    photoSize = MoPhotographSize180x180;
    
    [self.layer setCornerRadius:3];
    [self.layer setMasksToBounds:YES];
//    uid_ = [NSString stringWithString:uid];
    uid_ = [[NSString stringWithFormat:@"%@",uid] retain];
    
    NSString* path = [NSTemporaryDirectory() stringByAppendingFormat:@"FBPhoto:%@.jpg",uid_];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [self setImage:[UIImage imageWithContentsOfFile:path]];
    }else {
        if (url) {
            ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[url copy]]];
            request.delegate = self;
            [request setDownloadDestinationPath:path];
            [request startAsynchronous];
            /*
            activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            [activity setFrame:CGRectMake(0, 0, 50, 50)];
            [self addSubview:activity];
            
            [activity startAnimating];
            */
        }
    }
}
-(void)dealloc{
    [uid_ release];
    [super dealloc];
}
/*
-(void)requestFailed:(ASIHTTPRequest *)request{
    [activity stopAnimating];
    [activity removeFromSuperview];
    [activity release];
    activity = nil;
}
 */

-(void)requestFinished:(ASIHTTPRequest *)request{
//    [activity stopAnimating];
//    [activity removeFromSuperview];
//    [activity release];
//    activity = nil;
    
    NSString* path = [NSTemporaryDirectory() stringByAppendingFormat:@"FBPhoto:%@.jpg",uid_];
    UIImage* image = [UIImage imageWithContentsOfFile:path];
    [self setImage:image];
    if ([delegate respondsToSelector:@selector(reDraw)]) {
        [delegate performSelector:@selector(reDraw)];
    }
//    if (target) {
//        [target performSelector:@selector(selector)];
//    }
    
}

@end
