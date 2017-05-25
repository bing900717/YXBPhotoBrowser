//
//  YXBIndicatorView.h
//  YXBPhotoBrowser
//
//  Created by yaoxb on 2016/10/11.
//  Copyright © 2016年 yaoxb. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, YXBIndicatorStyle){
    YXBIndicatorStyleLoopDiagram, //环形型
    YXBIndicatorStylePieDiagram //饼型
};

@interface YXBIndicatorView : UIView

@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, assign) YXBIndicatorStyle style;//显示模式

@end
