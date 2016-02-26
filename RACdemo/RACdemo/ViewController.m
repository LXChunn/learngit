//
//  ViewController.m
//  RACdemo
//
//  Created by Mac OS on 16/2/25.
//  Copyright © 2016年 JASON. All rights reserved.
//

#import "ViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>


@interface ViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textUser;
@property (weak, nonatomic) IBOutlet UITextField *textPassword;
@property (strong, nonatomic) IBOutlet UIButton *loadBtn;

@end

@implementation ViewController
- (IBAction)changeBtn:(id)sender {
    
    
}
- (void)cancelKeyboard {
    [self.textUser resignFirstResponder];
    [self.textPassword resignFirstResponder];
}
-(void)viewDidAppear:(BOOL)animated
{
    self.loadBtn.enabled = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.textUser.delegate = self;
    self.textPassword.delegate = self;
    
    UITapGestureRecognizer* tapCancelKeyboard = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelKeyboard)];
    [self.view addGestureRecognizer:tapCancelKeyboard];
    
    NSLog(@"x=%f,y=%f,width=%f,height=%f",self.loadBtn.frame.origin.x,self.loadBtn.frame.origin.y,self.loadBtn.frame.size.width,self.loadBtn.frame.size.height);
    
    //RAC
    
//    __weak ViewController* bself = self;//防止弱引用
    @weakify(self);
    [[self.textUser.rac_textSignal map:^id(NSString* value) {
        NSLog(@"%@",value);
        
        return value.length?[UIColor redColor]:[UIColor whiteColor];
    }] subscribeNext:^(id x) {
        @strongify(self)
        
        UIColor* color = x;
        self.textUser.backgroundColor = color;
    }];
    
    [[self.textPassword.rac_textSignal map:^id(NSString* value) {
        NSLog(@"%@",value);
        
        return value.length?[UIColor redColor]:[UIColor whiteColor];
    }] subscribeNext:^(id x) {
        @strongify(self)
        
        UIColor* color = x;
        self.textPassword.backgroundColor = color;
    }];
    
    //登陆按钮
    RACSignal* validUsernameSignal = [self.textUser.rac_textSignal map:^id(NSString* value) {
        return @(value.length);
    }];
    RACSignal* validPasswordSignal = [self.textPassword.rac_textSignal map:^id(NSString* value) {
        return @(value.length);
    }];
    [[RACSignal combineLatest:@[validUsernameSignal,validPasswordSignal] reduce:^id(NSNumber* usernameValid,NSNumber* passwordValid){
        return @([usernameValid boolValue]&&[passwordValid boolValue]);
    }] subscribeNext:^(NSNumber* x) {
        NSLog(@"%@",x);
        self.loadBtn.enabled = [x boolValue];
    }];
    
    //响应式登陆
    [[self.loadBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        self.textUser.text = @"";
        self.textPassword.text = @"";
        
        self.textUser.backgroundColor = [UIColor whiteColor];
        self.textPassword.backgroundColor = [UIColor whiteColor];
        
        
        [self.textUser resignFirstResponder];
        [self.textPassword resignFirstResponder];
        NSLog(@"deng lu zhong");
    }];
    
    //通知传值
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"postData" object:nil]subscribeNext:^(NSNotification* notification) {
        NSLog(@"name=%@",notification.name);
        NSLog(@"arr=%@",notification.object);
        self.textUser.text = notification.object[0];
//        self.textPassword.text = notification.object[1];
    }];
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"postDataRed" object:nil]subscribeNext:^(NSNotification* notification) {
        NSLog(@"name=%@",notification.name);
        NSLog(@"arr=%@",notification.object);
        
        self.textPassword.text = notification.object[0];
    }];
}
-(void)viewWillAppear:(BOOL)animated
{
    
    
    self.navigationController.navigationBar.hidden = YES;
    
    //keyboard 通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillHidden:(NSNotification*)notification
{
    NSLog(@"keyboard will hidden");
    NSDictionary* userInfo = [notification userInfo];
    
    //弹出时间
    NSValue* animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    //
    [UIView animateWithDuration:animationDuration animations:^{
        CGRect loadBtnRect = self.view.frame;
        loadBtnRect.origin.y = 0;
        self.view.frame = loadBtnRect;
        
    }];
    
}

- (void)keyboardWillShow:(NSNotification*)notification
{
    NSLog(@"keyboard will show");
    NSDictionary* userInfo = [notification userInfo];
    
    //弹出时间
    NSValue* animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    //键盘高度
    NSValue* value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    CGFloat keyboardHeight = keyboardSize.height;
    //
    [UIView animateWithDuration:animationDuration animations:^{
        CGRect loadBtnRect = self.view.frame;
        loadBtnRect.origin.y = -keyboardHeight/10;
        self.view.frame = loadBtnRect;
        
        //???有问题，键盘出现
//        CGRect loadBtnRect = self.loadBtn.frame;
//        loadBtnRect.origin.y = -keyboardHeight/10;
//        self.loadBtn.frame = loadBtnRect;
        
        NSLog(@"x=%f,y=%f,width=%f,height=%f",self.loadBtn.frame.origin.x,self.loadBtn.frame.origin.y,self.loadBtn.frame.size.width,self.loadBtn.frame.size.height);
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
