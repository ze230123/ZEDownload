//
//  ZEFileUtils.h
//  ZEDownload
//
//  Created by 泽i on 2017/5/22.
//  Copyright © 2017年 泽i. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZEFileUtils : NSObject

/**
 获取Documents文件夹

 @return URL 文件夹路径
 */
+ (NSString *)getDocuments;

/**
 获取Caches文件夹

 @return URL 文件夹路径
 */
+ (NSString *)getCaches;

/**
 获取Preferences文件夹

 @return URL 文件夹路径
 */
+ (NSString *)getPreferences;

/**
 获取Tmp文件夹

 @return URL文件夹路径
 */
+ (NSString *)getTmp;


+ (BOOL)createDirctory:(NSString *)directoryPath;

+ (BOOL)moveFileAtPath:(NSString *)srcPath toPath:(NSString *)dstPath;

+ (NSString *)getFilePath:(NSString *)fileName;

@end
