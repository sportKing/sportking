//
//  SKAddActivity.m
//  sportking
//
//  Created by yang on 13/9/25.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "SKAddActivity.h"
#import "BDKNotifyHUD.h"
#import "FPPopoverController.h"
#import "SKSelectKind.h"
#import "SKAPI.h"
#import <QuartzCore/QuartzCore.h>
#import <AddressBookUI/AddressBookUI.h>

@interface SKAddActivity ()<selectKindDelegate,UITextFieldDelegate>{
    FPPopoverController *popover;
    UIDatePicker *datePicker;
    NSLocale *datelocale;
}
@end

@implementation SKAddActivity

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
    UIBarButtonItem *barItemLeft = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    
    UIBarButtonItem *barItemRight = [[UIBarButtonItem alloc] initWithTitle:@"建立" style:UIBarButtonItemStylePlain target:self action:@selector(finish)];
    [self.navigationItem setLeftBarButtonItem:barItemLeft];
    [self.navigationItem setRightBarButtonItem:barItemRight];
    
    //ui設定
    self.activityContent.layer.masksToBounds = YES;
    self.activityContent.layer.cornerRadius = 5;
    self.activityContent.layer.borderWidth = 0.5;
    self.activityContent.layer.borderColor = [[UIColor grayColor] CGColor];
    self.scrollview.contentSize = CGSizeMake(self.scrollview.frame.size.width, 570);
    
    /* 建立datepicker */
    // 建立 UIDatePicker
    datePicker = [[UIDatePicker alloc]init];
    // 時區的問題請再找其他協助 不是本篇重點
    datelocale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_TW"];
    datePicker.locale = datelocale;
    datePicker.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
    datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    // 以下這行是重點 (螢光筆畫兩行) 將 UITextField 的 inputView 設定成 UIDatePicker
    // 則原本會跳出鍵盤的地方 就改成選日期了
    self.activityTime.inputView = datePicker;
    
    // 建立 UIToolbar
    UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    // 選取日期完成鈕 並給他一個 selector
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self
                                                                          action:@selector(cancelPicker)];
    // 把按鈕加進 UIToolbar
    toolBar.items = [NSArray arrayWithObject:right];
    // 以下這行也是重點 (螢光筆畫兩行)
    // 原本應該是鍵盤上方附帶內容的區塊 改成一個 UIToolbar 並加上完成鈕
    self.activityTime.inputAccessoryView = toolBar;
    
    
    /* map 設定 */
    
    UITapGestureRecognizer *gestureTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPress:)];
    [self.map addGestureRecognizer:gestureTap];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)cancel{
    [self dismissModalViewControllerAnimated:YES];
}

-(void)finish{
    if ([self.activityName.text length]<1) {
        [self alert:@"請輸入活動名稱"];
        return;
    }else if([self.activityTime.text length]<1){
        [self alert:@"請輸入活動時間"];
        return;
    }else if([self.activityContent.text length]<1){
        [self alert:@"請輸入活動主旨"];
        return;
    }else if([self.activityLocation.text length]<1){
        [self alert:@"請選擇活動地點"];
        return;
    }
    
    /*
     type : 球類
     userName:userName
     activeName: 活動名稱
     activeLocation:活動地點
     activeDate:活動時間
     activeContent:活動內容
     x:精度
     y:緯度
     */
    
    NSDictionary *arg = [NSDictionary dictionaryWithObjectsAndKeys:
                         [NSString stringWithFormat:@"%d",type],@"type",
                         self.activityName.text,@"activeName",
                         self.activityTime.text,@"activeDate",
                         self.activityLocation.text,@"activeLocation",
                         self.activityContent.text,@"activeContent",
                         [NSString stringWithFormat:@"%f",X],@"x",
                         [NSString stringWithFormat:@"%f",Y],@"y",nil];
    [[SKAPI sharedSKAPI] sendPostNewJoinFromArguments:arg];
    
    // Create the HUD object
    BDKNotifyHUD *hud = [BDKNotifyHUD notifyHUDWithImage:[UIImage imageNamed:@"Checkmark.png"]
                                                    text:@"建立成功"];
    hud.center = CGPointMake(self.view.center.x, self.view.center.y - 20);
    
    // Animate it, then get rid of it. These settings last 1 second, takes a half-second fade.
    [self.view.window addSubview:hud];
    [hud presentWithDuration:1.0f speed:0.5f inView:self.view completion:^{
        [hud removeFromSuperview];
    }];
    
    [self dismissModalViewControllerAnimated:YES];
    
    
    [[SKAPI sharedSKAPI] getGroupDataBy:type];
}

-(void)alert:(NSString*)content{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"資料不完整" message:content delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [alert show];
    [alert release];
}

