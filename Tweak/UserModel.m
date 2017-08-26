//
//  UserModel.m
//  newTweak
//
//  Created by mutouren on 2017/7/24.
//  Copyright © 2017年 mutouren. All rights reserved.
//

#import "UserModel.h"
#import <CommonCrypto/CommonDigest.h>
#import <CoreLocation/CoreLocation.h>




@implementation UserModel

- (id)init {
    self = [super init];
    if (self) {
        self.curCoin = @"0";
        self.readCount = 0;
        self.startReadDate = [NSDate date];
    }
    return self;
}

- (NSString *)cachedFileNameForKey:(NSString *)key {
    const char *str = [key UTF8String];
    if (str == NULL) {
        str = "";
    }
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), r);
    NSString *filename = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                          r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10], r[11], r[12], r[13], r[14], r[15]];
    
    return filename;
}

- (BOOL)loadUrlArrayContainsObjectWithUrl:(NSString *)url {
    NSString *key = [self cachedFileNameForKey:url];
    return [self.alreadyLoadUrlArray containsObject:key];
}

- (void)loadUrlArrayaddObjectWithUrl:(NSString *)url {
    NSString *key = [self cachedFileNameForKey:url];
    
    if (![self.alreadyLoadUrlArray containsObject:key]) {
        [self.alreadyLoadUrlArray addObject:key];
    }
}

//对变量编码
- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.phone forKey:@"phone"];
    [coder encodeObject:self.password forKey:@"password"];
    [coder encodeObject:self.alreadyLoadUrlArray forKey:@"alreadyLoadUrlArray"];
    [coder encodeObject:self.curCoin forKey:@"curCoin"];
    [coder encodeObject:@(self.readCount) forKey:@"readCount"];
    [coder encodeObject:self.startReadDate forKey:@"startReadDate"];
    [coder encodeObject:@(self.state) forKey:@"state"];
    [coder encodeObject:self.deviceCode forKey:@"deviceCode"];
    [coder encodeObject:self.uuid forKey:@"uuid"];
    [coder encodeObject:self.OSVersion forKey:@"OSVersion"];
    [coder encodeObject:self.network forKey:@"network"];
    [coder encodeObject:self.device forKey:@"device"];
    [coder encodeObject:@(self.lat) forKey:@"lat"];
    [coder encodeObject:@(self.lon) forKey:@"lon"];
    
}
//对变量解码
- (id)initWithCoder:(NSCoder *)coder
{
    self.phone = [coder decodeObjectForKey:@"phone"];
    self.password = [coder decodeObjectForKey:@"password"];
    self.alreadyLoadUrlArray = [coder decodeObjectForKey:@"alreadyLoadUrlArray"];
    self.curCoin = [coder decodeObjectForKey:@"curCoin"];
    self.readCount = [[coder decodeObjectForKey:@"readCount"] integerValue];
    self.startReadDate = [coder decodeObjectForKey:@"startReadDate"];
    self.state = [[coder decodeObjectForKey:@"state"] integerValue];
    self.deviceCode = [coder decodeObjectForKey:@"deviceCode"];
    self.uuid = [coder decodeObjectForKey:@"uuid"];
    self.OSVersion = [coder decodeObjectForKey:@"OSVersion"];
    self.network = [coder decodeObjectForKey:@"network"];
    self.device = [coder decodeObjectForKey:@"device"];
    self.lat = [[coder decodeObjectForKey:@"lat"] doubleValue];
    self.lon = [[coder decodeObjectForKey:@"lon"] doubleValue];
    return self;
}

- (NSString *)randomNetWork {
    if ([self.device isEqualToString:@"iPhone 5"] || [self.device isEqualToString:@"iPhone 4S"]) {
        return @"WIFI";
    }
    else {
        NSArray *netWork = @[@"3G",@"4G",@"WIFI"];
        
        NSInteger index = arc4random()%netWork.count;
        
        return [netWork objectAtIndex:index];
    }
    
    
    return @"2G";
}

