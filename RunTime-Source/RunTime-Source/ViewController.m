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
#import "NSString+BaseCategory.h"
#import "NSObject+AddPushMessage.m"

__weak NSString *string_weak_assign = nil;
__weak NSString *string_weak_retain = nil;
__weak NSString *string_weak_copy   = nil;

// block 从底层看的换也是一个oc对象
// 有三种类型的block
// 1 在栈上创建的block
// 2 在堆上创建的block
// 2 在全局数据区创建block


typedef void(^CFRunloopBlock)(void);


/**
 runtime 函数从xocde5开始没有提示检测,需要在是buidsettings中 搜索 mgs 设置  Enable Strict Checking of objc_msgSend Calls 为NO
  在程序中动态的修改属性 方法
 oc 处理异常比较弱 方法交换修改这些比较若的系统API
 */
@interface ViewController (){
    
    @package
 
    BOOL isNeed;
    
}

@property(nonatomic,strong)StudentModel *model;
@property(nonatomic,strong)dispatch_source_t timer;
// 任务容器
@property(nonatomic,strong)NSMutableArray *taskAarry;

// 任务的最大数

@property(nonatomic)NSUInteger maxTask;



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ViewController *vc = ViewController.new;
    vc ->isNeed = YES;
    if( vc ->isNeed){
        NSLog(@"@packge的使用");
    }
    
    void(^blk)(void) = ^{
        
    };
    
    blk();
    
    
    NSLog(@"====blk%@",[blk class]); //blk__NSGlobalBlock__ 全局数据区创建的block,作用域是全局,注意如果在函数栈上创建的blok 没有截取自动变量,block实例还在全
    
    int i = 0;
    
    void(^blockAuto)(void) = ^{
        
        NSLog(@"%d",i);
        
    };
    //blockAuto被strong修饰
    blockAuto();
    // 栈上创建 自动赋值到了堆上 blockAuto默认是strong变量
    NSLog(@"=======blockAuto%@",[blockAuto class]);
    
    NSLog(@"blockAuto%@",[^{NSLog(@"1111");}class]);
    
    // copy的时候 栈上block会自动赋值到堆上
    NSLog(@"Copy Block %@",[[^{NSLog(@"2222");}copy]class]);
    
    NSLog(@"Stack Block %@",[^{NSLog(@"栈上的block %d",i);}class]);
    
    // __block 原理:将__block自动变量封装成一个结构体,让其在堆上创建,让堆上或者栈上访问和修改的数据是同一份数据
    
    
    // Do any additional setup after loading the view.
    StudentModel *stuModel = [[StudentModel alloc]init];
    // 消息发送
    //[stuModel messageSender];
    
    // 如果messageSender方法没有  performSelector  objc_msgSend都可以编译通过,但是运行时会crash
   // [stuModel performSelector:@selector(messageSender)];
    
    // 消息发送机制
    // 给 stuModel对象发送一个messageSender消息 在.h中不声明 objc_msgSend/messageSender也可以发送消息给stuModel xcode 会有警告. IMP指针方法实现和SEL一一对应
    objc_msgSend(stuModel, @selector(messageSender));
    
    // 带参数
    //objc_msgSend(stuModel, @selector(messageSender:),@"hello runtime");
    
    // sring快速构建使用 init
   NSString *str = @"";
//
    NSLog(@"%@",str);
//    
    //NSString *sring = [[NSString alloc]initWithString:"你好"];
    //NSLog(@"%@",sring);
    [self hunter_kvo];
    
    [self creatClass];
    
    [self creatMethodSignature];
    
    
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(0, 0));
    // 单位是纳秒 GCD开启不受runloop模式影响
    dispatch_source_set_timer(self.timer, DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC, 0);
    
    dispatch_source_set_event_handler(self.timer, ^{
        NSLog(@"你好");
    });
    
    dispatch_resume(self.timer);
    
    self.maxTask = 100;
    [self creatAddCFRunloop];
    
    
    // 把耗时的任务添加进去
    
    [self addBlock:^{
        // 加载大图片图片 一般是tabviewcell里面添加
    }];
    

}


// runtime 模拟实现一个kvo
- (void)hunter_kvo{
    // isa指针 === StudentModel类
    StudentModel *stuModel = [[StudentModel alloc]init];
    //  addObserver  添加了一个子类NSKVONotifying_StudentModel(改变isa指针),重写了setName 改变了stuModel类型指向
    //[stuModel addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew context:nil];
    
    [stuModel hunter_addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew context:nil];
    
    stuModel.associatedObject_assign = [NSString stringWithFormat:@"leichunfeng1"];
    stuModel.associatedObject_retain = [NSString stringWithFormat:@"leichunfeng2"];
    stuModel.associatedObject_copy   = [NSString stringWithFormat:@"leichunfeng3"];
  
    NSLog(@"%@", stuModel.associatedObject_assign);
    string_weak_assign = stuModel.associatedObject_assign;
    string_weak_retain = stuModel.associatedObject_retain;
    string_weak_copy   = stuModel.associatedObject_copy;
    
    self.model = stuModel;
    
    
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    NSLog(@"=====%@",self.model.name);
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    static int i = 0;
    i ++;
    
    self.model.name = [NSString stringWithFormat:@"%d",i];
    //  被释放掉了
    NSLog(@"=====1%@",string_weak_assign);
    NSLog(@"=====2%@",string_weak_retain);
    NSLog(@"=====3%@",string_weak_copy);
    
   // 关联对象的释放时机与移除时机并不总是一致，比如实验中用关联策略 OBJC_ASSOCIATION_ASSIGN 进行关联的对象，很早就已经被释放了，但是并没有被移除，而再使用这个关联对象时就会造成 Crash 。
//    //crash
//    NSLog(@"=====4%@",self.model.associatedObject_assign);
//    // crash
//    string_weak_assign = self.model.associatedObject_assign;

    
}

