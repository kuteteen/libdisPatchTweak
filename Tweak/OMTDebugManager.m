//
//  OMTDebugManager.m
//  OneMTDemo
//
//  Created by mutouren on 2017/7/31.
//  Copyright © 2017年 onemt. All rights reserved.
//

#import "OMTDebugManager.h"
#import "Marco.h"


#define textLabelFrame CGRectMake(0, 0, 280, 20)

#define textLabelFontSize 12.0f

@interface OMTDebugManager () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UIButton *debugButton;
@property (nonatomic, strong) UITableView *debugTableView;

@property (nonatomic, strong) NSMutableArray *debugDataArray;

@property (nonatomic, strong) UITableViewCell *heightCell;

@end

static OMTDebugManager *instance = nil;

@implementation OMTDebugManager

+ (instancetype)sharedInstance
{
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        instance = [[OMTDebugManager alloc] init];
    });
    return instance;
}



- (id)init {
    self = [super init];
    if (self) {
        self.debugDataArray = [NSMutableArray array];
        [[UIApplication sharedApplication].keyWindow addSubview:self.debugButton];
        [[UIApplication sharedApplication].keyWindow addSubview:self.debugTableView];
        self.heightCell = [UITableViewCell new];
        self.heightCell.frame = CGRectMake(0, 0, 320, 20);
        self.heightCell.textLabel.frame = textLabelFrame;
        [self.heightCell.textLabel setNumberOfLines:0];
        [self.heightCell.textLabel setFont:[UIFont systemFontOfSize:textLabelFontSize]];
        [self setLayout];
    }
    
    return self;
}

- (void)setLayout {
    self.debugButton.frame = CGRectMake((SCREEN_SIZE_WIDTH- 40)/2, 20, 40, 20);
    self.debugTableView.frame = CGRectMake((SCREEN_SIZE_WIDTH- 320)/2, CGRectGetMaxY(self.debugButton.frame), 320, 400);
}

- (NSString *)tDate

{
    
    NSDate *date = [NSDate date];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *res = [formatter stringFromDate:date];
    
    return res;
}

- (void)debugWithError:(NSError *)error {
    if (error) {
        [self debug:[NSString stringWithFormat:@"%@",error]];
    }
    else {
        [self debug:@"error is nil"];
    }
}

- (void)debug:(NSString *)text {
    
    NSString *content = [NSString stringWithFormat:@"%@ %@",[self tDate],text];
    
    [self.debugDataArray addObject:content];
    
    [self.debugTableView reloadData];
}

- (void)debugButtonClick:(id)sender {
    [self.debugTableView setHidden:![self.debugTableView isHidden]];
    
    [self.debugButton setTitle:[self.debugTableView isHidden]?@"show":@"hide" forState:UIControlStateNormal];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.debugDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *reuseId = @"OMTDebugCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
        [cell setBackgroundColor:[UIColor clearColor]];
        cell.textLabel.textColor = [UIColor whiteColor];
        [cell.textLabel setNumberOfLines:0];
        cell.textLabel.frame = textLabelFrame;
        [cell.textLabel setFont:[UIFont systemFontOfSize:textLabelFontSize]];
    }
    
    NSString *content = [self.debugDataArray objectAtIndex:indexPath.row];
    
    [cell.textLabel setText:content];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *content = [self.debugDataArray objectAtIndex:indexPath.row];
    
    [self.heightCell.textLabel setText:content];
    CGSize size = [self.heightCell.textLabel sizeThatFits:CGSizeMake(CGRectGetWidth(self.heightCell.textLabel.frame), MAXFLOAT)];
    
    return size.height;
}

#pragma mark init
- (UITableView *)debugTableView {
    if (!_debugTableView) {
        _debugTableView = [[UITableView alloc] initWithFrame:CGRectZero];
        _debugTableView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
        _debugTableView.delegate = self;
        _debugTableView.dataSource  = self;
        _debugTableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    }
    
    
    return _debugTableView;
}

- (UIButton *)debugButton {
    if (!_debugButton) {
        _debugButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_debugButton setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.8]];
        [_debugButton.titleLabel setFont:[UIFont systemFontOfSize:13.0f]];
        [_debugButton setTitle:@"show" forState:UIControlStateNormal];
        [_debugButton addTarget:self action:@selector(debugButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    return _debugButton;
}

@end
