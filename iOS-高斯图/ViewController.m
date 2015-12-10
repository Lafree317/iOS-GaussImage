//
//  ViewController.m
//  iOS-高斯图
//
//  Created by huchunyuan on 15/12/10.
//  Copyright © 2015年 huchunyuan. All rights reserved.
//

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
