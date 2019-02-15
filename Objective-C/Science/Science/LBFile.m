//
//  LBFile.m
//  Science
//
//  Created by zidonj on 2018/11/28.
//  Copyright © 2018 langlib. All rights reserved.
//

#import "LBFile.h"
#include <sys/xattr.h>

@implementation LBFile

+ (void)saveFile {
    
    NSString *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
    path = [path stringByAppendingPathComponent:@"a.txt"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:path]) {
        NSString *str = @"经典的旋律";
        [fileManager createFileAtPath:path contents:[str dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
    }
}

//非备份设置代码如下(一般大文件会禁止备份)
- (BOOL)addShipBackUpAttributeToUrl:(NSString *)url {
    
    NSURL *itemUrl = [NSURL URLWithString:url];
    const char *filePath = [[itemUrl path] fileSystemRepresentation];
    const char *attrName = "com.apple.MobileBackup";
    u_int8_t attrValue = 1;
    
    int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
    return result == 0;
}


@end
