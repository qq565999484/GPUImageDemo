#import "SimpleVideoFileFilterViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "GPUImage.h"
#import "SVProgressHUD.h"
#import "FWApplyFilter.h"
//各种滤镜效果


#import "CustomImageCell.h"

#define SCREEN_W  [UIScreen mainScreen].bounds.size.width
#define SCREEN_H  [UIScreen mainScreen].bounds.size.height

static NSString *staticCell=@"CustomImageCell";


@interface SimpleVideoFileFilterViewController ()<GPUImageMovieWriterDelegate,GPUImageMovieDelegate,UIAlertViewDelegate
,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    NSArray *_filterArray;
    
    NSMutableArray *imageArray;
    NSURL *sampleURL;
    BOOL isFilter;
     BOOL isComplement;
    NSInteger currType;
    
    
    
    
}
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *juhuaUI;

@property (weak, nonatomic) IBOutlet UIButton *leftButton;

@property (nonatomic, strong) UIImagePickerController *picker;
 @property (nonatomic, strong) AVPlayer *player;

@property (nonatomic, strong) GPUImageMovie *movieFile;
@property (nonatomic, strong)GPUImageOutput<GPUImageInput> *filter;

@property (nonatomic, strong)GPUImageMovieWriter *movieWriter;
@property (nonatomic, strong) GPUImageView *filterView;
@property (nonatomic, strong)NSTimer * timer;
@property (nonatomic, strong)AVAssetExportSession *exporter;

@property (weak, nonatomic) IBOutlet UICollectionView *bottomScrollView;



@property (retain, nonatomic) IBOutlet GPUImageView *videoView;

@end
@implementation SimpleVideoFileFilterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (void) clearAll
{
    [SVProgressHUD dismiss];
    if (self.timer) {
        [self.timer invalidate];
        self.timer=nil;
    }

    if (_movieFile)
    {
        
       
        
        _movieFile = nil;
    }

    if (_movieWriter)
    {
        
        _movieWriter = nil;
    }
    
    if (_player) {
        [_player pause];
        _player=nil;
    }

}

//暂停处理
- (void) pause
{
    if (_movieFile.progress < 1.0)
    {
        [_movieWriter cancelRecording];
    }
}

- (void) resume
{
    [self clearAll];
}

#pragma mark - View lifecycle
- (void)dealloc
{
    _movieFile = nil;
    _filter = nil;
    _movieWriter = nil;
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [_juhuaUI startAnimating];
    _filterArray=@[@"无",@"心情",@"怀旧",@"老电影",@"好日子"
                   ,@"星空",@"时尚",@"生日",@"心动",@"浪漫"
                   ,@"星光",@"雨天",@"花语",@"经典"];
    imageArray=@[].mutableCopy;
   
    [self createUI];
    
    isComplement=NO;
    
    [[GPUImageContext sharedImageProcessingContext].framebufferCache purgeAllUnassignedFramebuffers];
    
    sampleURL=[NSURL fileURLWithPath:self.inputFilePath];
    //初始化播放页面
    _player=[[AVPlayer alloc] initWithURL:sampleURL];
    AVPlayerLayer *layer=[AVPlayerLayer playerLayerWithPlayer:_player];
    layer.frame=CGRectMake(0, 0, SCREEN_W, self.videoView.bounds.size.height);
    
    [self.videoView.layer addSublayer:layer];
    
    
    [_player play];
    //基础滤镜
    //这里开始设置滤镜类型
    
}




- (UIImage *)applyNashvilleFilter:(UIImage *)image :(GPUImageOutput<GPUImageInput> *)imageFilter
{
    [imageFilter forceProcessingAtSize:image.size];
    GPUImagePicture *pic = [[GPUImagePicture alloc] initWithImage:image];
    [pic addTarget:imageFilter];
    [pic processImage];
    [imageFilter useNextFrameForImageCapture];
    return [imageFilter imageFromCurrentFramebuffer];
}



