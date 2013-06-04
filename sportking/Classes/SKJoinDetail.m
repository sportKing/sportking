//
//  SKJoinDetail.m
//  sportking
//
//  Created by yang on 13/5/8.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "SKJoinDetail.h"
#import "BDKNotifyHUD.h"

@interface SKJoinDetail ()

@end

@implementation SKJoinDetail

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
    // Do any additional setup after loading the view from its nib.
    [self.navigationController.visibleViewController setTitle:@"一起打球吧！"];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"退出" style:UIBarButtonItemStyleDone target:self action:@selector(submit)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) submit{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"確定要退出揪團嗎？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"確定", nil];
    [alert show];
    [alert release];
    /*
    // Create the HUD object
    BDKNotifyHUD *hud = [BDKNotifyHUD notifyHUDWithImage:[UIImage imageNamed:@"Checkmark.png"]
                                                    text:@"參加成功"];
    hud.center = CGPointMake(self.view.center.x, self.view.center.y - 20);
    
    // Animate it, then get rid of it. These settings last 1 second, takes a half-second fade.
    [self.view addSubview:hud];
    [hud presentWithDuration:1.0f speed:0.5f inView:self.view completion:^{
        [hud removeFromSuperview];
    }];
    */
}
- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    // the user clicked one of the OK/Cancel buttons
    if (buttonIndex == 1)
    {
        NSLog(@"ok");
    }else{
        NSLog(@"cancel");
    }
}

@end
