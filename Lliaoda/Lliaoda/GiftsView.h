//
//  GiftsView.h
//  Lliaoda
//
//  Created by 刘翔 on 2017/6/23.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GiftCell.h"
#import "MGiftModel.h"
#import "PersonModel.h"
#import "GiftLayout.h"
@class LHChatVC;
@interface GiftsView : UIView<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *layout;

@property (nonatomic,retain) AgoraAPI *inst;
@property (nonatomic,retain) GiftLayout *gifLayout;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UILabel *elabel;
@property (weak, nonatomic) IBOutlet UIButton *chonBtn;
@property (nonatomic,copy) void(^giftBlock)(NSString *giftName, int diamonds,NSString *giftUid);
- (IBAction)chongAC:(id)sender;
@property (nonatomic,retain) NSMutableArray *dataList;
- (instancetype)initGiftsView;
@property (nonatomic,retain) PersonModel *pmodel;
@property (nonatomic, assign) BOOL isCall;
@end
