//
//  YOSDBManager.m
//  kuailai
//
//  Created by yangyang on 15/5/14.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSDBManager.h"
#import "FMDB.h"

static const NSString *dbName = @"kawayiSASA.db";
static const NSString *activityCityName = @"yos_activity_city";
static const NSString *activityRegionName = @"yos_activity_region";

@implementation YOSDBManager {
    FMDatabase *_db;
    FMDatabaseQueue *_dbQueue;
    
    BOOL _isDBInitSuccess;
    BOOL _isUseDBQueue;
}

+ (instancetype)sharedManager {
    
    static YOSDBManager *dbManager;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dbManager = [[self alloc] init];
    });
    
    return dbManager;
}

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[dbName copy]];
        
        _db = [FMDatabase databaseWithPath:path];
        _dbQueue = [FMDatabaseQueue databaseQueueWithPath:path];
        
        if (!_db || !_dbQueue) {
            YOSLog(@"\r\n\r\n warnning : sqlite initialize failture.");
            _isDBInitSuccess = NO;
        } else {
            _isDBInitSuccess = YES;
        }
    });
    
    return self;
}

- (void)chooseTable:(YOSDBManagerTableType)tableType isUseQueue:(BOOL)status {
    
    _isUseDBQueue = status;
    
    NSString *tableName = nil;
    
    switch (tableType) {
        case YOSDBManagerTableTypeActivityCity: {
            tableName = [activityCityName copy];
            break;
        }
        case YOSDBManagerTableTypeActivityRegion: {
            tableName = [activityRegionName copy];
            break;
        }
        default: {
            break;
        }
    }
    
    NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (id integer PRIMARY KEY AUTOINCREMENT, city_name NOT NULL);", tableName];
    
    if (status) {
        [_dbQueue inDatabase:^(FMDatabase *db) {
            [db executeUpdate:sql];
        }];
    } else {
        if ([_db open]) {
            [_db executeUpdate:sql];
        }
    }
    
}

/**
 *  @[xx, xx, xx ...]
 *
 *  @param array
 */
- (void)updateActivityCityWithArray:(NSArray *)array {
    
    NSString *deleteSql = [NSString stringWithFormat:@"DELETE TABLE %@", [activityCityName copy]];
    
    NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO %@ (city_name)VALUES(?)", [activityCityName copy]];
    
    if (_isUseDBQueue) {
        
        [_dbQueue inDatabase:^(FMDatabase *db) {
            
            [db executeUpdate:deleteSql];
            
            [array enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
                [db executeUpdate:insertSql, obj];
            }];
            
        }];
        
    } else {
        
        [_db executeUpdate:deleteSql];
        
        [array enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
            [_db executeUpdate:insertSql, obj];
        }];
        
    }
}

@end
