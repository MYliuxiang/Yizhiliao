//
//  PersonHeaderCell.h
//  Lliaoda
//
//  Created by 小牛 on 2017/8/21.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "SelectedBannersHeader.h"
#import "PersonHeaderScroolView.h"
@interface PersonHeaderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet PersonHeaderScroolView *scroolBGView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *idLabel;
@property (weak, nonatomic) IBOutlet UIButton *ageButton;
@property (weak, nonatomic) IBOutlet UIButton *constellButton;
@property (weak, nonatomic) IBOutlet UIButton *priceButton;
@property (weak, nonatomic) IBOutlet UIButton *giftButton;
@property (weak, nonatomic) IBOutlet UIButton *rechatgeButton;
//@property (nonatomic, strong) SelectedBannersHeader *scrollView;
+ (PersonHeaderCell *)tableView:(UITableView *)tableView
                      indexPath:(NSIndexPath *)indexPath;

@property (nonatomic, strong) NSMutableArray *imagesArray;
@property (nonatomic, strong) NSMutableArray *titlesArray;
@property (nonatomic, strong) NSMutableArray *linksArray;
@end
