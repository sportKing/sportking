//
//  SKJoinDetail.m
//  sportking
//
//  Created by yang on 13/5/8.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "SKJoinDetail.h"
#import "BDKNotifyHUD.h"
#import "SKAPI.h"
#import "mainCell.h"
#import "mapCell.h"
#import "msgCell.h"
@interface SKJoinDetail ()<SKAPIDelegate>{
    mapCell *map;
}

@end

@implementation SKJoinDetail
@synthesize data,isJoined;

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
//    NSLog(@"join detail%@",data);
    // Do any additional setup after loading the view from its nib.
    if (isJoined) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"退出" style:UIBarButtonItemStyleDone target:self action:@selector(submit)];
    }else{
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"加入" style:UIBarButtonItemStyleDone target:self action:@selector(join)];
    }
    [[SKAPI sharedSKAPI] getJoinMessageFromJoinID:[data objectForKey:@"no"]];
    [[SKAPI sharedSKAPI] setDelegate:self];
    self.tabBarController.tabBar.hidden = YES;
    
    msgData = [[NSMutableArray alloc] init];
}

-(void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)join{
    [[SKAPI sharedSKAPI] sendJoinActiveByID:[data objectForKey:@"no"]];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"退出" style:UIBarButtonItemStyleDone target:self action:@selector(submit)];
    
    // Create the HUD object
    BDKNotifyHUD *hud = [BDKNotifyHUD notifyHUDWithImage:[UIImage imageNamed:@"Checkmark.png"]
                                                    text:@"參加成功"];
    hud.center = CGPointMake(self.view.center.x, self.view.center.y - 20);
    
    // Animate it, then get rid of it. These settings last 1 second, takes a half-second fade.
    [self.view addSubview:hud];
    [hud presentWithDuration:1.0f speed:0.5f inView:self.view completion:^{
        [hud removeFromSuperview];
    }];
}

-(void) submit{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"確定要退出揪團嗎？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"確定", nil];
    [alert show];
    [alert release];
}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    // the user clicked one of the OK/Cancel buttons
    if (buttonIndex == 1)
    {
        NSLog(@"ok");
        [[SKAPI sharedSKAPI] sendLeaveActiveByID:[data objectForKey:@"no"]];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"加入" style:UIBarButtonItemStyleDone target:self action:@selector(join)];
        
        BDKNotifyHUD *hud = [BDKNotifyHUD notifyHUDWithImage:[UIImage imageNamed:@"Checkmark.png"]
                                                        text:@"退出活動"];
        hud.center = CGPointMake(self.view.center.x, self.view.center.y - 20);
        
        // Animate it, then get rid of it. These settings last 1 second, takes a half-second fade.
        [self.view addSubview:hud];
        [hud presentWithDuration:1.0f speed:0.5f inView:self.view completion:^{
            [hud removeFromSuperview];
        }];
    }else{
        NSLog(@"cancel");
    }
}

- (void)dealloc {
    [_replyTextField release];
    [_replyBtn release];
    [_table release];
    [_replyView release];
    [super dealloc];
}

- (void)viewDidUnload {
    [self setReplyTextField:nil];
    [self setReplyBtn:nil];
    [self setTable:nil];
    [self setReplyView:nil];
    [super viewDidUnload];
}

- (IBAction)replyClick:(id)sender {
    if ([self.replyTextField.text length]<1) {
        return;
    }
    NSString *msg = self.replyTextField.text;
    self.replyTextField.text = @"";
    
    //no:	這留言隸屬於哪一團的no
    //fbid: 留言者fbid
    //name:	留言者姓名
    //content:	留言內容
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         [NSString stringWithFormat:@"%@",[data objectForKey:@"no"]],@"no",
                         [NSString stringWithFormat:@"%@",[SKAPI sharedSKAPI].userID],@"fbid",
                         [NSString stringWithFormat:@"%@",[SKAPI sharedSKAPI].userName],@"name",
                         msg,@"content",nil];
    [[SKAPI sharedSKAPI] sendJoinMessageFromArguments:dic];
    
    NSDictionary *dic2 = [NSDictionary dictionaryWithObjectsAndKeys:
                         [NSString stringWithFormat:@"%@",[data objectForKey:@"no"]],@"no",
                         [NSString stringWithFormat:@"%@",[SKAPI sharedSKAPI].userID],@"fbid",
                         [NSString stringWithFormat:@"%@",[SKAPI sharedSKAPI].userName],@"author",
                         msg,@"content",nil];
    [msgData addObject:dic2];
    [self.table reloadData];
    
    NSIndexPath *lastRow = [NSIndexPath indexPathForRow:(5+ [msgData count] - 1) inSection:0];
    [self.table scrollToRowAtIndexPath:lastRow
                                atScrollPosition:UITableViewScrollPositionBottom
                                        animated:YES];
    [self.replyTextField resignFirstResponder];
}

