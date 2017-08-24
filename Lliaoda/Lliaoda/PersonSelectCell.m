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

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _btnBGView.layer.cornerRadius = 44 / 2;
    _button1.layer.cornerRadius = 40 / 2;
    _button2.layer.cornerRadius = 40 / 2;
    
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.scrollEnabled = YES;
//    [self.contView addSubview:self.tableView];

}

#pragma  mark --------UITableView Delegete----------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *identifire = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifire];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifire];
        
    }
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return .1;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return .1;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}

- (void)setViewControllers:(NSMutableArray *)viewControllers
{
    _viewControllers = viewControllers;
    BaseCellVC *vc = _viewControllers[0];
    [self.contView addSubview:vc.view];

}

- (void)setCellCanScroll:(BOOL)cellCanScroll
{
    _cellCanScroll = cellCanScroll;
    
    for (BaseCellVC *VC in _viewControllers) {
        VC.vcCanScroll = cellCanScroll;
        if (!cellCanScroll) {//如果cell不能滑动，代表到了顶部，修改所有子vc的状态回到顶部
            VC.scrollview.contentOffset = CGPointZero;
        }
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (IBAction)button1AC:(id)sender {
    
    for (UIView *view in self.contView.subviews) {
        [view removeFromSuperview];
    }
    BaseCellVC *vc = _viewControllers[0];
    [self.contView addSubview:vc.view];

    _button1.selected = YES;
    _button2.selected = NO;
    _button1.backgroundColor = UIColorFromRGB(0x00DDCC);
    _button2.backgroundColor = [UIColor clearColor];
//    if (_delegate && [_delegate respondsToSelector:@selector(button1Click)]) {
//        [self.delegate button1Click];
//    }
    if (self.oneAction) {
        self.oneAction(1);
    }
    
}

- (IBAction)button2AC:(id)sender {
    
    for (UIView *view in self.contView.subviews) {
        [view removeFromSuperview];
    }
    BaseCellVC *vc = _viewControllers[1];
    [self.contView addSubview:vc.view];
    _button1.selected = NO;
    _button2.selected = YES;
    _button2.backgroundColor = UIColorFromRGB(0x00DDCC);
    _button1.backgroundColor = [UIColor clearColor];
//    if (_delegate && [_delegate respondsToSelector:@selector(button1Click)]) {
//        [self.delegate button2Click];
//    }
//        self.oneAction(2);
    
}
@end