- (void)createUI
{
    
    _bottomScrollView.delegate=self;
    _bottomScrollView.dataSource=self;
    [_bottomScrollView registerNib:[UINib nibWithNibName:@"CustomImageCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:staticCell];
    dispatch_async(dispatch_queue_create("create.ui.com", DISPATCH_QUEUE_SERIAL), ^{
        
        UIImage *image=[self getImageSL:self.inputFilePath];
        
        //得到基础的图片后 然后将
        //准备资源
        [imageArray addObject:image];
        
        for (int i=1; i<_filterArray.count; i++) {
            
            switch (i) {
                case 1:
                {
                    
                    [imageArray addObject:[self applyNashvilleFilter:image :[[FWNashvilleFilter alloc] init]]];
                    
                    
                }
                    break;
                    //无
                case 2:
                {
                    
                    
                    
                    [imageArray addObject:[self applyNashvilleFilter:image :[[FWLordKelvinFilter alloc] init]]];
                    
                    
                    
                    
                }
                    break;
                    //无
                case 3:
                {
                    
                    
                    [imageArray addObject:[self applyNashvilleFilter:image :[[FWRiseFilter alloc] init]]];
                    
                    
                }
                    break;
                    //无
                case 4:
                {
                    
                    
                    [imageArray addObject:[self applyNashvilleFilter:image :[[FWXproIIFilter alloc] init]]];
                    
                }
                    break;
                    //无
                case 5:
                {
                    
                    
                    [imageArray addObject:[self applyNashvilleFilter:image :[[FWWaldenFilter alloc] init]]];
                    
                }
                    break;
                    //无
                case 6:
                {
                    [imageArray addObject:[self applyNashvilleFilter:image :[[FWEarlybirdFilter alloc] init]]];
                    
                    
                }
                    break;
                    //无
                case 7:
                {
                    
                    
                    
                    [imageArray addObject:[self applyNashvilleFilter:image :[[FWToasterFilter alloc] init]]];
                    
                }
                    break;
                    //无
                case 8:
                {
                    
                    
                    
                    [imageArray addObject:[self applyNashvilleFilter:image :[[FWBrannanFilter alloc] init]]];
                    
                }
                    break;
                case 9:
                {
                    
                    [imageArray addObject:[self applyNashvilleFilter:image :[[FWInkwellFilter alloc] init]]];
                    
                }
                    break;
                case 10:
                {
                    
                    
                    [imageArray addObject:[self applyNashvilleFilter:image :[[FWSierraFilter alloc] init]]];
                    
                }
                    break;
                case 11:
                {
                    
                    
                    
                    [imageArray addObject:[self applyNashvilleFilter:image :[[FWHefeFilter alloc] init]]];
                    
                    
                }
                    break;
                case 12:
                {
                    
                    
                    
                    [imageArray addObject:[self applyNashvilleFilter:image :[[FWValenciaFilter alloc] init]]];
                    
                }
                    break;
                case 13:
                {
                    
                    
                    [imageArray addObject:[self applyNashvilleFilter:image :[[FWSutroFilter alloc] init]]];
                }
                    break;
                case 14:
                {
                    
                    
                    
                    [imageArray addObject:[self applyNashvilleFilter:image :[[FWAmaroFilter alloc] init]]];
                }
                    break;
                    
                default:
                    break;
            }
            
            
        }
        
        
        if (imageArray.count-_filterArray.count==0) {
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
               
                [_bottomScrollView reloadData];
                 [_juhuaUI stopAnimating];
                
                _juhuaUI.hidden=YES;
                
                
//                for(int i=0;i<_filterArray.count;i++)
//                {
//                    
//                    CustomClickView *button=[[CustomClickView alloc] initWithFrame:CGRectMake(i*115+10*(i+1), 0, 115, 115) :imageArray[i] :_filterArray[i]];
//                    button.tag=9000+i;
//                    
//                    [button addTarget:self action:@selector(addFilterToMovie:) forControlEvents:UIControlEventTouchUpInside];
//                    [_bottomScrollView addSubview:button];
//                }
//                
//                [_bottomScrollView setContentSize:CGSizeMake(_filterArray.count*115+10*(_filterArray.count+1), 0)];

                
                
            });
        }
        
    });
    
    
    
    
    
}

- (void)addFilterToMovie:(NSIndexPath *)typeIndexPath
{
    
    currType=typeIndexPath.row+9000;
    
    switch (currType) {
            //无
        case 9000:
        {   isFilter=NO;
            [self clearCache];
            DLog(@"%@",_videoView.layer.sublayers);
            [_videoView clearsContextBeforeDrawing];
            [_videoView setNeedsDisplay];
            _player=[[AVPlayer alloc] initWithURL:[NSURL fileURLWithPath:self.inputFilePath]];
            
            AVPlayerLayer *layer=[AVPlayerLayer playerLayerWithPlayer:_player];
            layer.frame=CGRectMake(0, 0, SCREEN_W, self.videoView.bounds.size.height);
            [_videoView.layer addSublayer:layer];
            [_player play];
            
        }
            break;
        case 9001:
        {
            [self filter1];
          
        }
            break;
            //无
        case 9002:
        {
            
             [self filter2];
            
        }
            break;
            //无
        case 9003:
        {
             [self filter3];
        }
            break;
            //无
        case 9004:
        {
             [self filter4];
        }
            break;
            //无
        case 9005:
        {
             [self filter5];
        }
            break;
            //无
        case 9006:
        {
             [self filter6];
        }
            break;
            //无
        case 9007:
        {
             [self filter7];
        }
            break;
            //无
        case 9008:
        {
            [self filter8];
        }
            break;
        case 9009:
        {
            [self filter9];
        }
            break;
        case 9010:
        {
            [self filter10];
        }
            break;
        case 9011:
        {
            [self filter11];
        }
            break;
        case 9012:
        {
            [self filter12];
        }
            break;
        case 9013:
        {
            [self filter13];
        }
            break;
        case 9014:
        {
            [self filter14];
        }
            break;
            
        default:
            break;
    }

}






