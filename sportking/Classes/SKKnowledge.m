//
//  SKKnowledge.m
//  sportking
//
//  Created by yang on 13/3/11.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "SKKnowledge.h"
#import "SKSelectKind.h"
#import "FPPopoverController.h"
@interface SKKnowledge ()<selectKindDelegate>{
    
    FPPopoverController *popover;
}

@end

@implementation SKKnowledge
@synthesize hiddenBtn;

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
    [self.navigationController.visibleViewController setTitle:@"知識"];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"分類" style:UIBarButtonItemStyleDone target:self action:@selector(changeKind)];
    
    //暫時的
    names = [[NSMutableArray alloc] initWithObjects:@"知識1",@"知識2",@"知識3",@"知識4",@"知識5",@"知識6", nil];
    
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
    return [names count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    //try to get a reusable cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    //create new cell if no reusable cell is available
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSString *cellValue = [names objectAtIndex:indexPath.row];
    cell.textLabel.text = cellValue;
    
    
    return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
    
    [self.navigationController.visibleViewController setTitle:@"知識"];
    UIViewController* FirstViewController = [storyboard instantiateViewControllerWithIdentifier:@"SKKnowledgeDetail"];
    
    [self.navigationController pushViewController:FirstViewController animated:YES];
    
    //[self embedYouTube:@"http://www.youtube.com/watch?v=l3Iwh5hqbyE" frame:CGRectMake(20, 20, 100, 100)];
    //[self embedYouTube];
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
    NSLog(@"%d",kind);
    [popover dismissPopoverAnimated:YES];
}

- (void)dealloc {
    [_table release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setTable:nil];
    [super viewDidUnload];
}
@end
