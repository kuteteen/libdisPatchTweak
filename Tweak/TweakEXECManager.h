//
//  TweakEXECManager.h
//  
//
//  Created by mutouren on 2017/6/28.
//
//

#import <Foundation/Foundation.h>
#import <objc/message.h>


#define OBJC_MSG(targat,name) ((void (*) (id, SEL)) (void *)objc_msgSend)(targat, NSSelectorFromString(name));
#define EXEC(targat,name) [[TweakEXECManager new] execFunWithTarget:targat selectorName:name]
#define EXECP(targat,name,param1) [[TweakEXECManager new] execFunWithTarget:targat selectorName:name param:param1]
#define EXECPP(targat,name,param1,param2) [[TweakEXECManager new] execFunWithTarget:targat selectorName:name param:param1 param:param2]


@interface TweakEXECManager : NSObject


- (id)execFunWithTarget:(id)targat selectorName:(NSString *)name;

- (id)execFunWithTarget:(id)targat selectorName:(NSString *)name param:(id)param;

- (id)execFunWithTarget:(id)targat selectorName:(NSString *)name param:(id)param1 param:(id)param2;


@end
