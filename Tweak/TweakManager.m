//
//  TweakManager.m
//  newTweak
//
//  Created by mutouren on 2017/7/15.
//  Copyright © 2017年 mutouren. All rights reserved.
//

#import "TweakManager.h"
#import "TweakDataManager.h"
#import "TweakEXECManager.h"
#import "NSObject+Extension.h"
#import "OMTDebugManager.h"
#import <CoreLocation/CoreLocation.h>
#import "./lib/MBProgressHUD/MBProgressHUD+OMTExtension.h"


#define ARC4RANDOM_MAX      0x100000000

@interface TweakManager ()

@property (nonatomic, assign) NSInteger moveCount;              //webView 移动用的个数
@property (nonatomic, strong) NSBlockOperation *op;
@property (nonatomic, assign) BOOL webViewLoading;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) CLGeocoder *geocoder;

@property (nonatomic, assign) NSInteger userConfigIndex;

@property (nonatomic, copy) userModelConfigCompleteBlock configCompleteBlock;

@property (nonatomic, assign) BOOL isExeWebLoad;

@property (nonatomic, strong) NSBlockOperation *webViewLoadOP;

@end


@implementation TweakManager


- (id)init {
    self = [super init];
    if (self) {
        self.dataArray = [NSMutableArray array];
        self.webViewLoading = NO;
    }
    
    return self;
}

- (void)readModelLogic {
    if ([[TweakDataManager sharedInstance] currentUserModel].readCount < [[TweakDataManager sharedInstance] maxReadCount]) {
        id model = nil;
        NSInteger count = [[TweakDataManager sharedInstance] maxReadCount] - [[TweakDataManager sharedInstance] currentUserModel].readCount;
        if (count < self.dataArray.count) {
            model = [self.dataArray objectAtIndex:count];
        }
        
        if (model) {
            UserModel *user = [[TweakDataManager sharedInstance] currentUserModel];
            user.readCount++;
            [self VCReadContentModel:model];
        }
        else {
            [self switchAccount];
        }
    }
    else {
        [self switchAccount];
    }
}

- (void)switchAccount {
    //获取金币
    [self gotoMyVC];
    
    [self gotoMyVC];
    
//    EXECP([TweakDataManager sharedInstance].myVC, @"beginRereshingAnimation:",@(YES));
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UserModel *model = [[TweakDataManager sharedInstance] currentUserModel];
        if (model) {
            model.curCoin = [[TweakDataManager sharedInstance] userCurCoin];
            [model updateStartReadDate];
        }
        
        //todo 切换账号
        [self gotoChannelsVC];
        if ([TweakDataManager sharedInstance].userIndex < [TweakDataManager sharedInstance].selectUserArray.count) {
            [TweakDataManager sharedInstance].userIndex++;
            [[TweakDataManager sharedInstance] saveUserModel];
            
            [self begin];
        }
        else {
            [self end];
        }
    });
}

- (void)randomChannel {
    UIView *navView = [TweakDataManager sharedInstance].channelsVCMainNavView;
    
    if (navView) {
        NSArray *btnArray = EXEC(navView, @"btnArray");
        
        if (btnArray&&btnArray.count) {
            NSInteger index = arc4random()%btnArray.count;
            UIButton *btn = [btnArray objectAtIndex:index];
            
            [btn sendActionsForControlEvents:UIControlEventTouchUpInside];
            return;
        }
        
    }
}

- (void)roadData {
    NSMutableArray *curArray = nil;
    
    id channel = EXEC([TweakDataManager sharedInstance].channelsVC,@"channel");
    if (channel) {
        curArray = EXEC(channel,@"array");
    }
    
    if (curArray ) {
        [curArray removeAllObjects];
    }
    
    [self downloadData];
}