- (void)retrievingProgress
{
    
     [SVProgressHUD showProgress:_movieFile.progress status:@"正在转码"] ;
}

- (void)viewDidUnload
{

    [self setVideoView:nil];
    [super viewDidUnload];
}



- (void)clearCache
{   if(_timer)
    {
        [_timer invalidate];
        _timer=nil;
    
    }

    [_filter removeAllTargets];
    [_filter removeOutputFramebuffer];
    
    if (_movieFile) {
        [_movieFile cancelProcessing];
        [_movieFile endProcessing];
        [_movieFile removeAllTargets];
        _movieFile=nil;
    }
    if (_movieWriter) {
        [_movieWriter cancelRecording];
        _movieWriter=nil;
    }
    
    
    
    for (CALayer *layer in _videoView.layer.sublayers) {
        if ([layer isKindOfClass:[AVPlayerLayer class]]) {
            [layer removeFromSuperlayer];
            [_player replaceCurrentItemWithPlayerItem:nil];
        }
    }
    
    [SVProgressHUD dismiss];
    
}
- (void)didCompletePlayingMovie
{
    DLog(@"放完了");
}


- (void)movieRecordingFailedWithError:(NSError *)error
{
    DLog(@"%@",error.localizedDescription);
}

- (void)commonFilter
{
    [self clearCache];

    //这块也可以先做预览 当用户点击下一步的时候再执行写入过程.
    
    
    isFilter=YES;
    sampleURL = [NSURL fileURLWithPath:self.inputFilePath];
    //设置输出画面
    _filterView = (GPUImageView *)self.videoView;
    if (_filterView) {
        [_filterView setFillMode:kGPUImageFillModePreserveAspectRatio];
    }
    [_filter addTarget:_filterView];
    
    _movieFile = [[GPUImageMovie alloc] initWithURL:sampleURL];
    _movieFile.delegate=self;
    _movieFile. runBenchmark=YES;
    _movieFile.playAtActualSpeed = NO;
    [_movieFile addTarget:_filter];
    
    [[NSFileManager defaultManager] removeItemAtPath:self.outputFilePath error:nil];
    unlink([self.outputFilePath UTF8String]);
    
    NSURL *movieURL = [NSURL fileURLWithPath:self.outputFilePath];
    
    AVURLAsset *asset=[AVURLAsset assetWithURL:[NSURL fileURLWithPath:self.inputFilePath]];
    
    _movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:movieURL size:asset.naturalSize];
    
    [_filter addTarget:_movieWriter];
    //添加声音的
    
    //软件注册权  9 个
    
    
    _movieWriter.shouldPassthroughAudio = YES;
    _movieWriter.delegate=self;
    //    [_movieWriter setHasAudioTrack:YES];
    _movieFile.audioEncodingTarget = _movieWriter;
    [_movieWriter setShouldInvalidateAudioSampleWhenDone:YES];
    
    
//    _movieWriter.shouldPassthroughAudio = YES;
//    _movieFile.audioEncodingTarget = _movieWriter;
//   
//    _movieWriter.hasAudioTrack=YES;
//
//    
//    _movieWriter.delegate=self;
   [_movieFile enableSynchronizedEncodingUsingMovieWriter:_movieWriter];
    
    [_movieWriter startRecording];
    [_movieFile startProcessing];
    
    WC;
    
    [_movieWriter setCompletionBlock:^{
        
        [weakSelf.filter removeTarget:weakSelf.movieWriter];
        [weakSelf.movieWriter finishRecording];
        if (weakSelf.timer) {
            [weakSelf.timer invalidate];
            weakSelf.timer=nil;
        }
        if (weakSelf.movieFile.progress==1.0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
                [[[UIAlertView alloc] initWithTitle:@"提示" message:@"当前滤镜处理视频完成\n是否进行下一步?" delegate:weakSelf cancelButtonTitle:@"否" otherButtonTitles:@"是", nil] show];
            });
        }
        
    }];
   
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ( buttonIndex ==1) {
        [self previewVideo:self.outputFilePath];
    }else
    {
        _clickBtn.enabled=YES;
          _bottomScrollView.hidden=NO;
    }

}


- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [SVProgressHUD dismiss];

}
//- (void)commonFilter2
//{
//    
//    if(_timer)
//    {
//        [_timer invalidate];
//        _timer=nil;
//        
//    }
//    
//    [_filter removeTarget:_filterView];
//    [_filter removeTarget:_movieWriter];
//    [_movieFile removeTarget:_filter];
//    [_movieWriter cancelRecording];
//    [_movieFile removeAllTargets];
//    [_filter removeAllTargets];
//    [_filter removeOutputFramebuffer];
//    [_movieFile setShouldIgnoreUpdatesToThisTarget:YES];
//    
//    
//    sampleURL = [NSURL fileURLWithPath:self.inputFilePath];
//    //设置输出画面
//    _filterView = (GPUImageView *)self.videoView;
//    if (_filterView) {
//        [_filterView setFillMode:kGPUImageFillModePreserveAspectRatio];
//    }
//    
//    
//    if (_movieWriter) {
//        [_movieWriter cancelRecording];
//        
//    }
//    //创建文件
//    if (_movieFile) {
//        
//        [_movieFile cancelProcessing];
//        [_movieFile removeAllTargets];
//        [_movieFile removeOutputFramebuffer];
//    }
//    
//    if (_filter) {
//        [_filter removeAllTargets];
//    }
//    for (CALayer *layer in _videoView.layer.sublayers) {
//        if ([layer isKindOfClass:[AVPlayerLayer class]]) {
//            [layer removeFromSuperlayer];
//            [_player replaceCurrentItemWithPlayerItem:nil];
//        }
//    }
//    
//    _movieFile = [[GPUImageMovie alloc] initWithURL:sampleURL];
//    _movieFile.runBenchmark = YES;
//    _movieFile.playAtActualSpeed =YES;
//    [_movieFile setShouldIgnoreUpdatesToThisTarget:YES];
//    //新创建一个滤镜
//    [_movieFile addTarget:_filter];
//    //将滤镜绑定到图片视图上
////    _player=nil;
//     [_filter addTarget:_filterView];
//    
//    
//    // In addition to displaying to the screen, write out a processed version of the movie to disk
//    //新创建输出地址
//    [[NSFileManager defaultManager] removeItemAtPath:self.outputFilePath error:nil];
//    
//    unlink([self.outputFilePath UTF8String]); // If a file already exists, AVAssetWriter won't let you record new frames, so delete the old movie
//    NSURL *movieURL = [NSURL fileURLWithPath:self.outputFilePath];
//    AVURLAsset *asset=[AVURLAsset assetWithURL:sampleURL];
//    
//    DLog(@"%@",asset);
//    NSArray *assetVideoTracks = [asset tracksWithMediaType:AVMediaTypeVideo];
//    
//    if (assetVideoTracks.count <= 0)
//    {
//        NSLog(@"Video track is empty!");
//        return;
//    }
//    
//     AVAssetTrack *videoAssetTrack = [[asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
//    CGSize sizeVideo = CGSizeMake(videoAssetTrack.naturalSize.width, videoAssetTrack.naturalSize.height);
//
//    _movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:movieURL size:sizeVideo];
//    _movieWriter.shouldPassthroughAudio = YES;
//    _movieWriter.delegate=self;
////    [_movieWriter setHasAudioTrack:YES];
//    _movieFile.audioEncodingTarget = _movieWriter;
//    [_movieWriter setShouldInvalidateAudioSampleWhenDone:YES];
//
//    //将滤镜绑定到输出源上
//    
//
//    // Configure this for video from the movie file, where we want to preserve all video frames and audio samples
//    //自动编码
//    [_movieFile enableSynchronizedEncodingUsingMovieWriter:_movieWriter];
//    //开始
//    
//    [_movieWriter startRecording];
//  
//    [_movieFile startProcessing];
//   // [self.player play];
//    
//    _timer = [NSTimer scheduledTimerWithTimeInterval:0.3f
//                                             target:self
//                                           selector:@selector(retrievingProgress)
//                                           userInfo:nil
//                                             repeats:YES];
//    
//  
//  
//    
//    [_movieWriter setFailureBlock:^(NSError *error) {
//        DLog(@"%@",error.localizedDescription);
//    }];
//  
//}
//碧波

//写出完成


- (void)filter1 {
    
    _filter = [[FWNashvilleFilter alloc] init];
    [self commonFilter];
    
}

//上野
- (void)filter2 {
    _filter = [[FWLordKelvinFilter alloc] init];
   
    [self commonFilter];
    

}
//彩虹瀑
- (void)filter3 {
    
    _filter = [[FWRiseFilter alloc] init];
  
   
        [self commonFilter];
    

}
//淡雅
- (void)filter4  {
    _filter = [[FWXproIIFilter alloc] init];

   
        [self commonFilter];
}
//候鸟
- (void)filter5 {
    _filter =   [[FWWaldenFilter alloc] init];
  
   
        [self commonFilter];
    

}
//哥特风
- (void)filter6  {
    _filter=[[FWEarlybirdFilter alloc] init] ;
   
        [self commonFilter];
    
}


//水晶球效果

- (void)filter7 {
    _filter = [[FWToasterFilter alloc] init] ;
   
        [self commonFilter];
    

}

- (void)filter8 {
    _filter = [[FWBrannanFilter alloc] init] ;
   
        [self commonFilter];
    
}

- (void)filter9 {
    _filter = [[FWInkwellFilter alloc] init] ;
   
        [self commonFilter];
    
    
}

- (void)filter10 {
    _filter = [[FWSierraFilter alloc] init] ;
   
        [self commonFilter];
    
    
}

- (void)filter11 {
    _filter = [[FWHefeFilter alloc] init] ;
   
        [self commonFilter];
    
    
}

