//
//  SKJoin.m
//  sportking
//
//  Created by yang on 13/3/11.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "SKJoin.h"
#import "sportcell.h"
#import "SKSelectKind.h"
#import "SKJoinDetail.h"
#import "FPPopoverController.h"
#import "SKAPI.h"
#import "SKAddActivity.h"
#import "BDKNotifyHUD.h"

@interface SKJoin ()<selectKindDelegate,SKAPIDelegate>{
    FPPopoverController *popover;
}

-(void)changeKind;
@end

@implementation SKJoin
@synthesize table;
@synthesize hiddenBtn;
@synthesize sportImg;

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
    
    [self.navigationItem setTitle:@"活動"];
    if ([SKAPI sharedSKAPI].userID == nil) {
        for (UIView *view in self.view.subviews) {
            [view setHidden:YES];
        }
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"登入" style:UIBarButtonItemStyleDone target:self action:@selector(login)];
        [self login];
    }else{
        for (UIView *view in self.view.subviews) {
            [view setHidden:NO];
        }
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"分類" style:UIBarButtonItemStyleDone target:self action:@selector(changeKind)];
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"我的活動" style:UIBarButtonItemStyleDone target:self action:@selector(myActivity)];
    }
    
    table.hidden = NO;
    
    
    joinDatas = [[NSMutableArray alloc] init];
    [[SKAPI sharedSKAPI] setDelegate:self];
//    [[SKAPI sharedSKAPI] getGroupDataBy:1];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    [self.navigationItem setTitle:@"活動"];
    if ([SKAPI sharedSKAPI].userID == nil) {
        for (UIView *view in self.view.subviews) {
            [view setHidden:YES];
        }
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"登入" style:UIBarButtonItemStyleDone target:self action:@selector(login)];
    }else{
        for (UIView *view in self.view.subviews) {
            [view setHidden:NO];
        }
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"分類" style:UIBarButtonItemStyleDone target:self action:@selector(changeKind)];
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"我的活動" style:UIBarButtonItemStyleDone target:self action:@selector(myActivity)];
        [[SKAPI sharedSKAPI] getGroupDataBy:1];
    }
    
}

-(void)myActivity{
    
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
    
    UIViewController* viewController = [storyboard instantiateViewControllerWithIdentifier:@"SKMyActivity"];
    [self.navigationController pushViewController:viewController animated:YES];
}

-(void)login{
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
    
    UIViewController* viewController = [storyboard instantiateViewControllerWithIdentifier:@"SKLogin"];
    [self presentModalViewController:viewController animated:YES];
}

#pragma mark -tableView delegate

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [joinDatas count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"sportcell";
    NSDictionary *dic = [joinDatas objectAtIndex:[indexPath row]];
    
    sportcell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray* nibObjs = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:nil options:nil];
        cell = [nibObjs objectAtIndex:0];
    }
    
    NSString *people = [NSString stringWithFormat:@"%@",[dic objectForKey:@"number_of_people"]];
    cell.people.text = people;
    cell.name.text = [dic objectForKey:@"active_name"];
    cell.descript.text = [dic objectForKey:@"site"];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
    
    NSDictionary *dic = [joinDatas objectAtIndex:[indexPath row]];
    bool isjoin = NO;
    
    for (NSDictionary *dic in [SKAPI sharedSKAPI].activitys) {
        NSString *joinNo = [dic objectForKey:@"no"];
        if ([joinNo isEqualToString:[dic objectForKey:@"no"]]) {
            isjoin = YES;
        }
    }
    SKJoinDetail* joinViewController = [storyboard instantiateViewControllerWithIdentifier:@"SKJoinDetail"];
    [joinViewController setData:dic];
    [joinViewController setIsJoined:isjoin];
    
    [joinViewController.navigationItem setTitle:[dic objectForKey:@"active_name"]];
    [self.navigationController pushViewController:joinViewController animated:YES];
    
}

-(void)changeKind{
    [self popover:hiddenBtn];
}

-(void)popover:(id)sender
{
    //the controller we want to present as a popover
    SKSelectKind* mainViewController = [[SKSelectKind alloc] init];
    mainViewController.delegate = self;
    popover = [[FPPopoverController alloc] initWithViewController:mainViewController];
    
    //popover.arrowDirection = FPPopoverArrowDirectionAny;
    popover.tint = FPPopoverDefaultTint;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        popover.contentSize = CGSizeMake(300, 500);
    }
    popover.arrowDirection = FPPopoverArrowDirectionAny;
    
    //sender is the UIButton view
    [popover presentPopoverFromView:sender];
}

-(void)selectKindDidFinish:(int)kind{
    [[SKAPI sharedSKAPI] getGroupDataBy:kind];
    [popover dismissPopoverAnimated:YES];
    NSString *image = nil;
    switch (kind) {
        case 1:
            image = @"basketball.png";
            break;
        case 2:
            image = @"soccer.png";
            break;
        case 3:
            image = @"badminton.png";
            break;
        case 4:
            image = @"baseball.png";
            break;
        case 5:
            image = @"tennis.png";
            break;
        case 6:
            image = @"volleyball.png";
            break;
        default:
            break;
    }
    self.sportImg.image = [UIImage imageNamed:image];

}

-(IBAction)addActivity:(id)sender{
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
    SKAddActivity *addView = [storyboard instantiateViewControllerWithIdentifier:@"SKAddActivity"];
    
    [addView setTitle:@"建立活動"];
    [self.navigationController presentModalViewController:addView animated:YES];
}

#pragma mark -SKAPI
-(void)SKAPI:(SKAPI *)skAPI didGetGroupData:(NSDictionary *)result{
//    NSLog(@"get activity  %@",result);
    [joinDatas removeAllObjects];
    
    for (NSDictionary *dic in result) {
        [joinDatas addObject:dic];
    }
    [table reloadData];
}



@end
