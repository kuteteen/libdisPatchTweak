//
//  ViewController.m
//  newTweak
//
//  Created by mutouren on 2017/7/15.
//  Copyright © 2017年 mutouren. All rights reserved.
//

#import "ViewController.h"
#import "NSObject+Extension.h"
#import "TweakDataManager.h"
#import "TweakManager.h"
#import "TweakEXECManager.h"
#import "TweakViewController.h"
#import "UserModel.h"
#import <CoreLocation/CoreLocation.h>
#import <AdSupport/AdSupport.h>


@interface ViewController ()

@property (nonatomic, strong) NSString *name;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    
    NSDictionary *info = [self toDictionary];
    
    UIViewController *vc = [info objectForKey:@"_myPage"];
    if (vc) {
        [TweakDataManager sharedInstance].myVC = vc;
    }
    
    vc = [info objectForKey:@"_videoPage"];
    if (vc) {
        [TweakDataManager sharedInstance].videoVC = vc;
    }
    
    vc = [info objectForKey:@"_contentPage"];
    if (vc) {
        [TweakDataManager sharedInstance].homeVC = vc;
    }
    
    [self.view setBackgroundColor:[UIColor blackColor]];
    [self.view removeFromSuperview];
    
    [self.view bringSubviewToFront:self.view];
    
    [self.navigationController popViewControllerAnimated:YES];
    CGPointMake(60, 500);
    
    UIButton *btn;
    [btn setTitle:@"MUTOUREN" forState:UIControlStateNormal];
    UIScrollView *v;
    [v setContentOffset:CGPointMake(0, 320)];
    UIWebView *webView;
    
    UITableView *view;
    
    [webView.scrollView setContentOffset:CGPointMake(0, webView.scrollView.contentSize.height - CGRectGetHeight(webView.frame))];
    
//    NSMutableArray *array = [NSMutableArray arrayWithArray:@[@"mutouren",@"mutouren1"]];
//    [array removeObject:@"mutouren"];
    
    TweakDataManager *manager = [TweakDataManager sharedInstance];
    
//    [manager.modelArray addObject:<#(nonnull id)#>];
    
    NSLog(@"mutouren!!!");
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
    });
    
    if ([TweakDataManager sharedInstance].tweakManager.webFinishLoadBlock) {
        [TweakDataManager sharedInstance].tweakManager.webFinishLoadBlock(webView);
    }
    
    id channel = EXEC(self, @"channel");
    
    [TweakDataManager sharedInstance].modelArray = EXEC(channel, @"array");
    
//    [[[UIAlertView alloc] initWithTitle:@"mutouren" message:@"mutouren" delegate:nil cancelButtonTitle:@"YES" otherButtonTitles:@"NO", nil] show];
    
//    [self presentViewController:[UIAlertController alertControllerWithTitle:@"mutouren" message:@"mutouren" preferredStyle:UIAlertControllerStyleAlert] animated:YES completion:nil];
    
    [[TweakDataManager sharedInstance].tweakManager begin];
    
    self.name = @"mutouren";
    
    
    
    TweakViewController *tweak = [TweakViewController new];
    [self addChildViewController:tweak];
    
    [self.view addSubview:tweak.view];
    
    NSString *n = [tweak name];
    
    [self addObserver:[TweakDataManager sharedInstance].tweakManager forKeyPath:@"count" options:NSKeyValueObservingOptionNew || NSKeyValueChangeOldKey context:nil];
    
    UICollectionView *collectionView;
    
    [self.view bringSubviewToFront:collectionView];
    [collectionView superview];
    
    EXEC([TweakDataManager sharedInstance].homeVC, @"collectionView");
    
    UITabBarController *tabBarVC;
    [tabBarVC setSelectedIndex:1];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
        
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
    });
    
    [self.view subviews];
    [self.view setBackgroundColor:[UIColor redColor]];
    [self.view removeFromSuperview];
    
    [[UIDevice currentDevice] systemVersion];
    
    
    
//    UserModel *model = [UserModel new];
    
//    NSString *uuid = model.uuid;
//    NSString *d = model.deviceCode;
//    
//    CGFloat lat = model.lat;
//    CGFloat lon = model.lon;
    
//    [[TweakDataManager sharedInstance].tweakManager sendLocationWithAddress:@"上海市徐汇区"];
    
//    [[TweakDataManager sharedInstance].tweakManager sendLocationWithLat:model.lat lon:model.lon];
//
    
    NSLog(@"mutouren");
    
    UserModel *model = [TweakDataManager sharedInstance].temporaryUserModel;
    
    CLLocation *tion = [[CLLocation alloc] initWithLatitude:[[TweakDataManager sharedInstance] currentUserModel].lat longitude:[[TweakDataManager sharedInstance] currentUserModel].lon];
    
    [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
    [[NSUUID alloc] initWithUUIDString:[[TweakDataManager sharedInstance] phoneUserModel].deviceCode];
    
    [[[UIDevice currentDevice] identifierForVendor] UUIDString];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
//    after-install::
//    install.exec "killall -9 SpringBoard"

}


@end
