//
//  UIView+OMTExtension.m
//  SocialSDKDemo
//
//  Created by liu_shaoqiu on 15/6/28.
//  Copyright (c) 2015年 onemt. All rights reserved.
//

#import "UIView+OMTExtension.h"

@implementation UIView(OMTExtension)
//根据视图的center,左右对换
+(CGPoint)symmetryViewCenter:(CGPoint)center supViewWidth:(CGFloat)width
{
    CGFloat pointX = center.x;
    center.x = width-pointX;
    return center;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)left {
    return self.frame.origin.x;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setLeft:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)top {
    return self.frame.origin.y;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setTop:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)centerX {
    return self.center.x;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setCenterX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)centerY {
    return self.center.y;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setCenterY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)width {
    return self.frame.size.width;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)height {
    return self.frame.size.height;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)ttScreenX {
    CGFloat x = 0;
    for (UIView* view = self; view; view = view.superview) {
        x += view.left;
    }
    return x;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)ttScreenY {
    CGFloat y = 0;
    for (UIView* view = self; view; view = view.superview) {
        y += view.top;
    }
    return y;
}



///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)screenViewX {
    CGFloat x = 0;
    for (UIView* view = self; view; view = view.superview) {
        x += view.left;
        
        if ([view isKindOfClass:[UIScrollView class]]) {
            UIScrollView* scrollView = (UIScrollView*)view;
            x -= scrollView.contentOffset.x;
        }
    }
    
    return x;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)screenViewY {
    CGFloat y = 0;
    for (UIView* view = self; view; view = view.superview) {
        y += view.top;
        
        if ([view isKindOfClass:[UIScrollView class]]) {
            UIScrollView* scrollView = (UIScrollView*)view;
            y -= scrollView.contentOffset.y;
        }
    }
    return y;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGRect)screenFrame {
    return CGRectMake(self.screenViewX, self.screenViewY, self.width, self.height);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGPoint)origin {
    return self.frame.origin;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGSize)size {
    return self.frame.size;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}




///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIView*)descendantOrSelfWithClass:(Class)cls {
    if ([self isKindOfClass:cls])
        return self;
    
    for (UIView* child in self.subviews) {
        UIView* it = [child descendantOrSelfWithClass:cls];
        if (it)
            return it;
    }
    
    return nil;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIView*)ancestorOrSelfWithClass:(Class)cls {
    if ([self isKindOfClass:cls]) {
        return self;
    } else if (self.superview) {
        return [self.superview ancestorOrSelfWithClass:cls];
    } else {
        return nil;
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)removeAllSubviews {
    while (self.subviews.count) {
        UIView* child = self.subviews.lastObject;
        [child removeFromSuperview];
    }
}


// sourced from http://stackoverflow.com/questions/4431292/inner-shadow-effect-on-uiview-layer

- (void)drawInnerShadowInRect:(CGRect)rect radius:(CGFloat)radius fillColor:(UIColor *)fillColor;
{
    CGRect bounds = [self bounds];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGFloat outsideOffset = 20.f;
    
    CGMutablePathRef visiblePath = CGPathCreateMutable();
    CGPathMoveToPoint(visiblePath, NULL, bounds.size.width-radius, bounds.size.height);
    CGPathAddArc(visiblePath, NULL, bounds.size.width-radius, radius, radius, 0.5f*M_PI, 1.5f*M_PI, YES);
    CGPathAddLineToPoint(visiblePath, NULL, radius, 0.f);
    CGPathAddArc(visiblePath, NULL, radius, radius, radius, 1.5f*M_PI, 0.5f*M_PI, YES);
    CGPathAddLineToPoint(visiblePath, NULL, bounds.size.width-radius, bounds.size.height);
    CGPathCloseSubpath(visiblePath);
    
    [fillColor setFill];
    CGContextAddPath(context, visiblePath);
    CGContextFillPath(context);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, -outsideOffset, -outsideOffset);
    CGPathAddLineToPoint(path, NULL, bounds.size.width+outsideOffset, -outsideOffset);
    CGPathAddLineToPoint(path, NULL, bounds.size.width+outsideOffset, bounds.size.height+outsideOffset);
    CGPathAddLineToPoint(path, NULL, -outsideOffset, bounds.size.height+outsideOffset);
    
    CGPathAddPath(path, NULL, visiblePath);
    CGPathCloseSubpath(path);
    
    CGContextAddPath(context, visiblePath);
    CGContextClip(context);
    
    UIColor * shadowColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.6f];
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, CGSizeMake(0.0f, 4.0f), 8.0f, [shadowColor CGColor]);
    [shadowColor setFill];
    
    CGContextSaveGState(context);
    CGContextAddPath(context, path);
    CGContextFillPath(context);
    
    CGPathRelease(path);
    CGPathRelease(visiblePath);
    CGContextRestoreGState(context);
}

- (void)drawInnerShadowInRect:(CGRect)rect fillColor:(UIColor *)fillColor
{
    [self drawInnerShadowInRect:rect radius:(0.5f * CGRectGetHeight(rect)) fillColor:fillColor];
}



@end