- (void)downloadData {
    
    NSMutableArray *curArray = nil;
    
    id channel = EXEC([TweakDataManager sharedInstance].channelsVC,@"channel");
    if (channel) {
        curArray = EXEC(channel,@"array");
    }
    
    NSInteger count = [[TweakDataManager sharedInstance] maxReadCount] - [[TweakDataManager sharedInstance] currentUserModel].readCount;
    if (count <= 0) {
        [MBProgressHUD showMessage:@"最大读取个数少于当前账号的已读个数"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self switchAccount];
        });
        
        return;
    }
    
    NSInteger roadMaxCount = (count/6)*8 + 6;
    
    __weak TweakManager *weakSelf = self;
    
    if (curArray.count < roadMaxCount) {
        OBJC_MSG([TweakDataManager sharedInstance].channelsVC, @"beginRefreshing");
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf downloadData];
            
        });
        return;
    }
    else {
        
        [self.dataArray removeAllObjects];
        
        for (id model in curArray) {
            NSString *introduction = EXEC(model, @"introduction");
            if ([NSStringFromClass([model class]) isEqualToString:@"QKContentModel"]) {
                if ([introduction isKindOfClass:[NSString class]] && introduction.length) {
                    [self.dataArray addObject:model];
                }
            }
        }
        
        
        [self readModelLogic];
    }
}

- (void)VCReadContentModel:(id)model {
    
    
    [self contentVCBack];
    __weak TweakManager *weakSelf = self;
    self.isExeWebLoad = NO;
    self.webFinishLoadBlock = ^(UIWebView *webView) {
        
        if (weakSelf.webViewLoading == NO) {
            weakSelf.webViewLoading = YES;
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [webView.scrollView setContentOffset:CGPointMake(0, 300)];
            });
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByClassName('collbtn')[0].click()"];
            });
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                weakSelf.moveCount = 0;
                [weakSelf moveWebViewBottom:webView];
            });
            
        }
        
    };
    
    EXECP([TweakDataManager sharedInstance].rootVC, @"gotoQKContentViewController:", model);
    
    if (self.webViewLoadOP) {
        if (self.webViewLoadOP.executing) {
            [self.webViewLoadOP cancel];
        }
        self.webViewLoadOP = nil;
    }
    
    [self.webViewLoadOP start];
}

- (void)VCLoginLogic {
    
    __weak TweakManager *weakSelf = self;
    
    if ([[TweakDataManager sharedInstance] userPhone] && [[TweakDataManager sharedInstance] userPhone].length) {
        [self logout];
        [[TweakDataManager sharedInstance] setLoginUserPhone:@""];
    }
    
    
    self.loginBlock = ^(UIViewController *loginVC) {
        UITextField *phoneText = EXEC(loginVC, @"phone_field");
        UITextField *passwordText = EXEC(loginVC, @"password_field");
        UserModel *userModel = [[TweakDataManager sharedInstance] currentUserModel];
        if (userModel) {
            
            [[TweakDataManager sharedInstance] setLoginUserPhone:userModel.phone];
            [phoneText setText:userModel.phone];
            [passwordText setText:userModel.password];
            
            if (phoneText && passwordText) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    OBJC_MSG(loginVC,@"login");
                });
                
                [weakSelf loginState];
            }
            
        }
        else {
            [weakSelf end];
        }
    };
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        OBJC_MSG([TweakDataManager sharedInstance].rootVC, @"logout");
    });
    
}

- (void)logout {
    Class MyClass = NSClassFromString(@"QKSettingViewController");
    
    OBJC_MSG([MyClass new], @"exitAction");
    
}

- (void)loginState {
    
    __weak TweakManager *weakSelf = self;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if ([TweakDataManager sharedInstance].rootVC.presentedViewController) {
            [weakSelf loginState];
        }
        else {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf execLogic:TweakManagerExecTypeLoginFinish];
            });
            
        }
    });
}

