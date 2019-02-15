//
//  main.m
//  Science
//
//  Created by zidonj on 2018/11/6.
//  Copyright © 2018 langlib. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

int main(int argc, char * argv[]) {
    @autoreleasepool {
        
        int b = 10;
        void (^test) (NSInteger a) = ^(NSInteger a) {
            
            NSLog(@"%d---%ld",b,a);
        };
        b = 50;
        test(10);
        NSLog(@"%@",test);
        
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}

// 加__block前
/*
struct __block_impl {
   void *isa;
   int Flags;
   int Reserved;
   void *FuncPtr;
};
 
struct __main_block_impl_0 {
    struct __block_impl impl;
    struct __main_block_desc_0* Desc;
    int b;
    __main_block_impl_0(void *fp, struct __main_block_desc_0 *desc, int _b, int flags=0) : b(_b) {
        impl.isa = &_NSConcreteStackBlock;
        impl.Flags = flags;
        impl.FuncPtr = fp;
        Desc = desc;
    }
};
static void __main_block_func_0(struct __main_block_impl_0 *__cself, NSInteger a) {
    int b = __cself->b; // bound by copy
    
    NSLog((NSString *)&__NSConstantStringImpl__var_folders_nf_p_4bfj_55p71gq5lpv4lgjqc0000gn_T_main_92c692_mi_0,b);
    
}

static struct __main_block_desc_0 {
    size_t reserved;
    size_t Block_size;
}
 __main_block_desc_0_DATA = { 0, sizeof(struct __main_block_impl_0)};
int main(int argc, char * argv[]) {
    { __AtAutoreleasePool __autoreleasepool;
        
        
        int b = 10;
        void (*test) (NSInteger a) = ((void (*)(NSInteger))&__main_block_impl_0((void *)__main_block_func_0, &__main_block_desc_0_DATA, b));
        b = 50;
        ((void (*)(__block_impl *, NSInteger))((__block_impl *)test)->FuncPtr)((__block_impl *)test, 10);
        
        return UIApplicationMain(argc, argv, __null, NSStringFromClass(((Class (*)(id, SEL))(void *)objc_msgSend)((id)objc_getClass("AppDelegate"), sel_registerName("class"))));
    }
}
*/


// 加__block后

/*
 
 struct __block_impl {
    void *isa;
    int Flags;
    int Reserved;
    void *FuncPtr;
 };
 
 
struct __Block_byref_b_0 {
    void *__isa;
    __Block_byref_b_0 *__forwarding;
    int __flags;
    int __size;
    int b;
};

struct __main_block_impl_0 {
    struct __block_impl impl;
    struct __main_block_desc_0* Desc;
    __Block_byref_b_0 *b; // by ref
    __main_block_impl_0(void *fp, struct __main_block_desc_0 *desc, __Block_byref_b_0 *_b, int flags=0) : b(_b->__forwarding) {
        impl.isa = &_NSConcreteStackBlock;
        impl.Flags = flags;
        impl.FuncPtr = fp;
        Desc = desc;
    }
};
static void __main_block_func_0(struct __main_block_impl_0 *__cself, NSInteger a) {
    __Block_byref_b_0 *b = __cself->b; // bound by ref
    
    
    NSLog((NSString *)&__NSConstantStringImpl__var_folders_nf_p_4bfj_55p71gq5lpv4lgjqc0000gn_T_main_5751fb_mi_0,(b->__forwarding->b));
}

static void __main_block_copy_0(struct __main_block_impl_0*dst, struct __main_block_impl_0*src) {_Block_object_assign((void*)&dst->b, (void*)src->b, );}

static void __main_block_dispose_0(struct __main_block_impl_0*src) {_Block_object_dispose((void*)src->b,);}

static struct __main_block_desc_0 {
    size_t reserved;
    size_t Block_size;
    void (*copy)(struct __main_block_impl_0*, struct __main_block_impl_0*);
    void (*dispose)(struct __main_block_impl_0*);
}
__main_block_desc_0_DATA = { 0, sizeof(struct __main_block_impl_0), __main_block_copy_0, __main_block_dispose_0};
int main(int argc, char * argv[]) {
    { __AtAutoreleasePool __autoreleasepool;
        
        __attribute__((__blocks__(byref))) __Block_byref_b_0 b = {(void*)0,(__Block_byref_b_0 *)&b, 0, sizeof(__Block_byref_b_0), 10};
        void (*test) (NSInteger a) = ((void (*)(NSInteger))&__main_block_impl_0((void *)__main_block_func_0, &__main_block_desc_0_DATA, (__Block_byref_b_0 *)&b, 570425344));
        (b.__forwarding->b) = 50;
        ((void (*)(__block_impl *, NSInteger))((__block_impl *)test)->FuncPtr)((__block_impl *)test, 10);
        
        return UIApplicationMain(argc, argv, __null, NSStringFromClass(((Class (*)(id, SEL))(void *)objc_msgSend)((id)objc_getClass("AppDelegate"), sel_registerName("class"))));
    }
}
*/
