//
//  HSCommonInfo.m
//  HitachShow
//
//  Created by Jeremy on 2016.
//  Copyright (c) 2016年 hitach. All rights reserved.
//

#import "HSCommonInfo.h"
#import <objc/message.h>

@implementation HSCommonInfo

static HSCommonInfo *_instance;

+ (HSCommonInfo *) shared {
    if (_instance == nil) {
        _instance = [[HSCommonInfo alloc] init];
    }
    return _instance;
}

- (NSArray *) findByCategory:(NSString *) category {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [self readDefaultDBWithTask:^(FMDatabase *db) {
        FMResultSet *resultSet = [db executeQuery:@"SELECT id,category,name,title,picture,text1,text2,video,country,spec,distributor,complete_year,pdf,ppt,area,type FROM hs_common_info WHERE category = ? ",category];
        while ([resultSet next]) {
            HSCommonInfo *element = [self toObjectWithResult:resultSet];
            [array addObject:element];
        }
    }];
    
    return array;
}

- (HSCommonInfo *) findByID:(NSString *) ID {
    __block HSCommonInfo *commonInfo = nil;
    [self readDefaultDBWithTask:^(FMDatabase *db) {
        FMResultSet *resultSet = [db executeQuery:@"SELECT id,category,name,title,picture,text1,text2,video,country,spec,distributor,complete_year,pdf,ppt,area,type FROM hs_common_info WHERE id = ? ",ID];
        while ([resultSet next]) {
            commonInfo = [self toObjectWithResult:resultSet];
        }
    }];
    
    return commonInfo;
}

- (NSArray *) findByArea:(NSString *) area {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [self readDefaultDBWithTask:^(FMDatabase *db) {
        FMResultSet *resultSet = [db executeQuery:@"SELECT id,category,name,title,picture,text1,text2,video,country,spec,distributor,complete_year,pdf,ppt,area,type FROM hs_common_info WHERE area = ? ",area];
        while ([resultSet next]) {
            HSCommonInfo *element = [self toObjectWithResult:resultSet];
            [array addObject:element];
        }
    }];
    
    return array;
}

- (NSArray *) findByType:(NSString *) type {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [self readDefaultDBWithTask:^(FMDatabase *db) {
        FMResultSet *resultSet = [db executeQuery:@"SELECT id,category,name,title,picture,text1,text2,video,country,spec,distributor,complete_year,pdf,ppt,area,type FROM hs_common_info WHERE type = ? ",type];
        while ([resultSet next]) {
            HSCommonInfo *element = [self toObjectWithResult:resultSet];
            [array addObject:element];
        }
    }];
    
    return array;
}

- (HSCommonInfo *) toObjectWithResult:(FMResultSet *) resultSet {
    HSCommonInfo *commonInfo = [[HSCommonInfo alloc] init];
    commonInfo.ID = [resultSet stringForColumn:@"id"];
    commonInfo.category = [resultSet stringForColumn:@"category"];
    commonInfo.name = [resultSet stringForColumn:@"name"];
    commonInfo.title = [resultSet stringForColumn:@"title"];
    commonInfo.picture = [resultSet stringForColumn:@"picture"];
    commonInfo.text1 = [resultSet stringForColumn:@"text1"];
    commonInfo.text2 = [resultSet stringForColumn:@"text2"];
    commonInfo.video = [resultSet stringForColumn:@"video"];
    commonInfo.country = [resultSet stringForColumn:@"country"];
    commonInfo.type = [resultSet stringForColumn:@"type"];
    commonInfo.spec = [resultSet stringForColumn:@"spec"];
    commonInfo.distributor = [resultSet stringForColumn:@"distributor"];
    commonInfo.completeYear = [resultSet stringForColumn:@"complete_year"];
    commonInfo.pdf = [resultSet stringForColumn:@"pdf"];
    commonInfo.ppt = [resultSet stringForColumn:@"ppt"];
    commonInfo.area = [resultSet stringForColumn:@"area"];
    
    return commonInfo;
}

- (HSCommonInfo *) initWithDictionary:(NSDictionary *) dictionary {
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([HSCommonInfo class], &outCount);
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        NSString *propName = [NSString stringWithUTF8String:property_getName(property)];
        id value = [dictionary objectForKey:propName];
        if (value) {
            [self setValue:value forKey:propName];
        }
    }
    
    return self;
}

- (void) saveOrUpdate {
    [self writeDefaultDBWithTask:^(FMDatabase *db, BOOL *rollback) {
        [db executeUpdate:@"replace into hs_common_info values(:ID,:category,:name,:title,:picture,:text1,:text2,:video,:ppt,:pdf,:country,:type,:spec,:distributor,:completeYear,:area);" withParameterObject:self];
    }];
}

@end