- (void)gotoChannelsVC {
    if ([TweakDataManager sharedInstance].rootVC) {
        UITabBarController *tabBarVC = (UITabBarController *)[TweakDataManager sharedInstance].rootVC;
        UIView *tabBar = EXEC(tabBarVC, @"tabBar");
        
        if (tabBar) {
            for (UIView *view in [tabBar subviews]) {
                if ([NSStringFromClass([view class]) isEqualToString:@"UITabBarButton"]) {
                    NSDictionary *info = [view toDictionary];
                    
                    UILabel *label = [info objectForKey:@"_label"];
                    if (label && [label.text isEqualToString:@"头条"]) {
                        [(UIButton*)view sendActionsForControlEvents:UIControlEventTouchUpInside];
                    }
                }
            }
        }
    }
}

- (void)gotoMyVC {
    if ([TweakDataManager sharedInstance].rootVC) {
        UITabBarController *tabBarVC = (UITabBarController *)[TweakDataManager sharedInstance].rootVC;
        UIView *tabBar = EXEC(tabBarVC, @"tabBar");
        
        if (tabBar) {
            for (UIView *view in [tabBar subviews]) {
                if ([NSStringFromClass([view class]) isEqualToString:@"UITabBarButton"]) {
                    NSDictionary *info = [view toDictionary];
                    
                    UILabel *label = [info objectForKey:@"_label"];
                    if (label && [label.text isEqualToString:@"我的"]) {
                        [(UIButton*)view sendActionsForControlEvents:UIControlEventTouchUpInside];
                    }
                }
            }
        }
    }
}

- (void)moveWebViewBottom:(UIWebView *)webView {
    
    if (webView.scrollView.contentOffset.y < webView.scrollView.contentSize.height - CGRectGetHeight(webView.frame) - 300) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [webView.scrollView setContentOffset:CGPointMake(0, webView.scrollView.contentOffset.y + 30.0f)];
            [self moveWebViewBottom:webView];
            
        });
        return ;
    }
    else {
        if (self.moveCount == 6) {
            [self contentVCBack];
            self.webViewLoading = NO;
            if ([TweakDataManager sharedInstance].contentVC) {
                [TweakDataManager sharedInstance].contentVC = nil;
            }
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self execLogic:TweakManagerExecTypeWebViewFinish];
            });
            return;
        }
        else {
            self.moveCount++;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self moveWebViewBottom:webView];
            });
            return;
        }
    }
}

- (void)execLogic:(TweakManagerExecType)type {
    switch (type) {
        case TweakManagerExecTypeLoginFinish:
        {
            self.loginBlock = nil;
            
//            [self sendLocationLogic];
            [self webViewConfig];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self randomChannel];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self roadData];
                });
            });
            
            
            break;
        }
        case TweakManagerExecTypeWebViewFinish:
        {
            self.webFinishLoadBlock = nil;
            
            [self readModelLogic];
            break;
        }
        
            
        default:
            break;
    }
}

- (void)webViewConfig {
    //    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    //    NSString *userAgent = [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    NSString *userAgent = [[TweakDataManager sharedInstance] phoneUserModel].userAgent;
    NSString *newUserAgent = [userAgent stringByAppendingString:@"ua qukan_ios"];
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:newUserAgent, @"UserAgent", nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];
}

- (void)randomLocationWithUserModel:(UserModel *)model {
    CLLocation *location=[self randomLocation];
    
    [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray * _Nullable placemarks, NSError * _Nullable error) {
        
//        NSLog(@"lat===>%f,lon===>%f",location.coordinate.latitude,location.coordinate.longitude);
        
        if (error || placemarks.count == 0) {
            
        }else {
            CLPlacemark *mark = [placemarks firstObject];
//            NSLog(@"mark.lat===>%f,mark.lon===>%f",mark.location.coordinate.latitude,mark.location.coordinate.longitude);
            NSDictionary *dic = mark.addressDictionary;
//            NSLog(@"addressDictionary===>%@",dic);
            if ([dic allKeys].count >= 9) {
                CLLocation *tion = EXEC(mark, @"location");
                model.lat = tion.coordinate.latitude;
                model.lon = tion.coordinate.longitude;
                [model location];
                self.userConfigIndex++;
                [self configUserModel];
                return;
            }
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            UserModel *model = [UserModel new];
            [self randomLocationWithUserModel:model];
            
        });
    }];
}

