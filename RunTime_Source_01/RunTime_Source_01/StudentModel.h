//
//  StudentModel.h
//  RunTime_Source_01
//
//  Created by wenze on 2020/11/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface StudentModel : NSObject
{
    // 4byte
  @public  int age;
  @public  int age1;
  @public  int age2;
    // 8byte
  @public NSString *name;
  @public NSString *sex;
  @public NSString *sort;
    
}
@property(nonatomic,assign)int age;
@end

NS_ASSUME_NONNULL_END
