//
//  MyalbumVC.m
//  Lliaoda
//
//  Created by 刘翔 on 2017/5/27.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "MyalbumVC.h"

@interface MyalbumVC ()


@end

@implementation MyalbumVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.nav.hidden = NO;
    self.dataList = [NSMutableArray array];

    if (@available(iOS 11.0, *)) {
//        _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    _layout.sectionInset=UIEdgeInsetsMake(0, 15, 0, 15);
    _layout.minimumLineSpacing= 15;
    _layout.minimumInteritemSpacing= 15;
    _layout.itemSize = CGSizeMake((kScreenWidth - 60) / 3.0 - 1,(kScreenWidth - 60) / 3.0 - 1 );
//    _layout.itemSize = CGSizeMake((kScreenWidth - 45) / 2.0 - 1,(kScreenWidth - 45) / 2.0 - 1 );

    [_layout setScrollDirection:UICollectionViewScrollDirectionVertical];//滚动方向
    
    //設定代理
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    [_collectionView registerNib:[UINib nibWithNibName:@"MyalbumCell" bundle:nil] forCellWithReuseIdentifier:@"MyalbumCellID"];
    _collectionView.backgroundColor = Color_bg;
    NSLog(@"%f",self.view.width);
    
    [self _loadData];

}

- (void)_loadData
{
    NSDictionary *params;
    params = @{@"type":@"photo"};
    [WXDataService requestAFWithURL:Url_accountmedia params:params httpMethod:@"GET" isHUD:YES isErrorHud:YES finishBlock:^(id result) {
        if(result){
            if ([[result objectForKey:@"result"] integerValue] == 0) {
                [self.dataList removeAllObjects];
                NSArray *array = result[@"data"];
                for (NSDictionary *dic in array) {
                    AlbumModel *model = [AlbumModel mj_objectWithKeyValues:dic];
                    [self.dataList addObject:model];
                }
                self.reloadData(self.dataList);
                [self.collectionView reloadData];
                
                
            } else{
                [SVProgressHUD showErrorWithStatus:result[@"message"]];
                dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
                dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                    
                    [SVProgressHUD dismiss];
                });
                
            }
        }
        
    } errorBlock:^(NSError *error) {
        NSLog(@"%@",error);
        
    }];

}

#pragma mark - UICollectionView Delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
   
    
    return self.dataList.count + 1;
    
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //如果有闲置的就拿到使用,如果没有,系统自动的去创建
    MyalbumCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MyalbumCellID" forIndexPath:indexPath];
    if (indexPath.row == 0) {
        cell.isFirst = YES;
    }else{
    
        cell.isFirst = NO;
    }
    if (indexPath.row != 0) {
        
        cell.model = self.dataList[indexPath.row - 1];

    }
    cell.bgImageView.tag = indexPath.row + 100;
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGuesture:)];
    [cell.bgImageView addGestureRecognizer:longPress];
    
    [cell setNeedsLayout];
    
    return cell;
}

