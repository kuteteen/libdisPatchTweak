//
//  TweakViewController.m
//  testTwetter
//
//  Created by mutouren on 2017/6/27.
//  Copyright © 2017年 mutouren. All rights reserved.
//

#import "TweakViewController.h"
#import "Marco.h"
#import "./lib/MBProgressHUD/MBProgressHUD+OMTExtension.h"
#import "./lib/UIView+OMTExtension.h"
#import "./lib/NSDate+Extension.h"
#import "UserModel.h"
#import "TweakDataManager.h"
#import "TweakTableViewCell.h"
#import "TweakManager.h"
#import "TweakEXECManager.h"
#import "OMTDebugManager.h"
#import <mach-o/dyld.h>


@interface TweakViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIView *tweakNavBar;
@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UIButton *moreBtn;
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIView *tableViewHeaderView;
@property (nonatomic, strong) UITextField *phoneField;
@property (nonatomic, strong) UITextField *passwordFiled;
@property (nonatomic, strong) UIButton *joinBtn;

@property (nonatomic, strong) UITextField *maxReadCountField;
@property (nonatomic, strong) UIButton *commitBtn;
@property (nonatomic, strong) UIButton *addViewButton;

@property (nonatomic, strong) UIButton *startBtn;

@property (nonatomic, strong) NSMutableArray *selectArray;

@end

@implementation TweakViewController

- (NSString *)name {
    return @"muouren";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.selectArray = [NSMutableArray array];
    
    [self.view addSubview:self.tweakNavBar];
    
    [self.tweakNavBar setBackgroundColor:[UIColor grayColor]];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self.tableViewHeaderView addSubview: self.phoneField];
    [self.tableViewHeaderView addSubview:self.passwordFiled];
    [self.tableViewHeaderView addSubview:self.joinBtn];
    
    [self.tableViewHeaderView addSubview:self.maxReadCountField];
    [self.tableViewHeaderView addSubview:self.commitBtn];
    
    [self.tableViewHeaderView addSubview:self.startBtn];
    
//    [self.tableViewHeaderView addSubview:self.addViewButton];
    
    [self.view addSubview:self.tableView];
    
    [self setLayout];
    
    self.tableView.tableHeaderView = self.tableViewHeaderView;
    
    [self.maxReadCountField setText:[NSString stringWithFormat:@"%ld",(long)[TweakDataManager sharedInstance].maxReadCount]];
    
//    for (int row = 0; row < [TweakDataManager sharedInstance].userArray.count; row++) {
//        [self.selectArray addObject:@(row)];
//    }
    
    [[TweakDataManager sharedInstance] resetUserModelReadState];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setLayout {
    self.tweakNavBar.frame = CGRectMake(0,0,SCREEN_SIZE_WIDTH,64.0f);
    
    CGFloat topPadding = 20.0f;
    self.backBtn.frame = CGRectMake(12, topPadding, 50, 44);
    
    self.titleLabel.frame = CGRectMake((CGRectGetWidth(_tweakNavBar.frame)-80)/2,20,80,44);
    
    self.moreBtn.frame = CGRectMake(CGRectGetWidth(_tweakNavBar.frame) - 50 - 12, topPadding, 50, 44);
    
    self.tableViewHeaderView.frame = CGRectMake(0, 0, SCREEN_SIZE_WIDTH, 120);
    
    self.phoneField.frame = CGRectMake(8.0f, 8.0f, 160, 26);
    self.passwordFiled.frame = CGRectMake(self.phoneField.left, self.phoneField.bottom+ 8.0f, self.phoneField.width, self.phoneField.height);
    
    self.joinBtn.frame = CGRectMake(self.phoneField.right+ 8.0f, self.phoneField.top, 60, self.passwordFiled.bottom - self.phoneField.top);
    
    self.maxReadCountField.frame = CGRectMake(self.phoneField.left, self.passwordFiled.bottom+8.0f, self.passwordFiled.width, self.passwordFiled.height);
    
    self.commitBtn.frame = CGRectMake(self.joinBtn.left, self.maxReadCountField.top, self.joinBtn.width, self.maxReadCountField.height);
    
    self.startBtn.frame = CGRectMake(self.joinBtn.right + 8.0f, self.joinBtn.top + 8.0f, 60, 40);
    
    self.addViewButton.frame = CGRectMake(self.startBtn.left, self.startBtn.bottom+8.0f, 60, 26);
    
    self.tableView.frame = CGRectMake(0, self.tweakNavBar.bottom + 8.0f, SCREEN_SIZE_WIDTH, self.view.height - self.tweakNavBar.bottom - 8.0f);
}

