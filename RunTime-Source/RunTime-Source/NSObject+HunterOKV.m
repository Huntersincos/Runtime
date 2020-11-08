//
//  NSObject+HunterOKV.m
//  RunTime-Source
//
//  Created by wenze on 2020/11/7.
//

#import "NSObject+HunterOKV.h"
#import <objc/message.h>

@implementation NSObject (HunterOKV)
-(void)hunter_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context{
    
    // 1 动态添加子类
     // pram  1 Class  _Nullable __unsafe_unretained superclass 父类  2 <#const char * _Nonnull name#>
    
    NSString *superClassName = NSStringFromClass([self class]);
    NSString *newClassName = [@"HUNTERKVO_" stringByAppendingString:superClassName];
 
    Class hunterClass = objc_allocateClassPair([self class], [newClassName UTF8String], 0);

    // 2    // 添加set方法 重写set方法  v@:@ 方法类型 所有的oc 都有2个默认参数(隐) 方法的调用者 和方法编号
    
    class_addMethod(hunterClass, @selector(setName:), (IMP)creatKVO, "v@:@");
    
    // 3 注册
    
    objc_registerClassPair(hunterClass);
    
    // 4 修改被观察者isa指针
    object_setClass(self, hunterClass);
    
    // 绑定观察者
    objc_setAssociatedObject(self, ( __bridge const void * _Nonnull)@"objc", observer, OBJC_ASSOCIATION_ASSIGN);
    
    
    
}

void creatKVO(id self, SEL _cmd,NSString *str){
    
   // NSLog(@"你好KVO");
    NSLog(@"方法的调用这%@",self);
    NSLog(@"%@", str);
    
    // 1 修改super的name
    
    id class = [self class];
    object_setClass(self, class_getSuperclass([self class]));
    objc_msgSend(self, @selector(setName:));
    
    
    // 2 通知观察者
    
   id observer =  objc_getAssociatedObject(self,(__bridge const void * _Nonnull)@"objc");
    
    objc_msgSend(observer, @selector(observeValueForKeyPath:ofObject:change:context:),@"name",self,@{@"new":str},nil);
    
    
    // 改回子类
    
    object_setClass(self, class);
    
    
}
@end