- (void)filter12 {
    _filter = [[FWValenciaFilter alloc] init] ;
    
        [self commonFilter];
    
    
}

- (void)filter13 {
    _filter = [[FWSutroFilter alloc] init] ;
   
    [self commonFilter];
    
}

- (void)filter14 {
    _filter = [[FWAmaroFilter alloc] init] ;
  
    [self commonFilter];
    
}



//- (void)MV1 {
//    //视频叠加
//    
//
//
//   // [self mergeVideo:sampleURL :[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"sakura" ofType:@"mp4"]]];
//    
//    //这块可以设置要传入什么文件
//    
//    [self mergeVideo:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"sunVideo" ofType:@"mp4"]] :[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"smile_text" ofType:@"mp4"]] :sampleURL ];
//    
//}
//
//
//- (void)MV2 {
//    //视频叠加
//    
// 
//    
//    
//      //[self mergeVideo:sampleURL :[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"sakura" ofType:@"mp4"]]];
//    
//     [self mergeVideo:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"rain-480-480" ofType:@"mp4"]] :[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"old-movie-2-480-480" ofType:@"mp4"]] :sampleURL];
//    
//}




// 音乐路径需要重新制定(本身的和定制的)   特效视频滤镜需要定制1/ 2/ 3-- 和本身