- (void)backBtnClick:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)moreBtnClick:(UIButton *)sender {
    [[OMTDebugManager sharedInstance] debug:[[TweakDataManager sharedInstance] tweakDirectory]];
}

- (void)joinBtnClicked:(UIButton *)sender {
    if (_phoneField.text.length != 11) {
        [MBProgressHUD showMessage:@"账号必须要 11 位！！！"];
        return;
    }
    
    if (_passwordFiled.text.length <= 0) {
        [MBProgressHUD showMessage:@"需要密码！！！"];
        return;
    }
    
    NSString *phone = self.phoneField.text;
    NSString *password = self.passwordFiled.text;
    
    self.phoneField.text = @"";
    self.passwordFiled.text = @"";
    
    UserModel *userModel = [UserModel new];
    userModel.phone = phone;
    userModel.password = password;
    
    UserModel *model = [self userArrayContainsObject:userModel];
    if (model) {
        [MBProgressHUD showMessage:@"已有账号，请先删除！！！"];
        return;
    }
    else {
        [[TweakDataManager sharedInstance].userArray addObject:userModel];
    }
    
    [self.view endEditing:YES];
    
    [[TweakDataManager sharedInstance] saveUserModel];
    
    [self.tableView reloadData];
}

- (BOOL)isPureInt:(NSString*)string {
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

- (void)commitBtnClicked:(UIButton *)sender {
    if (self.maxReadCountField.text.length && [self isPureInt:self.maxReadCountField.text]) {
        NSInteger max = [self.maxReadCountField.text integerValue];
        if (max > 0) {
            [[TweakDataManager sharedInstance] setMaxReadCount:max];
            [MBProgressHUD showMessage:@"设置成功！！！"];
            [self.view endEditing:YES];
        }
        else {
            [MBProgressHUD showMessage:@"值要大于0！！！"];
        }
    }
    else {
        [MBProgressHUD showMessage:@"只能是数字！！！"];
    }
    
}

- (void)addViewButtonClicked:(id)sender {
}

- (void)startBtnClicked:(UIButton *)sender {
    if ([TweakDataManager sharedInstance].tweakManager.isRun) {
        [[TweakDataManager sharedInstance].tweakManager end];
        [self.startBtn setTitle:@"开始" forState:UIControlStateNormal];
    }
    else {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [[TweakDataManager sharedInstance].tweakManager startConfigUserModelComleteBlock:^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [[TweakDataManager sharedInstance] updateSelectUserArrayWithRowArray:self.selectArray];
            
            if ([TweakDataManager sharedInstance].selectUserArray.count) {
                [TweakDataManager sharedInstance].userIndex = 0;
                
                [self dismissViewControllerAnimated:YES completion:^{
                    [[TweakDataManager sharedInstance].tweakManager gotoChannelsVC];
                    
                    [[TweakDataManager sharedInstance].tweakManager begin];
                    
                }];
                //            [self.startBtn setTitle:@"停止" forState:UIControlStateNormal];
            }
            else {
                [MBProgressHUD showMessage:@"没有选择操作的账号！！！，请选择！！！"];
            }
        }];
    }
}

- (UserModel *)userArrayContainsObject:(UserModel *) userModel {
    if (userModel.phone&&userModel.phone.length) {
        for (UserModel *user in [TweakDataManager sharedInstance].userArray) {
            if ([user.phone isEqualToString:userModel.phone]) {
                return user;
            }
        }
    }
    
    return nil;
}

- (NSString *)stringWithDateFormat:(NSString *)format date:(NSDate*)date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:format];
    NSString *reval =[formatter stringFromDate:date];
    
    return reval;
}

#pragma mark - Protocol conformance
#pragma mark - UITableViewDataSource

