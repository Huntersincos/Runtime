//
//  StudentModel.m
//  RunTime-Source
//
//  Created by wenze on 2020/11/7.
//

#import "StudentModel.h"

@implementation StudentModel

-(void)messageSender{
    
    NSLog(@"消息机制");
}

-(void)messageSender:(NSString *)msg{
    NSLog(@"%@",msg);
}

@end
