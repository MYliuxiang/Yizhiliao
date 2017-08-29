//
//  OnlineUserVC.h
//  Lliaoda
//
//  Created by 小牛 on 2017/8/29.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "BaseViewController.h"

@interface OnlineUserVC : BaseViewController<UITableViewDelegate, UITableViewDataSource>
{
    int _begin;
    BOOL _isdownLoad;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *bannersArray;
@property (nonatomic, retain) NSMutableArray *bannersTitlesArray;
@property (nonatomic, retain) NSMutableArray *bannersImagesArray;
@property (nonatomic, retain) NSMutableArray *bannersLinksArray;
@property (nonatomic,retain) NSMutableArray *tDataList;
@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;
@end
