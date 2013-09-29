//
//  SKMyActivity.m
//  sportking
//
//  Created by yang on 13/9/29.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "SKMyActivity.h"
#import "SKAPI.h"
#import "sportcell.h"
#import "SKJoinDetail.h"

@interface SKMyActivity ()

@end

@implementation SKMyActivity

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
    self.navigationItem.title = @"我的活動";
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.table reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -tableView delegate

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[SKAPI sharedSKAPI].activitys count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"sportcell";
    NSDictionary *dic = [[SKAPI sharedSKAPI].activitys objectAtIndex:[indexPath row]];
    
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
    
    NSDictionary *dic = [[SKAPI sharedSKAPI].activitys objectAtIndex:[indexPath row]];
    
    SKJoinDetail* joinViewController = [storyboard instantiateViewControllerWithIdentifier:@"SKJoinDetail"];
    [joinViewController setData:dic];
    [joinViewController setIsJoined:YES];
    
    [joinViewController.navigationItem setTitle:[dic objectForKey:@"active_name"]];
    [self.navigationController pushViewController:joinViewController animated:YES];
    
}

@end
