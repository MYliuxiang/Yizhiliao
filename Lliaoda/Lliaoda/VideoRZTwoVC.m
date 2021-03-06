//
//  VideoRZTwoVC.m
//  Lliaoda
//
//  Created by 刘翔 on 2017/4/20.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "VideoRZTwoVC.h"
#import <AVFoundation/AVFoundation.h>


@interface VideoRZTwoVC ()
{
    NSString     *_mp4Path;
    NSDate       *_startDate;
    
}
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;

@end

@implementation VideoRZTwoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.text = LXSring(@"視頻認證");
    self.label1.text = LXSring(@"距離完成認證僅差一步，請如實填寫手機號，以便我們及時聯繫你，賺取更多的收益！");
    self.label2.text = LXSring(@"手機號碼");
    self.label3.text = LXSring(@"公会名称");
    [self.completeBtn setTitle:LXSring(@"完成") forState:UIControlStateNormal];
    self.ghuiLabel.placeholder = LXSring(@"如沒有公會號，填寫000");
    self.textField.placeholder = LXSring(@"請輸入您真實的行動電話號碼");

    self.completeBtn.layer.cornerRadius = 22;
    self.completeBtn.layer.masksToBounds = YES;
    self.textField.delegate = self;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [self.view addGestureRecognizer:tap];
    
    [self.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
}

- (void)tap
{
    [self.view endEditing:YES];

}



#pragma mark -----UITextFieldDelegate
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//    
//}

- (void)textFieldDidChange:(UITextField *)textField
{
    
    if (textField == self.textField) {
        
        NSString *lang = [LXUserDefaults valueForKey:@"appLanguage"];
        if ([lang hasPrefix:@"zh-Hant"]) {
            
            if (textField.text.length > 10) {
                textField.text = [textField.text substringToIndex:10];
            }
            
        }else if ([lang hasPrefix:@"id"]){
            
            if (textField.text.length > 12) {
                textField.text = [textField.text substringToIndex:10];
            }
            
        }else{
            
//            if (textField.text.length > 10) {
//                textField.text = [textField.text substringToIndex:10];
//            }
        }

      
    }
    
}

- (IBAction)completeAC:(id)sender {
    
    NSString *lang = [LXUserDefaults valueForKey:@"appLanguage"];
    if ([lang hasPrefix:@"zh-Hant"]) {
        
        if (_textField.text.length != 10) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:LXSring(@"提示") message:LXSring(@"您输入的手機號碼不正确！") delegate:nil cancelButtonTitle:LXSring(@"確定") otherButtonTitles:nil, nil];
            [alert show];
            return;
            
        }
        
    }else if ([lang hasPrefix:@"id"]){
        
        if (_textField.text.length != 12) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:LXSring(@"提示") message:LXSring(@"您输入的手機號碼不正确！") delegate:nil cancelButtonTitle:LXSring(@"確定") otherButtonTitles:nil, nil];
            [alert show];
            return;
            
        }
        
    }else{
        
//        if (_textField.text.length != 10) {
//            
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:LXSring(@"提示") message:LXSring(@"您输入的手機號碼不正确！") delegate:nil cancelButtonTitle:LXSring(@"確定") otherButtonTitles:nil, nil];
//            [alert show];
//            return;
//            
//        }
    }

    
  
    if (_ghuiLabel.text.length == 0) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:LXSring(@"提示") message:LXSring(@"请填写公会号") delegate:nil cancelButtonTitle:LXSring(@"確定") otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    [self revoverToMp4Whith:[self.infoDic objectForKey:UIImagePickerControllerMediaURL]];

    
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
    = [paths objectAtIndex:0];
    
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
        
        [SVProgressHUD showWithStatus:LXSring(@"正在转码,请稍后...")];
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc]initWithAsset:avAsset
                                                                              presetName:_mp4Quality];
        NSDateFormatter* formater = [[NSDateFormatter alloc] init];
        [formater setDateFormat:@"yyyy-MM-dd-HH:mm:ss"];
        _mp4Path = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/output-%@.mp4", [formater stringFromDate:[NSDate date]]];
        
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


//压缩完成
- (void) convertFinish
{
    CGFloat duration = [[NSDate date] timeIntervalSinceDate:_startDate];
    NSString *convertTime = [NSString stringWithFormat:@"%.2f s", duration];
    NSString *mp4Size = [NSString stringWithFormat:@"%ld kb", (long)[self getFileSize:_mp4Path]];
    NSData *sssdata = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"file://localhost/private%@",_mp4Path]]];
    
    NSDictionary *params;
    params = @{@"private":@"0"};
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
                NSData *photoData = UIImageJPEGRepresentation([self thumbnailImageForVideo:[self.infoDic objectForKey:UIImagePickerControllerMediaURL]
                                                                                    atTime:1], .3);
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

- (void)postWithPhotoPath:(NSString *)path1
            withVideoPath:(NSString *)path2
{
    
    
    NSDictionary *params;
    params = @{@"cover":path1,@"video":path2};
    
    [WXDataService requestAFWithURL:Url_accountauth params:params httpMethod:@"POST" isHUD:NO isErrorHud:YES finishBlock:^(id result) {
        if(result){
            if ([[result objectForKey:@"result"] integerValue] == 0) {
                
                [SVProgressHUD dismiss];
//                VideoRZTwoVC *vc = [[VideoRZTwoVC alloc] init];
//                vc.capImage = [self thumbnailImageForVideo:[self.infoDic objectForKey:UIImagePickerControllerMediaURL]
//                                                    atTime:1];
//                vc.infoDic = self.infoDic;
//                [self.navigationController pushViewController:vc animated:YES];
                [self uploadPhone];
                
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


- (void)uploadPhone
{
    NSDictionary *params;
    if (self.ghuiLabel.text.length == 0) {
        params = @{@"phone":_textField.text};
        
    }else{
        
        params = @{@"phone":_textField.text,@"guild":_ghuiLabel.text};
        
    }
    [WXDataService requestAFWithURL:Url_account params:params httpMethod:@"POST" isHUD:YES isErrorHud:YES finishBlock:^(id result) {
        if(result){
            if ([[result objectForKey:@"result"] integerValue] == 0) {
                
                [SVProgressHUD showWithStatus:LXSring(@"上传成功")];
                dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.35 * NSEC_PER_SEC));
                dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                    [SVProgressHUD dismiss];
                    [self.navigationController popToRootViewControllerAnimated:YES];
                });
                
            }else{    //请求失败
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


@end
