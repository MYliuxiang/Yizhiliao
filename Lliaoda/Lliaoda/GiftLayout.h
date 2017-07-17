//
//  GiftLayout.h
//  Lliaoda
//
//  Created by 刘翔 on 2017/6/28.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GiftLayout : UICollectionViewFlowLayout

//  一行中 cell 的个数
@property (nonatomic,assign) NSUInteger itemCountPerRow;

//    一页显示多少行
@property (nonatomic,assign) NSUInteger rowCount;

@end
