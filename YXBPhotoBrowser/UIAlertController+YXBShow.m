//
//  UIAlertController+YXBShow.m
//  Pods-YXBPhotoBrowser_Example
//
//  Created by ramnova_iOS on 2018/4/28.
//

#import "UIAlertController+YXBShow.h"
#import <objc/runtime.h>

@interface UIAlertController()
@property (nonatomic, strong) UIWindow* alertWindow;
@end


@implementation UIAlertController (YXBShow)
- (void)setAlertWindow: (UIWindow*)alertWindow
{
    objc_setAssociatedObject(self, @selector(alertWindow), alertWindow, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIWindow*)alertWindow
{
    return objc_getAssociatedObject(self, @selector(alertWindow));
}

- (void)show
{
    self.alertWindow = [[UIWindow alloc] initWithFrame: [UIScreen mainScreen].bounds];
    self.alertWindow.rootViewController = [UIViewController new];
    self.alertWindow.windowLevel = UIWindowLevelAlert + 1;
    [self.alertWindow makeKeyAndVisible];
    [self.alertWindow.rootViewController presentViewController: self animated: YES completion: nil];
}


@end
