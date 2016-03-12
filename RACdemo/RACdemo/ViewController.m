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
#import "XCViewModel.h"


@interface ViewController ()<UITextFieldDelegate>
{
    int count;
    
}
@property (nonatomic,strong)RACCommand* command;
@property (weak, nonatomic) IBOutlet UIImageView *imageVw;
@property (weak, nonatomic) IBOutlet UIImageView *otherImage;

@property (nonatomic,strong)XCViewModel* viewModel;

@property (weak, nonatomic) IBOutlet UITextField *textUser;
@property (weak, nonatomic) IBOutlet UITextField *textPassword;
@property (strong, nonatomic) IBOutlet UIButton *loadBtn;

@property (nonatomic,copy)NSString* liu;
@property (nonatomic,copy)NSString* xiao;
@property (nonatomic,copy)NSString* chun;
@property (nonatomic,copy)NSString* LXC;
@property (nonatomic,copy)NSString* str;
@property (nonatomic,copy)NSString* lxcStr;

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
            NSLog(@"..........验证之后，可以登陆..........");
            return [self creatSignal];
        }];
        
        //现在理解就是配套的
        [[[_command executionSignals] concat]subscribeNext:^(id x) {
            self.liu = @"";
            self.textUser.backgroundColor = [UIColor whiteColor];
            
            self.xiao = @"";
            self.textPassword.text = @"";
            self.textPassword.backgroundColor = [UIColor whiteColor];
            NSLog(@"?????????");
        }];
    }
    return _command;
}

- (void)cancelKeyboard {
    [self.textUser resignFirstResponder];
    [self.textPassword resignFirstResponder];
}
//研究concat
- (void)concat
{
    RACSignal *fristSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                 NSLog(@"oneSignal createSignal");
                 [subscriber sendNext:@""];
                 [subscriber sendCompleted];
        
                 return [RACDisposable disposableWithBlock:^{
                         NSLog(@"oneSignal dispose");
                     }];
             }];
    
         RACMulticastConnection *connection = [fristSignal multicast:[RACReplaySubject subject]];
    
         [connection connect];
    
//         [connection.signal subscribeNext:^(id x) {
//                 NSLog(@"2");
//             }];
    RACSignal *afterConcat = [connection.signal concat:[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@""];
        return nil;
    }]];