- (NSString *)randomDevice {
    NSDictionary *deviceDic = @{@"7.1":@[@"iPhone 5",@"iPhone 4S"],
                                @"7.2":@[@"iPhone 5",@"iPhone 4S"],
                                @"7.3":@[@"iPhone 5",@"iPhone 4S"],
                                @"7.4":@[@"iPhone 5",@"iPhone 4S"],
                                @"8.1":@[@"iPhone 5",@"iPhone 4S",@"iPhone 5S",@"iPhone 5C"],
                                @"8.2":@[@"iPhone 5",@"iPhone 4S",@"iPhone 5S",@"iPhone 5C"],
                                @"8.3":@[@"iPhone 5",@"iPhone 4S",@"iPhone 5S",@"iPhone 5C"],
                                @"9.0":@[@"iPhone 5",@"iPhone 4S",@"iPhone 5S",@"iPhone 5C",@"iPhone 6",@"iPhone 6 Plus"],
                                @"9.1":@[@"iPhone 5",@"iPhone 4S",@"iPhone 5S",@"iPhone 5C",@"iPhone 6",@"iPhone 6 Plus"],
                                @"9.2":@[@"iPhone 5",@"iPhone 4S",@"iPhone 5S",@"iPhone 5C",@"iPhone 6",@"iPhone 6 Plus"],
                                @"9.3":@[@"iPhone 5",@"iPhone 4S",@"iPhone 5S",@"iPhone 5C",@"iPhone 6",@"iPhone 6 Plus"],
                                @"9.3.3":@[@"iPhone 5",@"iPhone 4S",@"iPhone 5S",@"iPhone 5C",@"iPhone 6",@"iPhone 6 Plus"],
                                @"10.1":@[@"iPhone 5S",@"iPhone 5C",@"iPhone 6",@"iPhone 6 Plus",@"iPhone 6S",@"iPhone 6S Plus",@"iPhone 7",@"iPhone 7 Plus"],
                                @"10.2":@[@"iPhone 5S",@"iPhone 5C",@"iPhone 6",@"iPhone 6 Plus",@"iPhone 6S",@"iPhone 6S Plus",@"iPhone 7",@"iPhone 7 Plus"],
                                @"10.3":@[@"iPhone 5S",@"iPhone 5C",@"iPhone 6",@"iPhone 6 Plus",@"iPhone 6S",@"iPhone 6S Plus",@"iPhone 7",@"iPhone 7 Plus"]};
    NSArray *device = [deviceDic objectForKey:self.OSVersion];
    
    if (device&&device.count) {
        NSInteger index = arc4random()%device.count;
        
        return [device objectAtIndex:index];
    }
    
    return @"iPhone 6";
}

- (NSString *)randomOSVersion {
    NSArray *OSVersion = @[@"7.1",@"7.2",@"7.3",@"7.4",@"8.1",@"8.2",@"8.3",@"9.0",@"9.1",@"9.2",@"9.3",@"9.3.3",@"10.1",@"10.2",@"10.3"];
    
    NSInteger index = arc4random()%OSVersion.count;
    
    return [OSVersion objectAtIndex:index];
}

- (NSString *)randowIntWithLength:(NSInteger)l {
    if (l == 0) {
        return @"";
    }
    
    NSMutableString *res = [NSMutableString string];
    
    for (int x = 0; x < l; x++) {
        [res appendFormat:@"%02x",arc4random_uniform(255)];
    }
    
    return res;
}

#pragma mark init
- (NSMutableArray *)alreadyLoadUrlArray {
    if (!_alreadyLoadUrlArray) {
        _alreadyLoadUrlArray = [NSMutableArray array];
    }
    
    return _alreadyLoadUrlArray;
}

- (NSString *)deviceCode {
    //@"F7C4B851-0419-4197-0000-5D011CBF182D"
    if (!_deviceCode) {
        NSMutableString *deviceCode = [NSMutableString string];
        [deviceCode appendFormat:@"%@-%@-%@-%@-%@",[self randowIntWithLength:4],[self randowIntWithLength:2],[self randowIntWithLength:2],[self randowIntWithLength:2],[self randowIntWithLength:6]];
        _deviceCode = [deviceCode uppercaseString];
    }
    
    return _deviceCode;
}

- (NSString *)uuid {
    //@"B4FBD181-582E-44D5-9B98-4C7D1E566C6C"
    if (!_uuid) {
        NSMutableString *uuid = [NSMutableString string];
        [uuid appendFormat:@"%@-%@-%@-%@-%@",[self randowIntWithLength:4],[self randowIntWithLength:2],[self randowIntWithLength:2],[self randowIntWithLength:2],[self randowIntWithLength:6]];
        _uuid = [uuid uppercaseString];
    }
    
    return _uuid;
}

- (NSString *)OSVersion {
    if (!_OSVersion) {
        _OSVersion = [self randomOSVersion];
    }
    
    return _OSVersion;
}

- (NSString *)network {
    if (!_network) {
        _network = [self randomNetWork];
    }
    
    return _network;
}

- (NSString *)device {
    if (!_device) {
        _device = [self randomDevice];
    }
    
    return _device;
}

- (id)location {
    if (!_location) {
        _location = [[CLLocation alloc] initWithLatitude:self.lat longitude:self.lon];
    }
    
    return _location;
}

//- (double)lon {
//    if (!_lon) {
//        double val = ((double)arc4random() / ARC4RANDOM_MAX);
////        val = val/3;
//        val += [self lonInteger];
//        NSString *ran = [NSString stringWithFormat:@"%.10f",val];
//        _lon = [ran doubleValue];
//    }
//    
//    return _lon;
//}
//
//- (double)lat {
//    if (!_lat) {
//        double val = ((double)arc4random() / ARC4RANDOM_MAX);
////        val = val/3;
//        val += [self latInteger];
//        NSString *ran = [NSString stringWithFormat:@"%.10f",val];
//        _lat = [ran doubleValue];
//    }
//    
//    return _lat;
//}

@end
