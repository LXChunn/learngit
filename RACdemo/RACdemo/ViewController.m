//
//  ViewController.m
//  RACdemo
//
//  Created by Mac OS on 16/2/25.
//  Copyright © 2016年 JASON. All rights reserved.
//

#import "ViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "AFNetworking.h"
#import "UIKit+AFNetworking.h"

@interface ViewController ()<UITextFieldDelegate>
{
    int count;
}
@property (nonatomic,strong)RACCommand* command;
@property (weak, nonatomic) IBOutlet UIImageView *imageVw;

@property (weak, nonatomic) IBOutlet UITextField *textUser;
@property (weak, nonatomic) IBOutlet UITextField *textPassword;
@property (strong, nonatomic) IBOutlet UIButton *loadBtn;

@property (nonatomic,copy)NSString* liu;
@property (nonatomic,copy)NSString* xiao;
@property (nonatomic,copy)NSString* chun;
@property (nonatomic,copy)NSString* LXC;

@property (nonatomic,strong)RACDisposable* loadingDispose;
@property (nonatomic,strong)RACSignal* signal;
@property (weak, nonatomic) IBOutlet UILabel *showObsever;

@property (nonatomic,strong)NSURLSession* session;

@end

@implementation ViewController

//-(id)init//在storyboard上加载过了，不走init
//{
//    if (self = [super init]) {
//        RACSignal* startSkip = [self.command.executionSignals map:^id(id value)
//        {
//            NSLog(@"开始跳转");
//            return NSLocalizedString(@"开始跳转", nil);
//        }];
//        
//        RACSignal* completedSkip = [self.command.executionSignals flattenMap:^RACStream *(RACSignal* value) {
//            return [[[value materialize]filter:^BOOL(RACEvent* event) {
//                return event.eventType == RACEventTypeCompleted;
//            }]map:^id(id value) {
//                NSLog(@"跳转完成");
//                return NSLocalizedString(@"跳转完成", nil);
//            }];
//            
//        }];
//        RACSignal* failedSkip = [[self.command.errors subscribeOn:[RACScheduler mainThreadScheduler]] map:^id(NSError* error) {
//            NSLog(@"error = %@",error);
//            return NSLocalizedString(@"error", nil);
//        }];
//        
//        RAC(self,xiao) = [RACSignal merge:@[startSkip,completedSkip,failedSkip]];
//    }
//    
//    return self;
//}
-(RACSignal *)signal
{
    if (!_signal) {
        self.chun = @"chun";
        
        _signal = [[RACSignal combineLatest:@[RACObserve(self, liu),RACObserve(self, xiao),RACObserve(self, chun)] reduce:^id(NSString* liu,NSString* xiao,NSString* chun){
            return @([liu isEqual:@"liu"] && [xiao isEqual:@"xiao"] && [chun isEqual:@"chun"]);
        }]map:^id(NSNumber* value) {
            return @([value boolValue]);
        }];
    }
    return _signal;
}

-(RACCommand *)command
{
    if (!_command) {
        _command = [[RACCommand alloc]initWithEnabled:self.signal signalBlock:^RACSignal *(id input) {
            NSLog(@"dianjile .........验证之后，可以登陆..........");
            self.liu = @"";
            self.textUser.backgroundColor = [UIColor whiteColor];
            
            self.xiao = @"";
            self.textPassword.text = @"";
            self.textPassword.backgroundColor = [UIColor whiteColor];
            
            return [self creatSignal];
        }];
    }
    return _command;
}