//

    
//    RACSignal *afterConcat = [connection.signal then:^RACSignal *{
//        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//                         [subscriber sendNext:@""];
//                         return nil;
//                     }];
//    }];
    
    [afterConcat subscribeNext:^(id x) {
        NSLog(@"afterConcat subscribeNext");
    }];
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    NSLog(@"%@",[NSHomeDirectory() stringByAppendingString:@""]);
    [self concat];
    
    
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
    self.viewModel = [[XCViewModel alloc]init];
    [[RACObserve(self.viewModel, list) ignore:nil] subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    
    [self.viewModel.listCommand execute:nil];
    
    [self map];//按钮点击网络请求，错误处理。。。
    NSArray* array = @[@(1),@(2),@(3),@(4)];
    NSLog(@"%@",[[[array rac_sequence]map:^id(id value){
        return [value stringValue];
    }]foldLeftWithStart:@"LXC"reduce:^id(id accumulator,id value){
        return [accumulator stringByAppendingString:value];
    }]);
    
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
//    RAC(self.textPassword,text) = [RACObserve(self, str) distinctUntilChanged];
//    self.str = @"chun";
//    self.str = @"ch";
//    self.str = @"chun";
    RAC(self.textPassword,text) = [RACObserve(self, lxcStr) distinctUntilChanged];
    self.lxcStr = @"w";
    self.lxcStr = @"w";
    self.lxcStr = @"w";
    
//    [[[RACSignal createSignal:^RACDisposable *(id subscriber) {
//        [subscriber sendNext:@"1"];
//        [subscriber sendNext:@"2"];
//        [subscriber sendNext:@"3"];
//        [subscriber sendCompleted];
//        return nil;
//    }] take:1] subscribeNext:^(id x) {
//        NSLog(@"only 1 and 2 will be print: %@", x);
//    }];

    
    [[[RACSignal createSignal:^RACDisposable *(id subscriber) {
        [subscriber sendNext:@"1"];
        [subscriber sendNext:@"2"];
        [subscriber sendNext:@"3"];
        [subscriber sendCompleted];
        return nil;
    }] take:2] subscribeNext:^(id x) {
        NSLog(@"only 1 and 2 will be print: %@", x);
    }];
    
    NSArray* arr = @[@(1),@(2),@(3),@(4),@(5),@(6)];
    NSArray* result = [[[[arr rac_sequence]filter:^BOOL(id value) {
        return [value integerValue]%2 == 0;
    }]map:^id(NSNumber* value) {
        long s = [value intValue] * [value intValue];
        return @(s);
    }] array] ;
    NSLog(@"%@",result);
    
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
    @weakify(self);
    [[self.textUser.rac_textSignal map:^id(NSString* value) {
        NSLog(@"用户名＝%@",value);
        self.liu = value;
        return value.length?[UIColor redColor]:[UIColor whiteColor];
    }] subscribeNext:^(id x) {
        @strongify(self)
        
        UIColor* color = x;
        self.textUser.backgroundColor = color;
    }];
    
    //用户密码输入的响应
    [[self.textPassword.rac_textSignal map:^id(NSString* value) {
        NSLog(@"用户密码＝%@",value);
        self.xiao = value;
        return value.length?[UIColor redColor]:[UIColor whiteColor];
    }] subscribeNext:^(id x) {
        @strongify(self)
        
        UIColor* color = x;
        self.textPassword.backgroundColor = color;
    }];
    
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
    //显示图片两种RAC方法
    [[[self fetchImageURL]map:^id(NSData* value) {
        dispatch_async(dispatch_get_main_queue(), ^{
//            NSLog(@"image = %@",value);
            self.imageVw.image = [UIImage imageWithData:value];
            
        });
        return value;
    }]subscribeNext:^(NSData* x) {
        
    }];
    
    [self showImage];//后台网络请求回到主线程刷新UI
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
    
    RAC(self.showObsever,text) = [RACSignal merge:@[startSkip,completedSkip,failedSkip]];
}
#pragma mark - RACShedule//显示网络图片
- (void)showImage
{
    RAC(self.otherImage,image) = [[RACSignal startEagerlyWithScheduler:[RACScheduler schedulerWithPriority:RACSchedulerPriorityBackground] block:^(id<RACSubscriber> subscriber) {//发起请求
        NSError* error;
        NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://pic14.nipic.com/20110522/7411759_164157418126_2.jpg"]
                                             options:NSDataReadingMappedAlways
                                               error:&error];
        if (error) {
            [subscriber sendError:error];
        }else{
            [subscriber sendNext:[UIImage imageWithData:data]];
            [subscriber sendCompleted];
        }
        
        
    }]deliverOn:[RACScheduler mainThreadScheduler]];
    
    
}

#pragma mark - 网络请求
- (RACSignal*)fetchImageURL
{
    RACSignal* request = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
        NSString* imageUrl = @"http://pica.nipic.com/2008-01-09/200819134250665_2.jpg";
        
        NSURL* url = [NSURL URLWithString:imageUrl];
        NSURLRequest* request = [NSURLRequest requestWithURL:url];
        self.session = [NSURLSession sharedSession];
        NSURLSessionDataTask* dataTask = [self.session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//            NSLog(@"%@",response);
            
            if (!error) {
                [subscriber sendNext:data];
                
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.showObsever.text = @"error";
                });
                [subscriber sendError:error];
            }
            
            [subscriber sendCompleted];
            
            
        }];
        
        [dataTask resume];
        
        return [RACDisposable disposableWithBlock:^{
            
            if (dataTask.state != NSURLSessionTaskStateCompleted) {
                [dataTask cancel];
//                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                NSLog(@"============?============");
            }
        }];
    }];
    
    //避免重复请求
    RACMulticastConnection* requestMutilConnetion = [request multicast:[RACReplaySubject subject]];
    [requestMutilConnetion connect];
    
    return [request flattenMap:^RACStream *(NSData* value) {
//        NSLog(@"data = %@",value);
        return [RACSignal return:value];
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
