//
//  FixintroduceVC.h
//  Lliaoda
//
//  Created by 刘翔 on 2017/4/18.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "BaseViewController.h"
#import "Mymodel.h"

@interface FixintroduceVC : BaseViewController<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (nonatomic,copy) NSString *value;
@property (nonatomic,retain) Mymodel *model;

@end