- (void)handleLongPressGuesture:(UILongPressGestureRecognizer *)guesture {

    if(guesture.state == UIGestureRecognizerStateEnded){
        //获取目标cell
        NSInteger row= guesture.view.tag - 100;
        //删除操作
        if (row > 0) {
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            
            
            UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:LXSring(@"設定封面") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                AlbumModel *model = self.dataList[row - 1];
                NSDictionary *params;
                params = @{@"uid":[NSString stringWithFormat:@"%d",model.uid]};
                [WXDataService requestAFWithURL:Url_accountmediarecover params:params httpMethod:@"POST" isHUD:YES isErrorHud:YES finishBlock:^(id result) {
                    if(result){
                        if ([[result objectForKey:@"result"] integerValue] == 0) {
                            for (AlbumModel *model1 in self.dataList) {
                                if (model1.uid == model.uid) {
                                    model1.selected = 1;
                                }else{
                                    model1.selected = 0;
                                }
                            }
                            self.reloadData(self.dataList);

                            [self.collectionView reloadData];
                           
                            
                        } else{
                            [SVProgressHUD showErrorWithStatus:result[@"message"]];
                            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
                            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                                
                                [SVProgressHUD dismiss];
                            });
                            
                        }
                    }
                    
                } errorBlock:^(NSError *error) {
                    NSLog(@"%@",error);
                    
                }];
                
                
            }];
            
            UIAlertAction *defaultAction1 = [UIAlertAction actionWithTitle:LXSring(@"删除") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                AlbumModel *model = self.dataList[row - 1];
                NSDictionary *params;
                params = @{@"uid":[NSString stringWithFormat:@"%d",model.uid]};
                [WXDataService requestAFWithURL:Url_accountmediaremove params:params httpMethod:@"POST" isHUD:YES isErrorHud:YES finishBlock:^(id result) {
                    if(result){
                        if ([[result objectForKey:@"result"] integerValue] == 0) {
                            
                            [self.collectionView performBatchUpdates:^{
                            [self.dataList removeObjectAtIndex:row - 1];
                            [self.collectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:row  inSection:0]]];
                                
                            } completion:^(BOOL finished) {
                                
                                if (model.selected == 1) {
                                    
                                    AlbumModel *fmodel = self.dataList[0];
                                    fmodel.selected = 1;
                                }
                                
                                self.reloadData(self.dataList);

                                [self.collectionView reloadData];
                                
                            }];
                            
                            
                        } else{
                            [SVProgressHUD showErrorWithStatus:result[@"message"]];
                            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
                            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                                
                                [SVProgressHUD dismiss];
                            });
                            
                        }
                    }
                    
                } errorBlock:^(NSError *error) {
                    NSLog(@"%@",error);
                    
                }];

                
            }];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:LXSring(@"取消") style:UIAlertActionStyleCancel handler:nil];
            [cancelAction setValue:Color_Text_lightGray forKey:@"_titleTextColor"];
            [defaultAction setValue:Color_Tab forKey:@"_titleTextColor"];
            [defaultAction1 setValue:Color_Text_lightGray forKey:@"_titleTextColor"];
            
            AlbumModel *smodel = self.dataList[row - 1];
            if (smodel.selected != 1) {
                
                [alertController addAction:defaultAction];

            }
            
            
            
            [alertController addAction:defaultAction1];
            [alertController addAction:cancelAction];
            [self presentViewController:alertController animated:YES completion:nil];
 
            
            
        }
    }
   
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
      //添加照片
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:LXSring(@"拍照") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self CreameAction:1];
            
            
        }];
        
        UIAlertAction *defaultAction1 = [UIAlertAction actionWithTitle:LXSring(@"从手机相薄选择") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self CreameAction:2];
            
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:LXSring(@"取消") style:UIAlertActionStyleCancel handler:nil];
        [cancelAction setValue:Color_Text_lightGray forKey:@"_titleTextColor"];
        [defaultAction setValue:Color_Tab forKey:@"_titleTextColor"];
        [defaultAction1 setValue:Color_Tab forKey:@"_titleTextColor"];
        
        [alertController addAction:defaultAction];
        [alertController addAction:defaultAction1];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
        

        
    }else{
    
        NSMutableArray *images = [NSMutableArray array];
        for (AlbumModel *model in self.dataList) {
            [images addObject:model.url];
        }
        // 加载网络图片
        NSMutableArray *browseItemArray = [[NSMutableArray alloc]init];
        int i = 0;
        for(i = 0;i < self.dataList.count ;i++)
        {
            AlbumModel *model = self.dataList[i];
            UIImageView *imageView = [self.view viewWithTag:i + 100 + 1];
            MSSBrowseModel *browseItem = [[MSSBrowseModel alloc]init];
            browseItem.bigImageUrl = model.url;// 加载网络图片大图地址
            browseItem.smallImageView = imageView;// 小图
            [browseItemArray addObject:browseItem];
        }
        MSSBrowseNetworkViewController *bvc = [[MSSBrowseNetworkViewController alloc]initWithBrowseItemArray:browseItemArray currentIndex:indexPath.row - 1];
        //    bvc.isEqualRatio = NO;// 大图小图不等比时需要設定这个属性（建议等比）
        [bvc showBrowseViewController];
    
    }
    
}





