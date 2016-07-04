#import <UIKit/UIKit.h>

@protocol SimpleVideoFileFilterViewControllerDelegate <NSObject>

- (void)videoHandleCancel:(BOOL)isSuccess;
- (void)videoHandleSuccess:(BOOL)isSuccess resultPath:(NSString *)path;

@end
@interface SimpleVideoFileFilterViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *clickBtn;


@property (strong,nonatomic)NSString *inputFilePath;
@property (strong,nonatomic)NSString *outputFilePath;
@property (strong,nonatomic)NSString *handleType;
@property (strong,nonatomic)NSString *handleTag;
@property (nonatomic,assign)id<SimpleVideoFileFilterViewControllerDelegate> vcdelegate;
@property (nonatomic,strong)NSDictionary *locationDic;


@end