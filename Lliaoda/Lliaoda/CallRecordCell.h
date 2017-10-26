//
//  CallRecordCell.h
//  Lliaoda
//
//  Created by 刘翔 on 2017/10/25.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CallRecordCell.h"

@interface CallRecordCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *thumb;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *alltime;
@property (nonatomic,strong) CallTime *call;
@end
