//
//  ZEFileUtils.m
//  ZEDownload
//
//  Created by 泽i on 2017/5/22.
//  Copyright © 2017年 泽i. All rights reserved.
//

#import "ZEFileUtils.h"

@implementation ZEFileUtils

/**
 获取文件夹路径
 
 @param directory 枚举 路径目录
 @return URL 文件夹路径
 */
+ (NSString *)getFolder:(NSSearchPathDirectory)directory {
    return [NSSearchPathForDirectoriesInDomains(directory, NSUserDomainMask, YES) firstObject];
}

+(NSString *)getDocuments {
    return [self getFolder:NSDocumentDirectory];
}
+ (NSString *)getCaches {
    return [self getFolder:NSCachesDirectory];
}
+ (NSString *)getPreferences {
    return [self getFolder:NSPreferencePanesDirectory];
}
+ (NSString *)getTmp {
    return NSTemporaryDirectory();
}

+ (BOOL)createDirctory:(NSString *)directoryPath {
    if ([[NSFileManager defaultManager] fileExistsAtPath:directoryPath]) {
        return NO;
    }
    return [[NSFileManager defaultManager] createDirectoryAtPath:directoryPath
                                     withIntermediateDirectories:YES
                                                      attributes:nil
                                                           error:nil];
}

+ (BOOL)moveFileAtPath:(NSString *)srcPath toPath:(NSString *)dstPath {
    return [[NSFileManager defaultManager] moveItemAtPath:srcPath
                                                   toPath:dstPath
                                                    error:nil];
}

+ (NSString *)getFilePath:(NSString *)fileName {
    return [[self getDocuments] stringByAppendingPathComponent:fileName];
}

@end
