//
//  NSURLSession+CorrectResumData.h
//  ZEDownload
//
//  Created by 泽i on 2017/5/22.
//  Copyright © 2017年 泽i. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURLSession (CorrectResumData)


- (NSURLSessionDownloadTask *)downloadTaskWithCorrectResumeData:(NSData *)resumeData;

@end
