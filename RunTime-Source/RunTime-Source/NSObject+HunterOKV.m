//
//  NSObject+HunterOKV.m
//  RunTime-Source
//
//  Created by wenze on 2020/11/7.
//



#import "NSObject+HunterOKV.h"
#import <objc/message.h>

// implmentation 实现
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
    
    // 绑定观察者 关联
    objc_setAssociatedObject(self, ( __bridge const void * _Nonnull)@"objc", observer, OBJC_ASSOCIATION_ASSIGN);
    
     
    //  objc_setAssociatedObject 关联 使用场景:
    // 1 为现有的类添加私有变量以帮助实现细节；
    // 2 为现有的类添加公有属性；在category使用最多,
    // 3 为 KVO 创建一个关联的观察者
    
    // key值 可以使用selector 使用get方法
    
    
    
    
    
    
}

void creatKVO(id self, SEL _cmd,NSString *str){
    
   // NSLog(@"你好KVO");
    NSLog(@"方法的调用%@",self);
    NSLog(@"%@", str);
    
    // 1 修改super的name
    
    id class = [self class];
    object_setClass(self, class_getSuperclass([self class]));
    objc_msgSend(self, @selector(setName:),str);
    
    
    // 2 通知观察者
    
   id observer =  objc_getAssociatedObject(self,(__bridge const void * _Nonnull)@"objc");
    
    objc_msgSend(observer, @selector(observeValueForKeyPath:ofObject:change:context:),@"name",self,@{@"new":str},nil);
    
    
    // 改回子类
    
    object_setClass(self, class);
    
    
}


- (NSString *)associatedObject_assign {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setAssociatedObject_assign:(NSString *)associatedObject_assign {
    objc_setAssociatedObject(self, @selector(associatedObject_assign), associatedObject_assign, OBJC_ASSOCIATION_ASSIGN);
}

- (NSString *)associatedObject_retain {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setAssociatedObject_retain:(NSString *)associatedObject_retain {
    objc_setAssociatedObject(self, @selector(associatedObject_retain), associatedObject_retain, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)associatedObject_copy {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setAssociatedObject_copy:(NSString *)associatedObject_copy {
    objc_setAssociatedObject(self, @selector(associatedObject_copy), associatedObject_copy, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

#pragma mark - ViewController Class Associated Objects

+ (NSString *)associatedObject {
    return objc_getAssociatedObject([self class], _cmd);
}

+ (void)setAssociatedObject:(NSString *)associatedObject {
    objc_setAssociatedObject([self class], @selector(associatedObject), associatedObject, OBJC_ASSOCIATION_RETAIN_NONATOMIC);


}




@end
