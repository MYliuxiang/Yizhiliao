//
//  PersonHeaderCell.m
//  Lliaoda
//
//  Created by 小牛 on 2017/8/21.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "PersonHeaderCell.h"

@implementation PersonHeaderCell
+ (PersonHeaderCell *)tableView:(UITableView *)tableView
                      indexPath:(NSIndexPath *)indexPath
{
    PersonHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PersonHeaderCell"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PersonHeaderCell" owner:self options:nil] firstObject];
        cell.backgroundColor = [UIColor clearColor];
    }
    return cell;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//    _scrollView = [[SelectedBannersHeader alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 250)];
//    _scrollView.backgroundColor = [UIColor redColor];
//    [_scroolBGView addSubview:_scrollView];
}

- (void)setImagesArray:(NSMutableArray *)imagesArray {
    _scroolBGView.imagesArray = imagesArray;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