- (void)configUserModel {
    if (self.userConfigIndex < [TweakDataManager sharedInstance].userArray.count) {
        UserModel *user = [[TweakDataManager sharedInstance].userArray objectAtIndex:self.userConfigIndex];
        
        [user deviceCode];
        [user uuid];
        [user OSVersion];
        [user network];
        [user device];
        [user userAgent];

        if (user.lat == 0 || user.lon == 0) {
            [self randomLocationWithUserModel:user];
        }
        else {
            self.userConfigIndex++;
            [self configUserModel];
            return;
        }
    }
    else {
        [[TweakDataManager sharedInstance] saveUserModel];
        self.configCompleteBlock();
    }
    
}

- (void)startConfigUserModelComleteBlock:(userModelConfigCompleteBlock)comleteBlock {
    self.userConfigIndex = 0;
    self.configCompleteBlock = comleteBlock;
    [self configUserModel];
}

- (void)sendLocationLogic {
    UserModel *userModel = [[TweakDataManager sharedInstance] phoneUserModel];
    if (userModel) {
        [self sendLocationWithLat:userModel.lat lon:userModel.lon];
    }
}

- (void)sendLocationWithLat:(double)lat lon:(double)lon {
    CLLocation *location=[[CLLocation alloc] initWithLatitude:lat longitude:lon];
    
    [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray * _Nullable placemarks, NSError * _Nullable error) {
        if (error || placemarks.count == 0) {
            
        }else {
            CLPlacemark *mark = [placemarks firstObject];
            NSDictionary *dic = mark.addressDictionary;
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if ([TweakDataManager sharedInstance].locationManager) {
                    EXECP([TweakDataManager sharedInstance].locationManager, @"sendLocation:", dic);
                }
                
            });
            
        }
        
    }];
    
}

- (void)contentVCBack {
    if ([TweakDataManager sharedInstance].contentVC) {
        EXEC([TweakDataManager sharedInstance].contentVC, @"back");
        [TweakDataManager sharedInstance].contentVC = nil;
    }
}

- (void)begin {
    self.isRun = YES;
    self.op = nil;
    [self.op start];
}

- (void)end {
    self.isRun = NO;
    [self.op cancel];
}

- (NSBlockOperation *)op {
    if (!_op) {
        _op = [NSBlockOperation blockOperationWithBlock:^{
            [self VCLoginLogic];
            
        }];
    }
    
    return _op;
}

- (NSBlockOperation *)webViewLoadOP {
    if (!_webViewLoadOP) {
        _webViewLoadOP = [NSBlockOperation blockOperationWithBlock:^{
            if (self.webFinishLoadBlock) {
                UIWebView *webView = [[TweakDataManager sharedInstance] contentWebView];
                if (webView) {
                    sleep(10.0f);
                    self.webFinishLoadBlock(webView);
                }
                
            }
        }];
    }
    
    return _webViewLoadOP;
}

-(CLGeocoder *)geocoder
{
    if (_geocoder==nil) {
        _geocoder=[[CLGeocoder alloc]init];
    }
    return _geocoder;
}

