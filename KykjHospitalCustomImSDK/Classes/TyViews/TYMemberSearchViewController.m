//
//  TYMemberSearchViewController.m
//  HospitalOnline
//
//  Created by 梁玉娟 on 2022/3/10.
//  Copyright © 2022 cc. All rights reserved.
//

#import "TYMemberSearchViewController.h"
#import "TYMemberSearchDetailViewController.h"
#import "TYMemberModel.h"
#import "Factory.h"
#import "MJExtension.h"

@interface TYMemberSearchViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *textfield;

@property (nonatomic, strong) UIButton *searchButton;

@property (nonatomic, strong) TYMemberModel *model;

@property (nonatomic, assign) CGFloat keyboardHeight;

@end

@implementation TYMemberSearchViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar lt_reset];
    [self.navigationController.navigationBar lt_setBackgroundColor:colorBackground];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];

    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar lt_reset];
//    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"健康问诊";
    

    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor = colorBackground;
    
    [self setupNav];
    
//    self.view.backgroundColor = RGB(249, 249, 249);
    [self setSubViews];
    // Do any additional setup after loading the view.
}
- (void)setupNav{
   

    UIButton * left = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 44)];
    [left setImage:[KykjImToolkit getImageResourceForName:@"arrow_left"] forState:UIControlStateNormal];
    [left addTarget:self action:@selector(leftBarButtonItemPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:left];
    

    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth-160, 44)];
    titleLabel.text = @"健康问诊";
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    self.navigationItem.titleView = titleLabel;
}
- (void)leftBarButtonItemPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)setSubViews
{
    UIEdgeInsets insets;
    if (@available(iOS 11.0, *))
    {
        insets = [UIApplication sharedApplication].delegate.window.safeAreaInsets;
    }
    else
    {
        insets = UIEdgeInsetsZero;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    _searchButton = [UIButton makeButton:^(ButtonMaker * _Nonnull make) {
        make.titleForState(@"搜索",UIControlStateNormal).titleFont([UIFont systemFontOfSize:18]).titleColorForState([UIColor whiteColor],UIControlStateNormal).backgroundColor(RGB(1, 111, 255)).addAction(self,@selector(searchAction),UIControlEventTouchUpInside).addToSuperView(self.view);
    }];
    _searchButton.layer.cornerRadius = 10.f;
    [_searchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).mas_offset(15);
        make.bottom.equalTo(self.view).mas_offset(-15-insets.bottom);
        make.right.equalTo(self.view).mas_offset(-15);
        make.height.mas_equalTo(49);
    }];
    
    UIView *bgView = [[UIView alloc] init];
    bgView.layer.cornerRadius = 10.f;
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.view).mas_offset(15);
        make.right.equalTo(self.view).mas_offset(-15);
        make.bottom.equalTo(self.searchButton.mas_top).mas_offset(-15);
    }];
    
    UILabel *titleLabel = [UILabel makeLabel:^(LabelMaker * _Nonnull make) {
        make.text(@"会员手机号").textColor(RGB(51, 51, 51)).font([UIFont boldSystemFontOfSize:23]).addToSuperView(self.view);
    }];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).mas_offset(118);
        make.centerX.equalTo(self.view);
    }];
    
    _textfield = [[UITextField alloc] init];
    _textfield.placeholder = @"请输入会员手机号";
    _textfield.textColor = RGB(51, 51, 51);
    _textfield.keyboardType = UIKeyboardTypePhonePad;
    _textfield.returnKeyType = UIReturnKeySearch;
    _textfield.backgroundColor = RGB(243, 244, 245);
    _textfield.font = [UIFont systemFontOfSize:20];
    _textfield.textAlignment = NSTextAlignmentCenter;
    _textfield.delegate = self;
    _textfield.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;

    [self.view addSubview:_textfield];
    [_textfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(titleLabel.mas_bottom).mas_offset(25);
        make.left.equalTo(self.view).mas_offset(32.5f);
        make.right.equalTo(self.view).mas_offset(-32.5f);
        make.height.mas_equalTo(45);
    }];
    
    _textfield.layer.cornerRadius = 5.f;
    
    [_textfield addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
}
- (void)searchAction
{
    if(![KykjImToolkit checkTelephone:_textfield.text]){
//        [SVProgressHUD showInfoWithStatus:@"请输入正确的手机号"];
//        [SVProgressHUD dismissWithDelay:1.5f];
        [LeafNotification showHint:@"请输入正确的手机号" yOffset:-ScreenHeight/2];
        return;
    }
    _searchButton.enabled = NO;
    [self requestMemberWithSearchString:_textfield.text];
    
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@""]) return YES;
    return [self isPureFloat:string];
    
    
    return NO;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(![KykjImToolkit checkTelephone:_textfield.text]){
        [LeafNotification showHint:@"请输入正确的手机号" yOffset:-ScreenHeight/2];
        return NO;
    }
    [textField resignFirstResponder];
    return YES;
}
- (void)textFieldDidChange:(UITextField *)textfield
{
    UITextRange *markedTextRange = textfield.markedTextRange;
    //如果存在待选文字记录，则暂不处理 markedTextRange == nil说明不存在待选文字
    if (markedTextRange == nil) {
        if (textfield.text.length > 11) {
            textfield.text=[textfield.text substringToIndex:11];
        }
    }
    
}
//判断是否为正浮点形：
- (BOOL)isPureFloat:(NSString*)string{
    BOOL isNumber = YES;
    NSCharacterSet * cset = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i = 0;
    while (i < string.length) {
        NSString *tempString = [string substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [tempString rangeOfCharacterFromSet:cset];
        if (range.length == 0) {
            isNumber = NO;
            break;
        }
        i++;
    }
    return isNumber;
    
}

- (void)requestMemberWithSearchString:(NSString*)searhString
{
    MBProgressHUDShowInThisView;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@"dzService" forKey:@"service"];
    [param setObject:@"searchUserInfo" forKey:@"method"];
    [param setObject:searhString forKey:@"homeTel"];
    
    @weakify(self)
    [HttpOperationManager HTTP_POSTWithParameters:param showAlert:NO success:^(id responseObject) {
      @strongify(self)
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.searchButton.enabled = YES;
        if (responseObject!=nil) {

//            system.TOKEN = getSafeString(responseObject[@"token"]);
            if ([responseObject[@"result"] isEqualToString:@"success"]) {
                TYMemberModel *temp = [[TYMemberModel alloc] init];
                if (responseObject[@"rows"] != nil) {
                    temp = [temp mj_setKeyValues:responseObject[@"rows"]];
                    
                    TYMemberSearchDetailViewController *vc = [[TYMemberSearchDetailViewController alloc] init];
                    vc.model = temp;
    //                vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                }
                else{
                    [LeafNotification showHint:@"未查询到会员信息！" yOffset:-ScreenHeight/2];
                }
            }else{
                NSString *msgString = getSafeString(responseObject[@"info"]);
                if (msgString.length > 0) {
                    [LeafNotification showHint:msgString yOffset:-ScreenHeight/2];
    //                [LeafNotification showInController:weakself withText:msgString];
                }else
                    [LeafNotification showHint:@"系统错误，请稍后再试！" yOffset:-ScreenHeight/2];
    //                [LeafNotification showInController:weakself withText:@"系统错误，请稍后再试！"];
            }
     
            
        }
    } failure:^(NSError *error) {
        NSLog(@"error:%@",error.userInfo);
        @strongify(self)
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.searchButton.enabled = YES;
        [LeafNotification showHint:@"网络连接失败" yOffset:-ScreenHeight/2];
    }];
}

#pragma mark- UIKeyboardWillChangeFrameNotification
- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
    UIEdgeInsets insets;
    if (@available(iOS 11.0, *))
    {
        insets = [UIApplication sharedApplication].delegate.window.safeAreaInsets;
    }
    else
    {
        insets = UIEdgeInsetsZero;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
        CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
        _keyboardHeight = keyboardFrame.size.height;
        
        BOOL isKeyBoardHidden = ScreenHeight == keyboardFrame.origin.y;
        
        if (isKeyBoardHidden) {
            [_searchButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.view).mas_offset(15);
                make.bottom.equalTo(self.view).mas_offset(-15-insets.bottom);
                make.right.equalTo(self.view).mas_offset(-15);
                make.height.mas_equalTo(49);
            }];
        }else{
            [_searchButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.view).mas_offset(15);
                make.bottom.equalTo(self.view).mas_offset(-15-insets.bottom-self.keyboardHeight);
                make.right.equalTo(self.view).mas_offset(-15);
                make.height.mas_equalTo(49);
            }];
            
        }
    

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
