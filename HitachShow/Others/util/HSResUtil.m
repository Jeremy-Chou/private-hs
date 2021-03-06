//
//  HSResUtil.m
//  HitachShow
//
//  Created by Jeremy on 2016.
//  Copyright (c) 2016年 hitach. All rights reserved.
//

#import "HSResUtil.h"
#import "HSFileUtil.h"
#import "ZipArchive.h"
#import "HSCommonInfo.h"

@implementation HSResUtil

+ (NSString *) pathWithFileName:(NSString *) fileName {
    NSString *path = nil;
    if (fileName != nil) {
        path = [HSFileUtil documentPathWithName:fileName];
    }
    return path;
}

+ (void) initResource {
    NSString *fileName = @"V1.0.zip";
    BOOL done = [HSFileUtil copyFromBundleToDocDirWithName:fileName];
    // unzip default resource
    ZipArchive *zipArchive = [[ZipArchive alloc] init];
    NSString *defaultDocPath = [HSFileUtil documentPathWithName:fileName];
    BOOL open = [zipArchive UnzipOpenFile:defaultDocPath];
    if (open) {
        BOOL success = [zipArchive UnzipFileTo:[HSFileUtil documentPathWithName:@""] overWrite:YES];
        [zipArchive UnzipCloseFile];
        // Delete zip file after upzip
        if (success) {
            [HSFileUtil removeWithPath:defaultDocPath];
        }
    }
    
    // delete from bundle
    BOOL exist = [HSFileUtil fileExistInDocWithName:fileName];
    if (done && exist) {
        NSString *filePath = [HSResUtil pathWithFileName:fileName];
        [HSFileUtil removeWithPath:filePath];
    }
}

// Unzip and update DB
+ (void) updateResourceWithPath:(NSString *) path {
    ZipArchive *zipArchive = [[ZipArchive alloc] init];
    BOOL open = [zipArchive UnzipOpenFile:path];
    if (open) {
        [zipArchive UnzipFileTo:[HSFileUtil documentPathWithName:@""] overWrite:YES];
        [zipArchive UnzipCloseFile];
    }
    
    // move files from versin folder to doc
    NSString *versionFolder = [path stringByDeletingPathExtension];
    [HSFileUtil moveItemsToDocWithPath:versionFolder];
    [HSFileUtil removeWithPath:versionFolder];
    
    NSString *infoFileName = [[path.lastPathComponent stringByDeletingPathExtension] stringByAppendingPathExtension:@"data"];
    // doc/version.data
    BOOL exist = [HSFileUtil fileExistInDocWithName:infoFileName];
    if (exist) {
        // Read file and update DB
        NSString *dataFilePath = [HSFileUtil documentPathWithName:infoFileName];
        NSData *data = [NSData dataWithContentsOfFile:dataFilePath];
        NSError *error;
        NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        for (NSDictionary *dic in array) {
            HSCommonInfo *commonInfo = [[HSCommonInfo alloc] initWithDictionary:dic];
            [commonInfo saveOrUpdate];
        }
        [HSFileUtil removeWithPath:dataFilePath];
        [HSFileUtil removeWithPath:path];
    }
}

+ (UIImage *) imageNamed:(NSString *) name {
    NSString *path = [HSFileUtil documentPathWithName:name];
    return [UIImage imageWithContentsOfFile:path];
}

@end
