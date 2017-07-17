//
//  VideoOneVC.h
//  Lliaoda
//
//  Created by 刘翔 on 2017/4/19.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "BaseViewController.h"
#import "FMVideoPlayController.h"
#import "VideoRZTwoVC.h"

@interface VideoOneVC : BaseViewController
{

        NSString     *_mp4Path;
        NSDate       *_startDate;
        
}
@property (nonatomic,retain) NSDictionary *infodic;
@property (weak, nonatomic) IBOutlet UIImageView *videlImageView;
@property (weak, nonatomic) IBOutlet UIButton *doneBtn;
- (IBAction)doneAC:(id)sender;
- (IBAction)playAC:(id)sender;

@end