////拍照的点击事
- (void)CreameAction:(NSInteger )index{
    
    static NSUInteger sourceType;
    
    if (index ==1) {
        sourceType = UIImagePickerControllerSourceTypeCamera;
    }else if(index ==2){
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    //判断是否支持相机
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        // 跳转到相机或相薄页面
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = sourceType;
        [self presentViewController:imagePickerController animated:YES completion:^{
        }];
    }
}

-(UIImage *)getSubImageWith:(UIImage *)originalImage
{
    
    CGRect cropFrame = CGRectMake(0, 0, kScreenWidth, kScreenWidth);
    CGRect squareFrame = CGRectMake(0, 0, kScreenWidth, kScreenWidth);
    
    CGFloat oriWidth = cropFrame.size.width;
    CGFloat oriHeight = originalImage.size.height * (oriWidth / originalImage.size.width);
    CGFloat oriX = cropFrame.origin.x + (cropFrame.size.width - oriWidth) / 2;
    CGFloat oriY = cropFrame.origin.y + (cropFrame.size.height - oriHeight) / 2;
    CGRect oldFrame = CGRectMake(oriX, oriY, oriWidth, oriHeight);
    CGRect latestFrame = oldFrame;
    
    CGFloat scaleRatio = latestFrame.size.width / originalImage.size.width;
    CGFloat x = (squareFrame.origin.x - latestFrame.origin.x) / scaleRatio;
    CGFloat y = (squareFrame.origin.y - latestFrame.origin.y) / scaleRatio;
    CGFloat w = squareFrame.size.width / scaleRatio;
    CGFloat h = squareFrame.size.width / scaleRatio;
    if (latestFrame.size.width < cropFrame.size.width) {
        CGFloat newW = originalImage.size.width;
        CGFloat newH = newW * (cropFrame.size.height /cropFrame.size.width);
        x = 0; y = y + (h - newH) / 2;
        w = newH; h = newH;
    }
    if (latestFrame.size.height < cropFrame.size.height) {
        CGFloat newH = originalImage.size.height;
        CGFloat newW = newH * (cropFrame.size.width / cropFrame.size.height);
        x = x + (w - newW) / 2; y = 0;
        w = newH; h = newH;
    }
    CGRect myImageRect = CGRectMake(x, y, w, h);
    CGImageRef imageRef = originalImage.CGImage;
    CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, myImageRect);
    CGSize size;
    size.width = myImageRect.size.width;
    size.height = myImageRect.size.height;
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, myImageRect, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();
    return smallImage;
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
//        UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
         UIImage *image =  [self getSubImageWith:[info objectForKey:UIImagePickerControllerEditedImage]];
        NSData *imageData = UIImageJPEGRepresentation(image, .3);
        
        NSDictionary *params;
        params = @{@"private":@0};
        [SVProgressHUD showWithStatus:LXSring(@"正在上传")];
        [WXDataService requestAFWithURL:Url_storagekey params:params httpMethod:@"POST" isHUD:NO isErrorHud:YES finishBlock:^(id result) {
            if(result){
                if ([[result objectForKey:@"result"] integerValue] == 0) {
                    NSString *key = result[@"data"][@"key"];
                    NSString *secret = result[@"data"][@"secret"];
                    NSString *token = result[@"data"][@"token"];
                    NSString *endpoint = result[@"data"][@"endpoint"];
                    id<OSSCredentialProvider> credential = [[OSSStsTokenCredentialProvider alloc] initWithAccessKeyId:key secretKeyId:secret securityToken:token];
                    OSSClient *client = [[OSSClient alloc] initWithEndpoint:endpoint credentialProvider:credential];
                    OSSPutObjectRequest *put = [OSSPutObjectRequest new];
                    put.bucketName = result[@"data"][@"bucket"];
                    NSDate*dat = [NSDate dateWithTimeIntervalSinceNow:0];
                    NSTimeInterval a=[dat timeIntervalSince1970];
                    int b = a;
                    NSString *timeString = [NSString stringWithFormat:@"%d",b];
                    put.objectKey = [NSString stringWithFormat:@"%@/media/%@_cover.jpg",result[@"data"][@"path"],timeString];
                    put.uploadingData = imageData; // 直接上传NSData
                    put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
                        NSLog(@"%lld, %lld, %lld", bytesSent, totalByteSent, totalBytesExpectedToSend);
                    };
                    
                    OSSTask *putTask = [client putObject:put];
                    [putTask continueWithBlock:^id(OSSTask *task) {
                        if (!task.error) {
                            
                            NSLog(@"upload object success!");
                            
                        }else{
                            
                        }
                        return nil;
                    }];
                    [putTask waitUntilFinished];
                    
                    if (!putTask.error) {
                        
                        [self postPhotopath:[NSString stringWithFormat:@"%@/media/%@_cover.jpg",result[@"data"][@"path"],timeString] withImage:image];
                        
                        
                    }else{
                        
                        [SVProgressHUD showErrorWithStatus:LXSring(@"上传失败")];
                        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.35 * NSEC_PER_SEC));
                        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                            
                            [SVProgressHUD dismiss];
                        });
                        
                    }
                    
                }else{    //请求失败
                    [SVProgressHUD showErrorWithStatus:result[@"message"]];
                    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.35 * NSEC_PER_SEC));
                    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                        
                        [SVProgressHUD dismiss];
                    });
                    
                }
                
            }
            
        } errorBlock:^(NSError *error) {
            NSLog(@"%@",error);
            
        }];
        
    }];
}

