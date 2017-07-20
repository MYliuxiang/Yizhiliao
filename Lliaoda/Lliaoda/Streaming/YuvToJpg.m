//
//  YuvToJpg.m
//  OpenVideoCall
//
//  Created by andy on 17/6/9.
//  Copyright © 2017年 Agora. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YuvToJpg.h"
#import <UIKit/UIKit.h>

@implementation YuvToJpg

int a = 0;

+ (void)yuv_to_jpg
{
    NSLog(@" yuv_to_jpg --------");
}
// Agora SDK Raw Data format is YUV420P
+ (void)yuv420p_to_nv12:(unsigned char*) yuv420p nv12:(unsigned char*)nv12 width: (int)width  height: (int)height{
    int i, j;
    int y_size = width * height;
    
    unsigned char* y = yuv420p;
    unsigned char* u = yuv420p + y_size;
    unsigned char* v = yuv420p + y_size * 5 / 4;
    
    unsigned char* y_tmp = nv12;
    unsigned char* uv_tmp = nv12 + y_size;
    
    // y
    memcpy(y_tmp, y, y_size);
    
    // u
    for (j = 0, i = 0; j < y_size/2; j+=2, i++)
    {
        // swtich the location of U、V，to NV12 or NV21
#if 1
        uv_tmp[j] = u[i];
        uv_tmp[j+1] = v[i];
#else
        uv_tmp[j] = v[i];
        uv_tmp[j+1] = u[i];
#endif
    }
}

+ (void) test:(unsigned char *)y ubuf:(unsigned char *)u vbuf:(unsigned char *)v ystride:(int)ystride ustride:(int)ustride vstride:(int)vstride width:(int)width height:(int)height chanel:(NSString *)chanel
{
    
//    //关闭原始数据
//
    NSLog(@" Here it is ！ --------");
    a++;
    if(a%10==0)
    {
        
        [AGVideoProcessing deregisterVideoPreprocessing:[AgoraRtcEngineKit sharedEngineWithAppId:agoreappID delegate:nil]];
        
        NSLog(@" yuv_to_jpg_01 --------");
        int Len = ystride * height * 3/2;
        int yLength = ystride * height;
        int uLength = yLength / 4;
        
        unsigned char *buf = (unsigned char *)malloc(Len);
        memcpy(buf,y,yLength);
        memcpy(buf + yLength, u, uLength);
        memcpy(buf + yLength + uLength, v, uLength);
        
        
//        [[VideoCallView share].openGLESView displayYUV420pData:buf width:width height:height];
        
        unsigned char *NV12buf = (unsigned char *)malloc(Len);
        [self yuv420p_to_nv12:buf nv12:NV12buf width:ystride height:height];
        
        [self UIImageToJpg:NV12buf width:ystride height:height chanel:chanel];
    
        if(buf != NULL)
        {
            free(buf);
            buf = NULL;
        }
        
        if(NV12buf != NULL)
        {
            free(NV12buf);
            NV12buf = NULL;
        }
    }
}


+(void)UIImageToJpg:(unsigned char *)buf width:(int)width height:(int)height chanel:(NSString *)chanel
{
    NSString*pngPath=[NSHomeDirectory()stringByAppendingPathComponent:@"Documents/Test.png"];
    
    NSString*jpgPath=[NSHomeDirectory()stringByAppendingPathComponent:@"Documents/Test.jpg"];
    
    NSLog(@" jpgPath: %@", jpgPath);
    
    // Write a UIImage to JPEG with minimum compression (best quality)
    // The value 'image' must be a UIImage object
    // The value '1.0' represents image compression quality asimage value from 0.0 to 1.0
    
    UIImage * image = [self YUVtoUIImage:width h:height buffer:buf];
    NSData *imageData = UIImageJPEGRepresentation(image, .3);
    
    NSDictionary *params;
    params = @{@"private":@1,@"type":@"capture"};
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
                NSString *uid = [NSString stringWithFormat:@"%@",[LXUserDefaults objectForKey:UID]];
                NSString *timeString = [NSString stringWithFormat:@"%d",b];
                put.objectKey = [NSString stringWithFormat:@"%@/%@/%@_%@_%@.jpg",result[@"data"][@"path"],chanel,uid,chanel,timeString];
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
                    
                 
                    
                    
                }
            }else{    //请求失败
                
            }
            
        
        }
        
    } errorBlock:^(NSError *error) {
        NSLog(@"%@",error);
        
    }];
    






    //UIImage * image =  [self makeUIImage:buf width:width height:height scale:2];
