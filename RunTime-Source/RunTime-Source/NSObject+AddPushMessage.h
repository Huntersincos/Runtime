//
//  NSObject+AddPushMessage.h
//  RunTime-Source
//
//  Created by wenze on 2020/11/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (AddPushMessage)
- (id)performSelectorWithArgs:(SEL)sel, ...;
@end

NS_ASSUME_NONNULL_END
