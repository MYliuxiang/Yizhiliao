//
//  SetHeaderImageVC.m
//  Lliaoda
//
//  Created by 小牛 on 2017/8/25.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "SetHeaderImageVC.h"

@interface SetHeaderImageVC ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@end

@implementation SetHeaderImageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.text = LXSring(@"个人头像");
    [self.cameraButton setTitle:LXSring(@"相机") forState:UIControlStateNormal];
    [self.albumButton setTitle:LXSring(@"相册") forState:UIControlStateNormal];
    
    self.buttonBGView.layer.cornerRadius = 5;
    self.buttonBGView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.buttonBGView.layer.shadowRadius = 5.f;
    self.buttonBGView.layer.shadowOpacity = .3f;
    self.buttonBGView.layer.shadowOffset = CGSizeMake(0, 0);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)cameraButtonAC:(id)sender {
    //判断是否支持相机
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        // 跳转到相机或相薄页面
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
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
        
        
        //        NSData *imageData = UIImageJPEGRepresentation(image, .3);
        //        
    }];
    
}
- (void)postPhotopath:(NSString *)path
            withImage:(UIImage *)image
{
    
    NSDictionary *params;
    params = @{@"portrait":path};
    
    [WXDataService requestAFWithURL:Url_account params:params httpMethod:@"POST" isHUD:NO isErrorHud:YES finishBlock:^(id result) {
        if(result){
            if ([[result objectForKey:@"result"] integerValue] == 0) {
                
                [SVProgressHUD dismiss];
//                self.model.portrait = result[@"data"][@"portrait"];
                [_headerImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", result[@"data"][@"portrait"]]]];
                [LXUserDefaults setObject:result[@"data"][@"portrait"] forKey:Portrait];
                [LXUserDefaults synchronize];
                
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
- (IBAction)albumButtonAC:(id)sender {
    //判断是否支持相机
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        // 跳转到相机或相薄页面
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePickerController animated:YES completion:^{
        }];
    }
}
@end