-(void)tableView:(UITableView *)tableView commitEditingStyle :( UITableViewCellEditingStyle)editingStyle forRowAtIndexPath :( NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    [[TweakDataManager sharedInstance].userArray removeObjectAtIndex:row];//bookInfo为当前table中显示的array
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
}
/*此时删除按钮为Delete，如果想显示为“删除” 中文的话，则需要实现
 UITableViewDelegate中的- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath方法*/
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath :( NSIndexPath *)indexPath{
    return @"删除";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [TweakDataManager sharedInstance].userArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *reuseId = @"UITableViewCell";
    TweakTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (!cell) {
        cell = [[TweakTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
    }
    
    if (self.selectArray.count) {
        if ([self.selectArray containsObject:@(indexPath.row)]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    UserModel *userModel = [[TweakDataManager sharedInstance].userArray objectAtIndex:indexPath.row];
    
    [cell setPhoneLabelText:userModel.phone];
    [cell setReadCountLabelText:[NSString stringWithFormat:@"%ld",(long)userModel.readCount]];
    //[self stringWithDateFormat:@"HH:mm" date:userModel.startReadDate]
    [cell setReadDateLabelText:[userModel.startReadDate stringWithDateFormat:@"MM/dd HH:mm"]];
    [cell setReadCoinLabelText:userModel.curCoin];
    
    [self.view endEditing:YES];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return CELLHEIGHT;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
     UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (self.selectArray.count) {
        if ([self.selectArray containsObject:@(indexPath.row)]) {
            [self.selectArray removeObject:@(indexPath.row)];
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        else {
            [self.selectArray addObject:@(indexPath.row)];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
    else {
        [self.selectArray addObject:@(indexPath.row)];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
}

#pragma mark init

- (UIView *)tweakNavBar {
    if (!_tweakNavBar) {
        _tweakNavBar = [[UIView alloc] initWithFrame:CGRectZero];
        
        [_tweakNavBar addSubview:self.backBtn];
        
        [_tweakNavBar addSubview:self.titleLabel];
        
        
        [_tweakNavBar addSubview:self.moreBtn];
        
    }
    
    return _tweakNavBar;
}

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton new];
        [_backBtn setTitle:@"<<<" forState:UIControlStateNormal];
        [_backBtn setBackgroundColor:[UIColor clearColor]];
        [_backBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _backBtn;
}

- (UIButton *)moreBtn {
    if (!_moreBtn) {
        _moreBtn = [UIButton new];
        [_moreBtn setTitle:@"~~~" forState:UIControlStateNormal];
        [_moreBtn setBackgroundColor:[UIColor clearColor]];
        [_moreBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_moreBtn addTarget:self action:@selector(moreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _moreBtn;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        [_titleLabel setTextAlignment:NSTextAlignmentCenter];
        [_titleLabel setBackgroundColor:[UIColor clearColor]];
        [_titleLabel setTextColor:[UIColor blackColor]];
        [_titleLabel setText:@"Tweak"];
    }
    
    return _titleLabel;
}

- (UIView *)tableViewHeaderView {
    if (!_tableViewHeaderView) {
        _tableViewHeaderView = [UIView new];
        [_tableViewHeaderView setBackgroundColor:[UIColor clearColor]];
    }
    
    return _tableViewHeaderView;
}

- (UITextField *)phoneField {
    if (!_phoneField) {
        _phoneField = [UITextField new];
        
        [_phoneField setTextColor:[UIColor blackColor]];
        [_phoneField setFont:[UIFont systemFontOfSize:14.0f]];
        
        [_phoneField setPlaceholder:@"账号"];
        [_phoneField setBackgroundColor:[UIColor grayColor]];
        
        UILabel * view = [[UILabel alloc] initWithFrame:CGRectMake(10,0,7,26)];
        view.backgroundColor = [UIColor clearColor];
        _phoneField.leftView = view;
        _phoneField.leftViewMode = UITextFieldViewModeAlways;
    }
    
    return _phoneField;
}

- (UITextField *)passwordFiled {
    if (!_passwordFiled) {
        _passwordFiled = [UITextField new];
        
        [_passwordFiled setTextColor:[UIColor blackColor]];
        [_passwordFiled setFont:[UIFont systemFontOfSize:14.0f]];
        
        [_passwordFiled setPlaceholder:@"密码"];
        [_passwordFiled setBackgroundColor:[UIColor grayColor]];
        
        UILabel * view = [[UILabel alloc] initWithFrame:CGRectMake(10,0,7,26)];
        view.backgroundColor = [UIColor clearColor];
        _passwordFiled.leftView = view;
        _passwordFiled.leftViewMode = UITextFieldViewModeAlways;
    }
    
    return _passwordFiled;
}

- (UIButton *)joinBtn {
    if (!_joinBtn) {
        _joinBtn = [UIButton new];
        [_joinBtn setBackgroundColor:UIColorFromHex(0xFF8A2A)];
        
        [_joinBtn setTitle:@"加入" forState:UIControlStateNormal];
        [_joinBtn addTarget:self action:@selector(joinBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _joinBtn;
}

- (UITextField *)maxReadCountField {
    if (!_maxReadCountField) {
        _maxReadCountField = [UITextField new];
        
        [_maxReadCountField setTextColor:[UIColor blackColor]];
        [_maxReadCountField setFont:[UIFont systemFontOfSize:14.0f]];
        
        [_maxReadCountField setPlaceholder:@"最大读文章个数"];
        [_maxReadCountField setBackgroundColor:[UIColor grayColor]];
        
        UILabel * view = [[UILabel alloc] initWithFrame:CGRectMake(10,0,7,26)];
        view.backgroundColor = [UIColor clearColor];
        _maxReadCountField.leftView = view;
        _maxReadCountField.leftViewMode = UITextFieldViewModeAlways;
    }
    
    return _maxReadCountField;
}

- (UIButton *)commitBtn {
    if (!_commitBtn) {
        _commitBtn = [UIButton new];
        [_commitBtn setBackgroundColor:UIColorFromHex(0xFF8A2A)];
        
        [_commitBtn setTitle:@"设置" forState:UIControlStateNormal];
        [_commitBtn addTarget:self action:@selector(commitBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _commitBtn;
}

- (UIButton *)addViewButton {
    if (!_addViewButton) {
        _addViewButton = [UIButton new];
        [_addViewButton setBackgroundColor:UIColorFromHex(0xFF8A2A)];

        [_addViewButton setTitle:@"+" forState:UIControlStateNormal];
        [_addViewButton addTarget:self action:@selector(addViewButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _addViewButton;
}

- (UIButton *)startBtn {
    if (!_startBtn) {
        _startBtn = [UIButton new];
        [_startBtn setBackgroundColor:UIColorFromHex(0xFF8A2A)];
        
        if (![TweakDataManager sharedInstance].tweakManager.isRun) {
            [self.startBtn setTitle:@"开始" forState:UIControlStateNormal];
        }
        else {
            [self.startBtn setTitle:@"停止" forState:UIControlStateNormal];
        }
        
        [_startBtn addTarget:self action:@selector(startBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _startBtn;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource  = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    
    return _tableView;
}

bool printDYLD() {
    
    //Get count of all currently loaded DYLD
    uint32_t count = _dyld_image_count();
    //安装NZT插件后会把原有的越狱文件名称统一修改成在/usr/lib/目录下的libSystem.B.dylib
    //    NSString *jtpath=@"/usr/lib/libSystem.B.dylib";
    
    uint32_t countyueyu=0;
    

    for(uint32_t i = 0; i < count; i++)
    {
        //Name of image (includes full path)
        const char *dyld = _dyld_get_image_name(i);
        
        //Get name of file
        long slength = strlen(dyld);
        
        long j;
        for(j = slength - 1; j>= 0; --j)
            if(dyld[j] == '/') break;
        
        NSString *name = [[NSString alloc]initWithUTF8String:_dyld_get_image_name(i)];
        
//        if ([name isEqualToString:@"/Library/MobileSubstrate/MobileSubstrate.dylib"]) {
//            UIAlertController * vc = [UIAlertController alertControllerWithTitle:@"mutouren" message:@"mutouren" preferredStyle:UIAlertControllerStyleAlert];
//            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:vc animated:YES completion:nil];
//        }
        
        [[OMTDebugManager sharedInstance] debug:name];
        //        if([name containsString:@"/Library/MobileSubstrate"])
        //        {
        //            return YES;
        //        }
        //
        //        if([name compare:jtpath] == NSOrderedSame)
        //        {
        //            countyueyu++;
        //        }
        
    }
    if( countyueyu > 2 )
        return YES;
    return NO;
    printf("\n");
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