- (void)dealloc {
    [_scrollview release];
    [_activityName release];
    [_typeBtn release];
    [_activityTime release];
    [_activityLocation release];
    [_map release];
    [_activityContent release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setScrollview:nil];
    [self setActivityName:nil];
    [self setTypeBtn:nil];
    [self setActivityTime:nil];
    [self setActivityLocation:nil];
    [self setMap:nil];
    [self setActivityContent:nil];
    [super viewDidUnload];
}
#pragma mark -map
-(void)tapPress:(UIGestureRecognizer *)sender
{
    CGPoint touchPoint = [sender locationInView:self.map];
    CLLocationCoordinate2D touchLocation = [self.map convertPoint:touchPoint toCoordinateFromView:self.map];
    
    [self creatAnnotation:touchLocation];
}
-(void)creatAnnotation:(CLLocationCoordinate2D )locationCoordinate
{
    
    //先清除原先的
    NSMutableArray * annotationsToRemove = [self.map.annotations mutableCopy ] ;
    [annotationsToRemove removeObject:self.map.userLocation ] ;
    [self.map removeAnnotations:annotationsToRemove ] ;
    
    MKPointAnnotation *pointAnnotation=Nil;
    pointAnnotation = [[[MKPointAnnotation alloc] init] autorelease];
    pointAnnotation.coordinate = locationCoordinate;
    pointAnnotation.title = @"位置經緯度:";
    pointAnnotation.subtitle = [NSString stringWithFormat:@"%f %f",locationCoordinate.latitude,locationCoordinate.longitude];
    
    [self.map addAnnotation:pointAnnotation];
    nowLocation = locationCoordinate;
    [self getAddress:locationCoordinate];
    
}
-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    
    //取得現在位置
    
//    if (abs(X - userLocation.location.coordinate.latitude) <1 && abs(Y == userLocation.location.coordinate.longitude)<1) {
//        return;
//    }
    X = userLocation.location.coordinate.latitude;
    Y = userLocation.location.coordinate.longitude;
    
    CLLocationCoordinate2D mapCenter;
    mapCenter.latitude = X;
    mapCenter.longitude = Y;
    
    //Map Zoom設定
    MKCoordinateSpan mapSpan;
    mapSpan.latitudeDelta = 0.01;
    mapSpan.longitudeDelta = 0.01;
    
    //設定地圖顯示位置
    MKCoordinateRegion mapRegion;
    mapRegion.center = mapCenter;
    mapRegion.span = mapSpan;
    
    //前往顯示位置
    [mapView setRegion:mapRegion];
    [mapView regionThatFits:mapRegion];
    mapView.showsUserLocation = NO;
}

-(void)getAddress:(CLLocationCoordinate2D)location{
    CLGeocoder *geocoder = [[[CLGeocoder alloc] init] autorelease];
    CLLocation *newlocation = [[CLLocation alloc] initWithLatitude:location.latitude longitude:location.longitude];
    [geocoder reverseGeocodeLocation: newlocation // You can pass aLocation here instead
                   completionHandler:^(NSArray *placemarks, NSError *error) {
                       dispatch_async(dispatch_get_main_queue(),^ {
                           // do stuff with placemarks on the main thread
                           if (placemarks.count == 1) {
                               CLPlacemark *place = [placemarks objectAtIndex:0];
                               if (place.country !=nil && place.administrativeArea !=nil) {
                                   self.activityLocation.text = ABCreateStringWithAddressDictionary(place.addressDictionary, YES);
                                   
                               }
                           }
                           
                       });
                   }];

}
//- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
//    /* 反查地址 */
//    CLGeocoder *geocoder = [[[CLGeocoder alloc] init] autorelease];
//    
//    [geocoder reverseGeocodeLocation: newLocation // You can pass aLocation here instead
//                   completionHandler:^(NSArray *placemarks, NSError *error) {
//                       dispatch_async(dispatch_get_main_queue(),^ {
//                           // do stuff with placemarks on the main thread
//                           if (placemarks.count == 1) {
//                               CLPlacemark *place = [placemarks objectAtIndex:0];
//                               if (place.country !=nil && place.administrativeArea !=nil) {
//                                   [self getAddress:ABCreateStringWithAddressDictionary(place.addressDictionary, YES)];
//                                   
//                               }
//                           }
//                           
//                       });
//                   }];
//    
//    [manager stopUpdatingLocation];
//    
//}


#pragma mark select kind

-(IBAction)changeKind:(id)sender{
    [self popover:self.typeBtn];
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
    NSString *image = nil;
    type = kind;
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
    
    [self.typeBtn setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    
}

#pragma mark -textfield
-(void) cancelPicker {
    // endEditing: 是結束編輯狀態的 method
    if ([self.view endEditing:NO]) {
//        Y-m-d H:i:s
        // 以下幾行是測試用 可以依照自己的需求增減屬性
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        NSString *dateFormat = [NSDateFormatter dateFormatFromTemplate:@"yyyy-MM-dd HH:mm:ss" options:0 locale:nil];
        [formatter setDateFormat:dateFormat];
//        [formatter setLocale:datelocale];
        // 將選取後的日期 填入 UITextField
        self.activityTime.text = [NSString stringWithFormat:@"%@",[formatter stringFromDate:datePicker.date]];
    }
}

-(IBAction)tapView:(id)sender{
    [self.activityName resignFirstResponder];
    [self.activityContent resignFirstResponder];
    [self.activityLocation resignFirstResponder];
    
}

@end
