//
//  ViewController.m
//  GPUImageDemo
//
//  Created by chenyh on 16/7/4.
//  Copyright © 2016年 chenyh. All rights reserved.
//

#import "ViewController.h"
#import "CaptureViewController.h"
#import "SimpleVideoFileFilterViewController.h"


@interface ViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIActionSheetDelegate,SimpleVideoFileFilterViewControllerDelegate>
@property (nonatomic,strong)NSString *videoPath;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    
    button.frame=CGRectMake(20, 100,self.view.bounds.size.width-40, 30);
    
    [button setTitle:@"打开选择资源的方式" forState:UIControlStateNormal];
    [button setTitleColor: [UIColor blueColor] forState:UIControlStateNormal];
    
    [button addTarget:self action:@selector(selectOpenGetRource) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)selectOpenGetRource
{
    
    UIActionSheet *as=[[UIActionSheet alloc]initWithTitle:@"选择资源" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"自己拍摄" otherButtonTitles:@"从相册中选择", nil ];
    as.actionSheetStyle=2;
    [as showInView:[[[UIApplication sharedApplication] delegate] window]];


}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    switch (buttonIndex) {
        case 0:
        {
            [self pickVideoFromCamera];
           
        }
            //相册选择
            break;
        case 1:
            //自己拍摄
        {
             [self pickVideoFromPhotoAlbum];
           
        }
            
        break;
        default:
            break;
    }
    
    
}


- (NSString *)getTmpPath
{
    
    NSError *err = nil;
    

    if ([[NSFileManager defaultManager] fileExistsAtPath:[NSTemporaryDirectory() stringByAppendingPathComponent:@"tmpHandle.mp4"]]) {
        [[NSFileManager defaultManager] removeItemAtPath:[NSTemporaryDirectory() stringByAppendingPathComponent:@"tmpHandle.mp4"] error:&err];
        
    }
    
  return  [NSTemporaryDirectory() stringByAppendingPathComponent:@"tmpHandle.mp4"];
    
}



#pragma mark - pickBackgroundVideoFromPhotosAlbum
//这个是从相册选
- (void)pickBackgroundVideoFromPhotosAlbum
{
    [self pickVideoFromPhotoAlbum];
}

- (void)pickVideoFromPhotoAlbum
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        // Only movie
        NSArray* availableMedia = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
        picker.mediaTypes = [NSArray arrayWithObject:availableMedia[1]];
    }
    
    [self presentViewController:picker animated:YES completion:nil];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:NO completion:nil];
}



#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // 1.
    [self dismissViewControllerAnimated:NO completion:nil];
    
    NSLog(@"info = %@",info);
    
    // 2.
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if([mediaType isEqualToString:@"public.movie"])
    {
        NSURL *url = [info objectForKey:UIImagePickerControllerMediaURL];
        //        [self setPickedVideo:url];
        
        SimpleVideoFileFilterViewController *newFilter=[SimpleVideoFileFilterViewController new];
        newFilter.inputFilePath=url.path;
        newFilter.outputFilePath=[self getTmpPath];
        
        newFilter.vcdelegate=self;
        
        [self presentViewController:newFilter animated:YES completion:nil];
        
    }
    else
    {
        NSLog(@"Error media type");
        return;
    }
}


#pragma mark - 自己拍摄
- (void)pickVideoFromCamera
{
    CaptureViewController *captureVC = [[CaptureViewController alloc] init];
    WC;
    
    [captureVC setCallback:^(BOOL success, id result)
     {
         if (success)
         {
             NSURL *fileURL = result;
             
             weakSelf.videoPath = fileURL.path;
             
             [self performSelector:@selector(showS) withObject:self afterDelay:1.0];
             
             
             
             //成功则开始进行滤镜
         }
         else
         {
             NSLog(@"Video Picker Failed: %@", result);
         }
     }];
    
    [self presentViewController:captureVC animated:YES completion:^{
        NSLog(@"PickVideo present");
    }];
}

- (void)showS{

    SimpleVideoFileFilterViewController *newFilter=[SimpleVideoFileFilterViewController new];
    newFilter.inputFilePath=self.videoPath;
    
    newFilter.outputFilePath=[self getTmpPath];
    newFilter.vcdelegate=self;
    
    [self presentViewController:newFilter animated:YES completion:nil];
    
}


- (void)videoHandleSuccess:(BOOL)isSuccess resultPath:(NSString *)path
{
    if (isSuccess) {
        
        for (CALayer *layer in self.view.layer.sublayers) {
            if ([layer isKindOfClass:[AVPlayerLayer class]]) {
                [layer removeFromSuperlayer];
//                [_player replaceCurrentItemWithPlayerItem:nil];
            }
        }
    
        
        
        AVPlayer *play=[[AVPlayer alloc] initWithURL:[NSURL fileURLWithPath:path]];
        
        AVPlayerLayer *layer=[AVPlayerLayer playerLayerWithPlayer:play];
        layer.frame = self.view.frame;
        
        [self.view.layer addSublayer:layer];
        
        [play play];
        
        
        
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
