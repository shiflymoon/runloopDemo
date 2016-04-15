//
//  ViewController.m
//  runloopDemo
//
//  Created by mac on 16/4/7.
//  Copyright © 2016年 com. All rights reserved.
//
#import "ViewController.h"
#import <MapKit/MapKit.h>
#import "ZXRunLoopSource.h"
@interface ViewController ()<MKMapViewDelegate>
{
    BOOL _end;
}

@property (weak, nonatomic) IBOutlet UIScrollView *testScrollview;
@property (nonatomic, readwrite, retain) ZXRunLoopSource *source;
@property (nonatomic, weak) NSThread *aThread;
@end

@implementation ViewController

static int a;
- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.testScrollview.hidden = YES;

    [self test7];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"");
}


static NSString *CustomRunLoopMode = @"CustomRunLoopMode";
/**
 *
 *  自定义RunLoopModel
 *
 */
-(void)test8{
    [NSThread detachNewThreadSelector:@selector(test88) toTarget:self withObject:nil];
}
-(void)test88{
    NSTimer *timer = [NSTimer timerWithTimeInterval:1
                                             target:self
                                           selector:@selector(printMessage:)
                                           userInfo:nil
                                            repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    CFRunLoopAddCommonMode(CFRunLoopGetCurrent(), (__bridge CFStringRef)(CustomRunLoopMode));
    
    do {
        [[NSRunLoop currentRunLoop] runMode:CustomRunLoopMode
                                 beforeDate:[NSDate dateWithTimeIntervalSinceNow:1.0]];
    } while (_end);
    NSLog(@"finishing thread.........");
}

/**
 *
 *  自定义源
 *
 */
-(void)test7{
    NSThread* aThread = [[NSThread alloc] initWithTarget:self selector:@selector(test77) object:nil];
    self.aThread = aThread;
    [aThread start];
}

-(void)test77{
    NSLog(@"starting thread.......");
    
    NSRunLoop *myRunLoop = [NSRunLoop currentRunLoop];
    
   // 设置Run Loop observer的运行环境
    CFRunLoopObserverContext context = {0, (__bridge void *)(self), NULL, NULL, NULL};
    
    // 创建Run loop observer对象
    // 第一个参数用于分配该observer对象的内存
    // 第二个参数用以设置该observer所要关注的的事件，详见回调函数myRunLoopObserver中注释
    // 第三个参数用于标识该observer是在第一次进入run loop时执行还是每次进入run loop处理时均执行
    // 第四个参数用于设置该observer的优先级
    // 第五个参数用于设置该observer的回调函数
    // 第六个参数用于设置该observer的运行环境
    CFRunLoopObserverRef observer = CFRunLoopObserverCreate(kCFAllocatorDefault,kCFRunLoopAllActivities, YES, 0, &myRunLoopObserver, &context);
    if (observer){
        CFRunLoopRef cfLoop = [myRunLoop getCFRunLoop];
        CFRunLoopAddObserver(cfLoop, observer, kCFRunLoopDefaultMode);
    }
    
    _source = [[ZXRunLoopSource alloc] init];
    [_source addToCurrentRunLoop];
    while (!self.aThread.isCancelled)
    {
        NSLog(@"We can do other work");
        [myRunLoop runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:5.0f]];
    }
    [_source invalidate];
    NSLog(@"finishing thread.........");
}
/**
 *
 *  自定义timer
 *
 */
-(void)test5{
    // 获得当前thread的Run loop
    NSRunLoop* myRunLoop = [NSRunLoop currentRunLoop];
    // 设置Run Loop observer的运行环境
    CFRunLoopObserverContext context = {0, (__bridge void *)(self), NULL, NULL, NULL};
    
    // 创建Run loop observer对象
    // 第一个参数用于分配该observer对象的内存
    // 第二个参数用以设置该observer所要关注的的事件，详见回调函数myRunLoopObserver中注释
    // 第三个参数用于标识该observer是在第一次进入run loop时执行还是每次进入run loop处理时均执行
    // 第四个参数用于设置该observer的优先级
    // 第五个参数用于设置该observer的回调函数
    // 第六个参数用于设置该observer的运行环境
    CFRunLoopObserverRef observer = CFRunLoopObserverCreate(kCFAllocatorDefault,kCFRunLoopAllActivities, YES, 0, &myRunLoopObserver, &context);
    if (observer){
        CFRunLoopRef cfLoop = [myRunLoop getCFRunLoop];
        CFRunLoopAddObserver(cfLoop, observer, kCFRunLoopDefaultMode);
    }
    CFRunLoopRef runLoop = CFRunLoopGetCurrent();
    CFRunLoopTimerContext timerContext = {0, NULL, NULL, NULL, NULL};
    CFRunLoopTimerRef timer = CFRunLoopTimerCreate(kCFAllocatorDefault, 0.1, 0.3, 0, 0,
                                                   &myCFTimerCallback, &timerContext);
    
    CFRunLoopAddTimer(runLoop, timer, kCFRunLoopCommonModes);
    NSInteger loopCount = 2;
    do{
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1]];
        loopCount--;
    }while (loopCount);

}
void myCFTimerCallback(){
    NSLog(@"-----++++-------");
}

/**
 *
 *  使用系统的timer(添加observe)
 *
 */
