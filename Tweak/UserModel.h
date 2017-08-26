//
//  UserModel.h
//  newTweak
//
//  Created by mutouren on 2017/7/24.
//  Copyright © 2017年 mutouren. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


// 分享平台类型
typedef NS_ENUM(NSUInteger, UserModelState) {
    UserModelStateNone,
    UserModelStateRead,
    UserModelStateStop,
    UserModelStateReadFinish,
};


@interface UserModel : NSObject

@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, strong) NSMutableArray *alreadyLoadUrlArray;
@property (nonatomic, copy) NSString *curCoin;
@property (nonatomic, assign) NSInteger readCount;
@property (nonatomic, strong) NSDate *startReadDate;

@property (nonatomic, assign) UserModelState state;


@property (nonatomic, copy) NSString *deviceCode;
@property (nonatomic, copy) NSString *device;
@property (nonatomic, copy) NSString *uuid;
@property (nonatomic, copy) NSString *OSVersion;
@property (nonatomic, copy) NSString *network;
@property (nonatomic, assign) double lat;
@property (nonatomic, assign) double lon;
@property (nonatomic, strong) id location;


- (BOOL)loadUrlArrayContainsObjectWithUrl:(NSString *)url;

- (void)loadUrlArrayaddObjectWithUrl:(NSString *)url;


@end
