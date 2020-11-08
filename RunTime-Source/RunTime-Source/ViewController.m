//
//  ViewController.m
//  RunTime-Source
//
//  Created by wenze on 2020/11/7.
//

#import "ViewController.h"
#import "StudentModel.h"
#import <objc/message.h>
#import <objc/runtime.h>
#import "NSObject+HunterOKV.h"

/**
 runtime 函数从xocde5开始没有提示检测,需要在是buidsettings中 搜索 mgs 设置  Enable Strict Checking of objc_msgSend Calls 为NO
  在程序中动态的修改属性 方法
 oc 处理异常比较弱 方法交换修改这些比较若的系统API
 */
@interface ViewController ()

@property(nonatomic,strong)StudentModel *model;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    StudentModel *stuModel = [[StudentModel alloc]init];
    // 消息发送
    //[stuModel messageSender];
    
    // 如果messageSender方法没有  performSelector  objc_msgSend都可以编译通过,但是运行时会crash
   // [stuModel performSelector:@selector(messageSender)];
    
    // 消息发送机制
    // 给 stuModel对象发送一个messageSender消息 在.h中不声明 objc_msgSend/messageSender也可以发送消息给stuModel xcode 会有警告. 是因为IMP指针方法实现和SEL一一对应
    objc_msgSend(stuModel, @selector(messageSender));
    
    // 带参数
    objc_msgSend(stuModel, @selector(messageSender:),@"hello runtime");
    
    // sring快速构建使用 init
   NSString *str = @"";
//
    NSLog(@"%@",str);
//    
    //NSString *sring = [[NSString alloc]initWithString:"你好"];
    //NSLog(@"%@",sring);
    [self hunter_kvo];

}


// runtime 模拟实现一个kvo
- (void)hunter_kvo{
    // isa指针 === StudentModel类
    StudentModel *stuModel = [[StudentModel alloc]init];
    //  addObserver  添加了一个子类NSKVONotifying_StudentModel(改变isa指针),重写了setName 改变了stuModel类型指向
    //[stuModel addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew context:nil];
    
    [stuModel hunter_addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew context:nil];
    
    self.model = stuModel;
    
    
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    NSLog(@"=====%@",self.model.name);
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    static int i = 0;
    i ++;
    
    self.model.name = [NSString stringWithFormat:@"%d",i];

    
}



@end
