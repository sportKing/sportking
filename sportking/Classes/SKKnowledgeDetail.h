//
//  SKKnowledgeDetail.h
//  sportking
//
//  Created by Ruei Yan, Huang on 13/6/4.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SKKnowledgeDetail : UIViewController<UIWebViewDelegate>
@property (retain, nonatomic) IBOutlet UITextView *textView;
@property(nonatomic,readwrite,retain)NSString *rule;

@end