- (void)test6{
    // 获得当前thread的Run loop
    NSRunLoop* myRunLoop = [NSRunLoop currentRunLoop];
    // 设置Run Loop observer的运行环境
    CFRunLoopObserverContext context = {0, (__bridge void *)(self), NULL, NULL, NULL};
    // 创建Run loop observer对象
    // 第一个参数用于分配该observer对象的内存
    // 第二个参数用以设置该observer所要关注的的事件，详见回调函数myRunLoopObserver中注释
    // 第三个参数用于标识该observer是在第一次进入run loop时执行还是每次进入run loop处理时均执行
    // 第四个参数用于设置该observer的优先级
    // 第五个参数用于设置该observer的回调函数
    // 第六个参数用于设置该observer的运行环境
    CFRunLoopObserverRef observer = CFRunLoopObserverCreate(kCFAllocatorDefault,kCFRunLoopAllActivities, YES, 0, &myRunLoopObserver, &context);
    if (observer){
        CFRunLoopRef cfLoop = [myRunLoop getCFRunLoop];
        CFRunLoopAddObserver(cfLoop, observer, kCFRunLoopDefaultMode);
    }
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(printMessage:) userInfo:nil repeats:YES];
    NSInteger loopCount = 2;
    
    do{
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1]];
        loopCount--;
    }while (loopCount);
}


/**
 *
 *  配置基于port的源
 *
 */
-(void)test9{
    [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(printMessage:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop]addPort:[NSPort port] forMode:NSRunLoopCommonModes];
    while (_end)
    {
        SInt32 result = CFRunLoopRunInMode(kCFRunLoopDefaultMode, 2, YES);
    }
    NSLog(@"finishing thread.........");
}

/**
 *
 *  在辅助线程使用timer
 *
 */
-(void)test4{
    NSLog(@"The new thread will start...");
    [NSThread detachNewThreadSelector:@selector(newThreadAction) toTarget:self withObject:nil];
}
-(void)newThreadAction{
    NSRunLoop *runloop = [NSRunLoop currentRunLoop];
    
    CFRunLoopObserverContext context = {0, (__bridge void *)(self), NULL, NULL, NULL};
    CFRunLoopObserverRef observer = CFRunLoopObserverCreate(kCFAllocatorDefault,kCFRunLoopAllActivities, YES, 0, &myRunLoopObserver, &context);
    if (observer){
        CFRunLoopRef cfLoop = [runloop getCFRunLoop];
        CFRunLoopAddObserver(cfLoop, observer, kCFRunLoopDefaultMode);
    }
    //在当前线程中注册事件源
    [NSTimer scheduledTimerWithTimeInterval: 1 target: self selector:@selector(printMessage:) userInfo: nil
                                    repeats:YES];
    
    NSInteger loopCount = 2;
    do{
        [runloop runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:2.0]];
        loopCount--;
        
    }while (loopCount);
}

/**
 *
 *  可以检查RunLoop的退出
 *
 */
- (void)test3
{
    BOOL done = NO;
    do{
        SInt32 result = CFRunLoopRunInMode(kCFRunLoopDefaultMode, 10, YES);
        if ((result == kCFRunLoopRunStopped) || (result == kCFRunLoopRunFinished))
            done = YES;
    }
    while (!done);
}



/**
 *
 *  可以看到每一个线程都有属于自己的ruunloop
 *
 */
-(void)test2{
    NSLog(@"CFRunLoopGetMain---------%@",CFRunLoopGetMain());
    NSLog(@"----currentRunLoop-------%@",[NSRunLoop currentRunLoop]);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"---async---currentRunLoopdispatch_get_main_queue---currentRunLoop----%@",[NSRunLoop currentRunLoop]);

    });
    dispatch_async(dispatch_queue_create("test1", NULL), ^{
        NSLog(@"--async---dispatch_queue_create(test1, NULL)----currentRunLoop----%@",[NSRunLoop currentRunLoop]);
    });
    dispatch_sync(dispatch_queue_create("test2", NULL), ^{
        NSLog(@"--sync----dispatch_queue_create(test2, NULL)---currentRunLoop-----%@",[NSRunLoop currentRunLoop]);
    });
}

/**
 *
 *  在滚动scrollview的时候,输出台停止打印,停止滚动后继续打印
 *
 */
-(void)test1{
    self.testScrollview.hidden = NO;
    self.testScrollview.contentSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height * 4);
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                                      target:self
                                                    selector:@selector(printMessage:)
                                                    userInfo:nil
                                                     repeats:YES];
    //把timer添加到commendModes里面
        [[NSRunLoop currentRunLoop]addTimer:timer forMode:NSRunLoopCommonModes];

}

-(void)printMessage:(NSTimer *)timer{
    a++;
    NSLog(@"%d",a);
}


void myRunLoopObserver(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info)
{
    switch(activity)
    {
            // 即将进入Loop
        case kCFRunLoopEntry:
            NSLog(@"run loop entry");
            break;
        case kCFRunLoopBeforeTimers://即将处理 Timer
            NSLog(@"run loop before timers");
            break;
        case kCFRunLoopBeforeSources://即将处理 Source
            NSLog(@"run loop before sources");
            break;
        case kCFRunLoopBeforeWaiting://即将进入休眠
            NSLog(@"run loop before waiting");
            break;
        case kCFRunLoopAfterWaiting://刚从休眠中唤醒
            NSLog(@"run loop after waiting");
            break;
        case kCFRunLoopExit://即将退出Loop
            NSLog(@"run loop exit");
            break;
        default:
            break;
    }
}

@end
