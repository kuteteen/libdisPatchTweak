//
//  TweakTableViewCell.m
//  newTweak
//
//  Created by mutouren on 2017/7/26.
//  Copyright © 2017年 mutouren. All rights reserved.
//

#import "TweakTableViewCell.h"
#import "./lib/UIView+OMTExtension.h"
#import "Marco.h"


@interface TweakTableViewCell ()

@property (nonatomic, strong) UILabel *phoneLabel;

@property (nonatomic, strong) UILabel *readCountLabel;

@property (nonatomic, strong) UILabel *readDateLabel;

@property (nonatomic, strong) UILabel *readCoinLabel;

@property (nonatomic, strong) UIImageView *lineView;

@end

@implementation TweakTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setBackgroundColor:[UIColor brownColor]];
        [self.contentView addSubview:self.phoneLabel];
        [self.contentView addSubview:self.readCountLabel];
        [self.contentView addSubview:self.readDateLabel];
        [self.contentView addSubview:self.readCoinLabel];
        [self.contentView addSubview:self.lineView];
        
        [self setLayout];
    }
    return self;
}

- (void)setPhoneLabelText:(NSString *)text {
    NSString *phone = [NSString stringWithFormat:@"账号：%@",text];
    [self.phoneLabel setText:phone];
}

- (void)setReadCountLabelText:(NSString *)text {
    NSString *count = [NSString stringWithFormat:@"已读数：%@",text];
    [self.readCountLabel setText:count];
}

- (void)setReadDateLabelText:(NSString *)text {
    NSString *date = [NSString stringWithFormat:@"读完时间：%@",text];
    [self.readDateLabel setText:date];
}

- (void)setReadCoinLabelText:(NSString *)text {
    NSString *coin = [NSString stringWithFormat:@"金币：%@",text];
    [self.readCoinLabel setText:coin];
}

- (void)setBackgroundColorWithCoin:(NSInteger)coin {
    
    [super setBackgroundColor:(coin >= 100)?[UIColor brownColor]:[UIColor redColor]];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setLayout {
    self.phoneLabel.frame = CGRectMake(8.0f, 8.0f, 136, 20.0f);
    self.readCountLabel.frame = CGRectMake(self.phoneLabel.right+8.0f, self.phoneLabel.top, 80, self.phoneLabel.height);
    self.readDateLabel.frame = CGRectMake(self.phoneLabel.left, self.phoneLabel.bottom+ 8.0f, self.phoneLabel.width + 22.0f, self.phoneLabel.height);
    self.readCoinLabel.frame = CGRectMake(self.readCountLabel.left+18.0f, self.readCountLabel.bottom + 8.0f, self.readCountLabel.width, self.readCountLabel.height);
    
    self.lineView.frame = CGRectMake((SCREEN_SIZE_WIDTH-320)/2, CELLHEIGHT-2, 320, 2);
}

#pragma mark init 
- (UILabel *)phoneLabel {
    if (!_phoneLabel) {
        _phoneLabel = [UILabel new];
        [_phoneLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [_phoneLabel setBackgroundColor:[UIColor clearColor]];
        [_phoneLabel setTextColor:[UIColor whiteColor]];
    }
    
    return _phoneLabel;
}

- (UILabel *)readCountLabel {
    if (!_readCountLabel) {
        _readCountLabel = [UILabel new];
        [_readCountLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [_readCountLabel setBackgroundColor:[UIColor clearColor]];
        [_readCountLabel setTextColor:[UIColor whiteColor]];
    }
    
    return _readCountLabel;
}

- (UILabel *)readDateLabel {
    if (!_readDateLabel) {
        _readDateLabel = [UILabel new];
        [_readDateLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [_readDateLabel setBackgroundColor:[UIColor clearColor]];
        [_readDateLabel setTextColor:[UIColor whiteColor]];
    }
    
    return _readDateLabel;
}

- (UILabel *)readCoinLabel {
    if (!_readCoinLabel) {
        _readCoinLabel = [UILabel new];
        [_readCoinLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [_readCoinLabel setBackgroundColor:[UIColor clearColor]];
        [_readCoinLabel setTextColor:[UIColor whiteColor]];
    }
    
    return _readCoinLabel;
}

- (UIImageView*)lineView {
    if (!_lineView) {
        _lineView = [[UIImageView alloc] init];
        [_lineView setBackgroundColor:[UIColor whiteColor]];
    }
    
    return _lineView;
}

@end
