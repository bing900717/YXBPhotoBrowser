//
//  HZImagesGroupView.m
//  photoBrowser
//
//  Created by huangzhenyu on 15/6/23.
//  Copyright (c) 2015年 eamon. All rights reserved.
//

#import "HZImagesGroupView.h"
#import "HZPhotoItemModel.h"
#import "YXBPhotoBrowser.h"
#import "UIButton+YYWebImage.h"


#define kImagesMargin 15

@interface HZImagesGroupView() <YXBPhotoBrowserDelegate>

@end

@implementation HZImagesGroupView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 清除图片缓存，便于测试

    }
    return self;
}

- (void)setPhotoItemArray:(NSArray *)photoItemArray
{
    _photoItemArray = photoItemArray;
    [photoItemArray enumerateObjectsUsingBlock:^(HZPhotoItemModel *obj, NSUInteger idx, BOOL *stop) {
        UIButton *btn = [[UIButton alloc] init];
        
        //让图片不变形，以适应按钮宽高，按钮中图片部分内容可能看不到
        btn.imageView.contentMode = UIViewContentModeScaleAspectFill;
        btn.clipsToBounds = YES;
        
        [btn setImageWithURL:[NSURL URLWithString:obj.thumbnail_pic] forState:UIControlStateNormal placeholder:[UIImage imageNamed:@"whiteplaceholder"]];
        btn.tag = idx+1000;
        
        [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    long imageCount = self.photoItemArray.count;
    int perRowImageCount = ((imageCount == 4) ? 2 : 3);
    CGFloat perRowImageCountF = (CGFloat)perRowImageCount;
    int totalRowCount = ceil(imageCount / perRowImageCountF);
    CGFloat w = 80;
    CGFloat h = 80;
    
    [self.subviews enumerateObjectsUsingBlock:^(UIButton *btn, NSUInteger idx, BOOL *stop) {
        
        long rowIndex = idx / perRowImageCount;
        int columnIndex = idx % perRowImageCount;
        CGFloat x = columnIndex * (w + kImagesMargin);
        CGFloat y = rowIndex * (h + kImagesMargin);
        btn.frame = CGRectMake(x, y, w, h);
    }];
    
    self.frame = CGRectMake(0, 0, 280, totalRowCount * (kImagesMargin + h));
}

- (void)buttonClick:(UIButton *)button
{
    [YXBPhotoBrowser showInWindow:self.window
                     withDelegate:self
                       imageCount:self.photoItemArray.count
                     currnetIndex:button.tag-1000];
}

#pragma mark - photobrowser代理方法
- (UIView *)photoBrowser:(YXBPhotoBrowser *)browser containerViewForIndex:(NSInteger)index
{
    UIButton *btn = [self viewWithTag:index+1000];
    return  btn.imageView;

}

- (UIImage *)photoBrowser:(YXBPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    UIButton *btn = [self viewWithTag:index+1000];
    return btn.currentImage;
}

- (NSURL *)photoBrowser:(YXBPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
        NSString *urlStr = [[self.photoItemArray[index] thumbnail_pic] stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
        return [NSURL URLWithString:urlStr];
}


@end
