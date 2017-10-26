//
//  MyVideoVC.m
//  Lliaoda
//
//  Created by 刘翔 on 2017/5/31.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "MyVideoVC.h"

@interface MyVideoVC ()

@end

@implementation MyVideoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    self.nav.hidden = YES;
    self.nav.hidden = NO;
    self.dataList = [NSMutableArray array];
    
    _layout.sectionInset=UIEdgeInsetsMake(0, 15, 0, 15);
    _layout.minimumLineSpacing= 15;
    _layout.minimumInteritemSpacing= 15;
    _layout.itemSize = CGSizeMake((kScreenWidth - 45) / 2.0 - 1,(kScreenWidth - 45) / 2.0 - 1 );
    [_layout setScrollDirection:UICollectionViewScrollDirectionVertical];//滚动方向
    
    if (@available(iOS 11.0, *)) {
        _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    //設定代理
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [_collectionView registerNib:[UINib nibWithNibName:@"MyVideoCell" bundle:nil] forCellWithReuseIdentifier:@"MyVideoCellID"];
    _collectionView.backgroundColor = Color_bg;
    [self _loadData];

}

- (void)_loadData
{
    NSDictionary *params;
    params = @{@"type":@"video"};
    [WXDataService requestAFWithURL:Url_accountmedia params:params httpMethod:@"GET" isHUD:YES isErrorHud:YES finishBlock:^(id result) {
        if(result){
            if ([[result objectForKey:@"result"] integerValue] == 0) {
                [self.dataList removeAllObjects];
                NSArray *array = result[@"data"];
                for (NSDictionary *dic in array) {
                    MyVideoModel *model = [MyVideoModel mj_objectWithKeyValues:dic];
                    [self.dataList addObject:model];
                }
                
                if(self.reloadData){
                self.reloadData(self.dataList);
                }
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
    MyVideoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MyVideoCellID" forIndexPath:indexPath];
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
                
                MyVideoModel *model = self.dataList[row - 1];
                NSDictionary *params;
                params = @{@"uid":[NSString stringWithFormat:@"%d",model.uid]};
                [WXDataService requestAFWithURL:Url_accountmediarecover params:params httpMethod:@"POST" isHUD:YES isErrorHud:YES finishBlock:^(id result) {
                    if(result){
                        if ([[result objectForKey:@"result"] integerValue] == 0) {
                            for (MyVideoModel *model1 in self.dataList) {
                                if (model1.uid == model.uid) {
                                    model1.selected = 1;
                                }else{
                                    model1.selected = 0;
                                }
                            }
                            if(self.reloadData){
                                self.reloadData(self.dataList);
                            }
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
                
                MyVideoModel *model = self.dataList[row - 1];
                NSDictionary *params;
                params = @{@"uid":[NSString stringWithFormat:@"%d",model.uid]};
                [WXDataService requestAFWithURL:Url_accountmediaremove params:params httpMethod:@"POST" isHUD:YES isErrorHud:YES finishBlock:^(id result) {
                    if(result){
                        if ([[result objectForKey:@"result"] integerValue] == 0) {
                            
                            [self.collectionView performBatchUpdates:^{
                                [self.dataList removeObjectAtIndex:row - 1];
                                [self.collectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:row inSection:0]]];
                                
                            } completion:^(BOOL finished) {
                                
                                if (model.selected == 1) {
                                    
                                    MyVideoModel *fmodel = self.dataList[0];
                                    fmodel.selected = 1;
                                }
                                if(self.reloadData){
                                    self.reloadData(self.dataList);
                                }
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
            
            MyVideoModel *smodel = self.dataList[row - 1];
            if (smodel.selected != 1) {
                
                [alertController addAction:defaultAction];
                
            }            [alertController addAction:defaultAction1];
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
        
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:LXSring(@"拍摄") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
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
        
        MyVideoModel *model = self.dataList[indexPath.row - 1];
        
//        [[MPMoviePlayerController alloc] init]
        VideoPlayVC *vc = [[VideoPlayVC alloc] init];
//        vc.player = [AVPlayer playerWithURL:[];
//        vc.showsPlaybackControls = NO;
        //播放視訊
        vc.videoUrl = [NSURL URLWithString:model.url];
        [self presentViewController:vc animated:YES completion:nil];
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
        imagePickerController.sourceType = sourceType;
        imagePickerController.mediaTypes = @[(NSString *)kUTTypeMovie];
        imagePickerController.videoMaximumDuration = 30;

        [self presentViewController:imagePickerController animated:YES completion:^{
        }];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    //url

    [picker dismissViewControllerAnimated:YES completion:^{
        
        _videoUrl =[info objectForKey:UIImagePickerControllerMediaURL];
        [self revoverToMp4Whith:[info objectForKey:UIImagePickerControllerMediaURL]];
              
    }];
}
//图片截取
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


//转换格式为 mp4
- (void)revoverToMp4Whith:(NSURL *)url
{
    
    
    NSFileManager *fileManager
    = [NSFileManager defaultManager];
    NSArray *paths
    = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                          NSUserDomainMask,
                                          YES);
    NSString *documentsDirectory
    = [NSString stringWithFormat:@"%@/public",[paths objectAtIndex:0]];
    
    if(![fileManager fileExistsAtPath:documentsDirectory]){//如果不存在,则说明是第一次运行这个程序，那么建立这个文件夹
        NSLog(@"first run");
        NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        NSString *directryPath = [path stringByAppendingPathComponent:@"public"];
        [fileManager createDirectoryAtPath:directryPath withIntermediateDirectories:YES attributes:nil error:nil];
       
        [fileManager createFileAtPath:directryPath contents:nil attributes:nil];
    }
    
    NSArray *contents
    = [fileManager contentsOfDirectoryAtPath:documentsDirectory error:NULL];
    NSEnumerator *e = [contents objectEnumerator];
    NSString *filename;
    while ((filename = [e nextObject])) {
        
        if ([[filename pathExtension] isEqualToString:@"mp4"]) {
            
            [fileManager
             removeItemAtPath:[documentsDirectory stringByAppendingPathComponent:filename] error:NULL];
        }
    }
    
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:url options:nil];
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
    NSString     *_mp4Quality = AVAssetExportPresetMediumQuality;
    
    
    if ([compatiblePresets containsObject:_mp4Quality])
    {
        [SVProgressHUD showWithStatus:@"正在转码,请稍后..."];
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc]initWithAsset:avAsset
                                                                              presetName:_mp4Quality];
        NSDateFormatter *formater = [[NSDateFormatter alloc] init];
        [formater setDateFormat:@"yyyy-MM-dd-HH:mm:ss"];
        _mp4Path = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/public/output-%@.mp4", [formater stringFromDate:[NSDate date]]];
        
        exportSession.outputURL = [NSURL fileURLWithPath: _mp4Path];
        _startDate = [NSDate date];
        exportSession.outputFileType = AVFileTypeMPEG4;
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            switch ([exportSession status]) {
                case AVAssetExportSessionStatusFailed:
                {
                    [SVProgressHUD dismiss];
                    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                    message:[[exportSession error] localizedDescription]
                                                                   delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles: nil];
                    [alert show];
                    break;
                }
                    
                case AVAssetExportSessionStatusCancelled:
                    NSLog(@"Export canceled");
                    [SVProgressHUD dismiss];
                    
                    break;
                case AVAssetExportSessionStatusCompleted:
                    NSLog(@"Successful!");
                    
                    [self performSelectorOnMainThread:@selector(convertFinish) withObject:nil waitUntilDone:NO];
                    break;
                default:
                    break;
            }
        }];
    }else{
        [SVProgressHUD dismiss];
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"AVAsset doesn't support mp4 quality"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
    }
    
}

//获取視訊 大小
- (NSInteger)getFileSize:(NSString*) path
{
    NSFileManager * filemanager = [[NSFileManager alloc]init];
    if([filemanager fileExistsAtPath:path]){
        NSDictionary * attributes = [filemanager attributesOfItemAtPath:path error:nil];
        NSNumber *theFileSize;
        if ( (theFileSize = [attributes objectForKey:NSFileSize]) )
            return  [theFileSize intValue]/1024;
        else
            return -1;
    }else{
        
        return -1;
    }
}


//压缩完成
- (void) convertFinish
{
    CGFloat duration = [[NSDate date] timeIntervalSinceDate:_startDate];
    NSString *convertTime = [NSString stringWithFormat:@"%.2f s", duration];
    NSString *mp4Size = [NSString stringWithFormat:@"%ld kb", (long)[self getFileSize:_mp4Path]];
    NSLog(@"視訊时间长短%@",convertTime);
    NSLog(@"視訊大小%@",mp4Size);
    NSData *sssdata = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"file://localhost/private%@",_mp4Path]]];
    
    NSDictionary *params;
    params = @{@"private":@(0)};
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
                put.contentType = @"video/mp4";
                put.bucketName = result[@"data"][@"bucket"];
                NSDate*dat = [NSDate dateWithTimeIntervalSinceNow:0];
                NSTimeInterval a=[dat timeIntervalSince1970]*1000;
                NSString *timeString = [NSString stringWithFormat:@"%f", a];
                put.objectKey = [NSString stringWithFormat:@"%@/auth/%@.mp4",result[@"data"][@"path"],timeString];
                put.uploadingData = sssdata; // 直接上传NSData
                put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
                    NSLog(@"%lld, %lld, %lld", bytesSent, totalByteSent, totalBytesExpectedToSend);
                };
                
                
                OSSPutObjectRequest *put1 = [OSSPutObjectRequest new];
                put1.bucketName = result[@"data"][@"bucket"];
                put1.objectKey = [NSString stringWithFormat:@"%@/auth/%@_cover.jpg",result[@"data"][@"path"],timeString];
                UIImage *cropImage = [self getSubImageWith:[self thumbnailImageForVideo:_videoUrl
                                                                                 atTime:1]];
                
                NSData *photoData = UIImageJPEGRepresentation(cropImage, .3);
                put1.uploadingData = photoData;
                OSSTask *putTask = [client putObject:put];
                OSSTask *putTask1 = [client putObject:put1];
                [putTask continueWithBlock:^id(OSSTask *task) {
                    if (!task.error) {
                        
                    }else{
                    }
                    return nil;
                }];
                [putTask waitUntilFinished];
                
                [putTask1 continueWithBlock:^id(OSSTask *task) {
                    if (!task.error) {
                        
                        NSLog(@"upload object success!");
                        
                    }else{
                    }
                    return nil;
                }];
                [putTask1 waitUntilFinished];
                
                if (!putTask1.error && !putTask.error) {
                    
                    [self postWithPhotoPath:[NSString stringWithFormat:@"%@/auth/%@_cover.jpg",result[@"data"][@"path"],timeString] withVideoPath:[NSString stringWithFormat:@"%@/auth/%@.mp4",result[@"data"][@"path"],timeString]];
                    
                    
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
    
    
}

#pragma mark - 取出視訊图片
- (UIImage*) thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time
{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    NSParameterAssert(asset);
    AVAssetImageGenerator *assetImageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    CGImageRef thumbnailImageRef = NULL;
    CFTimeInterval thumbnailImageTime = time;
    NSError *thumbnailImageGenerationError = nil;
    thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 60) actualTime:NULL error:&thumbnailImageGenerationError];
    if (!thumbnailImageRef)
        NSLog(@"thumbnailImageGenerationError %@", thumbnailImageGenerationError);
    
    UIImage *thumbnailImage = thumbnailImageRef ? [[UIImage alloc] initWithCGImage:thumbnailImageRef] : nil;
    
    return thumbnailImage;
}


- (void)postWithPhotoPath:(NSString *)path1
            withVideoPath:(NSString *)path2
{
    
    
    NSDictionary *params;
    params = @{@"cover":path1,@"path":path2,@"type":@"video"};
    
    [WXDataService requestAFWithURL:Url_accountmedia params:params httpMethod:@"POST" isHUD:NO isErrorHud:YES finishBlock:^(id result) {
        if(result){
            if ([[result objectForKey:@"result"] integerValue] == 0) {
                
                               [SVProgressHUD dismiss];
                MyVideoModel *model = [MyVideoModel mj_objectWithKeyValues:result[@"data"]];
                
                NSIndexPath *oldPath;
                oldPath = [NSIndexPath indexPathForItem:1 inSection:0];
                
                
                   [self.collectionView performBatchUpdates:^{
                    [self.dataList insertObject:model atIndex:0];
                    [self.collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:1 inSection:0]]];
                    
                } completion:^(BOOL finished) {

                    if (self.reloadData) {
                        
                        self.reloadData(self.dataList);

                    }

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
