//
//  SKSelectJind.m
//  sportking
//
//  Created by yang on 13/3/13.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "SKSelectKind.h"

@interface SKSelectKind ()

@end

@implementation SKSelectKind
@synthesize delegate;

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)button_click:(id)sender{
    int tag = [((UIButton*)sender) tag];

    if ([self.delegate respondsToSelector:@selector(selectKindDidFinish:)]) {
        [self.delegate selectKindDidFinish:tag];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
