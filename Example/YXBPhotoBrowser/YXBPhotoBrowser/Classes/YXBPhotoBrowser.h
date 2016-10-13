//
//  YXBPhotoBrowser.h
//  YXBPhotoBrowser
//
//  Created by yaoxb on 2016/10/10.
//  Copyright © 2016年 yaoxb. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YXBPhotoBrowser;

@protocol YXBPhotoBrowserDelegate <NSObject>

@required
- (UIImage *)photoBrowser:(YXBPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index;
- (NSURL *)photoBrowser:(YXBPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index;
- (UIView *)photoBrowser:(YXBPhotoBrowser *)browser containerViewForIndex:(NSInteger)index;

@end



@interface YXBPhotoBrowser : UIView

@property (nonatomic, weak) id<YXBPhotoBrowserDelegate> delegate;
@property (nonatomic, assign) NSInteger imageCount;
@property (nonatomic, assign) NSInteger currentIndex;

+(instancetype)showInWindow:(UIWindow *)window
                   withDelegate:(id<YXBPhotoBrowserDelegate>)delegate
                 imageCount:(NSInteger)imageCount
               currnetIndex:(NSInteger)currentIndex;
@end