- (NSDictionary *)latLonForepartDictionary {
    return @{@"抚州":@{@"lat":@[@"27.93",@"27.94",@"27.95",@"27.96",@"27.97"],@"lon":@[@"116.34",@"116.35",@"116.36",@"116.37",@"116.38"]},
             @"上饶":@{@"lat":@[@"28.42",@"28.43",@"28.44",@"28.45",@"28.46"],@"lon":@[@"117.94",@"117.95",@"117.96",@"117.97",@"117.98"]},
             @"衡州":@{@"lat":@[@"28.92",@"28.93",@"28.94",@"28.95",@"28.96",@"28.97",@"28.98"],@"lon":@[@"118.83",@"118.84",@"118.85",@"118.86",@"118.87",@"118.88",@"118.89",@"118.90"]},
             @"江山":@{@"lat":@[@"28.72",@"28.73",@"28.74",@"28.75",@"28.76"],@"lon":@[@"118.62",@"118.63",@"118.64"]},
             @"龙泉":@{@"lat":@[@"28.06",@"28.07"],@"lon":@[@"119.12",@"119.13",@"119.14"]},
             @"宜春":@{@"lat":@[@"27.78",@"27.79",@"27.80",@"27.81"],@"lon":@[@"114.33",@"114.34",@"114.35",@"114.36",@"114.37",@"114.38",@"114.39",@"114.40"]},
             @"萍乡":@{@"lat":@[@"27.61",@"27.62",@"27.63",@"27.64"],@"lon":@[@"113.83",@"113.84",@"113.85",@"113.86",@"113.87",@"113.88"]},
             @"长沙":@{@"lat":@[@"27.78",@"27.79",@"27.80",@"27.81",@"27.82",@"27.83",@"27.84",@"27.85",@"27.86",@"27.87",@"27.88",@"27.89",@"27.90",@"27.91",@"27.92",@"27.93",@"27.94",@"27.95",@"27.96",@"27.97",@"27.98",@"27.99",@"28.00",@"28.01",@"28.02",@"28.03",@"28.04",@"28.05",@"28.06",@"28.07",@"28.08",@"28.09",@"28.10",@"28.11",@"28.12",@"28.13",@"28.14",@"28.15",@"28.16",@"28.17",@"28.18",@"28.19",@"28.20",@"28.21",@"28.22",@"28.23",@"28.24",@"28.25",@"28.26",@"28.27",@"28.28",@"28.29",@"28.30"],@"lon":@[@"112.86",@"112.87",@"112.88",@"112.89",@"112.90",@"112.91",@"112.92",@"112.93",@"112.94",@"112.95",@"112.96",@"112.97",@"112.98",@"112.99",@"113.00",@"113.01",@"113.02",@"113.03",@"113.04",@"113.05",@"113.06",@"113.07",@"113.08",@"113.09",@"113.10",@"113.11",@"113.12",@"113.13"]}};
}

- (NSDictionary *)randomLatlon {
    
    NSArray *keyArray = [[self latLonForepartDictionary] allKeys];
    
    NSInteger index = arc4random()%keyArray.count;
    
    NSString *key = [keyArray objectAtIndex:index];
    
    NSDictionary *obj = [[self latLonForepartDictionary] objectForKey:key];
    
    NSArray *latArray = [obj objectForKey:@"lat"];
    NSArray *lonArray = [obj objectForKey:@"lon"];
    
    index = arc4random()%latArray.count;
    double randomLat = [[latArray objectAtIndex:index] doubleValue];
    
    index = arc4random()%lonArray.count;
    double randomLon = [[lonArray objectAtIndex:index] doubleValue];
    
    double lat = ((double)arc4random() / ARC4RANDOM_MAX);
    
    NSInteger intLat = lat*10;
    if (intLat) {
        lat = lat/10;
    }
    
    intLat = lat*100;
    if (intLat) {
        lat = lat/10;
    }
    
    //        val = val/3;
    lat += randomLat;
    NSString *latRan = [NSString stringWithFormat:@"%.10f",lat];
    
    double lon = ((double)arc4random() / ARC4RANDOM_MAX);
    
    NSInteger intLon = lon*10;
    if (intLon) {
        lon = lon/10;
    }
    
    intLon = lon*100;
    if (intLon) {
        lon = lon/10;
    }
    
    //        val = val/3;
    lon += randomLon;
    NSString *lonRan = [NSString stringWithFormat:@"%.10f",lon];
    
    return @{@"lat":latRan,@"lon":lonRan};
}

- (CLLocation*)randomLocation {
    NSDictionary *latLon = [self randomLatlon];
    CLLocationDegrees lat = [[latLon objectForKey:@"lat"] doubleValue];
    CLLocationDegrees lon = [[latLon objectForKey:@"lon"] doubleValue];
    CLLocation *tion = [[CLLocation alloc] initWithLatitude:lat longitude:lon];
    
    return tion;
}


@end
