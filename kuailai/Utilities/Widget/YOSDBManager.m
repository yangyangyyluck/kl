//
//  YOSDBManager.m
//  kuailai
//
//  Created by yangyang on 15/5/14.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSDBManager.h"
#import "FMDB.h"

static const NSString *kDBName = @"kawayiSASA.db";
static const NSString *kYOSTableCagro = @"yos_cargo";
static const NSString *kYOSTableBuddyRequest = @"yos_buddyrequest";
static const NSString *kYOSTableUserInfo = @"yos_userinfo";
static const NSString *kYOSTableNewestChat = @"yos_newestchat";

static const NSUInteger kUserInfoExpireDays = 3;
static const NSUInteger kNewestChatMaxCounts = 3;

static const NSString *kSQLCreateTableCagro = @"CREATE TABLE IF NOT EXISTS yos_cargo (id integer PRIMARY KEY AUTOINCREMENT, cargo_data blob NOT NULL);";

static const NSString *kSQLCreateTableBuddyRequest = @"CREATE TABLE IF NOT EXISTS yos_buddyrequest (id integer PRIMARY KEY AUTOINCREMENT, current_username text NOT NULL, buddy_username text NOT NULL, buddy_message text)";

static const NSString *kSQLCreateTableUserInfo = @"CREATE TABLE IF NOT EXISTS yos_userinfo (id integer PRIMARY KEY AUTOINCREMENT, username text NOT NULL, json text NOT NULL, update_time text NOT NULL)";

static const NSString *kSQLCreateTableNewestChat = @"CREATE TABLE IF NOT EXISTS yos_newestchat (id integer PRIMARY KEY AUTOINCREMENT, username text NOT NULL, update_time text NOT NULL)";

#pragma mark - single

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
        
        YOSLog(@"db path is %@", path);
        
        _db = [FMDatabase databaseWithPath:path];
        _dbQueue = [FMDatabaseQueue databaseQueueWithPath:path];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:path] && [_db open]) {
            [_db executeUpdate:[kSQLCreateTableCagro copy]];
            [_db executeUpdate:[kSQLCreateTableBuddyRequest copy]];
            [_db executeUpdate:[kSQLCreateTableUserInfo copy]];
            [_db executeUpdate:[kSQLCreateTableNewestChat copy]];
        }
        
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

#pragma mark - CargoData

/**
 *  blob 格式的存储
 *
 *  @param array
 */
- (void)updateCargoDataWithDictionary:(NSDictionary *)dict isUseQueue:(BOOL)status {
    
    if (!_isDBInitSuccess) {
        return;
    }
    
    __block NSString *key = nil;
    __block NSData *value = nil;
    
    [dict enumerateKeysAndObjectsUsingBlock:^(NSString *k, NSData *o, BOOL *stop) {
       
        key = k;
        value = o;
        
    }];
    
    if (!key.length || ![value isKindOfClass:[NSData class]]) {
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
                
                BOOL status = [_db executeUpdate:updateSql, value, key];
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
        
        [set close];
        
    }
}

- (id)getCargoDataWithKey:(YOSDBTableCargoKeyType)key {
    
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE id = ?;", [kYOSTableCagro copy]];
    
    if (!_isDBInitSuccess) {
        return nil;
    }
    
    id result = nil;

    FMResultSet *set = [_db executeQuery:sql, @(key)];
    
    if ([set next]) {
        NSData *data = [set objectForColumnName:@"cargo_data"];
        
        result = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    
    return result;
}

- (void)setCargoKey:(YOSDBTableCargoKeyType)key cargoValue:(id)value {
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:value];
    
    NSDictionary *dict = @{YOSInt2String(key) : data};
    
    [[YOSDBManager sharedManager] updateCargoDataWithDictionary:dict isUseQueue:NO];
}

#pragma mark - BuddyRequest

