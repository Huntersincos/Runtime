//
//  NSString+BaseCategory.m
//  RunTime-Source
//
//  Created by wenze on 2020/11/7.
//

#import "NSString+BaseCategory.h"
#import <objc/message.h>
#import <objc/runtime.h>
@implementation NSString (BaseCategory)

+(void)load{
    
    // 获取Method
    // 获取类方法 class_getClassMethod
   // NSString *str = @"";
    Method stringInitMethod =  class_getInstanceMethod([NSString class], @selector(init));
    // 获取实例方法
    Method newH_stringInitMethod =  class_getInstanceMethod([NSString class], @selector(Hunter_init));
    // 交换两个方法
    if (class_addMethod([NSString class], @selector(Hunter_init), method_getImplementation(newH_stringInitMethod), method_getTypeEncoding(stringInitMethod))) {
        
    }else{
        
    }
    
   // method_exchangeImplementations(stringInitMethod, newH_stringInitMethod);
    [[self alloc] runTests];
}

- (void)runTests
{
    unsigned int count;
    Method *methods = class_copyMethodList([self class], &count);
    for (int i = 0; i < count; i++)
    {
        Method method = methods[i];
        SEL selector = method_getName(method);
        NSString *name = NSStringFromSelector(selector);

        NSLog(@"方法 名字 ==== %@",name);

    }
}

-(instancetype)Hunter_init{
    
    NSString *h_newSring = self;
    
    if ([NSString isBlankString:h_newSring]) {
        h_newSring = @"";
    }
    
    return h_newSring;
}


// 字符串是否为空 通过runtime  在string 初始化的时候 就把这个功能加进去
+(BOOL)isBlankString:(NSString *)string{

     if (string == nil) {
        
         return YES;
        
         }
    
     if (string == NULL) {
        
         return YES;
        
         }
    
     if ([string isKindOfClass:[NSNull class]]) {
        
         return YES;
        
         }
    if ([string isEqualToString:@"(null)"]) {
        return YES;
    }
     if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0) {
         
         return YES;
         
         }
    
     return NO;
    
}

@end
