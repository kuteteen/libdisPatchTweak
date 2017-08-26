//
//  OMTDebugManager.h
//  OneMTDemo
//
//  Created by mutouren on 2017/7/31.
//  Copyright © 2017年 onemt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface OMTDebugManager : NSObject


+ (instancetype)sharedInstance;

- (void)debugWithError:(NSError *)error;
- (void)debug:(NSString *)text;

@end
