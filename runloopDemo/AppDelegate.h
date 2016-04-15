//
//  AppDelegate.h
//  runloopDemo
//
//  Created by mac on 16/4/7.
//  Copyright © 2016年 com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

+(AppDelegate *)sharedAppDelegate;
@end

