//
//  main.m
//  RunTime-Source
//
//  Created by wenze on 2020/11/7.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <objc/message.h>
// argv可执行文件资源
// 在swift中使用@UIApplicationMain代替



int main(int argc, char * argv[]) {
    NSString * appDelegateClassName;
    
    @autoreleasepool {
        // Setup code that might create autoreleased objects goes here.
        appDelegateClassName = NSStringFromClass([AppDelegate class]);
    }
    // app的单利对象 默认是或者为nil UIApplication 改成别的 比如UIbutton 会崩溃
    return UIApplicationMain(argc, argv, @"UIApplication", appDelegateClassName);
}



