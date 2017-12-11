//
//  SearchCell.m
//  Lliaoda
//
//  Created by 小牛 on 2017/12/8.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "SearchCell.h"

@implementation SearchCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.headerImageView.layer.cornerRadius = 30;
}

+ (SearchCell *)tableView:(UITableView *)tableView
                    model:(SelectedModel *)model
                indexPath:(NSIndexPath *)indexPath
{
    SearchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchCell"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SearchCell" owner:self options:nil] firstObject];
        cell.backgroundView = nil;
    }
    cell.model = model;
    return cell;
}



- (void)setModel:(SelectedModel *)model {
    self.nameLabel.text = model.nickname;
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:model.portrait] placeholderImage:[UIImage imageNamed:@"headerImage.jpg"]];
    self.headerImageView.layer.cornerRadius = 30;
    self.idLabel.text = model.uid;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
