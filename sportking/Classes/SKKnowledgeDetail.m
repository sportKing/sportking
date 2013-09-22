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
@synthesize rule;
@synthesize textView;

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
    textView.text = rule;
	// Do any additional setup after loading the view.
    
}


@end
