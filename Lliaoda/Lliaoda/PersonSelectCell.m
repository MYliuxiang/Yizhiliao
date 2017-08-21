//
//  PersonSelectCell.m
//  Lliaoda
//
//  Created by 小牛 on 2017/8/21.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "PersonSelectCell.h"

@implementation PersonSelectCell
+ (PersonSelectCell *)tableView:(UITableView *)tableView
                      indexPath:(NSIndexPath *)indexPath
                       delegate:(id<PersonSelectCellDelegate>)delegate
{
    PersonSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PersonSelectCell"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PersonSelectCell" owner:self options:nil] firstObject];
        cell.backgroundColor = [UIColor clearColor];
    }
    cell.delegate = delegate;
    return cell;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _btnBGView.layer.cornerRadius = 44 / 2;
    _button1.layer.cornerRadius = 40 / 2;
    _button2.layer.cornerRadius = 40 / 2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)button1AC:(id)sender {
    _button1.selected = YES;
    _button2.selected = NO;
    _button1.backgroundColor = UIColorFromRGB(0x00DDCC);
    _button2.backgroundColor = [UIColor clearColor];
    if (_delegate && [_delegate respondsToSelector:@selector(button1Click)]) {
        [_delegate button1Click];
    }
}

- (IBAction)button2AC:(id)sender {
    _button1.selected = NO;
    _button2.selected = YES;
    _button2.backgroundColor = UIColorFromRGB(0x00DDCC);
    _button1.backgroundColor = [UIColor clearColor];
    if (_delegate && [_delegate respondsToSelector:@selector(button1Click)]) {
        [_delegate button2Click];
    }
}
@end