- (void)updateBuddyRequestWithCurrentUser:(NSString *)current buddy:(NSString *)buddy message:(NSString *)message {
    
    if (!_isDBInitSuccess) {
        return;
    }
    
    if (!current.length || !buddy.length) {
        return;
    }
    
    if (!message) {
        message = @"";
    }
    
    NSString *getCountSql = [NSString stringWithFormat:@"SELECT COUNT(*) AS count FROM %@ WHERE current_username = ? AND buddy_username = ?", [kYOSTableBuddyRequest copy]];
    
    NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO %@ (current_username, buddy_username, buddy_message)VALUES(?, ?, ?)", [kYOSTableBuddyRequest copy]];
    
    NSString *updateSql = [NSString stringWithFormat:@"UPDATE %@ SET buddy_message = ? WHERE current_username = ? AND buddy_username = ?", [kYOSTableBuddyRequest copy]];
    
    FMResultSet *set = [_db executeQuery:getCountSql, current, buddy];
    
    if ([set next]) {
        NSUInteger count = [set intForColumn:@"count"];
        
        BOOL status = NO;
        
        if (count) {
            status = [_db executeUpdate:updateSql, message, current, buddy];
        } else {
            status = [_db executeUpdate:insertSql, current, buddy, message];
        }
        
        if (!status) {
            YOSLog(@"\r\n\r\n error : %@", [_db lastErrorMessage]);
        } else {
            YOSLog(@"\r\n\r\n success : update %@ --- %@", current, buddy);
        }
    }
    
    [set close];
    
}

- (void)deleteBuddyRequestWithCurrentUser:(NSString *)current buddy:(NSString *)buddy {
    
    if (!_isDBInitSuccess) {
        return;
    }
    
    if (!current.length || !buddy.length) {
        return;
    }
    
    NSString *deleteSql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE current_username = ? AND buddy_username = ?", [kYOSTableBuddyRequest copy]];
    
    
    BOOL status = [_db executeUpdate:deleteSql, current, buddy];
    
    if (!status) {
        YOSLog(@"\r\n\r\nerror : %@", [_db lastErrorMessage]);
    } else {
        YOSLog(@"\r\n\r\n success : delete %@ --- %@", current, buddy);
    }
}

- (NSArray *)getBuddyListWithUsername:(NSString *)username {
    
    NSString *selectSql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE current_username = ?", [kYOSTableBuddyRequest copy]];
    
    FMResultSet *set = [_db executeQuery:selectSql, username];
    
    NSMutableArray *array = [NSMutableArray array];
    
    while ([set next]) {
        NSString *hx_user = [set stringForColumn:@"buddy_username"];
        NSString *message = [set stringForColumn:@"buddy_message"];
        
        [array addObject:@{@"hx_user" : hx_user, @"message" : YOSFliterNil2String(message)}];
    }
    
    [set close];
    
    return array;
}

#pragma mark - UserInfo

- (void)updateUserInfoWithUsername:(NSString *)username json:(NSString *)json {
    if (!_isDBInitSuccess) {
        return;
    }
    
    if (!username.length || !json.length) {
        return;
    }
    
//    @"CREATE TABLE IF NOT EXISTS yos_userinfo (id integer PRIMARY KEY AUTOINCREMENT, username text NOT NULL, userinfo_json text NOT NULL, update_time text NOT NULL)";
    
    NSString *update_time = [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]];
    
    NSString *getCountSql = [NSString stringWithFormat:@"SELECT COUNT(*) AS count FROM %@ WHERE username = ?", [kYOSTableUserInfo copy]];
    
    NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO %@ (username, json, update_time)VALUES(?, ?, ?)", [kYOSTableUserInfo copy]];
    
    NSString *updateSql = [NSString stringWithFormat:@"UPDATE %@ SET json = ?, update_time = ? WHERE username = ?", [kYOSTableUserInfo copy]];
    
    FMResultSet *set = [_db executeQuery:getCountSql, username];
    
    if ([set next]) {
        NSUInteger count = [set intForColumn:@"count"];
        
        BOOL status = NO;
        
        if (count) {
            status = [_db executeUpdate:updateSql, json, update_time, username];
        } else {
            status = [_db executeUpdate:insertSql, username, json, update_time];
        }
        
        if (!status) {
            YOSLog(@"\r\n\r\n error : %@", [_db lastErrorMessage]);
        } else {
            YOSLog(@"\r\n\r\n success : update %@ --- %@", username, update_time);
        }
    }
    
    [set close];
}

