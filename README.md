# iOS-GaussImage
高斯图
#前言
昨天看到一位简书作者的博客,写的是swift的版的模糊图,正好我做的项目有这个需求,所以就翻译了一版OC语言的

---
#效果图

![高斯模糊图](http://upload-images.jianshu.io/upload_images/1298596-50ede58bf9748534.gif?imageMogr2/auto-orient/strip)
#上代码
scrollView和 button 都是为了换图片看效果才加的,如果只需要模糊效果可以只创建一个imageView
```
#import "ViewController.h"

@interface ViewController ()
/** 展示图片控件 */
@property (weak, nonatomic) IBOutlet UIImageView *imageview;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;
/** 背景图片 */
@property (strong, nonatomic) UIImageView *backgroundImageView;
/** 当前图片下标 */
@property (assign, nonatomic)NSInteger index;
@end

@implementation ViewController
- (IBAction)changeImage:(UIButton *)sender {
    // 点击切换图片 偏移量为0
    self.scrollview.contentOffset = CGPointZero;
    _index++;
    if (_index>5) {
        _index = 1;
    }
    [self changeImageWithIndex];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 赋初值调用方法
    _index = 1;
    [self changeImageWithIndex];

 }
/** 切换图片方法 */
- (void)changeImageWithIndex{
    [_imageview layoutIfNeeded];
    NSString *str = [NSString stringWithFormat:@"%ld",_index];
    self.imageview.image = [UIImage imageNamed:str];
    // 调用高斯模糊方法
    [self creatBlurBackgound:[UIImage imageNamed:str] view:_imageview blurRadius:50];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)creatBlurBackgound:(UIImage *)image view:(UIView *)view blurRadius:(CGFloat)blurRadius{
    // 创建属性
    CIImage *cimage = [[CIImage alloc] initWithImage:image];
    // 滤镜效果 高斯模糊
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    // 指定过滤照片
    [filter setValue:cimage forKey:kCIInputImageKey];
    // 模糊值
    NSNumber *number = [NSNumber numberWithFloat:blurRadius];
    // 指定模糊值
    [filter setValue:number forKey:@"inputRadius"];
    // 生成图片
    CIContext *context = [CIContext contextWithOptions:nil];
    // 创建输出
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    CGImageRef cgimage = [context createCGImage:result fromRect:result.extent];
    UIImage *imagea = [UIImage imageWithCGImage:cgimage];

    // 赋值图片
    self.backgroundImageView.image = imagea;

}
// 懒加载
- (UIImageView *)backgroundImageView{
    if (!_backgroundImageView) {
        // 获取view宽高
        CGFloat w = self.view.frame.size.width;
        CGFloat h = self.view.frame.size.height;
        // 4倍缩放
        _backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(-w/2, -h/2, w, 2*h)];
        // 等比例填充模式
        _backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
        // 对其
        _backgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth |UIViewAutoresizingFlexibleHeight;
        // 添加到view上
        [self.view insertSubview:_backgroundImageView belowSubview:_scrollview];
    }
    return _backgroundImageView;
}
@end

```
gitHub:https://github.com/Lafree317/iOS-GaussImage
swift版博客地址:http://www.jianshu.com/p/c9083a105921
