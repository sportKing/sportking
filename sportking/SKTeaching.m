//
//  SKTeaching.m
//  sportking
//
//  Created by Ruei Yan, Huang on 13/6/5.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "SKTeaching.h"
#import "SKSelectKind.h"
#import "FPPopoverController.h"
#import "SKAPI.h"
#import "SKTeachingDetail.h"

@interface SKTeaching ()<selectKindDelegate,SKAPIDelegate>{
    
    FPPopoverController *popover;
}

@end

@implementation SKTeaching
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
    [self.navigationController.visibleViewController setTitle:@"教學"];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"分類" style:UIBarButtonItemStyleDone target:self action:@selector(changeKind)];
    
    //暫時的
//    names = [[NSMutableArray alloc] initWithObjects:@"教學1",@"教學2",@"教學3",@"教學4",@"教學5",@"教學6", nil];
    teachDatas = [[NSMutableArray alloc] init];
    
    [[SKAPI sharedSKAPI] setDelegate:self];
    [[SKAPI sharedSKAPI] getTeachDataByKind:1];
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
    return [teachDatas count];
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
    
    NSDictionary *dic = [teachDatas objectAtIndex:indexPath.row];
    
    NSString *cellValue = [dic objectForKey:@"skill_name"];
    cell.textLabel.text = cellValue;
    
    return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
    
    [self.navigationController.visibleViewController setTitle:@"教學"];
    SKTeachingDetail* teach = [storyboard instantiateViewControllerWithIdentifier:@"SKTeachingDetail"];
    
    NSDictionary *dic = [teachDatas objectAtIndex:indexPath.row];
    
    
    [self.navigationController pushViewController:teach animated:YES];
    [teach.navigationItem setTitle:[dic objectForKey:@"skill_name"]];
    [teach setVideourl:[dic objectForKey:@"link"]];
//    [teach embedYouTube:[dic objectForKey:@"link"]];
    
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
//    NSLog(@"%d",kind);
    [[SKAPI sharedSKAPI] getTeachDataByKind:kind];
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

#pragma mark - api delegate
-(void)SKAPI:(SKAPI *)skAPI didGetTeachData:(NSDictionary *)result{
    
    [teachDatas removeAllObjects];
    
    for (NSDictionary *dic in result) {
        [teachDatas addObject:dic];
    }
    [table reloadData];
    
}
@end
