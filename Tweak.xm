
#import "./Tweak/TweakViewController.h"
#import "./Tweak/TweakEXECManager.h"
#import "./Tweak/TweakDataManager.h"
#import "./Tweak/Marco.h"
#import "./Tweak/NSObject+Extension.h"
#import "./Tweak/TweakManager.h"
#import "./Tweak/OMTDebugManager.h"
#import <UIKit/UIKit.h>
#import "./Tweak/OMTDebugManager.h"
#import <CoreLocation/CoreLocation.h>


//QKInterface 网络请求对象

%hook AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    return %orig;
}

%end

%hook UIDevice

+ (id)deviceMode {
    return [[TweakDataManager sharedInstance] phoneUserModel].device;
}

- (NSString*)systemVersion {
    return [[TweakDataManager sharedInstance] phoneUserModel].OSVersion;
}

- (NSUUID*)identifierForVendor {
    return [[NSUUID alloc] initWithUUIDString:[[TweakDataManager sharedInstance] phoneUserModel].uuid];
}

%end

%hook ASIdentifierManager

- (NSUUID*)advertisingIdentifier {
    return [[NSUUID alloc] initWithUUIDString:[[TweakDataManager sharedInstance] phoneUserModel].deviceCode];
}

%end

%hook LocationManager

- (id)coordinate {
    return @{@"lat":@([[TweakDataManager sharedInstance] phoneUserModel].lat),@"lon":@([[TweakDataManager sharedInstance] phoneUserModel].lon)};
}

- (CLLocation *)location {
    return [[TweakDataManager sharedInstance] phoneUserModel].location;
}

- (void)reverseGeocodeLocation:(id)arg1 {
    %orig([[TweakDataManager sharedInstance] phoneUserModel].location);
//    [[TweakDataManager sharedInstance].tweakManager sendLocationLogic];
}

%end

%hook ConfigManger

- (id)UUID {
//@"B4FBD181-582E-44D5-9B98-4C7D1E566C6C"
//    %orig;

    return [[TweakDataManager sharedInstance] phoneUserModel].uuid;
}

- (id)network {
    return [[TweakDataManager sharedInstance] phoneUserModel].network;
}

- (id)IDFA {
//@"F7C4B851-0419-4197-0000-5D011CBF182D"
//    NSString *IDFA = %orig;

    return [[TweakDataManager sharedInstance] phoneUserModel].deviceCode;
}

- (void)setLocationManager:(id)manager {
    %orig;
    [TweakDataManager sharedInstance].locationManager = manager;
}

%end

/*
{
"country" : "中国",
"street" : "",
"district" : "晋安区",
"city" : "福州市",
"address" : "中国福建省福州市晋安区鼓山镇",
"province" : "福建省"
}
*/


%hook UserManger

- (void)setLaunchOptions:(id)option {
    %orig;
    [TweakDataManager sharedInstance].userManager = self;
}

- (void)setUser:(id)user {
    %orig;
    [TweakDataManager sharedInstance].isSwitchoverLogin = YES;

}

%end


%hook ChannelsViewController


- (void)viewDidLoad {
    %orig;

    [TweakDataManager sharedInstance].homeVC = (UIViewController *)self;

}

- (void)search {
    [[TweakDataManager sharedInstance].tweakManager end];

    TweakViewController *tweakVC = [[TweakViewController alloc] init];
    UIViewController *rootCtrl = [UIApplication sharedApplication].keyWindow.rootViewController;
    [rootCtrl presentViewController:tweakVC animated:YES completion:nil];
}

%end


%hook QKContentViewController

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    %orig;
    if (webView.isLoading) {
        return;
    }

    [TweakDataManager sharedInstance].contentVC = (UIViewController*)self;
    if ([TweakDataManager sharedInstance].tweakManager.webFinishLoadBlock) {
        [TweakDataManager sharedInstance].tweakManager.webFinishLoadBlock(webView);
    }
}

%end


%hook QKLoginViewController

- (void)viewDidLoad {
    %orig;
    if ([TweakDataManager sharedInstance].tweakManager.loginBlock) {
        [TweakDataManager sharedInstance].tweakManager.loginBlock((UIViewController *)self);
    }
}

%end

%hook QKRootViewController

- (void)viewDidLoad {
    %orig;

    NSDictionary *info = [(UIViewController*)self toDictionary];

    UIViewController *vc = [info objectForKey:@"_myPage"];
    if (vc) {
        [TweakDataManager sharedInstance].myVC = vc;
    }

    vc = [info objectForKey:@"_videoPage"];
    if (vc) {
        [TweakDataManager sharedInstance].videoVC = vc;
    }

    [TweakDataManager sharedInstance].rootVC = (UIViewController*)self;
}

%end

/*
%hook QKMyViewController

%new
- (UIButton *)createTweakBtn {
    UIButton *btn = [UIButton new];
    btn.frame = CGRectMake(0,0,SCREEN_SIZE_WIDTH,50);
    [btn setBackgroundColor:[UIColor redColor]];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:12.0f]];
    //    btn.layer.cornerRadius = btn.frame.size.width / 2;
    //    btn.layer.masksToBounds = YES;
    [btn addTarget:self action:@selector(tweakBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"TWEAK" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    return btn;
}

%new
- (void)tweakBtnClick {

    TweakViewController *tweakVC = [[TweakViewController alloc] init];
    UIViewController *rootCtrl = [UIApplication sharedApplication].keyWindow.rootViewController;
    [rootCtrl presentViewController:tweakVC animated:YES completion:nil];

}

- (void)viewDidLoad {
    %orig;

    UIViewController *vc = (UIViewController *)self;

    UIButton *btn = (UIButton*)EXEC(vc,@"createTweakBtn");

    [vc.view addSubview:btn];

    for (UIView *view in vc.view.subviews) {
        if ([view isKindOfClass:[UITableView class]]) {
            UITableView *tableView = (UITableView *)view;
            [tableView.tableHeaderView addSubview:btn];
            tableView.tableFooterView = btn;
        }
    }
}
%end
*/

