//
//  NewMyalbumCell.h
//  Lliaoda
//
//  Created by 小牛 on 2017/10/24.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewMyalbumCell : UITableViewCell
- (IBAction)addButtonAC:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *imageView1;
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;
@property (weak, nonatomic) IBOutlet UIImageView *imageView3;
@property (weak, nonatomic) IBOutlet UIImageView *imageView4;
@property (nonatomic, strong) NSMutableArray *photoArray;
@end
