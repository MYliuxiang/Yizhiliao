//
//  MyVideoVC.h
//  Lliaoda
//
//  Created by 刘翔 on 2017/5/31.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "BaseViewController.h"
#import "MyVideoCell.h"
#import "MyVideoModel.h"
#import "VideoPlayVC.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface MyVideoVC : BaseViewController<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    
    NSString     *_mp4Path;
    NSDate       *_startDate;
    NSURL        *_videoUrl;
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *layout;

@property (nonatomic,retain) NSMutableArray *dataList;
@end
