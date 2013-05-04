//
//  SKFindPlace.m
//  sportking
//
//  Created by yang on 13/3/9.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "SKFindPlace.h"
#import "placecell.h"
#import "FPPopoverController.h"
#import "SKSelectKind.h"

@interface SKFindPlace ()<selectKindDelegate>{
    FPPopoverController *popover;
}

-(void)changeDisplay;
-(void)changeKind;
@end

@implementation SKFindPlace
@synthesize table;
@synthesize map;
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
    isShowMap = YES;
    [self.navigationController.visibleViewController setTitle:@"找場地"];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"列表" style:UIBarButtonItemStyleDone target:self action:@selector(changeDisplay)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"分類" style:UIBarButtonItemStyleDone target:self action:@selector(changeKind)];
    /* 暫時的！ */
    name = [[NSMutableArray alloc] initWithObjects:@"台科大室內籃球場",@"台大籃球場",@"民族國中",@"公館國小",@"大安森林公園",@"世新籃球場",@"青年公園籃球場",@"板球體育館籃球場",@"內湖籃球場", nil];
    position = [[NSMutableArray alloc] initWithObjects:@"距離 0 km",@"距離 0.2 km",@"距離 0.2 km",@"距離 0.5 km",@"距離 4 km",@"距離 5 km",@"距離 12 km",@"距離 15 km",@"距離 20 km", nil];

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
    return [name count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"placecell";
    
    placecell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray* nibObjs = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:nil options:nil];
        cell = [nibObjs objectAtIndex:0];
    }
    
    cell.name.text = [name objectAtIndex:indexPath.row];
    cell.position.text = [position objectAtIndex:indexPath.row];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -map
-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    
    //取得現在位置
    double X = userLocation.location.coordinate.latitude;
    double Y = userLocation.location.coordinate.longitude;
    
    NSLog(@"現在位置   x:%f  y:%f",X,Y);
    
    //自行定義的設定地圖函式
//    [self setMapRegionLongitude:Y andLatitude:X withLongitudeSpan:0.05 andLatitudeSpan:0.05];
    CLLocationCoordinate2D mapCenter;
    mapCenter.latitude = X;
    mapCenter.longitude = Y;
    
    //Map Zoom設定
    MKCoordinateSpan mapSpan;
    mapSpan.latitudeDelta = 0.05;
    mapSpan.longitudeDelta = 0.05;
    
    //設定地圖顯示位置
    MKCoordinateRegion mapRegion;
    mapRegion.center = mapCenter;
    mapRegion.span = mapSpan;
    
    //前往顯示位置
    [mapView setRegion:mapRegion];
    [mapView regionThatFits:mapRegion];
}

#pragma mark -other
-(void)changeDisplay{
    if(isShowMap){
        isShowMap = NO;
        map.hidden = YES;
        table.hidden = NO;
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"地圖" style:UIBarButtonItemStyleDone target:self action:@selector(changeDisplay)];
    }else{
        isShowMap = YES;
        map.hidden = NO;
        table.hidden = YES;
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"列表" style:UIBarButtonItemStyleDone target:self action:@selector(changeDisplay)];
    }
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


@end
