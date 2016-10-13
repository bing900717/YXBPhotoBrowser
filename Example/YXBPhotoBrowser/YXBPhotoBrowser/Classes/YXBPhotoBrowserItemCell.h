//
//  YXBPhotoBrowserItemCell.h
//  YXBPhotoBrowser
//
//  Created by yaoxb on 2016/10/10.
//  Copyright © 2016年 yaoxb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YXBPhotoBrowserItemCell : UICollectionViewCell


@property (nonatomic, strong) UIView *sourceImageContainer;

@property (nonatomic, strong) void (^singleTapBlock)(UITapGestureRecognizer *recognizer);

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder;

- (void)doAnimation;

- (void)resetZoomScale;


@end