//    [UIImageJPEGRepresentation(image,
//                               1.0)
//     writeToFile:jpgPath atomically:YES];
//
//    // Write image to PNG
//    [UIImagePNGRepresentation(image)
//     writeToFile:pngPath atomically:YES];
//    
//    // Let's check to see if files were successfully written...
//    // Create file manager
//    NSError *error;
//    NSFileManager *fileMgr =[NSFileManager defaultManager];
//    
//    // Point to Document directory
//    NSString *documentsDirectory =
//        [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
//    
//    // Write out the contents of home directory to console
//    NSLog(@"Documents directory: %@", [fileMgr
//          contentsOfDirectoryAtPath:documentsDirectory
//          error:&error]);
}

unsigned char *  YV12_to_RGB24(unsigned char* pYV12, unsigned char* pRGB24, int iWidth, int iHeight)
{
    if(!pYV12 || !pRGB24)
        return false;
    
     int nYLen = iHeight * iWidth;
     int nHfWidth = (iWidth>>1);
    
    if(nYLen<1 || nHfWidth<1)
        return false;
    
    // yv12数据格式，其中Y分量长度为width * height, U和V分量长度都为width * height / 4
    // |WIDTH |
    // y......y--------
    // y......y HEIGHT
    // y......y
    // y......y--------
    // v..v
    // v..v
    // u..u
    // u..u
    unsigned char * yData = pYV12;
    unsigned char * vData = &yData[nYLen];
    unsigned char * uData = &vData[nYLen>>2];
    
    if(!uData || !vData)
        return false;
    
    // Convert YV12 to RGB24
    //
    // formula
    // [1 1 1 ]
    // [r g b] = [y u-128 v-128] [0 0.34375 0 ]
    // [1.375 0.703125 1.734375]
    // another formula
    // [1 1 1 ]
    // [r g b] = [y u-128 v-128] [0 0.698001 0 ]
    // [1.370705 0.703125 1.732446]
    int rgb[3];
    int i, j, m, n, x, y;
    m = -iWidth;
    n = -nHfWidth;
    for(y=0; y < iHeight; y++)
    {
        m += iWidth;
        if(!(y % 2))
            n += nHfWidth;
        for(x=0; x < iWidth; x++)
        {
            i = m + x;
            j = n + (x>>1);
            rgb[2] = yData[i] + 1.370705 * (vData[j] - 128); // r分量值
            rgb[1] = yData[i] - 0.698001 * (uData[j] - 128) - 0.703125 * (vData[j] - 128); // g分量值
            rgb[0] = yData[i] + 1.732446 * (uData[j] - 128); // b分量值
            
            j = nYLen - iWidth - m + x;  
            i = (j<<1) + j;  
            for(j=0; j<3; j++)  
            {  
                if(rgb[j]>=0 && rgb[j]<=255)  
                    pRGB24[i + j] = rgb[j];  
                else  
                    pRGB24[i + j] = (rgb[j] < 0) ? 0 : 255;  
            }  
        }  
    }  
    return pRGB24;
}


