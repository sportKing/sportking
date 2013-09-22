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

#import "CallOutAnnotationVifew.h"
#import "CalloutMapAnnotation.h"
#import "JingDianMapCell.h"
#import "BasicMapAnnotation.h"

#import "ASIFormDataRequest.h"
#import "JSONDictionaryExtensions.h"

#import "SKMapDetail.h"

#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import "SKAPI.h"


@interface SKFindPlace ()<selectKindDelegate,SKAPIDelegate>{
    FPPopoverController *popover;
    
    NSMutableArray *_annotationList;
    
    CalloutMapAnnotation *_calloutAnnotation;
    CalloutMapAnnotation *_previousdAnnotation;
    double X,Y;
}
-(void)setAnnotionsWithList:(NSArray *)list;

-(void)changeDisplay;
-(void)changeKind;
@end

@implementation SKFindPlace
@synthesize table;
@synthesize map;
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
    
    placeDic = [[NSMutableArray alloc] init];
    
    _annotationList = [[NSMutableArray alloc] init];
    
	// Do any additional setup after loading the view.
    isShowMap = YES;
    X = 1000;
    Y = 1000;
    [self.navigationController.visibleViewController setTitle:@"找場地"];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"列表" style:UIBarButtonItemStyleDone target:self action:@selector(changeDisplay)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"分類" style:UIBarButtonItemStyleDone target:self action:@selector(changeKind)];
    /* 暫時的！ */
    name = [[NSMutableArray alloc] initWithObjects:@"台科大室內籃球場",@"台大籃球場",@"民族國中",@"公館國小",@"大安森林公園",@"世新籃球場",@"青年公園籃球場",@"板球體育館籃球場",@"內湖籃球場", nil];
    position = [[NSMutableArray alloc] initWithObjects:@"距離 0 km",@"距離 0.2 km",@"距離 0.2 km",@"距離 0.5 km",@"距離 4 km",@"距離 5 km",@"距離 12 km",@"距離 15 km",@"距離 20 km", nil];
    
//    ACAccountStore *account = [[ACAccountStore alloc] init];
//    ACAccountType *accountType = [account accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
//    NSArray *accounts = [account
//                         accountsWithAccountType:accountType];
//    ACAccount *facebookAccount = [accounts lastObject];
//    NSString *acessToken = [NSString stringWithFormat:@"%@",facebookAccount.credential.oauthToken];
//    NSDictionary *parameters = @{@"access_token": acessToken};
//    NSURL *feedURL = [NSURL URLWithString:@"https://graph.facebook.com/me/friends"];
//    SLRequest *feedRequest = [SLRequest
//                              requestForServiceType:SLServiceTypeFacebook
//                              requestMethod:SLRequestMethodGET
//                              URL:feedURL
//                              parameters:parameters];
//    feedRequest.account = facebookAccount;
//    [feedRequest performRequestWithHandler:^(NSData *responseData,
//                                             NSHTTPURLResponse *urlResponse, NSError *error)
//     {
//         NSLog(@"%@",[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
//     }];
    
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
    //    return [name count];
    return [placeDic count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"placecell";
    
    placecell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray* nibObjs = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:nil options:nil];
        cell = [nibObjs objectAtIndex:0];
    }
    NSDictionary *dic = [placeDic objectAtIndex:[indexPath row]];
    cell.name.text = [dic objectForKey:@"sitename"];
    cell.position.text = [NSString stringWithFormat:@"距離 %f 公里",
                          [[dic objectForKey:@"distance"] floatValue]];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
    
    
    NSDictionary *dic = [placeDic objectAtIndex:[indexPath row]];
    SKMapDetail* FirstViewController = [storyboard instantiateViewControllerWithIdentifier:@"SKMapDetail"];
    [FirstViewController setTitle:[dic objectForKey:@"sitename"]];
    [FirstViewController.sitename setText:[dic objectForKey:@"sitename"]];
    [self.navigationController pushViewController:FirstViewController animated:YES];
}

#pragma mark -map

-(void)setAnnotionsWithList:(NSArray *)list
{
    //先清除原先的
    NSMutableArray * annotationsToRemove = [map.annotations mutableCopy ] ;
    [annotationsToRemove removeObject:map.userLocation ] ;
    [map removeAnnotations:annotationsToRemove ] ;
    
    //在新增
    for (NSDictionary *dic in list) {
        
        CLLocationDegrees latitude=[[dic objectForKey:@"latitude"] doubleValue];
        CLLocationDegrees longitude=[[dic objectForKey:@"longitude"] doubleValue];
        CLLocationCoordinate2D location=CLLocationCoordinate2DMake(latitude, longitude);
        
        MKCoordinateRegion region=MKCoordinateRegionMakeWithDistance(location,4000 ,4000 );
        MKCoordinateRegion adjustedRegion = [map regionThatFits:region];
        [map setRegion:adjustedRegion animated:YES];
        
        BasicMapAnnotation *  annotation=[[[BasicMapAnnotation alloc] initWithLatitude:latitude andLongitude:longitude]  autorelease];
        [annotation setTitle:[dic objectForKey:@"sitename"]];
        [annotation setContent:[NSString stringWithFormat:@"距離 %f 公里",
                                [[dic objectForKey:@"distance"] floatValue]]];
        [map addAnnotation:annotation];
    }
}


- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
	if ([view.annotation isKindOfClass:[BasicMapAnnotation class]]) {
        BasicMapAnnotation *annotation = (BasicMapAnnotation*)view.annotation;
        if (_calloutAnnotation.coordinate.latitude == view.annotation.coordinate.latitude&&
            _calloutAnnotation.coordinate.longitude == view.annotation.coordinate.longitude) {
            return;
        }
        if (_calloutAnnotation) {
            [mapView removeAnnotation:_calloutAnnotation];
            _calloutAnnotation = nil;
        }
        _calloutAnnotation = [[[CalloutMapAnnotation alloc]
                               initWithLatitude:view.annotation.coordinate.latitude
                               andLongitude:view.annotation.coordinate.longitude] autorelease];
        [_calloutAnnotation setTitle:annotation.title];
        [_calloutAnnotation setContent:annotation.content];
        [mapView addAnnotation:_calloutAnnotation];
        
        
        [mapView setCenterCoordinate:_calloutAnnotation.coordinate animated:YES];
	}
    else{
        //        if([delegate respondsToSelector:@selector(customMKMapViewDidSelectedWithInfo:)]){
        //            [delegate customMKMapViewDidSelectedWithInfo:@"点击至之后你要在这干点啥"];
        //        }
    }
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    if (_calloutAnnotation&& ![view isKindOfClass:[CallOutAnnotationVifew class]]) {
        if (_calloutAnnotation.coordinate.latitude == view.annotation.coordinate.latitude&&
            _calloutAnnotation.coordinate.longitude == view.annotation.coordinate.longitude) {
            [mapView removeAnnotation:_calloutAnnotation];
            _calloutAnnotation = nil;
        }
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
	if ([annotation isKindOfClass:[CalloutMapAnnotation class]]) {
        CalloutMapAnnotation *annotation_new = (CalloutMapAnnotation*)annotation;
        CallOutAnnotationVifew *annotationView = (CallOutAnnotationVifew *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"CalloutView"];
        if (!annotationView) {
            annotationView = [[[CallOutAnnotationVifew alloc] initWithAnnotation:annotation reuseIdentifier:@"CalloutView"] autorelease];
            JingDianMapCell  *cell = [[[NSBundle mainBundle] loadNibNamed:@"JingDianMapCell" owner:self options:nil] objectAtIndex:0];
            [cell.name setText:annotation_new.title];
            [cell.content setText:annotation_new.content];
            [cell.btn addTarget:self action:@selector(detail_click) forControlEvents:UIControlEventTouchUpInside];
            [annotationView setCell:cell];
            [annotationView.contentView addSubview:cell];
        }else{
            [annotationView.cell.name setText:annotation_new.title];
            [annotationView.cell.content setText:annotation_new.content];
            
        }
        return annotationView;
	} else if ([annotation isKindOfClass:[BasicMapAnnotation class]]) {
        
        MKAnnotationView *annotationView =[map dequeueReusableAnnotationViewWithIdentifier:@"CustomAnnotation"];
        if (!annotationView) {
            annotationView = [[[MKAnnotationView alloc] initWithAnnotation:annotation
                                                           reuseIdentifier:@"CustomAnnotation"] autorelease];
            annotationView.canShowCallout = NO;
            annotationView.image = [UIImage imageNamed:@"pin.png"];
        }
        
		return annotationView;
    }
	return nil;
}

- (void)resetAnnitations:(NSArray *)data
{
    [_annotationList removeAllObjects];
    [_annotationList addObjectsFromArray:data];
    [self setAnnotionsWithList:_annotationList];
}

-(void)detail_click{
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
    
    SKMapDetail* FirstViewController = [storyboard instantiateViewControllerWithIdentifier:@"SKMapDetail"];
    [FirstViewController setTitle:_calloutAnnotation.title];
    [FirstViewController.sitename setText:_calloutAnnotation.title];
    [self.navigationController pushViewController:FirstViewController animated:YES];
}

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    
    //取得現在位置
    
    if (abs(X - userLocation.location.coordinate.latitude) <1 && abs(Y == userLocation.location.coordinate.longitude)<1) {
        return;
    }
    X = userLocation.location.coordinate.latitude;
    Y = userLocation.location.coordinate.longitude;
    
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
//    NSLog(@"%d",kind);
    [popover dismissPopoverAnimated:YES];
    
    [[SKAPI sharedSKAPI] setDelegate:self];
    [[SKAPI sharedSKAPI] getPlaceDataByKind:kind X:X Y:Y];
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

-(void)SKAPI:(SKAPI *)skAPI didGetPlaceData:(NSDictionary *)result{
    NSLog(@"result:%@",result);
    
    
    [placeDic removeAllObjects];
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    for (NSDictionary *dic in result) {
        [placeDic addObject:dic];
        NSDictionary *dic1=[NSDictionary dictionaryWithObjectsAndKeys:
                            [dic objectForKey:@"sitename"],@"sitename",
                            [dic objectForKey:@"distance"],@"distance",
                            [dic objectForKey:@"x"],@"latitude",
                            [dic objectForKey:@"y"],@"longitude",nil];
        [arr addObject:dic1];
    }
    [table reloadData];
    
    [self resetAnnitations:arr];
}


@end
