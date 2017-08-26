//
//  TweakManager.h
//  newTweak
//
//  Created by mutouren on 2017/7/15.
//  Copyright © 2017年 mutouren. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// 执行类型
typedef NS_ENUM(NSUInteger, TweakManagerExecType) {
    TweakManagerExecTypeNone,
    TweakManagerExecTypeLoginFinish,
    TweakManagerExecTypeWebViewFinish
};


typedef void (^webViewDidFinishLoadBlock)(UIWebView *webView);

typedef void (^exeLoginBlock)(UIViewController *loginVC);

typedef void (^loginDidFinishBlock)();

typedef void (^QKTableViewDataReloadBlock)(void);

typedef void (^userModelConfigCompleteBlock)(void);

@interface TweakManager : NSObject

@property (nonatomic, copy) webViewDidFinishLoadBlock webFinishLoadBlock;
@property (nonatomic, copy) exeLoginBlock loginBlock;
@property (nonatomic, assign) BOOL isRun;


- (void)begin;

- (void)end;

- (void)gotoHomeVC;

- (void)VCLoginLogic;

- (void)sendLocationLogic;

- (void)startConfigUserModelComleteBlock:(userModelConfigCompleteBlock)comleteBlock;


@end
