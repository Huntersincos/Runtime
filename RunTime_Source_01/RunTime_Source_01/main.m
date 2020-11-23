//
//  main.m
//  RunTime_Source_01
//
//  Created by wenze on 2020/11/7.
//

#import <Foundation/Foundation.h>
#import "StudentModel.h"
#import <objc/message.h>
int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");
        // clang -rewrite-objc main.m
        // 1个NSObject 占内存8个字节
        StudentModel *stuModel = [[StudentModel alloc]init];
        stuModel ->age = 5;
        stuModel ->name = @"你好";
        //x/4xw 0x0000000100544140
        //  x/4dw 0x100544140
        // 修改 memory read  memory write 
        NSLog(@"%ld  %ld", class_getInstanceSize([NSObject class]),class_getInstanceSize([StudentModel class]));
       ;
        
    }
    return 0;
}
