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
#import "FPPopoverController.h"
@interface SKJoin ()<selectKindDelegate>{
    FPPopoverController *popover;
}

-(void)changeDisplay;
-(void)changeKind;
@end

@implementation SKJoin
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
    [self.navigationController.visibleViewController setTitle:@"揪團"];
    isShowMap = YES;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"列表" style:UIBarButtonItemStyleDone target:self action:@selector(changeDisplay)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"分類" style:UIBarButtonItemStyleDone target:self action:@selector(changeKind)];
    
    peoples = [[NSMutableArray alloc] initWithObjects:@"1/4",@"3 / 4",@" 3 / 4",@"1 / 2",@"7 / 12",@"0 / 4", nil];
    names = [[NSMutableArray alloc] initWithObjects:@"一起打球吧！",@"籃球菜鳥找新手帶",@"籃球四缺一",@"鬥牛二缺一",@"神手欠人電",@"快樂打籃球", nil];
    descripts = [[NSMutableArray alloc] initWithObjects:@"台北大安區   距離 1 km",
                 @"新北永和區   距離 3 km",
                 @"台北大安區   距離 5 km",
                 @"新北板橋區   距離 15 km",
                 @"桃園中壢市  距離 37 km",@"新竹竹北市   距離 72 km", nil];

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
    
    static NSString *CellIdentifier = @"sportcell";
    
    sportcell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray* nibObjs = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:nil options:nil];
        cell = [nibObjs objectAtIndex:0];
    }
    
    cell.people.text = [peoples objectAtIndex:indexPath.row];
    cell.name.text = [names objectAtIndex:indexPath.row];
    cell.descript.text = [descripts objectAtIndex:indexPath.row];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
    
    [self.navigationController.visibleViewController setTitle:@"活動"];
    UIViewController* FirstViewController = [storyboard instantiateViewControllerWithIdentifier:@"SKJoinDetail"];
    
    [self.navigationController pushViewController:FirstViewController animated:YES];

}

#pragma mark - map

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
