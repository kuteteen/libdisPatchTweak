//
//  TweakEXECManager.m
//  
//
//  Created by mutouren on 2017/6/28.
//
//

#import "TweakEXECManager.h"
#import "TweakDataManager.h"
#import <objc/runtime.h>


@implementation TweakEXECManager


- (id)execFunWithTarget:(id)targat selectorName:(NSString *)name {
    id sender = nil;
    
    if (targat&&name&&name.length) {
        SEL action = NSSelectorFromString(name);
        if ([targat respondsToSelector:action]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            sender = [targat performSelector:action];
#pragma clang diagnostic pop
        }
    }
    
    
    return sender;
}

- (id)execFunWithTarget:(id)targat selectorName:(NSString *)name param:(id)param {
    id sender = nil;
    
    if (targat&&name&&name.length) {
        SEL action = NSSelectorFromString(name);
        if ([targat respondsToSelector:action]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            sender = [targat performSelector:action withObject:param];
#pragma clang diagnostic pop
        }
    }
    
    
    return sender;
}

- (id)execFunWithTarget:(id)targat selectorName:(NSString *)name param:(id)param1 param:(id)param2 {
    id sender = nil;
    
    if (targat&&name&&name.length) {
        SEL action = NSSelectorFromString(name);
        if ([targat respondsToSelector:action]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            sender = [targat performSelector:action withObject:param1 withObject:param2];
#pragma clang diagnostic pop
        }
    }
    
    
    return sender;
}


@end
