//
//  NSObject+HunterOKV.h
//  RunTime-Source
//
//  Created by wenze on 2020/11/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (HunterOKV)

-(void)hunter_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(nullable void *)context;
//Method _Nullable * _Nullable all_ClassMethod(Class class);

@property (assign, nonatomic) NSString *associatedObject_assign;
@property (strong, nonatomic) NSString *associatedObject_retain;
@property (copy,   nonatomic) NSString *associatedObject_copy;

+ (NSString *)associatedObject;
+ (void)setAssociatedObject:(NSString *)associatedObject;




@end

NS_ASSUME_NONNULL_END
