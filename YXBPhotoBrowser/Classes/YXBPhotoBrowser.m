//
//  YXBPhotoBrowser.m
//  YXBPhotoBrowser
//
//  Created by yaoxb on 2016/10/10.
//  Copyright © 2016年 yaoxb. All rights reserved.
//

#import "YXBPhotoBrowser.h"
#import "YXBPhotoBrowserConfig.h"
#import "YXBPhotoBrowserItemCell.h"

#define CellMark @"Cell"

@interface YXBPhotoBrowser ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) UILabel *indexLabel;

@end


@implementation YXBPhotoBrowser

+(instancetype)showInWindow:(UIWindow *)window
               withDelegate:(id<YXBPhotoBrowserDelegate>)delegate
                 imageCount:(NSInteger)imageCount
               currnetIndex:(NSInteger)currentIndex
{
    YXBPhotoBrowser *photoBrowser = [YXBPhotoBrowser new];
    photoBrowser.imageCount = imageCount;
    photoBrowser.currentIndex = currentIndex;
    photoBrowser.delegate = delegate;
    [window addSubview:photoBrowser];
    return photoBrowser;
}


- (instancetype)init
{
    if (self = [super init]) {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor blackColor];
        [self addSubview:self.collectionView];
    }
    return self;
}

- (void)didMoveToWindow
{
    [super didMoveToWindow];
    if (!self.window) {
        return;
    }
    [self.collectionView reloadData];
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
}


- (void)dimissWithIndex:(NSInteger)index imageView:(UIImageView *)imageView
{
    UIView *sourceView = [self.delegate photoBrowser:self containerViewForIndex:index];
    if (!sourceView) {
        [self removeFromSuperview];
        return;
    }
    
    CGRect targetFrame = [sourceView.superview convertRect:sourceView.frame toView:imageView.superview];
    self.indexLabel.hidden = YES;
    [UIView animateWithDuration:0.5f animations:^{
        imageView.frame = targetFrame;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


#pragma mark -
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imageCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YXBPhotoBrowserItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellMark forIndexPath:indexPath];
    
    id<YXBPhotoBrowserDelegate>delegate = self.delegate;
    UIView *sourceView = [delegate photoBrowser:self containerViewForIndex:indexPath.item];
    NSURL *url = [delegate photoBrowser:self highQualityImageURLForIndex:indexPath.item];
    UIImage *placeholder = [delegate photoBrowser:self placeholderImageForIndex:indexPath.item];
    cell.sourceImageContainer = sourceView;
    [cell setImageWithURL:url placeholderImage:placeholder];
    @weakify(self);
    cell.singleTapBlock = ^(UITapGestureRecognizer *tap){
        @strongify(self);
        [self dimissWithIndex:indexPath.item imageView:(UIImageView *)tap.view];
    };
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    YXBPhotoBrowserItemCell *displayCell = (YXBPhotoBrowserItemCell *)cell;
    if (indexPath.item == self.currentIndex) {
        [displayCell doAnimation];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    YXBPhotoBrowserItemCell *displayCell = (YXBPhotoBrowserItemCell *)cell;
    [displayCell resetZoomScale];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.imageCount <= 1) {
        return;
    }
    NSInteger index = scrollView.contentOffset.x/(ScreenWidth+2*InterSpace);
    if (!self.indexLabel.superview) {
        [self addSubview:self.indexLabel];
    }
    self.indexLabel.text = [NSString stringWithFormat:@"%zd/%zd", index+1,self.imageCount];
}


#pragma mark - getter
- (UICollectionViewFlowLayout *)flowLayout
{
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.minimumInteritemSpacing = 0;
        _flowLayout.minimumLineSpacing = 0;
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _flowLayout.itemSize = CGSizeMake(ScreenWidth+2*InterSpace, ScreenHeight);
    }
    return _flowLayout;
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(-InterSpace, 0, ScreenWidth+2*InterSpace, ScreenHeight) collectionViewLayout:self.flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[YXBPhotoBrowserItemCell class] forCellWithReuseIdentifier:CellMark];
        _collectionView.pagingEnabled = YES;
    }
    return _collectionView;
}

- (UILabel *)indexLabel
{
    if (!_indexLabel) {
        
        UILabel *indexLabel = [[UILabel alloc] init];
        indexLabel.textAlignment = NSTextAlignmentCenter;
        indexLabel.textColor = [UIColor whiteColor];
        indexLabel.font = [UIFont boldSystemFontOfSize:20];
        indexLabel.backgroundColor = [UIColor colorWithRed:0.1f green:0.1f blue:0.1f alpha:0.3f];
        indexLabel.bounds = CGRectMake(0, 0, 100, 40);
        indexLabel.center = CGPointMake(ScreenWidth * 0.5, 30);
        indexLabel.layer.cornerRadius = 15;
        indexLabel.clipsToBounds = YES;
        _indexLabel= indexLabel;
    }
    return _indexLabel;
}






@end
