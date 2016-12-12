//
//  HSInitUtil.m
//  HitachShow
//
//  Created by Jeremy on 2016.
//  Copyright (c) 2016年 hitach. All rights reserved.
//

#import "HSAppUtil.h"
#import "HSDBUtil.h"
#import "HSResUtil.h"
#import "AFNetworking.h"
#import "HSAlertView.h"

NSString * const INIT_FLAG = @"INIT_FLAG";
NSString * const DEFAULT_VERSION = @"V1.0";
NSString * const RESOURCE_VERSION = @"RESOURCE_VERSION";

@implementation HSAppUtil

+ (void) appInit {
    NSString *init = [[NSUserDefaults standardUserDefaults] objectForKey:INIT_FLAG];
    if (!init) {
        // Database init
        [HSDBUtil defaultDB];
        // Resource init
        [HSResUtil initResource];
        
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:INIT_FLAG];
    }
}

- (void) checkResourceVersion {
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSString *url = [AppServer stringByAppendingFormat:@"/api/version?v=%@",[HSAppUtil currentVersion]];
    NSURL *URL = [NSURL URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (!error) {
            NSArray *array = responseObject;
            if (array.count > 0) {
                HSAlertView *alert = [[HSAlertView alloc] initWithTitle:nil message:@"There is a new version,whether to update?" cancelButtonTitle:@"Cancel" otherButtonTitles:@"Sure" block:^(NSInteger buttonIndex) {
                    if (buttonIndex == 1) {
                        for (NSDictionary *dic in array) {
                            [self downloadAndUpdate:dic[@"url"]];
                        }
                    }
                }];
                [alert show];
            }
        } else {
            NSLog(@"Resource data can't be updated cause network error!");
            //            NSLog(@"Error: %@", error)
        }
    }];
    [dataTask resume];
}

// Download resource,unzip and update database
- (void) downloadAndUpdate:(NSString *) url {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        NSString *pathStr = [filePath path];
        if (pathStr) {
            [HSResUtil updateResourceWithPath:pathStr];
            NSString *version = [pathStr.lastPathComponent stringByDeletingPathExtension];
            [[NSUserDefaults standardUserDefaults] setObject:version forKey:RESOURCE_VERSION];
            NSLog(@"Resource version has updated to %@ " ,version);
        }
    }];
    [downloadTask resume];
}

+ (NSString *) currentVersion {
    NSString *currentVersion = [[NSUserDefaults standardUserDefaults] objectForKey:RESOURCE_VERSION];
    if (!currentVersion) {
        currentVersion = DEFAULT_VERSION;
    }
    return currentVersion;
}

@end