- (NSString *)getUserInfoJsonWithUsername:(NSString *)username {
    if (!_isDBInitSuccess) {
        return nil;
    }
    
    if (!username.length) {
        return nil;
    }
    
    NSString *selectSql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE username = ?", [kYOSTableUserInfo copy]];
    
    FMResultSet *set = [_db executeQuery:selectSql, username];
    
    if ([set next]) {
        NSString *update_time = [set stringForColumn:@"update_time"];
        NSString *json = [set stringForColumn:@"json"];
        
//        long long updateTimeInterval = [update_time longLongValue] + 2;
        long long updateTimeInterval = [update_time longLongValue] + kUserInfoExpireDays * (24 * 3600);
        
        NSTimeInterval nowTimeInterval = [[NSDate date] timeIntervalSince1970];
        
        if (updateTimeInterval >= nowTimeInterval) {
            return json;
        } else {
            [self deleteUserInfoWithUsername:username];
            return nil;
        }
    }
    
    [set close];
    
    return nil;
}

- (void)deleteUserInfoWithUsername:(NSString *)username {
    if (!_isDBInitSuccess) {
        return;
    }
    
    if (!username.length) {
        return;
    }
    
    NSString *deleteSql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE username = ?", [kYOSTableUserInfo copy]];
    
    BOOL status = [_db executeQuery:deleteSql, username];
    
    if (status) {
        NSLog(@"delete UserInfo with %@ --- success", username);
    } else {
        NSLog(@"delete UserInfo with %@ --- failure", username);
    }
}

#pragma mark - NewestRequest

- (void)updateNewestRequestWithUsername:(NSString *)username update_time:(NSString *)update_time {
    if (!_isDBInitSuccess) {
        return;
    }
    
    if (!username.length) {
        return;
    }
    
    NSString *getCountSql = [NSString stringWithFormat:@"SELECT COUNT(*) AS count FROM %@ WHERE username = ?", [kYOSTableNewestChat copy]];
    
    NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO %@ (username, update_time)VALUES(?, ?)", [kYOSTableNewestChat copy]];
    
    NSString *updateSql = [NSString stringWithFormat:@"UPDATE %@ SET  update_time = ? WHERE username = ?", [kYOSTableNewestChat copy]];
    
    FMResultSet *set = [_db executeQuery:getCountSql, username];
    
    if ([set next]) {
        NSUInteger count = [set intForColumn:@"count"];
        
        BOOL status = NO;
        
        if (count) {
            status = [_db executeUpdate:updateSql, update_time, username];
        } else {
            status = [_db executeUpdate:insertSql, username, update_time];
        }
        
        if (!status) {
            YOSLog(@"\r\n\r\n error : %@", [_db lastErrorMessage]);
        } else {
            YOSLog(@"\r\n\r\n success : update %@ --- %@", username, update_time);
        }
    }
    
    [set close];
}

- (NSArray *)getNewestChatUsernames {
    if (!_isDBInitSuccess) {
        return nil;
    }
    
    NSString *selectSql = [NSString stringWithFormat:@"SELECT * FROM %@ ORDER BY update_time LIMIT %zi", [kYOSTableNewestChat copy], kNewestChatMaxCounts];
    
    FMResultSet *set = [_db executeQuery:selectSql];
    
    NSMutableArray *result = [NSMutableArray array];
    
    if ([set next]) {
        NSString *username = [set stringForColumn:@"username"];
        
        [result addObject:username];
        
    }
    
    [set close];
    
    return [result copy];
}



@end
