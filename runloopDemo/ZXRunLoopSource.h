//
//  ZXRunLoopSource.h
//  runloopDemo
//
//  Created by mac on 16/4/12.
//  Copyright © 2016年 com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZXRunLoopSource : NSObject

{
    CFRunLoopSourceRef runLoopSource;
    NSMutableArray* commands;
}

- (id)init;
- (void)addToCurrentRunLoop;

- (void)sourceFired;

- (void)addCommand:(NSInteger)command withData:(id)data;
- (void)fireCommandsOnRunLoop:(CFRunLoopRef)runloop;
- (void)invalidate;
@end


@interface RunLoopContext : NSObject
{
    CFRunLoopRef        _runLoop;
    ZXRunLoopSource*        _source;
}
@property (readonly) CFRunLoopRef runLoop;
@property (readonly) ZXRunLoopSource* source;

- (id)initWithSource:(ZXRunLoopSource*)src andLoop:(CFRunLoopRef)loop;

@end

void RunLoopSourceScheduleRoutine (void *info, CFRunLoopRef rl, CFStringRef mode);
void RunLoopSourcePerformRoutine (void *info);
void RunLoopSourceCancelRoutine (void *info, CFRunLoopRef rl, CFStringRef mode);

