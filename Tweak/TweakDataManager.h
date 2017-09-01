//
//  TweakDataManager.h
//  
//
//  Created by mutouren on 2017/6/28.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UserModel.h"
#import "TweakManager.h"

@interface TweakDataManager : NSObject

@property (nonatomic, strong) UIViewController *myVC;
@property (nonatomic, strong) UIViewController *videoVC;
@property (nonatomic, strong) UIViewController *discoverVC;
@property (nonatomic, strong) UIViewController *rootVC;
@property (nonatomic, strong) UIViewController *contentVC;

@property (nonatomic, strong) UIViewController *channelsVC;
@property (nonatomic, strong, readonly) UIView *channelsVCMainNavView;
@property (nonatomic, strong) NSMutableArray *modelArray;

@property (nonatomic, strong) NSMutableArray *userArray;
@property (nonatomic, strong) NSMutableArray *selectUserArray;
    
@property (nonatomic, strong) UserModel *temporaryUserModel;

@property (nonatomic, strong) id userManager;

@property (nonatomic, strong) id locationManager;

@property (nonatomic, strong) TweakManager *tweakManager;

@property (nonatomic, assign) NSInteger userIndex;


+ (instancetype)sharedInstance;


- (UserModel *)currentUserModel;
- (UserModel *)phoneUserModel;

- (NSInteger)maxReadCount;
- (void)setMaxReadCount:(NSInteger)maxReadCount;

- (void)updateSelectUserArrayWithRowArray:(NSMutableArray *)array;

- (void)readUserModel;
- (void)saveUserModel;

- (void)resetUserModelReadState;

- (void)setLoginUserPhone:(NSString *)phone;

- (NSString *)tweakDirectory;

- (NSString *)userPhone;

- (NSString *)userCurCoin;

- (UIWebView *)contentWebView;



@end
