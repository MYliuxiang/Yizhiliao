//
//  VideoCallRedView.h
//  Lliaoda
//
//  Created by 刘翔 on 2017/6/23.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PersonModel.h"
@interface VideoCallRedView : UIView<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *sendView;

- (instancetype)initVideoCallRedView;
- (IBAction)closeAC:(id)sender;
@property (nonatomic,retain) AgoraAPI *inst;

@property (weak, nonatomic) IBOutlet UIView *firstView;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@property (weak, nonatomic) IBOutlet UITextField *onetextField;
@property (weak, nonatomic) IBOutlet UILabel *eLabel;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *countText;
@property (weak, nonatomic) IBOutlet UITextField *twotextField;
@property (weak, nonatomic) IBOutlet UILabel *textViewP;
@property (weak, nonatomic) IBOutlet UIButton *chongBtn;
- (IBAction)sendAc:(id)sender;
- (IBAction)chongzhiAC:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *threeView;
@property (nonatomic,retain) PersonModel *pmodel;

@property (nonatomic,retain) NSMutableArray *dataList;
@property (nonatomic,retain) NSTimer *timer;

@property (nonatomic,retain)CAEmitterCell *snowflake;

@property (weak, nonatomic) IBOutlet UILabel *jineLab;
@property (weak, nonatomic) IBOutlet UILabel *zuanLabel;
@property (weak, nonatomic) IBOutlet UILabel *lab1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;

@property (weak, nonatomic) IBOutlet UILabel *topLabel;

@end