// oc中的class类解析

- (void) creatClass{
    
    // class 对象都是指向一个指针 objc_class,objc_class 指针继承与objc_objc是个isa指针
    // 1 objc_class是个结构体{Class isa,superclass Class,cache_t 缓存方法, class_data_bits_t bits 获取具体的类信息 }
     // 获取super类
     Class h_class  = class_getSuperclass([self class]);
     NSLog(@"supername%@",h_class);
    // 获取类的属性
    //class_getProperty([self class], "")
    
    // 2 通过bits 查找具体的类信息 类信息存储在class_rw_t中:属性列表:const property_array_t properties() 方法列表: const method_array_t methods()  协议列表:protocol_array_t protocols()
    
    // 获取方法列表
    
    unsigned int conunt;
      
    Method *methods = class_copyMethodList(self.class, &conunt);
    
    for (int i = 0; i < conunt; i++) {
        
        Method currentMethod = methods[i];
        
        SEL sel_all = method_getName(currentMethod);
        
        NSString *curretMethodName = NSStringFromSelector(sel_all);
        
        NSLog(@"%@=====",curretMethodName);
    }
     
    
    // 获取属性列表
    
    unsigned int  propertyCount;
    
    objc_property_t *propertys = class_copyPropertyList(self.class, &propertyCount);
    
    for(int i = 0;i < propertyCount;i++){
        
        objc_property_t property = propertys[i];
        
        const char * _Nonnull propertyName = property_getName(property);
        
        NSLog(@"%@===propertyName",[NSString stringWithUTF8String:propertyName]);
        
    
    }
    
    
    
    // 获取协议
    
    //class_copyProtocolList(<#Class  _Nullable __unsafe_unretained cls#>, <#unsigned int * _Nullable outCount#>)
    
    // 3 查询成员变量 成员变量在class_ro_t

    //class_copyIvarList(<#Class  _Nullable __unsafe_unretained cls#>, <#unsigned int * _Nullable outCount#>)
    
    // 4 实例对象 instance 存储这isa指针和其他成员变量  isa 和superclass指向 instance of RootClass --->Root Class 1 instance of Superclass --->SuperClass 2  instacne of SubClass ----> SubClass
    
    // 4 class对象  instance of RootClass ----> Root Class class对象 --->  Root Class meta对象  4  instance of Superclass --->SuperClass class 对象 ---> SuperClass meta对象  5 instacne of SubClass ----> SubClass class对象 ----> SubClass meta 对象   6  subClass ----10 ----> superClass --- 11 ----> RootClass 12 -->nil
    // 5 meta-class 对象 存储isa指针,superclass指针 ,类方法信息
    
     
    
}


-(void)creatMethodSignature{
    
    StudentModel *stuModel = [[StudentModel alloc]init];
   // SEL sel = @selector(<#selector#>) 发送消息
    [stuModel performSelectorWithArgs:@selector( messageSender:sex:age:),@"李三",@"女",@"16"];
    
}


- (void)creatAddCFRunloop{
    
    // 主线程的runloop 监听完成 我们可以做优化,一般来说,我们的一个界面都在一个runloop 完成多次渲染 甚至有一些大图片加载,视图重复创建比如滚动界面,就会引起卡顿 优化方式让一个runloop 执行一次任务,然后循环多runloop次完成 ,而不是一个runloop 创建多次循环
    CFRunLoopRef loopRef = CFRunLoopGetCurrent();
    
    // 定义上下文
    CFRunLoopObserverContext content = {
        0,
        (__bridge void *)(self),
        &CFRetain,
        &CFRelease,
        NULL
    };
    
    static CFRunLoopObserverRef runLoopObserverRef;
    
    runLoopObserverRef = CFRunLoopObserverCreate(NULL, kCFRunLoopBeforeTimers, YES, 0, &cfRunlopCallBack, &content);
    //kCFRunLoopCommonModes 通过实际情况选择
    CFRunLoopAddObserver(loopRef, runLoopObserverRef, kCFRunLoopCommonModes);
    
    
}

static void  cfRunlopCallBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info){
    // 监听回调
    NSLog(@"你好 CFRunloop");
    // 在 无法调用oc对象 使用__brige
    // 获取当前的控制器
    ViewController *vc = (__bridge ViewController *)(info);
    
    if (vc.taskAarry.count == 0) {
        return;
    }
    
    CFRunloopBlock task = [vc.taskAarry firstObject];
    // 执行任务
    task();
    
    [vc.taskAarry removeObjectAtIndex:0];
    
    
}


-(void)addBlock:(CFRunloopBlock)task
{
    [self.taskAarry addObject:task];
    
    if (self.taskAarry.count > self.maxTask) {
        [self.taskAarry removeObjectAtIndex:0];
    }
    
}





@end
