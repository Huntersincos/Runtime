//
//  StudentModel.h
//  RunTime-Source
//
//  Created by wenze on 2020/11/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface StudentModel : NSObject

// no prama
-(void)messageSender;

@property(nonatomic,copy)NSString *name;

-(void)messageSender:(NSString *)msg sex:(NSString*)sex age:(NSString *)age;

@end

NS_ASSUME_NONNULL_END
