//
//  YOSDBManager.m
//  kuailai
//
//  Created by yangyang on 15/5/14.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSDBManager.h"
#import "FMDB.h"

NSString * const YOSDBTableCargoDataKey = @"YOSDBTableCargoDataKey";
NSString * const YOSDBTableCargoDataValue = @"YOSDBTableCargoDataValue";

static const NSString *kDBName = @"kawayiSASA.db";
static const NSString *kYOSTableCagro = @"yos_cargo";

@implementation YOSDBManager {
    FMDatabase *_db;
    FMDatabaseQueue *_dbQueue;
    
    BOOL _isDBInitSuccess;

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
        NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[kDBName copy]];
        
        _db = [FMDatabase databaseWithPath:path];
        _dbQueue = [FMDatabaseQueue databaseQueueWithPath:path];
        
        if (!_db || !_dbQueue) {
            YOSLog(@"\r\n\r\n warnning : sqlite initialize failture.");
            _isDBInitSuccess = NO;
        } else {
            YOSLog(@"\r\n\r\n path is : %@\r\n\r\n", path);
            _isDBInitSuccess = YES;
        }
    });
    
    return self;
}

- (void)chooseTable:(YOSDBManagerTableType)tableType isUseQueue:(BOOL)status {
    
    if (!_isDBInitSuccess) {
        return;
    }
    
    NSString *tableName = nil;
    NSString *sql = nil;
    
    switch (tableType) {
        case YOSDBManagerTableTypeCargoData: {
            tableName = [kYOSTableCagro copy];
            sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (id integer PRIMARY KEY AUTOINCREMENT, cargo_data blob NOT NULL);", tableName];
            break;
        }

        default: {
            break;
        }
    }
    
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
 *  blob 格式的存储
 *
 *  @param array
 */
- (void)updateCargoDataWithDictionary:(NSDictionary *)dict isUseQueue:(BOOL)status {
    
    if (!_isDBInitSuccess) {
        return;
    }
    
    NSString *key = dict[YOSDBTableCargoDataKey];
    NSString *value = dict[YOSDBTableCargoDataValue];
    
    if (!value || ![value isKindOfClass:[NSData class]]) {
        NSAssert(NO, @"value's class type must be NSData, and not be nil.");
    }
    
    NSString *getCountSql = [NSString stringWithFormat:@"SELECT COUNT(*) AS count FROM %@ WHERE id = ?", [kYOSTableCagro copy]];
    
    NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO %@ (id, cargo_data)VALUES(?, ?)", [kYOSTableCagro copy]];
    
    NSString *updateSql = [NSString stringWithFormat:@"UPDATE %@ SET cargo_data = ? WHERE id = ?", [kYOSTableCagro copy]];
    
    if (status) {
        
        [_dbQueue inDatabase:^(FMDatabase *db) {
            
            FMResultSet *set = [db executeQuery:getCountSql, key];
            
            if ([set next]) {
                NSUInteger count = [set intForColumn:@"count"];
                
                if (count) {
                    
                    BOOL status = [db executeUpdate:updateSql, key, value];
                    if (!status) {
                        YOSLog(@"\r\n\r\nerror : %@", [db lastErrorMessage]);
                    }
                    
                } else {
                    
                    BOOL status = [db executeUpdate:insertSql, key, value];
                    if (!status) {
                        YOSLog(@"\r\n\r\nerror : %@", [db lastErrorMessage]);
                    }
                    
                }
            }
            
            [set close];
            
        }];
        
    } else {
        
        FMResultSet *set = [_db executeQuery:getCountSql, key];
        
        if ([set next]) {
            NSUInteger count = [set intForColumn:@"count"];
            
            if (count) {
                
                BOOL status = [_db executeUpdate:updateSql, key, value];
                if (!status) {
                    YOSLog(@"\r\n\r\nerror : %@", [_db lastErrorMessage]);
                }
                
            } else {
                
                BOOL status = [_db executeUpdate:insertSql, key, value];
                if (!status) {
                    YOSLog(@"\r\n\r\nerror : %@", [_db lastErrorMessage]);
                }
                
            }
        }
        
    }
}

- (id)getCargoDataWithKey:(YOSDBTableCargoKeyType)key {
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE id = ?;", [kYOSTableCagro copy]];
    
    if (!_isDBInitSuccess) {
        return nil;
    }
    
    id result = nil;
    
    [_db open];

    FMResultSet *set = [_db executeQuery:sql, @(key)];
    
    if ([set next]) {
        NSData *data = [set objectForColumnName:@"cargo_data"];
        
        result = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    
    [_db close];
    
    return result;
}

@end
