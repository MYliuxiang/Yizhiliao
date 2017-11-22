//
//  NewMyalbumCell.h
//  Lliaoda
//
//  Created by 小牛 on 2017/10/24.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NewMyalbumCell;
@protocol NewMyalbumCellDelegate <NSObject>

- (void)imageShowAC:(UITapGestureRecognizer *)tap;

@end

@interface NewMyalbumCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView1;
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;
@property (weak, nonatomic) IBOutlet UIImageView *imageView3;
@property (weak, nonatomic) IBOutlet UIImageView *imageView4;
@property (weak, nonatomic) IBOutlet UIImageView *imageView5;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UILabel *addLabel;

@property (nonatomic, strong) NSMutableArray *photoArray;
@property (nonatomic, weak) id<NewMyalbumCellDelegate>delegate;
@end
