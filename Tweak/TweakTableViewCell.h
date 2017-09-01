//
//  TweakTableViewCell.h
//  newTweak
//
//  Created by mutouren on 2017/7/26.
//  Copyright © 2017年 mutouren. All rights reserved.
//

#import <UIKit/UIKit.h>

#define CELLHEIGHT 66.0f

@interface TweakTableViewCell : UITableViewCell


- (void)setPhoneLabelText:(NSString *)text;

- (void)setReadCountLabelText:(NSString *)text;

- (void)setReadDateLabelText:(NSString *)text;

- (void)setReadCoinLabelText:(NSString *)text;

@end
