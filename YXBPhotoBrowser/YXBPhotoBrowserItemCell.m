
//
//  YXBPhotoBrowserItemCell.m
//  YXBPhotoBrowser
//
//  Created by yaoxb on 2016/10/10.
//  Copyright © 2016年 yaoxb. All rights reserved.
//

#import "YXBPhotoBrowserItemCell.h"
#import "YXBIndicatorView.h"
#import "YXBPhotoBrowserConfig.h"

@interface YXBPhotoBrowserItemCell()<UIScrollViewDelegate>
@property (nonatomic, strong) YYAnimatedImageView *imageView;
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic,strong) UITapGestureRecognizer *doubleTap;
@property (nonatomic,strong) UITapGestureRecognizer *singleTap;
@property (nonatomic, assign) BOOL hasLoadedImage;//图片下载成功为YES 否则为NO
@property (nonatomic, strong) UIImage *placeholder;
@property (nonatomic, assign) BOOL hasDoneAnimation;

@property (nonatomic, strong) YXBIndicatorView *indicatorView;


@end


@implementation YXBPhotoBrowserItemCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.scrollView];
    }
    return self;
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder
{
    self.placeholder = placeholder;
    
    if (!self.indicatorView.superview && url) {
        [self.contentView addSubview:self.indicatorView];
    }
    
     @weakify(self);
    [self.imageView setImageWithURL:url placeholder:placeholder options:YYWebImageOptionSetImageWithFadeAnimation progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        @strongify(self);
        CGFloat rate = receivedSize/(CGFloat)expectedSize;
        self.indicatorView.progress = rate;
    } transform:nil completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        @strongify(self);
        [self updateUIWithImage:image];
        self.hasLoadedImage = YES;
        [self.indicatorView removeFromSuperview];
    }];
}

- (void)updateUIWithImage:(UIImage *)image
{
    if (!image) {
        return;
    }
    
    CGSize imageSize = image.size;
    CGFloat imageWidth = imageSize.width;
    CGFloat imageHeight = imageSize.height;
    
    CGFloat targetWidth = ScreenWidth;
    CGFloat targetHeight = targetWidth *imageHeight/imageWidth;

    CGFloat targetY = 0;
    if (targetHeight < ScreenHeight) {
       targetY = (ScreenHeight - targetHeight)/2;
    }
    
    CGRect frame = CGRectMake(0, targetY, ScreenWidth, targetHeight);
    
    self.imageView.frame = frame;
    self.scrollView.contentSize = CGSizeMake(ScreenWidth, targetHeight);
}

- (void)doAnimation
{
    
    if (self.hasDoneAnimation) {
        return;
    }
    
    UIImage *image = self.placeholder;
    if (!image) {
        return;
    }
    
    CGRect sourceFrame = [self.sourceImageContainer.superview convertRect:self.sourceImageContainer.frame toView:self.scrollView];
    self.imageView.frame = sourceFrame;
    CGSize imageSize = image.size;
    CGFloat imageWidth = imageSize.width;
    CGFloat imageHeight = imageSize.height;
    
    CGFloat targetWidth = ScreenWidth;
    CGFloat targetHeight = targetWidth *imageHeight/imageWidth;
    
    CGFloat targetY = 0;
    if (targetHeight < ScreenHeight) {
        targetY = (ScreenHeight - targetHeight)/2;
    }

    
    [UIView animateWithDuration:0.5 animations:^{
        self.imageView.frame = CGRectMake(0, targetY, ScreenWidth, targetHeight);
    } completion:^(BOOL finished) {
        self.hasDoneAnimation = YES;
    }];
    
    self.scrollView.contentSize = CGSizeMake(ScreenWidth, targetHeight);
}

- (void)resetZoomScale
{
    [self.scrollView setZoomScale:1.0 animated:NO]; //还原
}


#pragma mark 双击
- (void)handleDoubleTap:(UITapGestureRecognizer *)recognizer
{
    //图片加载完之后才能响应双击放大
    if (!self.hasLoadedImage) {
        return;
    }
    
    CGPoint touchPoint = [recognizer locationInView:self];
    if (self.scrollView.zoomScale <= 1.0) {
        
        CGFloat scaleX = touchPoint.x + self.scrollView.contentOffset.x;//需要放大的图片的X点
        CGFloat sacleY = touchPoint.y + self.scrollView.contentOffset.y;//需要放大的图片的Y点
        [self.scrollView zoomToRect:CGRectMake(scaleX, sacleY, 10, 10) animated:YES];
        
    } else {
        [self.scrollView setZoomScale:1.0 animated:YES]; //还原
    }
    
}
#pragma mark 单击
- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer
{
    self.indicatorView.hidden = YES;
    if (self.singleTapBlock) {
        self.singleTapBlock(recognizer,self.imageView);
    }
}

#pragma mark UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    self.imageView.center = [self centerOfScrollViewContent:scrollView];
}

- (CGPoint)centerOfScrollViewContent:(UIScrollView *)scrollView
{
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    CGPoint actualCenter = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                       scrollView.contentSize.height * 0.5 + offsetY);
    return actualCenter;
}

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [UIScrollView new];
        _scrollView.frame = CGRectMake(InterSpace, 0,ScreenWidth, ScreenHeight);
        [_scrollView addSubview:self.imageView];
        _scrollView.maximumZoomScale = 2.0;
        _scrollView.delegate = self;
        [_scrollView addGestureRecognizer:self.singleTap];
    }
    return _scrollView;
}


- (YYAnimatedImageView *)imageView
{
    if (!_imageView) {
        _imageView = [YYAnimatedImageView new];
        _imageView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        _imageView.userInteractionEnabled = YES;
        [_imageView addGestureRecognizer:self.doubleTap];
    }
    return _imageView;
}

- (UITapGestureRecognizer *)doubleTap
{
    if (!_doubleTap) {
        _doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
        _doubleTap.numberOfTapsRequired = 2;
        _doubleTap.numberOfTouchesRequired  =1;
    }
    return _doubleTap;
}

- (UITapGestureRecognizer *)singleTap
{
    if (!_singleTap) {
        _singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        _singleTap.numberOfTapsRequired = 1;
        _singleTap.numberOfTouchesRequired = 1;
        //只能有一个手势存在
        [_singleTap requireGestureRecognizerToFail:self.doubleTap];
        
    }
    return _singleTap;
}

- (YXBIndicatorView *)indicatorView
{
    if (!_indicatorView) {
        _indicatorView = [YXBIndicatorView new];
        _indicatorView.style = YXBIndicatorStyleLoopDiagram;
        _indicatorView.center = CGPointMake(ScreenWidth/2, ScreenHeight/2);
    }
    return _indicatorView;
}


@end
