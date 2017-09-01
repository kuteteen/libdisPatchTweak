//
//  TweakDataManager.m
//  
//
//  Created by mutouren on 2017/6/28.
//
//

#import "TweakDataManager.h"
#import "TweakEXECManager.h"
#import "OMTDebugManager.h"
#import "NSObject+Extension.h"


static NSString *const KUserModelArrayFileName = @"userModel.plist";

#define KMaxReadCountKey @"KMaxReadCountKey"

@interface TweakDataManager ()




@end


static TweakDataManager *instance = nil;

@implementation TweakDataManager

+ (instancetype)sharedInstance
{
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        instance = [[TweakDataManager alloc] init];
    });
    return instance;
}

- (id)init {
    self = [super init];
    if (self) {
        self.userIndex = 0;
        self.userArray = [NSMutableArray array];
        self.selectUserArray = [NSMutableArray array];
        
        [self readUserModel];
    }
    
    return self;
}

- (void)resetUserModelReadState {
    for (UserModel *model in self.userArray) {
        [model resetReadState];
    }
}

- (void)updateSelectUserArrayWithRowArray:(NSMutableArray *)array {
    if (array && array.count) {
        [[TweakDataManager sharedInstance].selectUserArray removeAllObjects];
        
        for (NSNumber *ber in array) {
            NSInteger index = [ber integerValue];
            if (index < [TweakDataManager sharedInstance].userArray.count) {
                UserModel *model = [[TweakDataManager sharedInstance].userArray objectAtIndex:index];
                [[TweakDataManager sharedInstance].selectUserArray addObject:model];
            }
        }
    }
}

- (UserModel *)currentUserModel {
    if (self.userIndex < self.selectUserArray.count) {
        return [self.selectUserArray objectAtIndex:self.userIndex];
    }
    
    return nil;
}

- (UserModel *)phoneUserModel {
    if ([self userPhone]&&[self userPhone].length) {
        for (UserModel *model in self.userArray) {
            if ([model.phone isEqualToString:[self userPhone]]) {
                return model;
            }
        }
    }

    return self.temporaryUserModel;
}

- (void)setLoginUserPhone:(NSString *)phone {
    id user = EXEC(self.userManager,@"user");
    if (user) {
        EXECP(user,@"setPhone:",phone);
    }
}

- (NSString *)tweakDirectory {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *file = @"tweak";
    path = [path stringByAppendingPathComponent:file];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:NULL];
    }
    
    return path;
}

- (NSInteger)maxReadCount {
    return [[[NSUserDefaults standardUserDefaults] objectForKey:KMaxReadCountKey] integerValue];
}

- (void)setMaxReadCount:(NSInteger)maxReadCount {
    [[NSUserDefaults standardUserDefaults] setObject:@(maxReadCount) forKey:KMaxReadCountKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)readUserModel {
    NSString *fileName = [[self tweakDirectory] stringByAppendingPathComponent:KUserModelArrayFileName];
    NSMutableArray *array = [NSKeyedUnarchiver unarchiveObjectWithFile:fileName];
    if (array) {
        [self.userArray removeAllObjects];
        for (UserModel *user in array) {
            [self.userArray addObject:user];
        }
    }
}

- (void)saveUserModel {
    NSString *fileName = [[self tweakDirectory] stringByAppendingPathComponent:KUserModelArrayFileName];
    
    [NSKeyedArchiver archiveRootObject:self.userArray toFile:fileName];
}

- (NSString *)userPhone {
    if (self.userManager) {
        id user = EXEC(self.userManager,@"user");
        if (user) {
            return EXEC(user,@"phone");
        }
    }
    
    return @"";
}

- (NSString *)userCurCoin {
    if (self.userManager) {
        id user = EXEC(self.userManager,@"user");
        if (user) {
            return EXEC(user,@"coin");
        }
    }
    
    return @"";
}

- (NSMutableArray *)modelArray {
    if (!_modelArray) {
        _modelArray = [NSMutableArray array];
    }
    
    return _modelArray;
}

- (UserModel *)temporaryUserModel {
    
    if (!_temporaryUserModel) {
        _temporaryUserModel = [UserModel new];
        [_temporaryUserModel uuid];
        [_temporaryUserModel deviceCode];
        [_temporaryUserModel OSVersion];
        [_temporaryUserModel network];
        [_temporaryUserModel device];
        [_temporaryUserModel userAgent];
        
        NSInteger index = arc4random()%[self temporaryLocation].count;
        
        NSArray * location = [[self temporaryLocation] objectAtIndex:index];
        _temporaryUserModel.lat = [[location firstObject] doubleValue];
        _temporaryUserModel.lon = [[location lastObject] doubleValue];
        
        [_temporaryUserModel location];
    }
    
    return _temporaryUserModel;
}

- (NSArray*)temporaryLocation {
    return @[@[@(31.460199),@(118.635013)],
             @[@(30.318881),@(119.414277)],
             @[@(31.508601),@(118.017324)],
             @[@(31.104868),@(119.741566)],
             @[@(28.941874),@(117.582061)],
             @[@(30.926509),@(120.484653)],
             @[@(28.280556),@(117.796796)],
             @[@(29.133959),@(119.697022)],
             @[@(28.928066),@(120.073874)],
             @[@(31.110599),@(117.304211)],
             @[@(31.314840),@(117.047707)],
             @[@(28.890244),@(117.394622)],
             @[@(30.411273),@(120.365953)],
             @[@(30.337859),@(119.856496)]];
}

- (TweakManager *)tweakManager {
    if (!_tweakManager) {
        _tweakManager = [TweakManager new];
    }
    
    return _tweakManager;
}

- (UIView *)channelsVCMainNavView {
    if (self.channelsVC) {
        return [[self.channelsVC toDictionary] objectForKey:@"_titlePageScrollView"];
    }
    
    return nil;
}

- (UIWebView *)contentWebView {
    if ([TweakDataManager sharedInstance].contentVC) {
        return EXEC([TweakDataManager sharedInstance].contentVC, @"");
    }
    
    return nil;
}

/*
- (id)userManager {
    Class userManagerClass = NSClassFromString(@"UserManger");
    return EXEC([userManagerClass class], @"manger");
    return nil;
}
*/
@end
