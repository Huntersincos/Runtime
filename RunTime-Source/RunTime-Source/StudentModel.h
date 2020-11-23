//
//  StudentModel.h
//  RunTime-Source
//
//  Created by wenze on 2020/11/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
// ios5之前成员变量
@interface StudentModel : NSObject{
    NSString *sex;
}

// no prama
-(void)messageSender;

@property(nonatomic,copy)NSString *name;

@property(nonatomic,copy)NSString *sex;

/**
  1  weak表:
   1.1 weak_table_t(全局表): 采用hash 的方式存储weak对象
   1.2 weak_entry_t :用于记录hash表中weak对象
 */
@property(nonatomic,weak)id objc;


-(void)messageSender:(NSString *)msg sex:(NSString*)sex age:(NSString *)age;

@end

NS_ASSUME_NONNULL_END
