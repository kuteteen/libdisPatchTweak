//
//  MBProgressHUD+OMTExtension.m
//  HudDemo
//
//  Created by yizhaorong on 20/05/2017.
//  Copyright © 2017 Matej Bukovinski. All rights reserved.
//

#import "MBProgressHUD+OMTExtension.h"
#import "../UIView+OMTExtension.h"

static NSTimeInterval const kDefaultHideInterval = 2;

@implementation MBProgressHUD (OMTExtension)

+ (instancetype)showMessage:(NSString *)message {
    return [self showMessage:message inView:[UIApplication sharedApplication].keyWindow];
}

+ (instancetype)showMessage:(NSString *)message inView:(UIView *)view {
    MBProgressHUD *hud = [self HudFromView:view];
    hud.mode = MBProgressHUDModeText;
    hud.userInteractionEnabled = NO;
    if (message) {
        if (message.length > 10) {
            hud.detailsLabel.text = message;
        } else {
            hud.label.text = message;
        }
    }
    [view addSubview:hud];
    [hud showAnimated:YES];
    [hud hideAnimated:YES afterDelay:kDefaultHideInterval];
    return hud;
}

+ (instancetype)show {
    return [self showInView:[UIApplication sharedApplication].keyWindow];
}

+ (instancetype)showInView:(UIView *)view {
    return [self showWithStatus:nil inView:view];
}

+ (instancetype)showWithStatus:(NSString *)string {
    return [self showWithStatus:string inView:[UIApplication sharedApplication].keyWindow];
}

+ (instancetype)showWithStatus:(NSString *)string inView:(UIView *)view {
    return [self showWithStatus:string inView:view offsetY:0];
}

+ (instancetype)showWithOffsetY:(CGFloat)offsetY {
    return [self showWithOffsetY:offsetY inView:[UIApplication sharedApplication].keyWindow];
}

+ (instancetype)showWithOffsetY:(CGFloat)offsetY inView:(UIView *)view {
    return [self showWithStatus:nil inView:view offsetY:offsetY];
}

+ (instancetype)showWithStatus:(NSString *)string offsetY:(CGFloat)offsetY {
    return [self showWithStatus:string inView:[UIApplication sharedApplication].keyWindow offsetY:offsetY];
}

+ (instancetype)showWithStatus:(NSString *)string inView:(UIView *)view offsetY:(CGFloat)offsetY {
    MBProgressHUD *hud = [self HudFromView:view];
    hud.top = offsetY;
    hud.height = view.height - offsetY;
    hud.offset = CGPointMake(0, -(offsetY / 2));
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.userInteractionEnabled = YES;
    hud.detailsLabel.text = nil;
    hud.label.text = nil;
    if (string) {
        if (string.length > 10) {
            hud.detailsLabel.text = string;
        } else {
            hud.label.text = string;
        }
    }
    
    [view addSubview:hud];
    [hud showAnimated:YES];
    return hud;
}

+ (void)dismiss {
    [self dismissWithDelay:0 inView:[UIApplication sharedApplication].keyWindow];
}

+ (void)dismissInView:(UIView *)view {
    [self dismissWithDelay:0 inView:view];
}

+ (void)dismissWithDelay:(NSTimeInterval)delay {
    [self dismissWithDelay:delay inView:[UIApplication sharedApplication].keyWindow];
}

+ (void)dismissWithDelay:(NSTimeInterval)delay inView:(UIView *)view {
    MBProgressHUD *hud = [MBProgressHUD HUDForView:view];
    if (hud) {
        [hud hideAnimated:YES afterDelay:delay];
    }
}

#pragma mark - Private
+ (instancetype)HudFromView:(UIView *)view {
    MBProgressHUD *hud = [MBProgressHUD HUDForView:view];
    if (!hud) hud = [[self alloc] initWithView:view];
    hud.margin = 10;
    hud.animationType = MBProgressHUDAnimationZoom;
    hud.bezelView.color = [UIColor colorWithWhite:0 alpha:0.6];
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.removeFromSuperViewOnHide = YES;
    hud.contentColor = [UIColor whiteColor];
    return hud;
}

@end
