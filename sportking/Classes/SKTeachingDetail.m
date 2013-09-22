//
//  SKTeachingDetail.m
//  sportking
//
//  Created by Ruei Yan, Huang on 13/6/5.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "SKTeachingDetail.h"

@interface SKTeachingDetail ()

@end

@implementation SKTeachingDetail
@synthesize webview;
@synthesize videourl;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    NSLog(@"view Did Load");
    [self embedYouTube:videourl];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)embedYouTube:(NSString*)url {
    CGRect rect = self.webview.frame;
    NSString* youtube = [NSString stringWithFormat:@"http://www.youtube.com/v/%@",url];
    NSString* embedHTML = @"\
    <html><head>\
    <style type=\"text/css\">\
    body {\
    background-color: transparent;\
    color: white;\
    }\
    </style>\
    </head><body style=\"margin:0\">\
    <embed id=\"yt\" src=\"%@\" type=\"application/x-shockwave-flash\" \
    width=\"%0.0f\" height=\"%0.0f\"></embed>\
    </body></html>";
//    NSLog(@"embed %@ %@",youtube,webview);
    NSString* html = [NSString stringWithFormat:embedHTML, youtube, rect.size.width, rect.size.height];
    [webview loadHTMLString:html baseURL:nil];
    [webview setOpaque:NO];
    //    [webview setContentMode:UIViewContentModeScaleAspectFill];
    //    [webview setScalesPageToFit:YES];
    //    [webview setAutoresizingMask:(UIViewAutoresizingFlexibleHeight| UIViewAutoresizingFlexibleWidth)];
    
}

@end