//#pragma  mark  - 图片转视频
//#pragma  mark  - 视频合成
//
//- (void)mergeVideo:(NSURL *)ybpVideoURL :(NSURL *)mv2URL :(NSURL *)endVideoURL
//{
//    
//    
//    
//    AVURLAsset  *firstAsset;
//    AVURLAsset *secondAsset;
//    AVURLAsset* thirdAsset;
//    
//    
//    
//    if (ybpVideoURL!= nil &&endVideoURL!=nil && mv2URL!=nil) {
//        /*
//         合成视频套路就是下面几条，跟着走就行了，具体函数意思自行google
//         1.不用说，肯定加载。用ASSET
//         2.这里不考虑音轨，所以只获取video信息。用track 获取asset里的视频信息，一共两个track,一个track是你自己拍的视频，第二个track是特效视频,因为两个视频需要同时播放，所以起始时间相同，都是timezero,时长自然是你自己拍的视频时长。然后把两个track都放到mixComposition里。
//         3.第三步就是最重要的了。instructionLayer,看字面意思也能看个七七八八了。架构图层，就是告诉系统，等下合成视频，视频大小，方向，等等。这个地方就是合成视频的核心。我们只需要更改透明度就行了，把特效track的透明度改一下，让他能显示底下你自己拍的视屏图层就行了。
//         4.*/
//        
// 
//        // 1第一个仪表盘 URL资源
//        
//        firstAsset = [AVURLAsset assetWithURL:ybpVideoURL];
//
//        secondAsset=[AVURLAsset assetWithURL:mv2URL];
//        //第二个是最终视频的
//        thirdAsset= [AVURLAsset assetWithURL:endVideoURL];
//        
//        
//    
//        
//        }
//    
//    if (firstAsset != nil && secondAsset != nil && thirdAsset != nil) {
//        
//        // 2.  创建一个总的轨道容器
//        mixComposition = [[AVMutableComposition alloc] init];
//        
//        // create first track创建一个总的轨道容器匣
//        AVMutableCompositionTrack *firstTrack =
//        [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo
//                                    preferredTrackID:kCMPersistentTrackID_Invalid];
//
//        [firstTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, thirdAsset.duration)
//                            ofTrack:[[firstAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0]
//                             atTime:kCMTimeZero
//                              error:nil];
//        
//        
//        
//        
//        AVMutableCompositionTrack *thirdTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
//        
//        [thirdTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, thirdAsset.duration)
//                             ofTrack:[[thirdAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0]
//                              atTime:kCMTimeZero
//                               error:nil];
//        
//        
//        
//        // 3.
//        AVMutableVideoCompositionInstruction *mainInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
//        
//        
//        mainInstruction.timeRange = CMTimeRangeMake(kCMTimeZero,thirdAsset.duration);
//        
//        // 第一个视频的架构层
//        
//        
//        
//        AVMutableVideoCompositionLayerInstruction *firstlayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:firstTrack];
//        
//        
//        
//        [firstlayerInstruction setOpacityRampFromStartOpacity:0.5 toEndOpacity:0.8 timeRange:CMTimeRangeMake(kCMTimeZero, thirdAsset.duration)];
//        
//        [firstlayerInstruction setTransform:CGAffineTransformIdentity atTime:kCMTimeZero];
//        
//        
//        
//        
////        AVMutableVideoCompositionLayerInstruction *secondlayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:secondTrack];
//        
//        
////        
////        [secondlayerInstruction setOpacityRampFromStartOpacity:0.5 toEndOpacity:0.2 timeRange:CMTimeRangeMake(kCMTimeZero, secondAsset.duration)];
////      
////        
////        [secondlayerInstruction setTransform:CGAffineTransformIdentity atTime:kCMTimeZero];
//        
//        
//        
//        
//        
//        // 第二个视频的架构层
//        
//        AVMutableVideoCompositionLayerInstruction *thirdlayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:thirdTrack];
//        
//        [thirdlayerInstruction setTransform:CGAffineTransformIdentity atTime:kCMTimeZero];
//        
//        
//        // 这个地方你把数组顺序倒一下，视频上下位置也跟着变了。
//       // mainInstruction.layerInstructions = [NSArray arrayWithObjects:firstlayerInstruction,secondlayerInstruction,thirdlayerInstruction, nil];
//        
//         mainInstruction.layerInstructions = [NSArray arrayWithObjects:firstlayerInstruction,thirdlayerInstruction, nil];
//        
//        mainComposition = [AVMutableVideoComposition videoComposition];
//        mainComposition.instructions = [NSArray arrayWithObjects:mainInstruction,nil];
//        mainComposition.frameDuration = CMTimeMake(1, 10); //播放速率
//        
//        //MV势必会导致视频错乱
//        mainComposition.renderSize = CGSizeMake(190,200);
//
//        [[NSFileManager defaultManager] removeItemAtPath:self.outputFilePath error:nil];
//        
//
////        
//////
////        //声音采集
////        AVURLAsset* audioAsset =[[AVURLAsset alloc]initWithURL:assetURL2 options:nil];
////        CMTimeRange audio_timeRange =CMTimeRangeMake(kCMTimeZero,thirdAsset.duration);//声音长度截取范围==视频长度
////        AVMutableCompositionTrack*c_compositionAudioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio   preferredTrackID:kCMPersistentTrackID_Invalid];
////        
////        [c_compositionAudioTrack    insertTimeRange:audio_timeRange ofTrack:[[audioAsset tracksWithMediaType:AVMediaTypeAudio]    objectAtIndex:0]    atTime:kCMTimeZero    error:nil];
//      
//        
//        /*声音采集*/
//        
//        
//       NSString *path4 = [[NSBundle mainBundle] pathForResource:@"五环之歌" ofType:@"mp3"];
//       NSURL *assetURL2 =[NSURL fileURLWithPath:path4];
//       musicAsset = [AVURLAsset URLAssetWithURL:assetURL2 options:nil];
//        
//        
//        
//        CMTimeRange audio_timeRange2 =CMTimeRangeMake(kCMTimeZero,thirdAsset.duration);//声音长度截取范围==视频长度
//        AVMutableCompositionTrack*b_compositionAudioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio   preferredTrackID:kCMPersistentTrackID_Invalid];
//        
//        [b_compositionAudioTrack    insertTimeRange:audio_timeRange2 ofTrack:[[musicAsset tracksWithMediaType:AVMediaTypeAudio]    objectAtIndex:0]    atTime:kCMTimeZero    error:nil];
//        
//        
//        
//        //导出
//        
//        _exporter = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPreset640x480];
//        
//        
//        _exporter.outputURL = [NSURL fileURLWithPath:self.outputFilePath];
//        
//        _exporter.outputFileType = AVFileTypeMPEG4;
//        
//        _exporter.shouldOptimizeForNetworkUse = YES;
//        
//        _exporter.videoComposition = mainComposition;
//        WC;
//        
//        [SVProgressHUD showWithStatus:@"正在转码。。"];
//        
//    
//        _timer=[NSTimer scheduledTimerWithTimeInterval:0.33 target:self selector:@selector(updateProgress) userInfo:nil repeats:YES];
//        
//        //主要是用这个来做导出  如果这个导出失败则没办法了
//        [_exporter exportAsynchronouslyWithCompletionHandler:^{
//            
//                dispatch_async(dispatch_get_main_queue(), ^{
//                //[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"五环之歌" ofType:@"mp3"]]]
//           
//            //    [self theVideoWithMixMusic:[NSURL fileURLWithPath:outPut] : [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"五环之歌" ofType:@"mp3"]]];
//                    DLog(@"%ld",(long)weakSelf.exporter.status);
//                    if (weakSelf.exporter.status==AVAssetExportSessionStatusCompleted) {
//                        [weakSelf.timer invalidate];
//                        weakSelf.timer =nil;
//                        [SVProgressHUD dismiss];
//                        [weakSelf.vcdelegate videoHandleSuccess:YES resultPath:weakSelf.outputFilePath];
//                        [weakSelf dismissViewControllerAnimated:YES completion:^{
//                            
//                            
//                        }];
//                    }else
//                    {
//                        
//                        [weakSelf.timer invalidate];
//                        [SVProgressHUD showErrorWithStatus:@"合成出错"];
//                    }
//                    
//                    //
//                   
//               
//            });
//        }];
//        
//    }else {
//        
//        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"出错!" message:@"选择视频"
//                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alert show];
//    }
//    
//    
//}
//
//
//
//
//
- (void)updateProgress
{
    [SVProgressHUD showProgress:_exporter.progress status:@"正在转码.." ] ;
}