- (void)postPhotopath:(NSString *)path
            withImage:(UIImage *)image
{
    
    NSDictionary *params;
    params = @{@"type":@"photo",@"path":path};
    
    [WXDataService requestAFWithURL:Url_accountmedia params:params httpMethod:@"POST" isHUD:NO isErrorHud:YES finishBlock:^(id result) {
        if(result){
            if ([[result objectForKey:@"result"] integerValue] == 0) {
                
                [SVProgressHUD dismiss];
                AlbumModel *model = [AlbumModel mj_objectWithKeyValues:result[@"data"]];
                
                NSIndexPath *oldPath;
                oldPath = [NSIndexPath indexPathForItem:1 inSection:0];

//                for (int i = 0; i<self.dataList.count; i++) {
//                    AlbumModel *oldModel = self.dataList[i];
//                    if (oldModel.selected == 1) {
//                        oldPath = [NSIndexPath indexPathForItem:i+ 1 inSection:0];
//                        oldModel.selected = 0;
//                    }
//                }
//                [self.collectionView reloadItemsAtIndexPaths:@[oldPath]];
                
                [self.collectionView performBatchUpdates:^{
                    [self.dataList insertObject:model atIndex:0];
                    [self.collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:1 inSection:0]]];
                    
                } completion:^(BOOL finished) {
                    
//                    self.reloadData(self.dataList);
                    [self.collectionView reloadData];
                    
                }];

                

                
            } else{
                [SVProgressHUD showErrorWithStatus:result[@"message"]];
                dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
                dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                    
                    [SVProgressHUD dismiss];
                });
                
            }
        }
        
    } errorBlock:^(NSError *error) {
        NSLog(@"%@",error);
        
    }];

    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
