//
//  MBProgressHUD+OMTExtension.h
//  Pods
//
//  Created by yizhaorong on 26/05/2017.
//
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (OMTExtension)

+ (instancetype)showMessage:(NSString *)message;

+ (instancetype)showMessage:(NSString *)message inView:(UIView *)view;

+ (instancetype)show;

+ (instancetype)showInView:(UIView *)view;

+ (instancetype)showWithStatus:(NSString *)string;

+ (instancetype)showWithStatus:(NSString *)string inView:(UIView *)view;

+ (instancetype)showWithOffsetY:(CGFloat)offsetY;

+ (instancetype)showWithOffsetY:(CGFloat)offsetY inView:(UIView *)view;

+ (instancetype)showWithStatus:(NSString *)string offsetY:(CGFloat)offsetY;

+ (instancetype)showWithStatus:(NSString *)string inView:(UIView *)view offsetY:(CGFloat)offsetY;

+ (void)dismiss;

+ (void)dismissInView:(UIView *)view;

+ (void)dismissWithDelay:(NSTimeInterval)delay;

+ (void)dismissWithDelay:(NSTimeInterval)delay inView:(UIView *)view;

@end