#pragma mark -tableView delegate

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 5 + [msgData count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if ([indexPath row] == 3) {
        NSString *text = [data objectForKey:@"content"];
        CGSize constraint = CGSizeMake(190, 2000.0f);
        
        CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint];
        
        CGFloat height = MAX(size.height +20, 38.0f);

        return height;
    }else if ([indexPath row] == 4) {
        //map
        return 150;
    }else if ([indexPath row] >4){
        
        NSString *text = [[msgData objectAtIndex:[indexPath row]-5] objectForKey:@"content"];
        CGSize constraint = CGSizeMake(190, 2000.0f);
        
        CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint];
        
        CGFloat height = MAX(size.height +30, 55.0f);
        
        return height;
    }
    
//    NSDictionary *dic = [data objectAtIndex:index];
//    NSString *text = [dic objectForKey:@"data_content"];
//    
//    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH, 2000.0f);
//    
//    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint];
//    
//    CGFloat height = MAX(size.height, 44.0f);
    
//    return height ;
    
    if ([indexPath row]<4) {
        return 38;
    }
    return 55;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([indexPath row] <=3) {
        //內容s
        static NSString *CellIdentifier = @"mainCell";
        mainCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            NSArray* nibObjs = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:nil options:nil];
            cell = [nibObjs objectAtIndex:0];
            cell.userInteractionEnabled = NO;
        }
        if ([indexPath row] == 0) {
            [cell.title setText:@"主持人"];
            [cell.content setText:[data objectForKey:@"organizer"]];
        }else if([indexPath row] == 1){
            [cell.title setText:@"活動時間"];
            [cell.content setText:[data objectForKey:@"date"]];
        }else if([indexPath row] == 2){
            [cell.title setText:@"參加人數"];
            [cell.content setText:[data objectForKey:@"number_of_people"]];
        }else if([indexPath row] == 3){
            [cell.title setText:@"活動主旨"];
            [cell.content setText:[data objectForKey:@"content"]];
        }

        return cell;
    }else if ([indexPath row] == 4){
        if (!map) {
            NSArray* nibObjs = [[NSBundle mainBundle] loadNibNamed:@"mapCell" owner:nil options:nil];
            map = [nibObjs objectAtIndex:0];
            [map setX:[[data objectForKey:@"x"] doubleValue]];
            [map setY:[[data objectForKey:@"y"] doubleValue]];
            [map setAddress:[data objectForKey:@"site"]];
        }
        //map
        return map;
    }
    
    //留言
    static NSString *CellIdentifier = @"msgCell";
    
    msgCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray* nibObjs = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:nil options:nil];
        cell = [nibObjs objectAtIndex:0];
    }
    NSDictionary *dic = [msgData objectAtIndex:[indexPath row] - 5];
    NSString *fbid = [dic objectForKey:@"fbid"];
    NSString *url = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?width=120&height=120",fbid];
    [[cell headImage] loadRequestURL:url user_id:fbid];
    [[cell nameLabel] setText:[dic objectForKey:@"author"]];
    [[cell msgLabel] setText:[dic objectForKey:@"content"]];
    return cell;
}


#pragma mark -skapi

-(void)SKAPI:(SKAPI *)skAPI didGetMessageData:(NSDictionary *)result{
    [msgData removeAllObjects];
    for (NSDictionary *dic in result) {
        [msgData addObject:dic];
    }
    [self.table reloadData];
    
}

#pragma mark -textfield delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelegate:self];
    
    //設定動畫開始時的狀態為目前畫面上的樣子
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    self.replyView.frame = CGRectMake(self.replyView.frame.origin.x,
                                 self.replyView.frame.origin.y - 215,
                                 self.replyView.frame.size.width,
                                 self.replyView.frame.size.height);
    
    [UIView commitAnimations];
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelegate:self];
    
    //設定動畫開始時的狀態為目前畫面上的樣子
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    self.replyView.frame = CGRectMake(self.replyView.frame.origin.x,
                                 self.replyView.frame.origin.y + 215,
                                 self.replyView.frame.size.width,
                                 self.replyView.frame.size.height);
    
    [UIView commitAnimations];
}

@end