int * yuv_to_rgb(unsigned char *yuv,int width, int height)
{
    
    //byte[] yuv = rotateYUV420Degree270_1(yuv1,width,height);
    BOOL invertHeight = false;
    if (height < 0) {
        height =-height;
        invertHeight = true;
    }
    
    BOOL invertWidth = false;
    if (width < 0) {
        width = -width;
        invertWidth = true;
    }
    
    
    int iterations = width * height;
    //if ((iterations*3)/2 > yuv.length){throw new IllegalArgumentException();}
    //int * rgb = new int[iterations];
    int * rgb = (int*)malloc(iterations*sizeof(int));

    
    for (int i = 0; i < iterations; i++) {
        /*int y = yuv[i] & 0x000000ff;
         int u = yuv[iterations+(i/4)] & 0x000000ff;
         int v = yuv[iterations + iterations/4 + (i/4)] & 0x000000ff;*/
        int nearest = (i / width) / 2 * (width / 2) + (i % width) / 2;
        
        int y = yuv[i] & 0x000000ff;
        int u = yuv[iterations + nearest] & 0x000000ff;
        
        
        int v = yuv[iterations + iterations / 4 + nearest] & 0x000000ff;
        
        //int b = (int)(1.164*(y-16) + 2.018*(u-128));
        //int g = (int)(1.164*(y-16) - 0.813*(v-128) - 0.391*(u-128));
        //int r = (int)(1.164*(y-16) + 1.596*(v-128));
        
        //double Y = (y/255.0);
        //double Pr = (u/255.0-0.5);
        //double Pb = (v/255.0-0.5);
        
        
        
        /*int b = (int)(1.164*(y-16)+1.8556*(u-128));
         
         int g = (int)(1.164*(y-16) - (0.4681*(v-128) + 0.1872*(u-128)));
         int r = (int)(1.164*(y-16)+1.5748*(v-128));*/
        
        int b = (int) (y + 1.8556 * (u - 128));
        
        int g = (int) (y - (0.4681 * (v - 128) + 0.1872 * (u - 128)));
        
        int r = (int) (y + 1.5748 * (v - 128));
        
        
        /*double B = Y+1.8556*Pb;
         
         double G = Y - (0.4681*Pr + 0.1872*Pb);
         double R = Y+1.5748*Pr;*/
        
        //int b = (int)B*255;
        //int g = (int)G*255;
        //int r = (int)R*255;
        
        
        if (b > 255) {
            b = 255;
        } else if (b < 0) {
            b = 0;
        }
        if (g > 255) {
            g = 255;
        } else if (g < 0) {
            g = 0;
        }
        if (r > 255) {
            r = 255;
        } else if (r < 0) {
            r = 0;
        }
        
        /*rgb[i]=(byte)b;
         rgb[i+1]=(byte)g;
         rgb[i+2]=(byte)r;*/
        int targetPosition = i;
        
        if (invertHeight) {
            targetPosition = ((height - 1) - targetPosition / width) * width + (targetPosition % width);
        }
        if (invertWidth) {
            targetPosition = (targetPosition / width) * width + (width - 1) - (targetPosition % width);
        }
        
        
        rgb[targetPosition] = (0xff000000) | (0x00ff0000 & r << 16) | (0x0000ff00 & g << 8) | (0x000000ff & b);
    }
    return rgb;
    
}

//This is API work well for NV12 data format only.
+(UIImage *)YUVtoUIImage:(int)w h:(int)h buffer:(unsigned char *)buffer{
    //YUV(NV12)-->CIImage--->UIImage Conversion
    NSDictionary *pixelAttributes = @{(NSString*)kCVPixelBufferIOSurfacePropertiesKey:@{}};
    
    
    CVPixelBufferRef pixelBuffer = NULL;
    
    CVReturn result = CVPixelBufferCreate(kCFAllocatorDefault,
                                          w,
                                          h,
                                          kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange,
                                          (__bridge CFDictionaryRef)(pixelAttributes),
                                          &pixelBuffer);
    
    CVPixelBufferLockBaseAddress(pixelBuffer,0);
    unsigned char *yDestPlane = CVPixelBufferGetBaseAddressOfPlane(pixelBuffer, 0);
    
    // Here y_ch0 is Y-Plane of YUV(NV12) data.
    unsigned char *y_ch0 = buffer;
    unsigned char *y_ch1 = buffer + w * h;
    memcpy(yDestPlane, y_ch0, w * h);
    unsigned char *uvDestPlane = CVPixelBufferGetBaseAddressOfPlane(pixelBuffer, 1);
    
    // Here y_ch1 is UV-Plane of YUV(NV12) data.
    memcpy(uvDestPlane, y_ch1, w * h/2);
    CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);
    
    if (result != kCVReturnSuccess) {
        NSLog(@"Unable to create cvpixelbuffer %d", result);
    }
    
    // CIImage Conversion
    CIImage *coreImage = [CIImage imageWithCVPixelBuffer:pixelBuffer];
    
    CIContext *MytemporaryContext = [CIContext contextWithOptions:nil];
    CGImageRef MyvideoImage = [MytemporaryContext createCGImage:coreImage
                                                       fromRect:CGRectMake(0, 0, w, h)];
    
    // UIImage Conversion
    UIImage *Mynnnimage = [[UIImage alloc] initWithCGImage:MyvideoImage
                                                     scale:1.0
                                               orientation:UIImageOrientationRight];
    
    CVPixelBufferRelease(pixelBuffer);
    CGImageRelease(MyvideoImage);
    
    return Mynnnimage;
}

@end