#pragma mark - 保存路径

//得到视频输出地址



////最终音频和视频混合
//-(void)theVideoWithMixMusic:(NSURL *)videoURL :(NSURL *)audioURL
//{
//    
//    NSString *documentsDirectory =[NSHomeDirectory()
//                                   stringByAppendingPathComponent:@"Documents"];
//    
//    //声音来源路径（最终混合的音频）
//    NSURL   *audio_inputFileUrl =videoURL;
//    
//    
//    //视频来源路径
//    NSURL   *video_inputFileUrl =audioURL;
//    
//    //最终合成输出路径
//    NSString *outputFilePath =[documentsDirectory stringByAppendingPathComponent:@"XXX0000.mp4"];
//    
//    NSURL   *outputFileUrl = [NSURL fileURLWithPath:outputFilePath];
//    
//    if([[NSFileManager defaultManager]fileExistsAtPath:outputFilePath])
//        [[NSFileManager defaultManager]removeItemAtPath:outputFilePath error:nil];
//    
//    CMTime nextClipStartTime =kCMTimeZero;
//    
//    //创建可变的音频视频组合
//    
//    
//    //视频采集
//    AVURLAsset* videoAsset =[[AVURLAsset alloc]initWithURL:[NSURL fileURLWithPath:self.outputFilePath] options:nil];
//    
//    CMTimeRange video_timeRange =CMTimeRangeMake(kCMTimeZero,videoAsset.duration);
//    
//    AVMutableCompositionTrack   *a_compositionVideoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo    preferredTrackID:kCMPersistentTrackID_Invalid];
//    
//    [a_compositionVideoTrack    insertTimeRange:video_timeRange ofTrack:[[videoAsset tracksWithMediaType:AVMediaTypeVideo]    objectAtIndex:0]    atTime:nextClipStartTime    error:nil];
//
//   
//    
//    //音频轨道
//    //    musicAsset = [AVURLAsset URLAssetWithURL:videoURL options:nil];
//    //    NSLog(@"second Asset = %@",musicAsset);
//    //    CMTime startTime =CMTimeMakeWithSeconds(0,musicAsset.duration.timescale);
//    //    CMTime trackDuration =musicAsset.duration;
//    //
//    //    [self setUpAndAddAudioAtPath:videoURL toComposition:mixComposition start:startTime :trackDuration :CMTimeMake(0, 44100)];
//    
//    
//    NSString *path4=@"";
//    //本地要插入的音乐
//    NSURL *assetURL2 =[NSURL fileURLWithPath:path4];
//    musicAsset = [AVURLAsset URLAssetWithURL:assetURL2 options:nil];
//
//    
//    
//    //声音采集
//    AVURLAsset* audioAsset =[[AVURLAsset alloc]initWithURL:assetURL2 options:nil];
//    CMTimeRange audio_timeRange =CMTimeRangeMake(kCMTimeZero,videoAsset.duration);//声音长度截取范围==视频长度
//    AVMutableCompositionTrack*b_compositionAudioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio   preferredTrackID:kCMPersistentTrackID_Invalid];
//    
//    [b_compositionAudioTrack    insertTimeRange:audio_timeRange ofTrack:[[audioAsset tracksWithMediaType:AVMediaTypeAudio]    objectAtIndex:0]    atTime:nextClipStartTime    error:nil];
//    
//    _assetExport =[[AVAssetExportSession  alloc]initWithAsset:mixComposition  presetName:AVAssetExportPresetMediumQuality];
//    _assetExport.outputFileType =AVFileTypeQuickTimeMovie;
//    _assetExport.outputURL =outputFileUrl;
//    _assetExport.shouldOptimizeForNetworkUse=YES;
//    
//    [_assetExport   exportAsynchronouslyWithCompletionHandler:
//     ^(void ) {
//         
//         dispatch_async(dispatch_get_main_queue(), ^{
//             
//             //
//             MPMoviePlayerViewController *theMovie =[[MPMoviePlayerViewController alloc]initWithContentURL:outputFileUrl];
//             [self   presentMoviePlayerViewControllerAnimated:theMovie];
//             
//             theMovie.moviePlayer.movieSourceType=MPMovieSourceTypeFile;
//             
//             [theMovie.moviePlayer play];
//             
//          
//             
//         });
//         
//         
//     }
//     ];
//    NSLog(@"完成！输出路径==%@",outputFilePath);
//}
//
//
//
//
//多个视频叠加的时候 可以先将两个视频合成,然后得到输出的源后 再继续和另一个视频合成
/*

//通过文件路径建立和添加音频素材
- (void)setUpAndAddAudioAtPath:(NSURL*)assetURL toComposition:(AVMutableComposition*)composition start:(CMTime)startdura :(CMTime)duraoffset :(CMTime)offset{
    
    //传入视频的地址  和播放起点  终点
    AVURLAsset *songAsset =[AVURLAsset URLAssetWithURL:assetURL options:nil];
    
    //一个音频轨道
    AVMutableCompositionTrack *track =[composition  addMutableTrackWithMediaType:AVMediaTypeAudio   preferredTrackID:kCMPersistentTrackID_Invalid];
    
    // 拿到这个媒体源中的音pin
    AVAssetTrack *sourceAudioTrack =[[songAsset tracksWithMediaType:AVMediaTypeAudio]objectAtIndex:0];
    
    NSError *error =nil;
    BOOL ok =NO;
    
    CMTime startTime = startdura;
    CMTime trackDuration = duraoffset;
    
    CMTimeRange tRange =CMTimeRangeMake(startTime,trackDuration);
    
    //设置音量
    //AVMutableAudioMixInputParameters（输入参数可变的音频混合）
    //audioMixInputParametersWithTrack（音频混音输入参数与轨道）
    AVMutableAudioMixInputParameters *trackMix =[AVMutableAudioMixInputParameters   audioMixInputParametersWithTrack:track];
    
    [trackMix   setVolume:0.8f  atTime:startTime];
    
    //素材加入数组
    [audioMixParams addObject:trackMix];
    
    //Insert audio into track  //offsetCMTimeMake(0, 44100)
    //
    ok = [track insertTimeRange:tRange ofTrack:sourceAudioTrack atTime:startTime error:&error];
}
*/








