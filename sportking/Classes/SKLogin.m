//
//  SKLogin.m
//  sportking
//
//  Created by yang on 13/9/29.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "SKLogin.h"
#import "SKAPI.h"
#import "BDKNotifyHUD.h"

@interface SKLogin ()

@end

@implementation SKLogin

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
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancle)];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)cancle{
    [self dismissModalViewControllerAnimated:YES];
}

-(IBAction)login:(id)sender{
    [[FacebookNetwork shareFacebook] login];
    [[FacebookNetwork shareFacebook] setDelegate:self];
}

#pragma mark -facebook delegate
-(void)facebookLoginSuccess{
    [[FacebookNetwork shareFacebook] requestME];
}


-(void)facebookRequestDidFinish:(id)result{
    if ([FacebookNetwork shareFacebook].fbState == FacebookStateTypeMyAboutME) {
        NSDictionary *dic = (NSDictionary*)result;
        [[SKAPI sharedSKAPI] setUserID:[dic objectForKey:@"id"]];
        [[SKAPI sharedSKAPI] setUserName:[dic objectForKey:@"name"]];
        [defaults setObject:[SKAPI sharedSKAPI].userID forKey:@"SK_USERID"];
        [defaults setObject:[SKAPI sharedSKAPI].userName forKey:@"SK_USERNAME"];
        [defaults synchronize];
        
        
        BDKNotifyHUD *hud = [BDKNotifyHUD notifyHUDWithImage:[UIImage imageNamed:@"Checkmark.png"]
                                                        text:@"登入成功"];
        hud.center = CGPointMake(self.view.center.x, self.view.center.y - 20);
        
        // Animate it, then get rid of it. These settings last 1 second, takes a half-second fade.
        [self.view.window addSubview:hud];
        [hud presentWithDuration:1.0f speed:0.5f inView:self.view completion:^{
            [hud removeFromSuperview];
        }];
        [self dismissModalViewControllerAnimated:YES];
    }
    
}


@end
