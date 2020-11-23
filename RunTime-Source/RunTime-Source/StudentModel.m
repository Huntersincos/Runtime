//
//  StudentModel.m
//  RunTime-Source
//
//  Created by wenze on 2020/11/7.
//

#import "StudentModel.h"

@implementation StudentModel
//@synthesize生产set方法
// 发生这种状况根本原因是苹果将默认编译器从GCC转换为LLVM(low level virtual machine)，才不再需要为属性声明实例变量了。在没有更改之前，属性的正常写法需要成员变量 + @property + @synthesize 成员变量 三个步骤。
// 如果已经手动实现了get和set方法（两个都实现）的话Xcode不会再自动生成带有下划线的私有成员变量了

@synthesize sex;
-(void)setName:(NSString *)name{
    // 在set方法中 self.name = name;会导致死循环
    //self.name = name;  self.name在这里调用的set和get方法 所以是死循环
    
    // 给_name成员变量赋值
    _name = name;
    self.sex = @"niaho";
    
    NSString *subSting = nil;
    // 不为空 才是非常危险的 为空到没事情
    [subSting substringFromIndex:100000];
    
    [subSting substringToIndex:100000];
    
    [subSting substringWithRange:NSMakeRange(0, 10)];
    
}

-(void)setSex:(NSString *)sex{
    
 NSLog(@"%@",sex);
 self ->sex = sex;
    // _是不行的
   // _sex = sex;
    
}

-(void)messageSender{
    self.sex = @"niaho";
    NSLog(@"消息机制");
    
}

-(void)messageSender:(NSString *)msg sex:(NSString*)sex age:(NSString *)age{
    NSLog(@"%@ %@ %@",msg,sex,age);
}

@end
