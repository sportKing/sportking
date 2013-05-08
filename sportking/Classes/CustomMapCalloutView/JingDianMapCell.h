//
//  JingDianMapCell.h
//  IYLM
//
//  Created by Jian-Ye on 12-11-8.
//  Copyright (c) 2012年 Jian-Ye. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JingDianMapCell : UIView{
    
}
@property(nonatomic,readwrite,retain)IBOutlet UILabel *name;
@property(nonatomic,readwrite,retain)IBOutlet UILabel *content;
@property(nonatomic,readwrite,retain)IBOutlet UIButton *btn;

-(IBAction)btn_click:(id)sender;
@end