- (void)cancelKeyboard {
    [self.textUser resignFirstResponder];
    [self.textPassword resignFirstResponder];
}
-(void)viewWillAppear:(BOOL)animated
{
    NSLog(@"%@",[NSHomeDirectory() stringByAppendingString:@""]);
    
    
    
    self.navigationController.navigationBar.hidden = YES;
    
    //keyboard 通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)viewDidAppear:(BOOL)animated
{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self map];//按钮点击网络请求，错误处理。。。
    
//    RAC(self.textPassword,text) = self.textUser.rac_textSignal;//相当于赋值
    /**
     ************filters************
     **/
    [[self.textUser.rac_textSignal filter:^BOOL(id value) {
        return [value isEqual:@"1"];
    }]subscribeNext:^(id x) {
        NSLog(@"filter:%@",x);
    }];
    
    [[self.textUser.rac_textSignal ignore:@"1"]subscribeNext:^(id x) {
        NSLog(@"ignore:%@",x);
    }];
    
    [[self.textUser.rac_textSignal ignoreValues]subscribeNext:^(id x) {
        NSLog(@"ignoreALL:%@",x);
    }];
    
    //这一次值与上次值进行比较
    RAC(self.textPassword,text) = [RACObserve(self, chun) distinctUntilChanged];
    self.chun = @"l";
    self.chun = @"l";
    self.chun = @"w";
    
    [[[RACSignal createSignal:^RACDisposable *(id subscriber) {
        [subscriber sendNext:@"1"];
        [subscriber sendNext:@"2"];
        [subscriber sendNext:@"3"];
        [subscriber sendCompleted];
        return nil;
    }] take:1] subscribeNext:^(id x) {
        NSLog(@"only 1 and 2 will be print: %@", x);
    }];
    
    //显示处理结果
//    RAC(self.showObsever,text) = RACObserve(self, LXC);
    //或者
    [RACObserve(self, LXC) subscribeNext:^(NSString* x) {
        self.showObsever.text = x;
    }];
      
    self.textUser.delegate = self;
    self.textPassword.delegate = self;
    
    UITapGestureRecognizer* tapCancelKeyboard = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelKeyboard)];
    [self.view addGestureRecognizer:tapCancelKeyboard];
    
    NSLog(@"x=%f,y=%f,width=%f,height=%f",self.loadBtn.frame.origin.x,self.loadBtn.frame.origin.y,self.loadBtn.frame.size.width,self.loadBtn.frame.size.height);
    
    //RAC
//    __weak ViewController* bself = self;//防止弱引用
    
    //用户名输入的响应
//    @weakify(self);
//    [[self.textUser.rac_textSignal map:^id(NSString* value) {
//        NSLog(@"用户名＝%@",value);
//        self.liu = value;
//        return value.length?[UIColor redColor]:[UIColor whiteColor];
//    }] subscribeNext:^(id x) {
//        @strongify(self)
//        
//        UIColor* color = x;
//        self.textUser.backgroundColor = color;
//    }];
//    
//    //用户密码输入的响应
//    [[self.textPassword.rac_textSignal map:^id(NSString* value) {
//        NSLog(@"用户密码＝%@",value);
//        self.xiao = value;
//        return value.length?[UIColor redColor]:[UIColor whiteColor];
//    }] subscribeNext:^(id x) {
//        @strongify(self)
//        
//        UIColor* color = x;
//        self.textPassword.backgroundColor = color;
//    }];
    
    //登陆按钮
//    RACSignal* validUsernameSignal = [self.textUser.rac_textSignal map:^id(NSString* value) {
//        return @(value.length);
//    }];
//    RACSignal* validPasswordSignal = [self.textPassword.rac_textSignal map:^id(NSString* value) {
//        return @(value.length);
//    }];
//    [[RACSignal combineLatest:@[validUsernameSignal,validPasswordSignal] reduce:^id(NSNumber* usernameValid,NSNumber* passwordValid){
//        return @([usernameValid boolValue]&&[passwordValid boolValue]);
//    }] subscribeNext:^(NSNumber* x) {
//        NSLog(@"%@",x);
//        self.loadBtn.enabled = [x boolValue];
//    }];
    
    //登陆按钮或者简写
