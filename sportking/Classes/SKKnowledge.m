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
#import "SKAPI.h"
#import "SKKnowledgeDetail.h"

@interface SKKnowledge ()<selectKindDelegate,SKAPIDelegate>{
    FPPopoverController *popover;
}

@end

@implementation SKKnowledge
@synthesize hiddenBtn;
@synthesize table;
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
	// Do any additional setup after loading the view.
    [self.navigationController.visibleViewController setTitle:@"知識"];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"分類" style:UIBarButtonItemStyleDone target:self action:@selector(changeKind)];
    
    //暫時的
    knowledgeDatas = [[NSMutableArray alloc] init];
    [[SKAPI sharedSKAPI] setDelegate:self];
    [[SKAPI sharedSKAPI] getRuleDataByKind:1];
    
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
    return [knowledgeDatas count];
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
    NSDictionary *dic = [knowledgeDatas objectAtIndex:indexPath.row];
    
    NSString *cellValue = [dic objectForKey:@"rule_name"];
    cell.textLabel.text = cellValue;
    
    
    return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
    
    [self.navigationController.visibleViewController setTitle:@"知識"];
    SKKnowledgeDetail* knowledge = [storyboard instantiateViewControllerWithIdentifier:@"SKKnowledgeDetail"];
    
    NSDictionary *dic = [knowledgeDatas objectAtIndex:indexPath.row];
    
    [self.navigationController pushViewController:knowledge animated:YES];
    [knowledge.navigationItem setTitle:[dic objectForKey:@"rule_name"]];
    [knowledge setRule:[dic objectForKey:@"rule"]];
    
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
    [[SKAPI sharedSKAPI] getRuleDataByKind:kind];
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

- (void)dealloc {
    [table release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setTable:nil];
    [super viewDidUnload];
}
#pragma mark -api delegate
-(void)SKAPI:(SKAPI *)skAPI didGetRuleData:(NSDictionary *)result{
    [knowledgeDatas removeAllObjects];
    
    for (NSDictionary *dic in result) {
        [knowledgeDatas addObject:dic];
    }
    [table reloadData];
    
}

@end