/*

- (void)exportDidFinish:(NSURL *)outPutURL {
    
    
    NSLog(@"exportDidFinish");
    
    
    if (outPutURL) {
        
        
        
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        
        if ([library videoAtPathIsCompatibleWithSavedPhotosAlbum:outPutURL])  {
            
            [library writeVideoAtPathToSavedPhotosAlbum:outPutURL completionBlock:^(NSURL *assetURL, NSError *error) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if (error) {
                        
                        
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                        message:error.localizedDescription
                                                                       delegate:nil
                                                              cancelButtonTitle:@"OK"
                                                              otherButtonTitles:nil];
                        [alert show];
                        
                    }else {
                        
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success"
                                                                        message:@"存档成功"
                                                                       delegate:self
                                                              cancelButtonTitle:@"OK"
                                                              otherButtonTitles:nil];
                        
                        [alert show];
                        
                        
                        
                        
                    }
                    
                    
                });
            }];
            
        }
        
    }else {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"存档失败"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
}

*/

//- (void)gaoxiao{
//    _filter = [[GPUImageGlassSphereFilter alloc] init];
//    [self commonFilter];
//    
//}



- (void)previewVideo:(NSString *)path
{
    
    if (_vcdelegate && [_vcdelegate respondsToSelector:@selector(videoHandleSuccess:resultPath:)]) {
        
        
        [_vcdelegate videoHandleSuccess:YES resultPath:path];
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
        
    }
    
}





- (IBAction)clickFinilshEditVideo:(id)sender {
    isComplement=YES;
    _clickBtn.enabled=NO;
  
    _bottomScrollView.hidden=YES;
    
    if (isFilter) {
        if (_movieFile.progress<1.0) {
            UIButton *button=sender;
            button.enabled=NO;
            _timer =[NSTimer scheduledTimerWithTimeInterval:0.3f target:self selector:@selector(retrievingProgress)userInfo:nil repeats:YES];
        }else if (_movieFile.progress==1.0){
            
            [self previewVideo:self.outputFilePath];
        }
        
    }else
    {
        [self previewVideo:self.inputFilePath];
    }
    
}




#pragma mark -瀑布流

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return imageArray.count>0?imageArray.count:0;

}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self addFilterToMovie:indexPath];
    
    
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{

    return  CGSizeMake(125, 125);
    
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    CustomImageCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:staticCell forIndexPath:indexPath];
    cell.filterImage.image=imageArray[indexPath.row];
    cell.filterLab.text=_filterArray[indexPath.row];

    return cell;

}



- (UIImage *)getImageSL:(NSString *)videoURL
{
    NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    
    // NSString *videoStr=[[NSBundle mainBundle] pathForResource:@"war3end" ofType:@"mp4"];
    
    
    NSURL *url = [NSURL fileURLWithPath:videoURL];
    
    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:url options:opts];
    
    AVAssetImageGenerator *generator = [AVAssetImageGenerator assetImageGeneratorWithAsset:urlAsset];
    
    generator.appliesPreferredTrackTransform = YES;
    generator.maximumSize = CGSizeMake(960, 540);
    CMTime actucalTime; //缩略图实际生成的时间
    
    NSError *error = nil;
    CGImageRef img = [generator copyCGImageAtTime:CMTimeMake(0, 600) actualTime:&actucalTime error:&error];
    
    if (error) {
        DLog(@"截取视频图片失败:%@",error.localizedDescription);
    }
    CMTimeShow(actucalTime);
    
    UIImage *image = [UIImage imageWithCGImage: img];
    
    return image;
}


@end
