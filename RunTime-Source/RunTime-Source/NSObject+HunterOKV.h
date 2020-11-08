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

@end

NS_ASSUME_NONNULL_END
