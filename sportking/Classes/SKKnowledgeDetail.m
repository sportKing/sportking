//
//  SKKnowledgeDetail.m
//  sportking
//
//  Created by Ruei Yan, Huang on 13/6/4.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "SKKnowledgeDetail.h"

@interface SKKnowledgeDetail ()

@end

@implementation SKKnowledgeDetail

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
	// Do any additional setup after loading the view.
    
    //接收影片網址
    //格式：http://www.youtube.com/embed/XXXXX
    //[self youtube:<#(NSString *)#>];
}

- (void)youtube:(NSString *)url{
    NSString *embedHTML =[NSString stringWithFormat:@"\
                          <html><head>\
                          <style type=\"text/css\">\
                          body {\
                          background-color: transparent;\
                          color: blue;\
                          }\
                          </style>\
                          </head><body style=\"margin:0\">\
                          <iframe height=\"200\" width=\"310\"      src=\"%@\"></iframe>\
                          </body></html>", url];
    
    self.webView.backgroundColor = [UIColor clearColor];
    [self.webView loadHTMLString:embedHTML baseURL:nil];
    [self.view addSubview:self.webView];
}


- (UIButton *)findButtonInView:(UIView *)view {
    UIButton *button = nil;
    if ([view isMemberOfClass:[UIButton class]]) {
        return (UIButton *)view;
    }
    if (view.subviews && [view.subviews count] > 0) {
        for (UIView *subview in view.subviews) {
            button = [self findButtonInView:subview];
            if (button) return button;
        }
    }
    return button;
}

- (void)dealloc {
    [_webView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setWebView:nil];
    [super viewDidUnload];
}
@end