//    RAC(self.loadBtn,enabled) = [RACSignal combineLatest:@[self.textUser.rac_textSignal,self.textPassword.rac_textSignal] reduce:^id (NSString* userStr,NSString* passwordStr){
//        return @(userStr.length > 0 && passwordStr.length > 0);
//    }];
//
//    //响应式登陆
//    [[self.loadBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
//        
//        self.liu = self.textUser.text;
//        
//        self.textUser.text = @"";
//        self.textPassword.text = @"";
//        
//        self.textUser.backgroundColor = [UIColor whiteColor];
//        self.textPassword.backgroundColor = [UIColor whiteColor];
//        
//        [self.textUser resignFirstResponder];
//        [self.textPassword resignFirstResponder];
//        NSLog(@"deng lu zhong");
//    }];
    //登陆
    
    
    //通知传值
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"postData" object:nil]subscribeNext:^(NSNotification* notification) {
        NSLog(@"name=%@",notification.name);
        NSLog(@"arr=%@",notification.object);
        if ([notification.object[0] isEqual:@""]) {
            self.textUser.backgroundColor = [UIColor whiteColor];
            self.textUser.text = @"";
        }else{
            self.liu = notification.object[0];
            self.textUser.backgroundColor = [UIColor redColor];
            self.textUser.text = notification.object[0];
        }
        
    }];
    
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"postDataRed" object:nil]subscribeNext:^(NSNotification* notification) {
        NSLog(@"name=%@",notification.name);
        NSLog(@"arr=%@",notification.object);
        if ([notification.object[0] isEqual:@""]) {
            self.textPassword.backgroundColor = [UIColor whiteColor];
            self.textPassword.text = @"";
        }else{
            self.xiao = notification.object[0];
            self.textPassword.backgroundColor = [UIColor redColor];
            self.textPassword.text = notification.object[0];
        }
    }];
    
    self.loadBtn.rac_command = self.command;//保证执行过程中，不会执行其他操作
    
    [[[self fetchImageURL]map:^id(NSData* value) {
        self.imageVw.image = [UIImage imageWithData:value];
        NSLog(@"data = %@",value);
        return value;
    }]subscribeNext:^(NSData* x) {
        
    }];
    

}
#pragma mark - 延时5秒
- (void)delayFiveSecond
{
    [self.loadingDispose dispose];
    RACSignal* loggingSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"myTest"];
        [subscriber sendCompleted];
        return nil;
    }];
    
    loggingSignal = [loggingSignal delay:5];
    
    self.loadingDispose = [loggingSignal subscribeNext:^(NSString* x) {
        NSLog(@"%@",x);
    }];
    
    self.loadingDispose = [loggingSignal subscribeCompleted:^{
        NSLog(@"subscription");
    }];
}

#pragma mark - 创建信号
- (RACSignal*)creatSignal
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        count++;
        NSError* error;
        NSString* strCount = [NSString stringWithFormat:@"%d",count];
        if (!strCount) {
            [subscriber sendError:error];
        }else{
            [subscriber sendNext:strCount];
            [subscriber sendCompleted];
        }
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"clear ...");
        }];
    }];
}

#pragma mark - 错误处理过程
- (void)map
{
    RACSignal* startSkip = [self.command.executionSignals map:^id(id value)
                            {
                                NSLog(@"开始跳转");
                                return NSLocalizedString(@"开始跳转", nil);
                            }];
    
    RACSignal* completedSkip = [self.command.executionSignals flattenMap:^RACStream *(RACSignal* value) {
        return [[[value materialize]filter:^BOOL(RACEvent* event) {
            return event.eventType == RACEventTypeCompleted;
        }]map:^id(id value) {
            NSLog(@"跳转完成");
            return NSLocalizedString(@"跳转完成", nil);
        }];
    }];
    
    RACSignal* failedSkip = [[self.command.errors subscribeOn:[RACScheduler mainThreadScheduler]] map:^id(NSError* error) {
        NSLog(@"error = %@",error);
        return NSLocalizedString(@"error", nil);
    }];
    
    RAC(self,LXC) = [RACSignal merge:@[startSkip,completedSkip,failedSkip]];
}
#pragma mark - 网络请求
- (RACSignal*)fetchImageURL
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
        NSString* imageUrl = @"http://b.hiphotos.baidu.com/image/pic/item/0823dd54564e925838c205c89982d158ccbf4e26.jpg";
        
        NSURL* url = [NSURL URLWithString:imageUrl];
        NSURLRequest* request = [NSURLRequest requestWithURL:url];
        self.session = [NSURLSession sharedSession];
        NSURLSessionDataTask* dataTask = [self.session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            NSLog(@"%@",response);
            
            if (!error) {
                [subscriber sendNext:data];
                
            }else{
                [subscriber sendError:error];
            }
            
            [subscriber sendCompleted];
        }];
        
        [dataTask resume];
        
        return [RACDisposable disposableWithBlock:^{
            [dataTask cancel];
            NSLog(@"========================");
        }];
        
    }];
    
    
    
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
