//
//  SKTeachingDetail.h
//  sportking
//
//  Created by Ruei Yan, Huang on 13/6/5.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SKTeachingDetail : UIViewController
@property (retain, nonatomic) IBOutlet UIWebView *webview;
@property (nonatomic,readwrite,retain)NSString *videourl;
- (void)embedYouTube:(NSString*)url;

@end
