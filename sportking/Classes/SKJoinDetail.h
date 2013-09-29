//
//  SKJoinDetail.h
//  sportking
//
//  Created by yang on 13/5/8.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#define FONT_SIZE 14.0f
#define CELL_CONTENT_HEIGHT 200.0f
#define CELL_CONTENT_WIDTH 206.0f
#define CELL_CONTENT_MARGIN 10.0f

@interface SKJoinDetail : UIViewController<UIAlertViewDelegate>{
    NSMutableArray *msgData;
}
@property(nonatomic,readwrite,retain)NSDictionary *data;
@property(nonatomic,readwrite,assign)BOOL isJoined;
@property (retain, nonatomic) IBOutlet UITextField *replyTextField;
@property (retain, nonatomic) IBOutlet UIButton *replyBtn;
@property (retain, nonatomic) IBOutlet UIView *replyView;

@property (retain, nonatomic) IBOutlet UITableView *table;

- (IBAction)replyClick:(id)sender;
@end
